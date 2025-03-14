classdef (Abstract) HGR_model < handle
    %HGR_model is an abstract class with common methods for evaluation of
    %Hand Gesture Recognition models.

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
    properties (Constant, Abstract)
        num_gestures;
        gestures;
        noGesture_name;
    end

    methods
        %% Constructor
        % -----------------------------------------------------------------
        function obj = HGR_model()
            %HGR_model(...)
            %
        end
    end
    methods
        userData = load_user(obj);

    end
    methods (Abstract)
        %%
        class_predicted = classify(obj, EMG);

        [predictions, class_predicted, raw_predictions] = ...
            evaluate_sample_windows(obj, windows);
    end


    %%
    % -----------------------------------------------------------------
    methods(Static)
        function response = format_sample_response(predictions, ...
                class_predicted, window_length, stride, EMG_size, time)
            %obj.format_sample_response() formats the response to fit the
            %evalRecognition library.

            % # ---- Data Validation
            arguments
                predictions (1, :) string
                class_predicted (1, 1) string
                window_length (1, 1) double
                stride (1, 1) double
                EMG_size (1, 1) double
                time (1, 1) double
            end

            % # ----
            numw = numel(predictions);

            response.vectorOfLabels = categorical(predictions);

            response.vectorOfTimePoints = window_length:stride:EMG_size;
            response.vectorOfProcessingTimes = time/numw;
            response.class = class_predicted;
        end

        %%
        % -----------------------------------------------------------------
        function rawData = load_presegmentation_data(folder)
            %obj.load_presegmentation_data loads the data that is in the
            %format dividing in traing and testing samples.
            %

            % # ---- Data Validation
            arguments
                folder (1, 1) string
            end

            % # ----
            rawData = load(fullfile(folder, "userData")).userData;
        end

        %%
        % -----------------------------------------------------------------
        function indices = load_segmentation_info(folder, username)
            %obj.load_segmentation_info loads the segmentation data.
            %

            % # ---- Data Validation
            arguments
                folder (1, 1) string
                username (1, 1) string
            end

            % # ----
            indices = load(fullfile(folder, ...
                "indicesTodos")).indices.(username);
        end

        %%
        % -----------------------------------------------------------------
        function samples = label_samples(samples, gt_indices)
            %obj.label_samples() includes the gt fields in the samples.
            %
            %

            % # ---- Data Validation
            arguments
                samples (:, 1) cell
                gt_indices
            end

            % # ----
            for i = 1:length(samples)
                r = samples{i};
                g = r.gestureName;
                if isequal(g, "relax")
                    % relax does not have segmentation
                    continue
                end

                tamEMG = size(r.emg, 1);
                GT = false(1, tamEMG);
                ii = mod(i, 30);

                if ii == 0
                    ii = 30;
                end

                GT(gt_indices.(g)(ii, 1):gt_indices.(g)(ii, 2)) = true;
                r.groundTruth = GT;
                r.groundTruthIndex = gt_indices.(g)(ii, :);

                samples{i} = r;
            end
        end
        %%
        % -----------------------------------------------------------------
        function samples = get_raw_samples(rawData, gestures)
            %obj.get_raw_samples retrieves the samples from the rawData
            %estructure.
            %

            % # ---- Data Validation
            arguments
                rawData
                gestures (1, :) string
            end

            % # ---- loop by gesture
            samples = {};
            for g = gestures

                for rep = rawData.gestures.(g).data'
                    r = rep{1};
                    r.gestureName = g;
                    samples{end + 1, 1} = r;
                end
            end
        end
        %%
        % -----------------------------------------------------------------
        function windows = split_sample_windows(EMG, window_length, stride)
            %obj = split_sample_windows() returns the signal EMG divided in
            %windows with the given stride. By default the first window is
            %filled with the whole signal. It leaves apart the rest of the
            %signal that does not complete the stride.
            %


            % # ----- Data Validation
            arguments
                EMG (:, 8) double
                window_length (1, 1) double {mustBePositive, mustBeInteger}
                stride (1, 1) double {mustBePositive}
            end

            % # ----- dependent vars
            windows = {};

            % # ----- looping
            ti = 1;
            to = window_length;

            while to <= length(EMG)
                windows{1, end + 1} = EMG(ti:to, :);
                ti = ti + stride;
                to = to + stride;
            end
        end

        %%
        % -----------------------------------------------------------------
        function samples = invertChannels(samples, newOrder)
            %obj.invertChannels resamples the EMGs with the new order.
            %

            % # ---- Data Validation
            arguments
                samples        (:, 1) cell
                newOrder    (1, 8) double
            end

            % # ----
            for i = 1:numel(samples)
                samples{i}.emg = samples{i}.emg(:, newOrder);
            end

        end
    end
end
% More properties at: AbortSet, Abstract, Access, Dependent, GetAccess, ...
% GetObservable, NonCopyable, PartialMatchPriority, SetAccess, ...
% SetObservable, Transient, Framework attributes
% https://www.mathworks.com/help/matlab/matlab_oop/property-attributes.html

% Methods: Abstract, Access, Hidden, Sealed, Framework attributes
% https://www.mathworks.com/help/matlab/matlab_oop/method-attributes.html