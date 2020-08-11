
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
deck = np.concatenate((np.ones(14), np.ones(4) * 2 , np.ones(10) * 3, np.ones(8) * 4
                , np.ones(12) * 5, np.ones(6) * 6, np.ones(6) * 7, np.ones(14) * 8
                , np.ones(14) * 9, np.ones(10) * 10, np.ones(5) * 11, np.ones(5) * 12))
deck = deck.astype(int)

def generateHands(nArrays, nCards):
    np.random.shuffle(deck)
    aws = [] ##Array of decks
    aws2 = []  ## Array for picked cards
    for i in range(nArrays):
        aws.append(deck[i * nCards: (i+1) * nCards].tolist())
        aws2.append([])
    return aws, aws2

def sendResults(roomId):
    points = []
    makiFirst = [0, -1]
    makiSecond = [0, -1]
    puddingsMost = [0, -1]
    puddingsLeast = [999, -1]
    for i in range(len(rooms[roomId]["decks"])):
        temporalPoints = 0
        #Chopsticks -ya
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 2, rooms[roomId]["decks"][i]))
        #Dumplins
        dumplins = rooms[roomId]["decks"][i].count(8)
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 8, rooms[roomId]["decks"][i]))
        temporalPoints += dumplins #add conversion to points
        #Sashimi -ya
        temporalPoints += (rooms[roomId]["decks"][i].count(1) // 3) * 10 
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 1, rooms[roomId]["decks"][i]))
        #Tempura -ya
        temporalPoints += (rooms[roomId]["decks"][i].count(9) //2) * 5
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 9, rooms[roomId]["decks"][i]))
        #Maki
        maki = rooms[roomId]["decks"][i].count(6) + (rooms[roomId]["decks"][i].count(5) * 2) + (rooms[roomId]["decks"][i].count(4) * 3)
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 6, rooms[roomId]["decks"][i]))
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 5, rooms[roomId]["decks"][i]))
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 4, rooms[roomId]["decks"][i]))
        if (maki == makiFirst[0] and maki != 0):
            makiFirst.append(i)
        elif (maki > makiFirst[0]):
            makiSecond = [makiFirst[0], makiFirst[1]]
            makiFirst = [maki, i]
        #pudding
        pudding = rooms[roomId]["decks"][i].count(3)
        rooms[roomId]["decks"][i] = list(filter(lambda a: a != 3, rooms[roomId]["decks"][i]))
        if (pudding == puddingsMost[1] and pudding != 0):
            puddingsMost.append(i)
        elif (pudding > puddingsMost[1]):
            puddingsMost = [pudding, i]
        elif (pudding == puddingsLeast[1] and pudding != 0):
            puddingsLeast.append(i)
        elif (pudding < puddingsLeast[1]):
            puddingsLeast = [pudding,i]
        #Nigiri
        wasabi = 0
        for j in rooms[roomId]["decks"][i]:
            if (j == 7):
                wasabi += 1
            elif (j == 10):
                if (wasabi > 0):
                    temporalPoints += 2 * 3
                    wasabi -= 1
                else:
                    temporalPoints += 2
            elif (j == 11):
                if (wasabi > 0):
                    temporalPoints += 1 * 3
                    wasabi -= 1
                else:
                    temporalPoints += 1
            elif (j == 12):
                if (wasabi > 0):
                    temporalPoints += 3 * 3
                    wasabi -= 1
                else:
                    temporalPoints += 3
        points.append(temporalPoints)
    for i in range(1,len(makiFirst)):
        if (makiFirst[i] > -1):
            points[makiFirst[i]] += 6 // len(range(1,len(makiFirst)))
    for i in range(1,len(makiSecond)):
        if (makiSecond[i] > -1):
            points[makiSecond[i]] += 3 // len(range(1,len(makiSecond)))
    for i in range(1,len(puddingsMost)):
        if (puddingsMost[i] > -1):
            points[puddingsMost[i]] += 6 // len(range(1,len(puddingsMost)))
    for i in range(1,len(puddingsLeast)):
        if (puddingsMost[i] > -1):
            points[puddingsMost[i]] -= 6 // len(range(1,len(puddingsLeast)))
    
    response = {}
    response["type"] = 114
    response["status"] = []
    for i in range(len(rooms[roomId]["decks"])):
        obj = {}
        obj["id"] = rooms[roomId]["players"][i]
        obj["username"] = users[ rooms[roomId]["players"][i] ]["username"]
        obj["points"] = points[i] 
        response["status"].append(obj)
    for i in range(len(rooms[obj["room_id"]]["players"])):
            users[i]["socket"].send(repr(response).encode("utf-8"))

    #Remove room

