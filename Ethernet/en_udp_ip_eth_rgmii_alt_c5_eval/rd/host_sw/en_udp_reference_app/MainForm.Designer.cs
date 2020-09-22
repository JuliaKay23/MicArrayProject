namespace en_udp_reference_app
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.gbConnection = new System.Windows.Forms.GroupBox();
            this.bOpenClose = new System.Windows.Forms.Button();
            this.lHostRxPort = new System.Windows.Forms.Label();
            this.lFpgaRxPort = new System.Windows.Forms.Label();
            this.tbHostRxPort = new System.Windows.Forms.TextBox();
            this.lFpgaIpAddress = new System.Windows.Forms.Label();
            this.tbFpgaRxPort = new System.Windows.Forms.TextBox();
            this.tbFpgaIpAddress = new System.Windows.Forms.TextBox();
            this.gbLoopback = new System.Windows.Forms.GroupBox();
            this.lPacketsReceived = new System.Windows.Forms.Label();
            this.tbPacketsReceived = new System.Windows.Forms.TextBox();
            this.lPacketsSent = new System.Windows.Forms.Label();
            this.tbPacketsSent = new System.Windows.Forms.TextBox();
            this.lTimeout = new System.Windows.Forms.Label();
            this.tbTimeout = new System.Windows.Forms.TextBox();
            this.lPacketCount = new System.Windows.Forms.Label();
            this.lTestState = new System.Windows.Forms.Label();
            this.lPacketSize = new System.Windows.Forms.Label();
            this.bLoopback = new System.Windows.Forms.Button();
            this.tbPacketCount = new System.Windows.Forms.TextBox();
            this.tbPacketSize = new System.Windows.Forms.TextBox();
            this.cbCheckContent = new System.Windows.Forms.CheckBox();
            this.gbConnection.SuspendLayout();
            this.gbLoopback.SuspendLayout();
            this.SuspendLayout();
            // 
            // gbConnection
            // 
            this.gbConnection.Controls.Add(this.bOpenClose);
            this.gbConnection.Controls.Add(this.lHostRxPort);
            this.gbConnection.Controls.Add(this.lFpgaRxPort);
            this.gbConnection.Controls.Add(this.tbHostRxPort);
            this.gbConnection.Controls.Add(this.lFpgaIpAddress);
            this.gbConnection.Controls.Add(this.tbFpgaRxPort);
            this.gbConnection.Controls.Add(this.tbFpgaIpAddress);
            this.gbConnection.Cursor = System.Windows.Forms.Cursors.Default;
            this.gbConnection.Location = new System.Drawing.Point(12, 12);
            this.gbConnection.Name = "gbConnection";
            this.gbConnection.Size = new System.Drawing.Size(299, 129);
            this.gbConnection.TabIndex = 0;
            this.gbConnection.TabStop = false;
            this.gbConnection.Text = "Connection";
            // 
            // bOpenClose
            // 
            this.bOpenClose.Location = new System.Drawing.Point(9, 98);
            this.bOpenClose.Name = "bOpenClose";
            this.bOpenClose.Size = new System.Drawing.Size(283, 23);
            this.bOpenClose.TabIndex = 5;
            this.bOpenClose.Text = "Open";
            this.bOpenClose.UseVisualStyleBackColor = true;
            this.bOpenClose.Click += new System.EventHandler(this.bOpenClose_Click);
            // 
            // lHostRxPort
            // 
            this.lHostRxPort.AutoSize = true;
            this.lHostRxPort.Location = new System.Drawing.Point(6, 74);
            this.lHostRxPort.Name = "lHostRxPort";
            this.lHostRxPort.Size = new System.Drawing.Size(67, 13);
            this.lHostRxPort.TabIndex = 4;
            this.lHostRxPort.Text = "Host Rx Port";
            // 
            // lFpgaRxPort
            // 
            this.lFpgaRxPort.AutoSize = true;
            this.lFpgaRxPort.Location = new System.Drawing.Point(6, 48);
            this.lFpgaRxPort.Name = "lFpgaRxPort";
            this.lFpgaRxPort.Size = new System.Drawing.Size(73, 13);
            this.lFpgaRxPort.TabIndex = 3;
            this.lFpgaRxPort.Text = "FPGA Rx Port";
            // 
            // tbHostRxPort
            // 
            this.tbHostRxPort.Location = new System.Drawing.Point(125, 71);
            this.tbHostRxPort.Name = "tbHostRxPort";
            this.tbHostRxPort.Size = new System.Drawing.Size(168, 20);
            this.tbHostRxPort.TabIndex = 2;
            this.tbHostRxPort.Text = "50101";
            this.tbHostRxPort.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // lFpgaIpAddress
            // 
            this.lFpgaIpAddress.AutoSize = true;
            this.lFpgaIpAddress.Location = new System.Drawing.Point(6, 22);
            this.lFpgaIpAddress.Name = "lFpgaIpAddress";
            this.lFpgaIpAddress.Size = new System.Drawing.Size(89, 13);
            this.lFpgaIpAddress.TabIndex = 0;
            this.lFpgaIpAddress.Text = "FPGA IP-Address";
            // 
            // tbFpgaRxPort
            // 
            this.tbFpgaRxPort.Location = new System.Drawing.Point(125, 45);
            this.tbFpgaRxPort.Name = "tbFpgaRxPort";
            this.tbFpgaRxPort.Size = new System.Drawing.Size(168, 20);
            this.tbFpgaRxPort.TabIndex = 2;
            this.tbFpgaRxPort.Text = "50100";
            this.tbFpgaRxPort.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // tbFpgaIpAddress
            // 
            this.tbFpgaIpAddress.Location = new System.Drawing.Point(125, 19);
            this.tbFpgaIpAddress.Name = "tbFpgaIpAddress";
            this.tbFpgaIpAddress.Size = new System.Drawing.Size(168, 20);
            this.tbFpgaIpAddress.TabIndex = 1;
            this.tbFpgaIpAddress.Text = "16.0.0.1";
            this.tbFpgaIpAddress.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // gbLoopback
            // 
            this.gbLoopback.Controls.Add(this.cbCheckContent);
            this.gbLoopback.Controls.Add(this.lPacketsReceived);
            this.gbLoopback.Controls.Add(this.tbPacketsReceived);
            this.gbLoopback.Controls.Add(this.lPacketsSent);
            this.gbLoopback.Controls.Add(this.tbPacketsSent);
            this.gbLoopback.Controls.Add(this.lTimeout);
            this.gbLoopback.Controls.Add(this.tbTimeout);
            this.gbLoopback.Controls.Add(this.lPacketCount);
            this.gbLoopback.Controls.Add(this.lTestState);
            this.gbLoopback.Controls.Add(this.lPacketSize);
            this.gbLoopback.Controls.Add(this.bLoopback);
            this.gbLoopback.Controls.Add(this.tbPacketCount);
            this.gbLoopback.Controls.Add(this.tbPacketSize);
            this.gbLoopback.Enabled = false;
            this.gbLoopback.Location = new System.Drawing.Point(12, 147);
            this.gbLoopback.Name = "gbLoopback";
            this.gbLoopback.Size = new System.Drawing.Size(299, 226);
            this.gbLoopback.TabIndex = 1;
            this.gbLoopback.TabStop = false;
            this.gbLoopback.Text = "Loopback";
            // 
            // lPacketsReceived
            // 
            this.lPacketsReceived.AutoSize = true;
            this.lPacketsReceived.Location = new System.Drawing.Point(5, 199);
            this.lPacketsReceived.Name = "lPacketsReceived";
            this.lPacketsReceived.Size = new System.Drawing.Size(95, 13);
            this.lPacketsReceived.TabIndex = 14;
            this.lPacketsReceived.Text = "Packets Received";
            // 
            // tbPacketsReceived
            // 
            this.tbPacketsReceived.Location = new System.Drawing.Point(124, 196);
            this.tbPacketsReceived.Name = "tbPacketsReceived";
            this.tbPacketsReceived.ReadOnly = true;
            this.tbPacketsReceived.Size = new System.Drawing.Size(168, 20);
            this.tbPacketsReceived.TabIndex = 13;
            this.tbPacketsReceived.Text = "N/A";
            this.tbPacketsReceived.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // lPacketsSent
            // 
            this.lPacketsSent.AutoSize = true;
            this.lPacketsSent.Location = new System.Drawing.Point(5, 173);
            this.lPacketsSent.Name = "lPacketsSent";
            this.lPacketsSent.Size = new System.Drawing.Size(71, 13);
            this.lPacketsSent.TabIndex = 12;
            this.lPacketsSent.Text = "Packets Sent";
            // 
            // tbPacketsSent
            // 
            this.tbPacketsSent.Location = new System.Drawing.Point(124, 170);
            this.tbPacketsSent.Name = "tbPacketsSent";
            this.tbPacketsSent.ReadOnly = true;
            this.tbPacketsSent.Size = new System.Drawing.Size(168, 20);
            this.tbPacketsSent.TabIndex = 11;
            this.tbPacketsSent.Text = "N/A";
            this.tbPacketsSent.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // lTimeout
            // 
            this.lTimeout.AutoSize = true;
            this.lTimeout.Location = new System.Drawing.Point(6, 74);
            this.lTimeout.Name = "lTimeout";
            this.lTimeout.Size = new System.Drawing.Size(67, 13);
            this.lTimeout.TabIndex = 10;
            this.lTimeout.Text = "Timeout [ms]";
            // 
            // tbTimeout
            // 
            this.tbTimeout.Location = new System.Drawing.Point(125, 71);
            this.tbTimeout.Name = "tbTimeout";
            this.tbTimeout.Size = new System.Drawing.Size(168, 20);
            this.tbTimeout.TabIndex = 9;
            this.tbTimeout.Text = "1000";
            this.tbTimeout.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // lPacketCount
            // 
            this.lPacketCount.AutoSize = true;
            this.lPacketCount.Location = new System.Drawing.Point(6, 48);
            this.lPacketCount.Name = "lPacketCount";
            this.lPacketCount.Size = new System.Drawing.Size(72, 13);
            this.lPacketCount.TabIndex = 8;
            this.lPacketCount.Text = "Packet Count";
            // 
            // lTestState
            // 
            this.lTestState.BackColor = System.Drawing.Color.Yellow;
            this.lTestState.Location = new System.Drawing.Point(6, 117);
            this.lTestState.Name = "lTestState";
            this.lTestState.Size = new System.Drawing.Size(286, 21);
            this.lTestState.TabIndex = 7;
            this.lTestState.Text = "N/A";
            this.lTestState.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lPacketSize
            // 
            this.lPacketSize.AutoSize = true;
            this.lPacketSize.Location = new System.Drawing.Point(6, 22);
            this.lPacketSize.Name = "lPacketSize";
            this.lPacketSize.Size = new System.Drawing.Size(98, 13);
            this.lPacketSize.TabIndex = 7;
            this.lPacketSize.Text = "Packet Size [bytes]";
            // 
            // bLoopback
            // 
            this.bLoopback.Location = new System.Drawing.Point(6, 141);
            this.bLoopback.Name = "bLoopback";
            this.bLoopback.Size = new System.Drawing.Size(286, 23);
            this.bLoopback.TabIndex = 6;
            this.bLoopback.Text = "Execute Loopback Test";
            this.bLoopback.UseVisualStyleBackColor = true;
            this.bLoopback.Click += new System.EventHandler(this.bLoopback_Click);
            // 
            // tbPacketCount
            // 
            this.tbPacketCount.Location = new System.Drawing.Point(125, 45);
            this.tbPacketCount.Name = "tbPacketCount";
            this.tbPacketCount.Size = new System.Drawing.Size(168, 20);
            this.tbPacketCount.TabIndex = 5;
            this.tbPacketCount.Text = "10";
            this.tbPacketCount.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // tbPacketSize
            // 
            this.tbPacketSize.Location = new System.Drawing.Point(125, 19);
            this.tbPacketSize.Name = "tbPacketSize";
            this.tbPacketSize.Size = new System.Drawing.Size(168, 20);
            this.tbPacketSize.TabIndex = 6;
            this.tbPacketSize.Text = "100";
            this.tbPacketSize.TextAlign = System.Windows.Forms.HorizontalAlignment.Center;
            // 
            // cbCheckContent
            // 
            this.cbCheckContent.AutoSize = true;
            this.cbCheckContent.Location = new System.Drawing.Point(125, 97);
            this.cbCheckContent.Name = "cbCheckContent";
            this.cbCheckContent.Size = new System.Drawing.Size(134, 17);
            this.cbCheckContent.TabIndex = 15;
            this.cbCheckContent.Text = "Check Packet Content";
            this.cbCheckContent.UseVisualStyleBackColor = true;
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(323, 381);
            this.Controls.Add(this.gbLoopback);
            this.Controls.Add(this.gbConnection);
            this.Name = "MainForm";
            this.Text = "en_udp Reference Application";
            this.gbConnection.ResumeLayout(false);
            this.gbConnection.PerformLayout();
            this.gbLoopback.ResumeLayout(false);
            this.gbLoopback.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox gbConnection;
        private System.Windows.Forms.GroupBox gbLoopback;
        private System.Windows.Forms.Button bOpenClose;
        private System.Windows.Forms.Label lHostRxPort;
        private System.Windows.Forms.Label lFpgaRxPort;
        private System.Windows.Forms.TextBox tbHostRxPort;
        private System.Windows.Forms.Label lFpgaIpAddress;
        private System.Windows.Forms.TextBox tbFpgaRxPort;
        private System.Windows.Forms.TextBox tbFpgaIpAddress;
        private System.Windows.Forms.Button bLoopback;
        private System.Windows.Forms.Label lTestState;
        private System.Windows.Forms.Label lPacketCount;
        private System.Windows.Forms.Label lPacketSize;
        private System.Windows.Forms.TextBox tbPacketCount;
        private System.Windows.Forms.TextBox tbPacketSize;
        private System.Windows.Forms.Label lTimeout;
        private System.Windows.Forms.TextBox tbTimeout;
        private System.Windows.Forms.Label lPacketsReceived;
        private System.Windows.Forms.TextBox tbPacketsReceived;
        private System.Windows.Forms.Label lPacketsSent;
        private System.Windows.Forms.TextBox tbPacketsSent;
        private System.Windows.Forms.CheckBox cbCheckContent;
    }
}

