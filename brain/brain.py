import socket
import sys
import aiml
import speech
import marshal
import chatterbotapi
import wolframalpha

wa = wolframalpha.Client("UPV478-9L6XGWQHPA")
informationPods = 3

usingJarvis = True
informationMode = False

from chatterbotapi import ChatterBotFactory, ChatterBotType
factory = ChatterBotFactory()
cbb = factory.create(ChatterBotType.JABBERWACKY)
cb = cbb.create_session()

k = aiml.Kernel()
#k.learn("std-startup.xml")
#k.respond("LOAD AIML B")
k.loadBrain("jarvis.brn")

k.setBotPredicate("name","Jarvis")

sessionFile = file("jarvis.ses", "rb")
session = marshal.load(sessionFile)
sessionFile.close()

for pred,value in session.items():
    k.setPredicate(pred, value, "jarvis")


 
HOST = ''   # Symbolic name, meaning all available interfaces
PORT = 8888 # Arbitrary non-privileged port
 
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print 'Socket created'
 
#Bind socket to local host and port
try:
    s.bind((HOST, PORT))
except socket.error as msg:
    print 'Bind failed. Error Code : ' + str(msg[0]) + ' Message ' + msg[1]
    sys.exit()
     
print 'Socket bind complete'
 
#Start listening on socket
s.listen(10)
print 'Socket now listening'
 
#now keep talking with the client
while 1:
    #wait to accept a connection - blocking call
    conn, addr = s.accept()
    print 'Connected with ' + addr[0] + ':' + str(addr[1])
    break

while True:
    #phrase = speech.input()
    phrase = raw_input("> ")
    print phrase

    if phrase == "Turn off":
        speech.say("Goodbye.")
        k.saveBrain("jarvis.brn")
        session = k.getSessionData("jarvis")
        sessionFile = file("jarvis.ses", "wb")
        marshal.dump(session, sessionFile)
        sessionFile.close()
        break

    if phrase == "Stop tracking":
        conn.send(phrase)
        response = "ok"
        print response
        speech.say(response)
    elif phrase == "Track":
        conn.send(phrase)
        response = "ok"
        print response
        speech.say(response)
    elif phrase == "Stop searching":
        conn.send(phrase)
        response = "ok"
        print response
        speech.say(response)
    elif phrase == "Search":
        conn.send(phrase)
        response = "ok"
        print response
        speech.say(response)
    elif phrase == "Jarvis on":
        response = "Switching to Jarvis"
        print response
        speech.say(response)
        usingJarvis = True
    elif phrase == "Jarvis off":
        response = "Switching to Jabberwacky"
        print response
        speech.say(response)
        usingJarvis = False
    elif phrase == "Jarvis information":
        response = "Switching to information mode"
        informationMode = True
        print response
        speech.say(response)
    elif phrase == "Jarvis information off":
        response = "Turning off information mode"
        informationMode = False
        print response
        speech.say(response)
    else:
        if usingJarvis:
            if informationMode:
                res = wa.query(phrase)
                i = informationPods
                for pod in res.pods:
                    if i <= 0:
                        break
                    print pod.text
                    speech.say(pod.text)
                    i = i -1
                    
                
            else:
                response = k.respond(phrase, "jarvis")
                print response
                speech.say(response)
            
        else:
            response = cb.think(phrase)
            print response
            speech.say(response)
    
    
    
     
s.close()
