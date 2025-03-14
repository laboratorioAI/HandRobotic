classdef Myo < handle
    %Myo class to communicate with myo

    %{
    Laboratorio de Inteligencia y Visión Artificial
    ESCUELA POLITÉCNICA NACIONAL
    Quito - Ecuador
    
    autor: ztjona!
    jonathan.a.zea@ieee.org
    
    "I find that I don't understand things unless I try to program them."
    -Donald E. Knuth
    
    12 August 2021
    Matlab 9.9.0.1592791 (R2020b) Update 5.
    %}

    %%
    properties (GetAccess = public, SetAccess=private)
        isConnected = false;
        myoObject
    end

    methods
        %% Constructor
        % -----------------------------------------------------------------
        function obj = Myo()
            %Myo(...) creates a new myo object
            %

            % # ----
            connectMyo(obj);
            if ~obj.isConnected 
                connectMyo(obj);
            end

            if ~obj.isConnected 
                warning("No se pudo conectar")
            end
        end

        connectMyo(obj)
        terminateMyo(obj)

        %%
        % -----------------------------------------------------------------
        function resetBuffer(obj)
            obj.myoObject.myoData.clearLogs();
        end



        %%
        % -----------------------------------------------------------------
        function emg = readEmg(obj)
            %obj.readEmg() returns EMG signal
            %# Outputs
            %* emg		-M-by-8
            %

            % # ----
            emg = obj.myoObject.myoData.emg_log;
            obj.myoObject.myoData.clearLogs();
        end




        %%
        % -----------------------------------------------------------------
        function data = load_EMG_window(obj, window_size)
            %obj.load_EMG_window() returns the most recent EMG data inside
            %a window.
            %
            
            % # ---- Data Validation
            arguments
                obj
                window_size (1, 1) double {mustBePositive, mustBeInteger}
            end
        
            % # ---- 
            persistent emg;
            if isempty(emg)
                emg = zeros(window_size, 8);
            end
            
            

            %--- saturating input
            newData = obj.readEmg();

            stride = size(newData, 1);
            if stride > window_size
                stride = window_size;
            end

            emg = circshift(emg, -stride, 1);

            emg(end - stride + 1:end, :) = newData( ...
                end - stride + 1:end, :);
            data = emg;
        end


        %% 
        % -----------------------------------------------------------------
        function delete(obj)
            obj.terminateMyo();
        end
    end

    methods (Static)
        
    end
end
% More properties at: AbortSet, Abstract, Access, Dependent, GetAccess, ...
% GetObservable, NonCopyable, PartialMatchPriority, SetAccess, ...
% SetObservable, Transient, Framework attributes
% https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html

% Methods: Abstract, Access, Hidden, Sealed, Framework attributes
% https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html