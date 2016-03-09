#!/usr/bin/env python
import json
import zmq

class PythonInterface(object):
    def __init__(self, port=5560):
        self.context = zmq.Context()
        self.socket = self.context.socket(zmq.REP)
        self.port = port
        self.socket.bind("tcp://*:%s" % self.port)

    def send(self, data):
        self.socket.send(json.dumps(data))

    def read(self):
        return self.socket.recv_json()
