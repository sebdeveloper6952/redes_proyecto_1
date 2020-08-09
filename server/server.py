
import selectors
import socket
import types
import json
import numpy as np

HOST = '127.0.0.1'  # localHOST
PORT = 65432        # Port

rooms = {}
users = {}
#Create deck
maso = np.concatenate((np.ones(14), np.ones(4) * 2 , np.ones(10) * 3, np.ones(8) * 4
                , np.ones(12) * 5, np.ones(6) * 6, np.ones(6) * 7, np.ones(14) * 8
                , np.ones(14) * 9, np.ones(10) * 10, np.ones(5) * 11, np.ones(5) * 12))
maso = maso.astype(int)

def generateHands(nArrays, nCards):
    np.random.shuffle(maso)
    aws = [] 
    aws2 = [] 
    for i in range(nArrays):
        aws.append(maso[i * nCards: (i+1) * nCards].tolist())
        aws2.append([])
    return aws, aws2

def process_message(message, connection): 
    print("Entramos", message)
    obj = json.loads(message)
    response =	{
        "type": 0
    }
    if (obj["type"] == 101):
        #Generate user id
        userId = len(users)
        #Add user to list
        users[userId] =  { #id
            "username": obj["username"], #usuario
            "socket": connection
        }
        #Build response
        response["type"] = 102
        response["user_id"] = userId
    elif (obj["type"] == 104):
        #Generate room id
        roomsId = len(rooms)
        #Add room to list
        rooms[roomsId] =  { # de sala
            "players": [obj["user_id"]], #players jugando en una sala,
            "turn": 0,
            "decks": [],
            "selectedCards": []
        }
        #Build response
        response["type"] = 105
        response["room_id"] = roomsId
    elif (obj["type"] == 106):
        #Hacer el add del usuario a la lista
        rooms[obj["room_id"]]["players"].append(obj["user_id"])
        #Build response
        ''' Check first if is in the list and the length of the array '''
        response["type"] = 107
        response["room_id"] = obj["room_id"]
        users[obj["user_id"]]["socket"].send(repr(response).encode("utf-8"))
        ###### Send Broadcast #######################################    
        response = {}
        response["type"] = 115
        response["players"]  = []
        for i in rooms[obj["room_id"]]["players"]:
            temp = {}
            temp["id"] = i
            temp["username"] = users[i]["username"]
            response["players"].append(temp)
        for i in rooms[obj["room_id"]]["players"]: #For making the broadcast
            users[i]["socket"].send(repr(response).encode("utf-8"))
        response =  None
    elif (obj["type"] == 108):
        ''' Check if it is the manager and decks is empty'''
        rooms[obj["room_id"]]["decks"], rooms[obj["room_id"]]["selectedCards"] = generateHands(2, 10)
        response["type"] = 109
        response["status"] = 1
        for i in rooms[obj["room_id"]]["players"]:
            users[i]["socket"].send(repr(response).encode("utf-8"))
        response = None    
    elif (obj["type"] == 110):
        #Mandar mazo
        index = rooms[obj["room_id"]]["players"].index(obj["user_id"]) + rooms[obj["room_id"]]["turn"]
        nPlayers = len(rooms[obj["room_id"]]["players"])
        response["type"] = 111
        response["cards"] = rooms[ obj["room_id"] ][  "decks"  ][ index % nPlayers ]
    elif (obj["type"] == 112):
        pos = rooms[obj["room_id"]]["players"].index(obj["user_id"])
        index = pos + rooms[obj["room_id"]]["turn"]
        nPlayers = len(rooms[obj["room_id"]]["players"])
        for i in obj["cards"]:
            if (i>0):
                rooms[ obj["room_id"] ][  "decks"  ][ index % nPlayers ].append( abs(i) )
            else:
                rooms[ obj["room_id"] ][  "decks"  ][ index % nPlayers ].remove(i)
                rooms[ obj["room_id"] ]["selectedCards"][pos].append(i)        
        response["type"] = 113
    elif (obj["type"] == 200):
        response["type"] = 201
        response["message"] = obj["message"]
        response["user_id"] = obj["user_id"]
        response["Username"] = users[i]["username"]
        for i in rooms[obj["room_id"]]["players"]:
            users[i]["socket"].send(repr(response).encode("utf-8"))
    return response

#

#a = a.astype(int)
#print( process_message('{"type":106,"id":1, "room_id":1}', None) )   

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
            print(key, mask)
            message = data.outb
            print("recibi", message.decode("utf-8"), type(message.decode("utf-8")))
            response = process_message(message.decode("utf-8"), sock)
            if (response):
                sent = sock.send(repr(response).encode("utf-8"))  # Should be ready to write
            data.outb = data.outb[len(message):]
###########################################################################################

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
