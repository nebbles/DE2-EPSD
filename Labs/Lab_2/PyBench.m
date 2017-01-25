%  PyBench - a Matlab class to work with the PyBench Board
%  ...  designed for Dyson School of Design Engineering
%   ...  second year course on signals, systems and control
%   This class works with pybench.py on the Pyboard in order to
%   ...  turn the PyBench system into an electronic workbench.
%   ... Together, they provide drivers for all the functionality
%   ... found ont he PyBench board.
%
%  Author:  Peter Y K Cheung, Imperial College
%  Version: 1.1,  25, Jan 2017
%
classdef PyBench
    properties (GetAccess = public,SetAccess = public)
        BUFFERSIZE = 20000
        sig_freq = 10.0
        dc_v = 1.65;
        max_v = 3.3;
        min_v = 0.0;
        duty_cycle = 50;
        samp_freq = 100.0
        usb
    end
    
    methods
        % PyBench Constructor
        % Usage:   pb = PyBench (usb_port);
        function obj = PyBench(device)  % Constructor
            fclose('all');
            delete(instrfindall);
            %% Create Serial Object to talk with PyBoard
            obj.usb = serial(device, 'BaudRate', 115200, 'DataBits', 8);
            set(obj.usb, 'InputBufferSize', obj.BUFFERSIZE);
            fopen(obj.usb);
        end
        
         function [status] = ok(obj)
            fprintf(obj.usb, '%s', '?');
            ack = fread(obj.usb, 1);
            status = (ack == 33);                                   
        end
       
        function dc(obj, v)
            tmp = max(min(v,3.3),0.0);  % between 0 and 3.3V
            command = sprintf('V%d',int16(4095*tmp/3.3));
            fprintf(obj.usb, '%s', command);
            ack = fread(obj.usb, 1);
        end
        
        function out(obj, value)
            command = sprintf('B%d', value);
            fprintf(obj.usb, '%s', command);
            ack = fread(obj.usb, 1);
        end
        
        function sine(obj)
            fprintf(obj.usb, '%s', 'S');
            ack = fread(obj.usb, 1);
        end
        
        function triangle(obj)
            fprintf(obj.usb, '%s', 'T');
            ack = fread(obj.usb, 1);
        end
        
        function square(obj)
            fprintf(obj.usb, '%s', 'Q');
            ack = fread(obj.usb, 1);
        end
        
        function obj = set_max_v(obj, v)
            obj.max_v = max(min(v,3.3),0.0);  % between 0 and 3.3V
            command = sprintf('X%d', int16(4095*obj.max_v/3.3));
            fprintf(obj.usb, '%s', command);
            ack = fread(obj.usb, 1);
        end
        
        function obj = set_min_v(obj, v)
            obj.min_v = max(min(v,3.3),0.0);  % between 0 and 3.3V
            command = sprintf('N%d', int16(4095*obj.min_v/3.3));
            fprintf(obj.usb, '%s', command);
            ack = fread(obj.usb, 1);
        end
        
        function obj = set_sig_freq(obj, f)
            if (f>3000)
                disp('Maximum signal frequency is 3000Hz. Signal frequency not changed.')
            else
                obj.sig_freq = max(min(f,100000.0),0.1);  % between 0.1Hz and 100kHz
                command = sprintf('F%d', int16(obj.sig_freq*10));
                fprintf(obj.usb, '%s', command);
                ack = fread(obj.usb, 1);
            end
        end
        
        function obj = set_samp_freq(obj, f)
            if (f>30000)
                disp('Maximum sampling frequency is 30kHz. Sampling frequency not changed.')
            else
                obj.samp_freq = max(min(f,100000),10);  % between 0 and 3.3V
                command = sprintf('A%d', int16(obj.samp_freq));
                fprintf(obj.usb, '%s', command);
                ack = fread(obj.usb, 1);
            end
        end
        
        function obj = set_duty_cycle(obj, d)
            d_cycle = max(min(d,100),0);  % between 0 and 3.3V
            command = sprintf('D%d', int16(d_cycle));
            fprintf(obj.usb, '%s', command);
            ack = fread(obj.usb, 1);
        end
        
        function v = get_one(obj)
            fprintf(obj.usb, '%s', 'G');
            data = fread(obj.usb,2);
            v = (256*data(1) + data(2))*3.3/4096;
        end
        
        function v = sample(obj,i)
            tmp = max(min(i,4095),0);  % between 0 and 4095
            command = sprintf('B%d',tmp);
            fprintf(obj.usb, '%s', command);
            data = fread(obj.usb,2);
            v = 256*data(1) + data(2);
        end
        
        function data = get_block(obj,n)
            tmp = max(min(n,obj.BUFFERSIZE/2),1);  % between 0 and 4095
            command = sprintf('M%d',tmp);
            fprintf(obj.usb, '%s', command);
            % time it takes to sample
            pause(n/obj.samp_freq);
            raw = fread(obj.usb,tmp*2);
            data = zeros(tmp,1);    % reserve memory
            for i = 1:n
                data(i) = (raw(2*i-1)*256 + raw(2*i))*3.3/4096;
            end
        end
        
        function data = get_mic(obj,n)
            tmp = max(min(n,obj.BUFFERSIZE/2),1);  % between 0 and 4095
            command = sprintf('J%d',tmp);
            fprintf(obj.usb, '%s', command);
            % time it takes to sample
            pause(n/obj.samp_freq);
            raw = fread(obj.usb,tmp*2);
            data = zeros(tmp,1);    % reserve memory
            for i = 1:n
                data(i) = (raw(2*i-1)*256 + raw(2*i))*3.3/4096;
            end
        end
        
        function [pitch, roll] = get_accel(obj)
            fprintf(obj.usb, '%s', 'K');
            data = fread(obj.usb,6);
            accel_scale = 8192; % degree
            gyro_scale = 131;   % degree/sec
            x = data(1)*256 + data(2);
            y = data(3)*256 + data(3);
            z = data(5)*256 + data(6);
            if (data(1) >= 128)
                x = x - 65536;
            end
            if (data(3) >= 128)
                y = y - 65536;
            end
            if (data(5) >= 128)
                z = z - 65536;
            end
            x = x/accel_scale;
            y = y/accel_scale;
            z = z/accel_scale;
            pitch = -atan2(x,z);
            roll = atan2(y,z);
        end
        
        function [xdot, ydot, zdot] = get_gyro(obj)
            fprintf(obj.usb, '%s', 'L');
            data = fread(obj.usb,6);
            gyro_scale = 7150;   % radian/sec
            x = data(1)*256 + data(2);
            y = data(3)*256 + data(3);
            z = data(5)*256 + data(6);
            if (data(1) >= 128)
                x = x - 65536;
            end
            if (data(3) >= 128)
                y = y - 65536;
            end
            if (data(5) >= 128)
                z = z - 65536;
            end
            xdot = x/gyro_scale;
            ydot = y/gyro_scale;
            zdot = z/gyro_scale;
        end
        
    end  % method
end   % class