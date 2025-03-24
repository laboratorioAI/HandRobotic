classdef Model_spec_CNN_LSTM < HGR_model
    %Model_spec_CNN_LSTM implements the methods needed for hand gesture
    %recognition.

    %{
    Laboratorio de Inteligencia y Visión Artificial
    ESCUELA POLITÉCNICA NACIONAL
    Quito - Ecuador
    
    autor: z_tja
    jonathan.a.zea@ieee.org
    
    "I find that I don't understand things unless I try to program them."
    -Donald E. Knuth
    
    10 May 2023
    Matlab 9.11.0.2179507 (R2021b) Update 5.
    %}

    %%
    properties (Access=public)

    end
    properties (Hidden=true)

    end
    properties (Constant)
        % including no gesture
        num_gestures = 6;
        gestures = ["waveIn", "waveOut", "fist", "open", "pinch", "relax"];
        noGesture_name = "relax";
        SPECTROGRAM_WINDOW = 24;
        FREQUENCY = 200;
        SPECTROGRAM_FRECUENCIES = 0:12;
        OVERLAPPING = floor(Model_spec_CNN_LSTM.SPECTROGRAM_WINDOW*0.5);

        model_noGesture = "noGesture";
    end

    properties (SetAccess = immutable)
        Fa
        Fb

        classes % 6-by-1 categorical
    end
    properties (SetAccess = protected)
        model
    end

    methods
        %% Constructor
        % -----------------------------------------------------------------
        function obj = Model_spec_CNN_LSTM(model_file)
            %Model_spec_CNN_LSTM(...) constructor, it loads the net object
            %for classification.
            %

            % # ---- Data Validation
            arguments
                model_file (1, 1) string = "modelLSTM_s30_e10.mat";
            end

            % # ----
            obj.model = load(model_file).net;
            obj.classes = obj.model.Layers(80).Classes;
            [obj.Fb, obj.Fa] = butter(5, 0.1, 'low');
        end

        %%
        % -----------------------------------------------------------------
        function [predictions, class_predicted, raw_predictions] = ...
                evaluate_sample_windows(obj, windows, unified)
            %obj.evaluate_sample_windows() runs the model to obtain the
            %predictions of the consecutive windows of a sample.
            % It applies the postprocessing.


            % # ---- Data Validation
            arguments
                obj
                windows (1, :) cell
                unified (1, 1) logical = false;
            end


            % # ----
            if unified
                % todas las ventanas de una misma repeticion
                [raw_predictions, prob] = obj.classify_sequence(windows);
            else
                % loop por cada ventana
                raw_predictions = {};
                obj.model = obj.model.resetState;
                for w = windows
                    [class_predicted, ~] = obj.classify(w{1});
                    raw_predictions{1, end + 1}  = class_predicted{1};
                end
                obj.model = obj.model.resetState;
                raw_predictions = [raw_predictions{:}];
            end

            % # ---- post-processing
            predictions = categorical("noGesture");
            li = 3;
            for li = 3:numel(raw_predictions)
                if raw_predictions(li - 2) == raw_predictions(li)
                    p = raw_predictions(li - 1);
                else
                    p = categorical("noGesture");
                end
                predictions(1, end + 1) = p;
            end
            % duplicating last label...
            predictions(1, end + 1) = p;

            % # ---- class
            active_classes = predictions( ...
                predictions ~= obj.model_noGesture);

            if isempty(active_classes)
                class_predicted = obj.model_noGesture;
            else
                class_predicted = mode(active_classes);
            end
        end

        %%
        % -----------------------------------------------------------------
        function spectrograms = preprocess(obj, EMG)
            %obj.preprocess() returns the feature map to use in
            %classification for a given EMG matrix.
            %


            % # ---- Data Validation
            arguments
                obj
                EMG (:, 8) double
            end

            % # ----
            signal = filtfilt(obj.Fb, obj.Fa, abs(EMG));

            % # ---- loop by channel
            spectrograms = [];
            for i = 1:8
                [s,~,~,~] = spectrogram(signal(:,i), ...
                    obj.SPECTROGRAM_WINDOW, obj.OVERLAPPING, ...
                    obj.SPECTROGRAM_FRECUENCIES, ...
                    obj.FREQUENCY, 'yaxis');

                if isempty(spectrograms)
                    spectrograms = abs(s).^2; % ps;
                else
                    spectrograms(:, :, end + 1) = abs(s).^2; % ps;
                end
            end

        end
        %%
        % -----------------------------------------------------------------
        function [class_predicted, prob] = classify(obj, EMG)
            %obj.classify runs the model to find the label of a raw EMG
            %matrix.
            %

            % # ---- Data Validation
            arguments
                obj
                EMG (:, 8) double
            end

            % # ---- loop by channel
            spectrograms = obj.preprocess(EMG);

            %class_predicted parece q class predicted tiene un bug
            [obj.model, class_predicted, probs] = ...
                obj.model.classifyAndUpdateState(spectrograms);
            %obj.model.classifyAndUpdateState({spectrograms});

            [max_prob, idx_class]= max(probs);
            class_predicted = obj.classes(idx_class);
        end

        %%
        % -----------------------------------------------------------------
        function [class_predicted, prob] = classify_sequence(obj, windows)
            %obj.classify_sequence runs the model to find the labels of the
            %windows.
            %

            % # ---- Data Validation
            arguments
                obj
                windows (1, :) cell
            end

            sequence = cellfun(@(x)obj.preprocess(x), windows, ...
                'UniformOutput',false);
            feature_map = cat(4, sequence{:});
            [class_predicted, prob] = obj.model.classify(feature_map);
        end
    end

end