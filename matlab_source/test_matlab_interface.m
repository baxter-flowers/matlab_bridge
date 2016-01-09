clear;
clc;

bridge = MatlabInterface();
i = 0;

while true
    disp('Read python file')
    test = bridge.read();
    disp(test);
    
    disp('Send matlab file')
    bridge.send([i, 0, 0, i, 0, 0, 0]);
    
    i = i + 1;
end
