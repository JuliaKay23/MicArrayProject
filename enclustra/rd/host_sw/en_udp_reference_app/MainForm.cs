using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using System.Collections.Concurrent;

namespace en_udp_reference_app
{
    public static class EnUtils
    {
        /**
         * <summary>
         * Compare two arrays, the Equals() function is used to compare array elements.
         * </summary>
         * 
         * <param name="a1">    First array to compare </param>
         * <param name="a2">    Second array to compare </param>
         * <returns>            True = arrays are equal \n
         *                      False = arrays not equal</returns>
         */
        public static bool ArraysEqual<T>(this T[] a1, T[] a2)
        {
            //Check length
            if (a1.Length != a2.Length)
            {
                return false;
            }

            //Check content
            for (int i = 0; i < a1.Length; i++)
            {
                if (!a1[i].Equals(a2[i]))
                {
                    return false;
                }
            }

            //Arrays are equal
            return true;
        }
    }

    public partial class MainForm : Form
    {
        /****************************************************************************************/
        /* Types                                                                                */
        /****************************************************************************************/

        /** Connection status */
        enum EConnectionStatus 
        { 
            /** Connection is open */
            Open, 
            /** Connection is closed */
            Closed 
        };

        /** Test result */
        enum ETestResult
        {
            /** Test successfult */
            Success,
            /** Test timed out */
            TimeOut,
            /** Failed: Received packet with wrong size */
            WrongSize,
            /** Failed: Received packet with wrong data */
            WrongData
        }

        /****************************************************************************************/
        /* Variables                                                                            */
        /****************************************************************************************/
        /** Status of the connection */
        private EConnectionStatus m_connectionStatus;

        /** UDP socket to use */
        private UdpClient m_socket;

        /** IP endpoint of the FPGA */
        private IPEndPoint m_fpgaEndPoint;

        /** Packet size in bytes */
        private int m_packetSize;

        /** Packet count */
        private int m_packetCount;

        /** Send thread */
        private Thread m_sendThread;

        /** Checking of packet content */
        private bool m_checkContent;

        /** Receive thread */
        private Thread m_receiveThread;

        /** Test thread */
        private Thread m_testThread;

        /** Timeout of the test in ms */
        private int m_timeoutMs;

        /** Local port */
        private int m_localPort;

        /** Test results */
        private ETestResult m_testResult;

        /** Packet Content FIFO for checking data */
        private ConcurrentQueue<byte[]> m_packetFifo;

        /** Flow control semaphore to prevent UDP buffer overflows */
        private Semaphore m_openPacketsSemaphore;

        /****************************************************************************************/
        /* Private Methods                                                                      */
        /****************************************************************************************/

        /**
         * <summary> Test thread main function </summary>
         */
        private void TestThreadMain()
        {
            //Create test infrastructure
            m_socket = new UdpClient(m_localPort);
            m_socket.Connect(m_fpgaEndPoint);
            m_sendThread = new Thread(SendThreadMain);
            m_receiveThread = new Thread(ReceiveThreadMain);

            //Execute test
            m_openPacketsSemaphore = new Semaphore(10, 1000000000);
            m_packetFifo = new ConcurrentQueue<byte[]>();
            SetPacketsSent(0);
            SetPacketsReceived(0);
            SetTestState("Test running", Color.Yellow);
            m_receiveThread.Start();
            m_sendThread.Start();
            m_sendThread.Join();
            if (!m_receiveThread.Join(m_timeoutMs))
            {
                m_testResult = ETestResult.TimeOut;
            }
            m_socket.Close();

            //GUI Update
            switch (m_testResult)
            {
                case ETestResult.Success:
                    SetTestState("Test successful", Color.LightGreen);
                    break;
                case ETestResult.TimeOut:
                    SetTestState("Test timed out", Color.Red);
                    break;
                case ETestResult.WrongSize:
                    SetTestState("Received wrong packet size", Color.Red);
                    break;
                case ETestResult.WrongData:
                    SetTestState("Received wrong packet data", Color.Red);
                    break;
            }
            SetTestSettingsEnabled(true);
        }

