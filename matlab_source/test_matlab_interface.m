clear;
clc;

bridge = MatlabInterface();
bridge.matlab_file = 'test_file.json';
bridge.matlab_flag = 'test_flag.txt';


while true
    bridge.send([0, 0, 0])
    a = bridge.read()
%     disp('Read python file')
%     test = bridge.read();
%     disp(test);
%     
%     disp('Send matlab file')
%     bridge.send([i, 0, 0, i, 0, 0, 0]);
%     
%     i = i + 1;
end
