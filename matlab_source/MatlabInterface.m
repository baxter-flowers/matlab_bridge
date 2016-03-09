classdef MatlabInterface
    
    properties
        context;
        socket;
        address;
    end
    
    methods
        function self = MatlabInterface(port)
            if nargin == 0
                port = 5560;
            end
            self.context = zmq.core.ctx_new();
            self.socket = zmq.core.socket(self.context, 'ZMQ_REQ');
            self.address = ['tcp://127.0.0.1:', num2str(port)];
            zmq.core.connect(self.socket, self.address);
        end
                      
        function send(self, data)
            zmq.core.send(self.socket, uint8(savejson('', data)));
        end
        
        function s = read(self)
            s = loadjson(char(zmq.core.recv(self.socket)));
        end
    end
end

