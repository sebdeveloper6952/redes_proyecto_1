import socket

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind(('127.0.0.1', 9876))
server_socket.listen(12)
print('Server: listening...')

while True:
    # accept connections from outside
    (client_socket, address) = server_socket.accept()
    print(f'Client connected from: {address}')
    message = 'You are connected'
    client_socket.send(b'You are connected!')
    data = client_socket.recv(1024)
    print(f'Server: received {data}')
    client_socket.close()
    if str(input('Close? [y/n]')) == 'y':
        break

server_socket.close()