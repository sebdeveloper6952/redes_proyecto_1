
import selectors
import socket
import types
import json

HOST = '127.0.0.1'  # localHOST
PORT = 65432        # Puerto

def process_message(message): 
    obj = json.loads(message)
    response =	{
        "type": 0
    }
    if (obj["type"] == 101):
        response["type"] = 102
        response["id"] = 1234
    elif (obj["type"] == 104):
        response["type"] = 105
        response["id"] = 1234
    elif (obj["type"] == 106):
        response["type"] = 107
        response["status"] = True
    elif (obj["type"] == 108):
        response["type"] = 109
        response["status"] = True
    elif (obj["type"] == 110):
        response["type"] = 111
        response["cards"] = [1,1,1,1,1,1,1,1,]
    elif (obj["type"] == 112):
        response["type"] = 113
    elif (obj["type"] == 200):
        response["type"] = 201
        response["message"] = "Hola putos!"
        response["User_id"] = 1
        response["Username"] = "paulb"

    return (response)


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
        if recv_data: #Si leemos algo´
            data.outb += recv_data
        else: #el cliente cerro su sokcet
            print('closing connection to', data.addr)
            sel.unregister(sock)
            sock.close()
    if mask & selectors.EVENT_WRITE: #El socket esta listo para escribir
        if data.outb:
            message = data.outb
            response = process_message(message.decode("utf-8"))
            print('echoing', repr(response), 'to', data.addr)
            sent = sock.send(repr(response).encode("utf-8"))  # Should be ready to write
            data.outb = data.outb[sent:]

sel = selectors.DefaultSelector() #Crear el multiplexor por defecto

lsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #Crear socket IPV4, TCP
lsock.bind((HOST, PORT)) #Amarrar la ip al puerto
lsock.listen() # Cantidad de conexiones por defecto
print('listening on', (HOST, PORT))
lsock.setblocking(False) #Eliminar llamadas bloqueadoras
sel.register(lsock, selectors.EVENT_READ, data=None) #Monitorear el socket, y registra 

while True:
    events = sel.select(timeout=None) # Esperar hasta que se registre un objeto
    for key, mask in events: #Para todos los eventos que se leyeron
        if key.data is None: # Si aun no hemos registrado el cliente
            accept_wrapper(key.fileobj) # Registrar
        else:
            service_connection(key, mask) #Procesar solicitud