        /**
         * <summary> Send thread main function </summary>
         */
        private void SendThreadMain()
        {
            Random rnd = new Random();
            try
            {
                for (int i = 0; i < m_packetCount; i++)
                {
                    byte[] packet = new byte[m_packetSize];
                    m_openPacketsSemaphore.WaitOne();
                    //Generate random data if required
                    if (m_checkContent)
                    {
                        rnd.NextBytes(packet);
                        m_packetFifo.Enqueue(packet);
                    }
                    m_socket.Send(packet, packet.Length);
                    SetPacketsSent(i + 1);
                }
            }
            //Socket exception occurs on close in timeout case
            catch (SocketException)
            {
            }
        }

        /**
         * <summary> Main function of the receive thread </summary>
         */
        private void ReceiveThreadMain()
        {
            try
            {
                int completedCount = 0;
                for (int i = 0; i < m_packetCount; i++)
                {
                    byte[] packet = m_socket.Receive(ref m_fpgaEndPoint);
                    SetPacketsReceived(i + 1);
                    //Check Size
                    if (packet.Length != m_packetSize)
                    {
                        m_testResult = ETestResult.WrongSize;
                        break;
                    }
                    //Check Content
                    if (m_checkContent)
                    {
                        byte[] expectedArray;
                        if (!m_packetFifo.TryDequeue(out expectedArray))
                        {
                            throw new Exception("Received more Packets than sent");
                        }
                        if (!expectedArray.ArraysEqual(packet))
                        {
                            m_testResult = ETestResult.WrongData;
                            break;
                        }                           
                    }
                    //Release one more token for send side   
                    m_openPacketsSemaphore.Release(1);
                    completedCount = i + 1;
                }
                //Release all tokens not yet released
                if (m_packetCount - completedCount > 0)
                {
                    m_openPacketsSemaphore.Release(m_packetCount - completedCount);
                }
                m_testResult = ETestResult.Success;
            }
            //Socket exception occurs on close in timeout case
            catch (Exception ex)
            {
                if (ex is SocketException || ex is ObjectDisposedException)
                { 
                    m_testResult = ETestResult.TimeOut;
                }
                else
                {
                    throw ex;
                }
            }
        }

        /**
         * <summary> Set test state </summary>
         * <param name="background"> Background color for the label </param>
         * <param name="state"> Text for the label </param>
         */
        private void SetTestState(string state, Color background)
        {
            this.Invoke((MethodInvoker)(() => lTestState.Text = state));
            this.Invoke((MethodInvoker)(() => lTestState.BackColor = background));
        }

        /**
         * <summary> Update sent packets counter </summary>
         * <param name="count"> Number of sent packets </param>
         */
        private void SetPacketsSent(int count)
        {
            this.Invoke((MethodInvoker)(() => tbPacketsSent.Text = "" + count));
        }

        /**
         * <summary> Update received packets counter </summary>
         * <param name="count"> Number of received packet </summary>
         */
        private void SetPacketsReceived(int count)
        {
            this.Invoke((MethodInvoker)(() => tbPacketsReceived.Text = "" + count));
        }

        /**
         * <summary> Exception handling of the GUI </summary>
         * <param name="e"> Exception to handle </param>
         */
        private void ExceptionHandling(Exception e)
        {
            MessageBox.Show(e.Message);
        }

        /**
         * <summary> Open connection </summary>
         */
        private void OpenConnection()
        {
            //Create socket information
            IPAddress fpgaIpAddr;
            try
            {
                fpgaIpAddr = IPAddress.Parse(tbFpgaIpAddress.Text);
            }
            catch (FormatException)
            {
                throw new Exception("Illegal IP-Address entered");
            }
            Int32 fpgaPort;
            try
            {
                fpgaPort = Int32.Parse(tbFpgaRxPort.Text);
            }
            catch (FormatException)
            {
                throw new Exception("Illegal FPGA Rx Port entered");
            }
            m_fpgaEndPoint = new IPEndPoint(fpgaIpAddr, fpgaPort);
            try
            {
                m_localPort = Int32.Parse(tbHostRxPort.Text);
            }
            catch (FormatException)
            {
                throw new Exception("Illegal Host Rx Port entered");
            }
            
            //Update GUI
            m_connectionStatus = EConnectionStatus.Open;
            SetGuiState(EConnectionStatus.Open);
        }

