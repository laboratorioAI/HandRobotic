clc;
close all;
clear all;
warning off all;

%% COMMON DATA
%% =======================================================================
% Write a list for the rest of users OR load from a variable
users = {'CristhianMotoche', 'JonathanZea'}; % DEBE ACTUALIZAR ESTE CAMPO CON LOS NOMBRES DE LOS USUARIOS


%% LOAD TARGETS AND OUTPUTS
%% =======================================================================
gestures = {'relax', 'fist', 'wave_in', 'wave_out', 'fingers_spread', 'double_tap'}; % NO MODIFICAR

% Training and testing data folder
pathName = 'data';

for user_i = 1:length(users)
    %% MESSAGES
    clc;
    fprintf('Users: %d/%d\n', user_i, length(users));
    
    %% TRAINING
    % Training samples
    version = 'training';
    [train_RawX, train_Y] = getTotalXnYByUser_mb(pathName, users{user_i}, version, gestures);
  
end
fprintf('ESTRUCTURA DE DATOS CORRECTA \n');
