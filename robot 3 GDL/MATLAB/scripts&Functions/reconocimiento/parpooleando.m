%% Configurando parpool

if isempty(gcp)
    fprintf('Configurando Parpool.\n')
    parpool;
    beep
end

fprintf('Listo parpool.\n')



