#!/usr/bin/env python
import json
import zmq

class PythonInterface(object):
    DEFAULT_PORT=5560
    def __init__(self, port=DEFAULT_PORT):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.PAIR)
        if 1024 < port:
            self.port = port
        else:
            raise ValueError("Invalid port {}, pick a port > 1024. The default port is {}, perhaps try {}?".format(port, self.DEFAULT_PORT, self.DEFAULT_PORT+1))
        self.socket.bind("tcp://*:%s" % self.port)

    def send(self, data):
        self.socket.send_string(json.dumps(data))

    def read(self):
        return self.socket.recv_json()
