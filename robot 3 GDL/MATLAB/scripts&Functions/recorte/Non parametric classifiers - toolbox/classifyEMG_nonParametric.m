function [predicted_Y, actual_Y, time] = classifyEMG_nonParametric(train_X,...
    train_Y, test_X, test_Y, options)
Fa = options.Fa;
Fb = options.Fb;
rectFcn = options.rectFcn;
strideLength = options.strideLength;
windowLength = options.windowLength;
w = options.dtwWindow;
k = options.k;
numTestingClasses = length(test_X);
predicted_Y = cell(1, numTestingClasses);
actual_Y = cell(1, numTestingClasses);
time = cell(1, numTestingClasses);
parfor class_i = 1:numTestingClasses
    test_emg_class_i = test_X{class_i};
    numTestingTrials_class_i = length(test_emg_class_i);
    for trial_j = 1:numTestingTrials_class_i
        fprintf('Gesture: %d/%d, Sample: %d/%d\n', ...
            class_i, numTestingClasses, trial_j, numTestingTrials_class_i);
        test_emg_class_i__trial_j = test_emg_class_i{trial_j};
        % Window observation
        count = 0;
        emgLength = size(test_emg_class_i__trial_j, 1);
        numClassifications = floor((emgLength - windowLength)/strideLength) + 1;
        predLabelSeq = zeros(5, numClassifications);
        timeSeq = zeros(5, numClassifications);
        while true
            startPoint = strideLength*count + 1;
            endPoint = startPoint + windowLength - 1;
            if endPoint > emgLength
                break;
            end
            tStart = tic;
            window_emg = test_emg_class_i__trial_j(startPoint:endPoint, :);
            filt_window_emg = preProcessEMGSegment(window_emg, Fa, Fb, rectFcn);
            t_acqAndFilt = toc(tStart);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %                         figure(1);
            %                         for c = 1:8
            %                             subplot(4, 2, c);
            %                             plot(window_emg(:, c), 'r');
            %                             hold all;
            %                             plot(filt_window_emg(:, c), 'k');
            %                             hold off;
            %                             ylim([-1 1]);
            %                             title(['CH: ' num2str(c)]);
            %                         end
            %                         hold off;
            %                         disp('press Enter to continue');
            %                         pause
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Computing the DTW distance
            tStart = tic;
            distanceDTW = dtwDistance(train_X, filt_window_emg, w);
            t_dtw = toc(tStart);
            % Entropy
            tStart = tic;
            Pr_E = computeProbability(distanceDTW, train_Y, k, 'entropy');
            [probabilityLabel_E, predictedLabel_E] = max(Pr_E);
            t_classificationE = toc(tStart);
            tStart = tic;
            if probabilityLabel_E < 0.5
                predictedLabel_E = 1;
                probabilityLabel_E = NaN;
            end
            t_threshE = toc(tStart);            
            % DTW
            tStart = tic;
            Pr_DTW = computeProbability(distanceDTW, train_Y, k, 'sumDTW');
            [probabilityLabel_DTW, predictedLabel_DTW] = max(Pr_DTW);
            t_classificationDTW = toc(tStart);
            tStart = tic;
            if probabilityLabel_DTW < 0.8
                predictedLabel_DTW = 1;
                probabilityLabel_DTW = NaN;
            end
            t_threshDTW = toc(tStart);
            % Entropy + DTW
            tStart = tic;
            mean_E_DTW = mean([Pr_E Pr_DTW], 2);
            [probabilityLabel_E_DTW, predictedLabel_E_DTW] = max(mean_E_DTW);
            t_classificationE_DTW = toc(tStart);
            tStart = tic;
            if probabilityLabel_E_DTW < 0.6
                predictedLabel_E_DTW = 1;
                probabilityLabel_E_DTW = NaN;
            end
            t_threshE_DTW = toc(tStart);
            % Maximum cross-correaltion
            tStart = tic;
            c_cVal = crossCorrelation(train_X, filt_window_emg);
            Pr_C = computeProbability(c_cVal, train_Y, k, 'crossCorrelation');
            [probabilityLabel_C, predictedLabel_C] = max(Pr_C);
            t_classificationC = toc(tStart);
            tStart = tic;
            if probabilityLabel_C < 0.5
                predictedLabel_C = 1;
                probabilityLabel_C = NaN;
            end
            t_threshC = toc(tStart);
            % Maximum cross-correlation + DTW
            tStart = tic;
            mean_C_DTW = mean([Pr_C Pr_DTW], 2);
            [probabilityLabel_C_DTW, predictedLabel_C_DTW] = max(mean_C_DTW);
            t_classificationC_DTW = toc(tStart);
            tStart = tic;
            if probabilityLabel_C_DTW < 0.5
                predictedLabel_C_DTW = 1;
                probabilityLabel_C_DTW = NaN;
            end
            t_threshC_DTW = toc(tStart);
            
            % Storing predictions
            count = count + 1;
            predLabelSeq(1, count) = predictedLabel_E;
            predLabelSeq(2, count) = predictedLabel_DTW;
            predLabelSeq(3, count) = predictedLabel_E_DTW;
            predLabelSeq(4, count) = predictedLabel_C;
            predLabelSeq(5, count) = predictedLabel_C_DTW;
            
            % Computing times
            timeSeq(1, count) = t_acqAndFilt + t_dtw + t_classificationE + t_threshE;
            timeSeq(2, count) = t_acqAndFilt + t_dtw + t_classificationDTW + t_threshDTW;
            timeSeq(3, count) = t_acqAndFilt + t_dtw + t_classificationE_DTW + t_threshE_DTW;
            timeSeq(4, count) = t_acqAndFilt + t_classificationC + t_threshC;
            timeSeq(5, count) = t_acqAndFilt + t_classificationC_DTW + t_threshC_DTW;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             figure(1);
            %             imagesc([P, mean(P(:,1:2),2), mean(P(:,2:3),2)], [0 1]);
            %             colormap jet;
            %             colorbar;
            %             yLabels = {code2gesture_mb( 1 ),...
            %                 code2gesture_mb( 2 ),...
            %                 code2gesture_mb( 3 ),...
            %                 code2gesture_mb( 4 ),...
            %                 code2gesture_mb( 5 ),...
            %                 code2gesture_mb( 6 )};
            %             set(gca, 'xtick', 1:5);
            %             set(gca, 'xticklabels', {'Entropy', 'DTW', 'Corr', 'E_DTW', 'C_DTW'});
            %             set(gca, 'yticklabels', yLabels);
            %             title(['C_DTW: ' code2gesture_mb(predictedLabel_C_DTW),...
            %                 '(' num2str(probabilityLabel_C_DTW) ')',...
            %                 ', E_DTW: ' code2gesture_mb(predictedLabel_E_DTW),...
            %                 '(' num2str(probabilityLabel_E_DTW) ')',...
            %                 ', E: ' code2gesture_mb(predictedLabel_E),...
            %                 '(' num2str(probabilityLabel_E) ')',...
            %                 ', DTW: ' code2gesture_mb(predictedLabel_DTW),...
            %                 '(' num2str(probabilityLabel_DTW) ')',...
            %                 ', C: ' code2gesture_mb(predictedLabel_C),...
            %                 '(' num2str(probabilityLabel_C) ')']);
            %             disp('ENTER');
            %             pause
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        predicted_Y{class_i}{trial_j} = predLabelSeq;
        actual_Y{class_i}{trial_j} = test_Y{class_i}{trial_j}(1);
        time{class_i}{trial_j} = timeSeq;
    end
end
return