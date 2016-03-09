clear;
clc;

% This tests a multi-channel communication (i.e. through different network ports)
% We send and receive lists of floats on 2 different channels 5560 and 5561


disp('Declaring the interfaces...')
channel_5560 = MatlabInterface(5560);
channel_5561 = MatlabInterface(5561);

disp('Sending 3 floats to Python channel 5560...')
channel_5560.send([5560.1, 5560.2, 5560.3])

disp('Sending 3 floats to Python channel 5561...')
channel_5561.send([5561.1, 5561.2, 5561.3])

disp('Reading response from Python channel 5560...')
answer_5560 = channel_5560.read()

disp('Reading response from Python channel 5561...')
answer_5561 = channel_5561.read()

disp('Communication successful, exiting.')