import socket
import time
import wave  # For output

UDP_MAX_DATA_LEN = 1472

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

sock.bind(('', 8192))  # Bind socket to all interfaces

output_file = wave.open('output.wav', 'wb')
output_file.setnchannels(2)
output_file.setsampwidth(2)
output_file.setframerate(50000)

cnt = 0
start_time = time.time()
while time.time() - start_time < 10.0:
    data, addr = sock.recvfrom(UDP_MAX_DATA_LEN)
    data_len = len(data)
    for i in range(0, data_len, 4):
        output_file.writeframesraw(data[i:i+4])

output_file.writeframes(b'')
output_file.close()
