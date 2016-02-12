#!/usr/bin/env python
import os.path
import json
import time
import tempfile

class PythonInterface(object):
    def __init__(self, channel_name="default"):
        shared_folder = os.path.join(tempfile.gettempdir(), 'matlab_bridge', channel_name)
        # create share_folder if necessary
        if not os.path.exists(shared_folder):
            os.makedirs(shared_folder)
        else:
            # delete the content of the folder
            for the_file in os.listdir(shared_folder):
                file_path = os.path.join(shared_folder, the_file)
                try:
                    if os.path.isfile(file_path):
                        os.unlink(file_path)
                except Exception as e:
                    print(e)
        # set the flag path

        self.matlab_flag = os.path.join(shared_folder, 'flagMatlabFinished.txt')
        self.python_flag = os.path.join(shared_folder, 'flagPythonFinished.txt')
        # define matlab file to read
        self.matlab_file = os.path.join(shared_folder, 'matlab_file.json')
        # define python file to send
        self.python_file = os.path.join(shared_folder, 'python_file.json')
        # define the rate for sleeping
        self.rate = 0.01

    def is_matlab_flag_set(self):
        return os.path.isfile(self.matlab_flag)

    def unset_matlab_flag(self):
        os.remove(self.matlab_flag)

    def wait_for_matlab_flag(self):
        # loop until the flag is set
        while not self.is_matlab_flag_set():
            time.sleep(self.rate)

    def set_python_flag(self):
        open(self.python_flag, 'a').close()

    def remove_matlab_file(self):
        os.remove(self.matlab_file)

    def send(self, data):
        # write the json file to the shared folder
        with open(self.python_file, 'w') as output_file:
            json.dump(data, output_file)
        # set the python flag
        self.set_python_flag()

    def read(self):
        # wait for the flag to be set
        self.wait_for_matlab_flag()
        # open the structure
        with open(self.matlab_file) as data_file:
            data = json.load(data_file)
        # remove the read file
        self.remove_matlab_file()
        # unset the flag
        self.unset_matlab_flag()
        # return the structure
        return data

