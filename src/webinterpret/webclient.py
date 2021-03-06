#!/usr/bin/env python

import socket
import pdb
import time

def client_program():
    host = socket.gethostname()  # as both code is running on same pc
    port = 4444  # socket server port number

    client_socket = socket.socket()  # instantiate
    client_socket.connect((host, port))  # connect to the server

    message='GET abc'

    while message.lower().strip() != 'bye':
        client_socket.send(message.encode())  # send message
        time.sleep(1)
        data = client_socket.recv(1024).decode()  # receive response

        print('Received from server: ' + data)  # show in terminal

        message=input('>')

    client_socket.close()  # close the connection


if __name__ == '__main__':
    client_program()
