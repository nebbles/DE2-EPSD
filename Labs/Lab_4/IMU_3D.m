%  IMU_3D - a Matlab class to work with the PyBench Board
%  ....  designed for Dyson School of Design Engineering
%   ...  second year course on signals, systems and control
%   This class create a 3D model of the PyBench board
%  ....   and draw this at a defined pitch and roll angle
%
%  Author:  Peter Y K Cheung, Imperial College
%  Version: 1.0,  25, Dec 2016
%

classdef IMU_3D
    properties (GetAccess = public,SetAccess = public)
        a = 75;  	% 0.5 x width of board in mm
        b = 35;     % 0.5 x depth of board
        c = 5;      % 0.5 x height of board
        p1;         % p1 to p8 are coordinates of all 8 corners
        p2;
        p3; p4; p5; p6; p7; p8; box;
    end
    
    methods
        % initialization - usage:   pb_model = PyBench3D ( );
        function obj = IMU_3D()  % Constructor
            % define all corner coordinates of the box
            obj.p1 = [-obj.a -obj.b obj.c];
            obj.p2 = [-obj.a obj.b obj.c];
            obj.p3 = [obj.a obj.b obj.c];
            obj.p4 = [obj.a -obj.b obj.c];
            obj.p5 = [-obj.a -obj.b -obj.c];
            obj.p6 = [-obj.a obj.b -obj.c];
            obj.p7 = [obj.a obj.b -obj.c];
            obj.p8 = [obj.a -obj.b -obj.c];
            obj.box=[obj.p1; obj.p2;
                obj.p3; obj.p4;
                obj.p5; obj.p6;
                obj.p7; obj.p8];
        end
        
        function draw(obj, fig, pitch, roll, subtitle)
            %
            % Method to draw the 3D model
            %     fig - figure handle  (created by the calling script)
            %     pitch - pitch angle defined as positive if tilting towards you
            %     roll - roll angle defined as positive if rotate anti-clockwise
            %   usage:    	fh = figure (1);
            %			pb_model = PyBench3D ( );
            %			pb_model.draw (fh, 0, 10);
            
            % compute the direction cosine matrix from Euler angles
            dcm = angle2dcm(0, -roll, pitch);  % yaw is 0
            new_box = obj.box*dcm;      % compute the new coordinates
            q1 = new_box(1,:);          % extract the new corners
            q2 = new_box(2,:);
            q3 = new_box(3,:);
            q4 = new_box(4,:);
            q5 = new_box(5,:);
            q6 = new_box(6,:);
            q7 = new_box(7,:);
            q8 = new_box(8,:);
            
            % draw the box
            axis([-120 120 -100 100 -80 80]);
            title(subtitle,'FontSize', 16);
            xlabel('Roll (degrees)');
            ylabel('Pitch (degrees)');
            grid on;  hold on;
            
            poly_rectangle(q1, q2, q3, q4, 0.0);  % draw each surface
            poly_rectangle(q5, q6, q7, q8, 0.2);
            poly_rectangle(q1, q4, q8, q5, 0.4);
            poly_rectangle(q4, q3, q7, q8, 0.6);
            poly_rectangle(q2, q3, q7, q6, 0.8);
            poly_rectangle(q1, q2, q6, q5, 1.0);
        end
    end
end
