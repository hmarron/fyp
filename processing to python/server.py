import socket
import sys
import aiml
import speech
import marshal
import os

files = os.listdir(os.curdir)
print files

k = aiml.Kernel()
#k.learn("std-startup.xml")
#k.respond("LOAD AIML B")
k.loadBrain("./jarvis.brn")

k.setBotPredicate("name","Jarvis")

sessionFile = file("jarvis.ses", "rb")
session = marshal.load(sessionFile)
sessionFile.close()

for pred,value in session.items():
    k.setPredicate(pred, value, "jarvis")
 
HOST = ''   # Symbolic name, meaning all available interfaces
PORT = 1337 # Arbitrary non-privileged port
 
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
    phrase = speech.input()
    #phrase = raw_input("> ")
    print phrase
    response = k.respond(phrase, "jarvis")
    print response
    speech.say(response)
    
    if response == "Goodbye.":
        k.saveBrain("jarvis.brn")
        session = k.getSessionData("jarvis")
        sessionFile = file("jarvis.ses", "wb")
        marshal.dump(session, sessionFile)
        sessionFile.close()
        break
     
s.close()
