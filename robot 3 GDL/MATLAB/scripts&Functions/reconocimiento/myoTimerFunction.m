function myoTimerFunction()
% timer function for reading MYO. Data is transfered as global variables

global  emg   myoObject  flags

if flags.leidoMyo == 1 % cuando no se utilizó antes la señal...
    emg= [emg ; myoObject.myoData.emg_log ] ;
else % algo hicieron con la señal...
    emg= myoObject.myoData.emg_log ;
end

myoObject.myoData.clearLogs();
flags.leidoMyo = 1 ;
flags.kMyoRecibido = flags.kMyoRecibido + 1 ;

end