# Matlab-Python communication through network

This library overloads ZMQ to exchange tables or dictionaries/maps of floats between Matlab and Python through localhost network communication.
It is able to send and receive to different channels through different network ports, either to communicate between different threads or simply to separate semantically the communication channels.

Tables are simply encoded as JSON and sent through the network using ZMQ.
Works on Windows and Linux.

## Installing procedure

 - [Install the ZMQ 3 library + pyZMQ](http://zeromq.org/intro:get-the-software) for your OS and compile it if necessary
  - On Ubuntu and derivates it's just a `sudo apt-get install libzmq3-dev python-zmq`
 - Clone this repository, including its submodule matlab-zmq
 - Edit the file [matlab_source/matlab-zmq/config.m](https://github.com/fagg/matlab-zmq/blob/6bb0c025cd605e39454e6fc6c656233e3fcf0d07/config.m) by changing the name of the library, the path to the headers and to the library
  - On Linux, it's likely:
  ```
  ZMQ_COMPILED_LIB = 'libzmq.so';
  ZMQ_LIB_PATH = '/usr/lib/x86_64-linux-gnu/';
  ZMQ_INCLUDE_PATH = '/usr/include/';
  ```
 - Add (/matlab_source)[matlab_bridge/tree/zmq/matlab_source] and its subfolders into your Matlab path
 - Compile matlab-zmq in Matlab by running [matlab_source/matlab-zmq/compile.m](https://github.com/fagg/matlab-zmq/blob/6bb0c025cd605e39454e6fc6c656233e3fcf0d07/compile.m), check that the last display returns `errors = 0` (you might have warnings though)
 - Install the Python library by executing the [setup script](setup.py)
  - `sudo python setup.py install`

## Getting started
Here is how we exchange tables of floats or ints between Matlab and Python:
#### Matlab side:
```
bridge = MatlabInterface();
disp('Sending message to Python...')
bridge.send([1, 2, 3])
disp('Reading response from Python...')
answer = bridge.read()
disp(['Received: ', answer])   % Python answers the table "4 5 6"
```
Example file: [test_matlab_interface.m](matlab_source/test_matlab_interface.m)

#### Python side
```
bridge = PythonInterface()
print("Reading from Matlab...")
recv = bridge.read()
print("Received: {}".format(recv))
bridge.send([4, 5, 6])
print("Answer to Matlab sent!")
```
Example file: [test_python_interface](script/test_python_interface)

#### Multi-channels example
See also [test_matlab_interface_multiple_channels.m](matlab_source/test_matlab_interface_multiple_channels.m) and [test_python_interface_multiple_channels](script/test_python_interface_multiple_channels) to use multiple channels implemented as network ports. Default port is 5560.

## Troubleshooting
### Matlab error `Attempt to execute SCRIPT xxxxx as a function`
If xxxxx concerns a ZMQ-related script, make sure that you have compiled matlab-zmq and that it succeeded
