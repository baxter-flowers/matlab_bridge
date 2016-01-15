classdef MatlabInterface
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shared_folder = '/tmp/matlab_bridge/';
        matlab_flag = 'flagMatlabFinished.txt';
        python_flag = 'flagPythonfinished.txt'
        matlab_file = 'matlab_file.json';
        python_file = 'python_file.json';
        rate = 0.001;
    end
    
    methods
        function self = MatlabInterface()
            self.matlab_flag = [self.shared_folder, self.matlab_flag];
            self.python_flag = [self.shared_folder, self.python_flag];
            self.matlab_file = [self.shared_folder, self.matlab_file];
            self.python_file = [self.shared_folder, self.python_file];
            
            % create the folder for file exchange
            [s,mess,messid] = mkdir(self.shared_folder);
            % in case the folder already exist clear its content
            delete([self.shared_folder,'*'])
        end
        
        function set_matlab_file(filename)
            self.matlab_file = [self.shared_folder, filename];
        end
        
        function set_matlab_flag(filename)
            self.matlab_flag = [self.shared_folder, filename];
        end
        
        function set_python_file(filename)
            self.python_file = [self.shared_folder, filename];
        end
        
        function set_python_flag(filename)
            self.python_flag = [self.shared_folder, filename];
        end
        
        function bool_flag = is_python_flag_set(self)
            % check if file exist
            bool_flag = (exist(self.python_flag, 'file') == 2);
        end

        function unset_python_flag(self)
            delete(self.python_flag)
        end

        function wait_for_python_flag(self)
            % loop until the flag is set
            while ~self.is_python_flag_set()
                pause(self.rate)
            end
            % unset the flag
            self.unset_python_flag()
        end
        
        function set_matlab_flag(self)
            % create the empty file
            fclose(fopen(self.matlab_flag, 'w'));
        end
        
        function remove_python_file(self)
            delete(self.python_file)
        end
        
        function send(self, data)
            % write the json file to the shared folder
            savejson('', data, self.matlab_file);
            % set the matlab flag
            self.set_matlab_flag()
        end
        
        function s = read(self)
            % wait for the flag to be set
            self.wait_for_python_flag()
            % open the structure
            s = loadjson(self.python_file);
            % remove the read file
            self.remove_python_file()
        end
    end
end

