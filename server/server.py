
import selectors
import socket

HOST = '127.0.0.1'  # localhost
PORT = 65432        # Puerto

sel = selectors.DefaultSelector() #Crear el multiplexor por defecto

lsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #Crear socket IPV4, TCP
lsock.bind((host, port)) #Amarrar la ip al puerto
lsock.listen() # Cantidad de conexiones por defecto
print('listening on', (host, port))
lsock.setblocking(False) #Eliminar llamadas bloqueadoras
sel.register(lsock, selectors.EVENT_READ, data=None) #Monitorear el socket, y registra 

while True:
    events = sel.select(timeout=None) # Esperar hasta que se registre un objeto
    for key, mask in events: #Para todos los eventos que se leyeron
        if key.data is None: # Si aun no hemos registrado el cliente
            accept_wrapper(key.fileobj) # Registrar
        else:
            service_connection(key, mask) #Procesar solicitud

def accept_wrapper(sock):
    conn, addr = sock.accept()  # Aceptar la conexion
    print('accepted connection from', addr)
    conn.setblocking(False)  #Eliminar llamadas bloqueadoras
    data = types.SimpleNamespace(addr=addr, inb=b'', outb=b'') #Crear el objeto que va a registrar las interacciones 
    events = selectors.EVENT_READ | selectors.EVENT_WRITE #Que eventos se can a registrar
    sel.register(conn, events, data=data) # registrar los eventos de la conexion que acabamos de crear

def service_connection(key, mask):
    sock = key.fileobj #Quien mando el objeto
    data = key.data #Que objeto mando
    if mask & selectors.EVENT_READ: # Si logramos leer algo
        recv_data = sock.recv(1024)  # Should be ready to read
        if recv_data: #Si leemos algo
            data.outb += recv_data
        else: #el cliente cerro su sokcet
            print('closing connection to', data.addr)
            sel.unregister(sock)
            sock.close()
    if mask & selectors.EVENT_WRITE: #El socket esta listo para escribir
        if data.outb:
            print('echoing', repr(data.outb), 'to', data.addr)
            sent = sock.send(data.outb)  # Should be ready to write
            data.outb = data.outb[sent:]