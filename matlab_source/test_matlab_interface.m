clear;
clc;

bridge = MatlabInterface();

disp('Sending message to Python...')
bridge.send([1, 2, 3])
disp('Reading response from Python...')
answer = bridge.read()
disp(['Received: ', answer])