        /**
         * <summary> Close connection </summary>
         */
        private void CloseConnection()
        {
            m_connectionStatus = EConnectionStatus.Closed;
            SetGuiState(EConnectionStatus.Closed);
        }

        /**
         * <summary> Set enable of all test settings gui elements </summary>
         * <param name="ena"> Enable state to apply </param>
         */
        private void SetTestSettingsEnabled(bool ena)
        {
            this.Invoke((MethodInvoker)(() => bLoopback.Enabled = ena));
            this.Invoke((MethodInvoker)(() => tbPacketCount.Enabled = ena));
            this.Invoke((MethodInvoker)(() => tbPacketSize.Enabled = ena));
            this.Invoke((MethodInvoker)(() => tbTimeout.Enabled = ena));
            this.Invoke((MethodInvoker)(() => cbCheckContent.Enabled = ena));
        }

        /**
         * <summary> Set GUI state </summary>
         * <param name="status"> Status to apply </param>
         */
        private void SetGuiState(EConnectionStatus status)
        {
            switch (status)
            {
                case EConnectionStatus.Open:
                    gbLoopback.Enabled = true;
                    tbFpgaIpAddress.Enabled = false;
                    tbFpgaRxPort.Enabled = false;
                    tbHostRxPort.Enabled = false;
                    lFpgaIpAddress.Enabled = false;
                    lFpgaRxPort.Enabled = false;
                    lHostRxPort.Enabled = false;
                    bOpenClose.Text = "Close";
                    break;
                case EConnectionStatus.Closed:
                    gbLoopback.Enabled = false;
                    tbFpgaIpAddress.Enabled = true;
                    tbFpgaRxPort.Enabled = true;
                    tbHostRxPort.Enabled = true;
                    lFpgaIpAddress.Enabled = true;
                    lFpgaRxPort.Enabled = true;
                    lHostRxPort.Enabled = true;
                    bOpenClose.Text = "Open";
                    break;
                default:
                    throw new ArgumentOutOfRangeException("Illegl status passed");
            }
        }

        /****************************************************************************************/
        /* Constructors                                                                         */
        /****************************************************************************************/

        /**
         * <summary> Constructor </summary>
         */
        public MainForm()
        {
            InitializeComponent();
            m_connectionStatus = EConnectionStatus.Closed;
            m_packetSize = 100;
            m_packetCount = 2;
            m_timeoutMs = 1000;
        }

        /****************************************************************************************/
        /* Event Handlers                                                                       */
        /****************************************************************************************/

        /**
         * <summary> Open/Close button event handler </summary>
         * <param name="e"> Event arguments </summary>
         * <param name="sender"> Event sender </summary>
         */
        private void bOpenClose_Click(object sender, EventArgs e)
        {
            try
            {
                if (m_connectionStatus == EConnectionStatus.Closed)
                {
                    OpenConnection();
                }
                else
                {
                    CloseConnection();
                }
            }
            catch (Exception ex)
            {
                ExceptionHandling(ex);
            }
        }

        private void bLoopback_Click(object sender, EventArgs e)
        {
            try
            {
                //Read settings
                try
                {
                    m_packetSize = int.Parse(tbPacketSize.Text);
                    m_packetCount = int.Parse(tbPacketCount.Text);
                    m_timeoutMs = int.Parse(tbTimeout.Text);
                }
                catch (FormatException)
                {
                    throw new Exception("Illegal parameter value");
                }
                m_checkContent = cbCheckContent.Checked;

                //Run test thread
                SetTestSettingsEnabled(false);
                m_testThread = new Thread(TestThreadMain);
                m_testThread.Start();

            }
            catch (Exception ex)
            {
                ExceptionHandling(ex);
            }
        }


    }
}