def process_message(message, connection): 
    obj = json.loads(message)
    response =	{
        "type": 0
    }
    if (obj["type"] == 101): #101 Login
        #Generate user id
        userId = len(users)
        #Add user to list
        users[userId] =  { #id
            "username": obj["username"],
            "socket": connection
        }
        #Build response
        response["type"] = 102
        response["user_id"] = userId
    elif (obj["type"] == 104): #104 Create room
        #Generate room id
        roomsId = len(rooms)
        #Add room to list
        rooms[roomsId] =  { # room
            "players": [obj["user_id"]], #players playing on the romm,
            "turn": 0,
            "decks": [],
            "selectedCards": [],
            "cardsReceived": 0,
        }
        #Build response
        response["type"] = 105
        response["room_id"] = roomsId
    elif (obj["type"] == 106): #106 join room
        #Add usser to list og players in the room
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
    elif (obj["type"] == 108): #108 Start game
        ''' Check if it is the manager and decks is empty, manage amount of cards  '''
        if (len(rooms[obj["room_id"]]["decks"]) == 0):
            rooms[obj["room_id"]]["decks"], rooms[obj["room_id"]]["selectedCards"] = generateHands(len(rooms[obj["room_id"]]["players"]), 10)
        response["type"] = 109
        response["status"] = 1
        for i in rooms[obj["room_id"]]["players"]:
            users[i]["socket"].send(repr(response).encode("utf-8"))
        response = None    
    elif (obj["type"] == 110): #110 Send decks to players
        index = rooms[obj["room_id"]]["players"].index(obj["user_id"]) + rooms[obj["room_id"]]["turn"]
        nPlayers = len(rooms[obj["room_id"]]["players"])
        response["type"] = 111
        response["cards"] = rooms[ obj["room_id"] ][  "decks"  ][ index % nPlayers ]
    elif (obj["type"] == 112):#112 Receive card from player
        ## Add routine to send message when all have send their card 
        pos = rooms[obj["room_id"]]["players"].index(obj["user_id"])
        index = pos + rooms[obj["room_id"]]["turn"]
        nPlayers = len(rooms[obj["room_id"]]["players"])
        for i in obj["cards"]:
            print("Carta: ", i)
            if (i<0):
                rooms[ obj["room_id"] ]["decks"][ index % nPlayers ].append( abs(i) )
            else:
                print("Antes", rooms[ obj["room_id"] ]["decks"][ index % nPlayers ])
                rooms[ obj["room_id"] ]["decks"][ index % nPlayers ].remove(i)
                print("Despues", rooms[ obj["room_id"] ]["decks"][ index % nPlayers ])
                rooms[ obj["room_id"] ]["selectedCards"][pos].append(i)
        #Add from receive cards
        rooms[ obj["room_id"] ]["cardsReceived"] += 1
        #Check # receive cards       
        if (rooms[ obj["room_id"] ]["cardsReceived"] == len(rooms[ obj["room_id"] ]["players"])): #if every player send their cards
            #Check if the game is over
            if (len(rooms[ obj["room_id"] ]["decks"][0]) == 0):
                sendResults(obj["room_id"]) ##LLamar al 114
            else:
                rooms[ obj["room_id"] ]["turn"] += 1
                rooms[ obj["room_id"] ]["cardsReceived"] = 0
                process_message('{"type": 108, "room_id":'+str(obj["room_id"]) +'}', None)
        response = None
    elif (obj["type"] == 200): #200 Send message
        response["type"] = 201
        response["message"] = obj["message"]
        response["user_id"] = obj["user_id"]
        response["username"] = users[obj["user_id"]]["username"]
        for i in rooms[obj["room_id"]]["players"]:
            if (obj["user_id"] != i):
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
                sock.send(repr(response).encode("utf-8"))  # Should be ready to write
                # sent = sock.send(repr(response).encode("utf-8"))  # For checking send data
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
