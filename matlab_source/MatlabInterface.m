classdef MatlabInterface
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
            matlab_flag =  '';
            python_flag = '';
            matlab_file = '';
            python_file = '';
            rate = 0.001;
    end
    
    methods
        function self = MatlabInterface(channel_name)
            if nargin == 0
                channel_name = 'default'
            end
            shared_folder = [tempdir, 'matlab_bridge/']
            self.matlab_flag =  [shared_folder, channel_name, '/flagMatlabFinished.txt'];
            self.python_flag = [shared_folder, channel_name, '/flagPythonFinished.txt']
            self.matlab_file = [shared_folder, channel_name, '/matlab_file.json'];
            self.python_file = [shared_folder, channel_name, '/python_file.json'];
            % create the folder for file exchange
            [s,mess,messid] = mkdir(shared_folder);
            % in case the folder already exist clear its content
            delete([shared_folder,'*'])
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
            % unset the flag
            self.unset_python_flag()
        end
    end
end

