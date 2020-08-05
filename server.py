import selectors
import socket
import types

def accept_wrapper(sock):
    conn, addr = sock.accept() # Should be ready to read| Aceptamos la conexion
    print('accepted connection from', addr)
    conn.setblocking(False) #Remover llamadas bloqueadoras de la conexión
    data = types.SimpleNamespace(addr=addr, inb=b'', outb=b'') #crear el obtejo en el que vamos a almacenar las comunicaciones
    events = selectors.EVENT_READ | selectors.EVENT_WRITE #Que eventos vamos registrar
    sel.register(conn, events, data=data) #Definir que vamos a escuchar|que socket|que evento


def service_connection(key, mask):
    sock = key.fileobj
    data = key.data
    if mask & selectors.EVENT_READ:
        recv_data = sock.recv(1024)  # Should be ready to read
        if recv_data:
            data.outb += recv_data
        else:
            print('closing connection to', data.addr)
            sel.unregister(sock)
            sock.close()
    if mask & selectors.EVENT_WRITE:
        if data.outb:
            print('echoing', repr(data.outb), 'to', data.addr)
            sent = sock.send(data.outb)  # Should be ready to write
            data.outb = data.outb[sent:]

#####################################################################
sel = selectors.DefaultSelector() #Inicializacion del multiplexor

HOST = '127.0.0.1'  # Standard loopback interface address (localhost)
PORT = 65432        # Port to listen on (non-privileged ports are > 1023)

# ...
lsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #Crear socket IPV4, TCP
lsock.bind((HOST, PORT)) #Amarrar el socket a una ip y puerto
lsock.listen() #Inicializar (Creo que definir la cantidad de conexiones permitidas)
print('listening on', (HOST, PORT))

lsock.setblocking(False) #Remover llamadas bloqueadoras del socket
sel.register(lsock, selectors.EVENT_READ, data=None) #Definir que vamos a escuchar|que socket|que evento| data en un objeto opaco, significa que no tiene tipo

while True:
    events = sel.select(timeout=None) #Esperar hasta que exita algun socket listo para I/O
    #@events, lista de llaves y eventos para cada socket
    for key, mask in events:
        if key.data is None: # Nueva coneccion
            accept_wrapper(key.fileobj)
        else: # 
            service_connection(key, mask)