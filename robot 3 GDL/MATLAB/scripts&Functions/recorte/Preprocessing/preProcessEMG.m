function emg_out = preProcessEMG(emg_in, options)
Fa = options.Fa;
Fb = options.Fb;
rectFcn = options.rectFcn;
plotSignals = options.plotSignals;
numClasses = length(emg_in);
emg_out = emg_in;
for class_i = 1:numClasses
    raw_emg_class_i = emg_in{class_i};
    numTrials_class_i = length(raw_emg_class_i);
    filtered_emg_class_i = raw_emg_class_i;
    for trial_j = 1:numTrials_class_i
        raw_emg_class_i__trial_j = raw_emg_class_i{trial_j};
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if plotSignals
            if size(raw_emg_class_i__trial_j, 1) > 400
                raw_emg_class_i__trial_j = raw_emg_class_i__trial_j(1:400, :);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        filteredEMG = preProcessEMGSegment(raw_emg_class_i__trial_j, Fa, Fb, rectFcn);
        if options.detectMuscleActivity
            [idxStart, idxEnd] = detectMuscleActivity(filteredEMG, options);
        else
            idxStart = 1;
            idxEnd = size(filteredEMG, 1);
        end
        filtered_emg_class_i{trial_j} = filteredEMG(idxStart:idxEnd, :);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if plotSignals
            figure(3);
            f = gcf;
            set(f, 'Name', ['Class: ' num2str(class_i) ', Trial: ' num2str(trial_j)]);
            for c = 1:8
                subplot(4, 2, c);
                if max( abs(raw_emg_class_i__trial_j(:, c)) ) >= 1
                    raw_emg_class_i__trial_j(:, c) = raw_emg_class_i__trial_j(:, c)/128;
                end
                plot(raw_emg_class_i__trial_j(:, c), 'r');
                hold all;
                plot(filteredEMG(:, c), 'k');
                plot([1 idxStart idxStart idxEnd idxEnd size(raw_emg_class_i__trial_j, 1)],...
                    [0 0 1 1 0 0], 'b', 'linewidth', 2);
                hold off;
                ylim([-1 1]);
                title(['CH: ' num2str(c)]);
            end
            hold off;
            drawnow;
            
            figure(4);
            f = gcf;
            set(f, 'Name', ['Class: ' num2str(class_i) ', Trial: ' num2str(trial_j)]);
            subplot(2, 1, 1);
            imagesc(raw_emg_class_i__trial_j', [-1, 1]);
            colormap jet;
            colorbar;
            title('Raw EMG');
            subplot(2, 1, 2);
            imagesc(filteredEMG', [-1, 1]);
            colormap jet;
            colorbar;
            title('Filtered EMG');
            disp('press Enter to continue');
            drawnow;
            pause;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    emg_out{class_i} = filtered_emg_class_i;
end
return