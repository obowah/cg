#!/usr/bin/env python

from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import socket
from thread import *
import time
import sys
import os

ssnd=''
srcv=''
#Function for handling connection.
def clientthread(conn):
    global srcv,ssnd
     
    #infinite loop so that function do not terminate and thread do not end.
    conn.sendall('Welcome\n')
    while True:         
        if srcv:
            conn.sendall(srcv+'\n')    #send to forth
            srcv=''   
        else:
            time.sleep(1)
            continue    
        #Receiving from forth client
        reply = conn.recv(16*1024)
        if not reply: 
            break     
        print reply
        outstr=reply.replace('<br>','\r')
        ssnd=outstr
     
    #came out of loop
    conn.close()

def socksvr():
    HOST = ''   # Symbolic name, meaning all available interfaces
    PORT = 9999 # Arbitrary non-privileged port
     
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
    while True:
        #wait to accept a connection - blocking call
        conn, addr = s.accept()
        print 'Connected with ' + addr[0] + ':' + str(addr[1])
         
        #start new thread takes 1st argument as a function name to be run, second is the tuple of arguments to the function.
        start_new_thread(clientthread ,(conn,))
         
    s.close()
start_new_thread(socksvr,())

#Create custom HTTPRequestHandler class
class intrpRequestHandler(BaseHTTPRequestHandler):
  
  #handle GET command
  def do_GET(self):
    try:
        if not 'interpret' in self.path:
            self.send_response(404) 
            return           
         
        f = open('webinterpret.html') #open requested file
        #send code 200 response
        self.send_response(200)

        #send header first
        self.send_header('Content-type','text-html')
        self.end_headers()

        #send file content to client
        self.wfile.write(f.read())
        f.close()
        return
      
    except IOError:
      self.send_error(404, 'file not found')
      
  def do_POST(self):
    global srcv,ssnd
    
    # gets posted data; hands off to forth socket; gets response; returns response to webpage
    plen = int(self.headers['Content-Length']) # <--- Gets the size of data
    pdata = self.rfile.read(plen) # <--- Gets the data itself
    print plen,pdata
    srcv=pdata      # socket client will see this and send it to forth
    while not ssnd: # wait for response
        time.sleep(1) 
    self.send_response(200)
    self.send_header("Content-Length", len(ssnd))
    self.send_header("Content-Type", "text/html")
    self.end_headers()
    self.wfile.write(ssnd)  # send response to web page
    ssnd=''

def httpsrvr():  
    print('http server is starting...')
    
    #ip and port of servr
    server_address = ('', 8888)
    httpd = HTTPServer(server_address, intrpRequestHandler)
    print('http server is running...')
    httpd.serve_forever()
    
httpsrvr()
    
