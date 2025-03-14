

ejecutar.m es el script principal del Sistema de Reconocimiento de Gestos en Tiempo Real para control de un Brazo Robótico


------usersData-----------------
Es la carpeta donde la rutina de entrenamiento guarda las señales electromiográficas EMG.


------MATLAB-----------------
GUI: contiene las funciones y figuras dependientes de la interfaz gráfica. 
images: contiene las imágenes de las 6 clases que reconoce el Sistema de Reconocimiento de Gestos
scripts&Functions


-----------EV3--------------
"Lego ev3 Toolbox" es un toolbox de Matlab para control de Lego Mindstorms EV3. Se utiliza para enviar comandos al EV3 desde Matlab.

"modelos rearmado Lego" contiene los archivos del software Lego Digital Designer para rearmado del brazo robótico.

"robot3GDL.ev3" es el framework para control del brazo robótico en Lego Mindstorms Education EV Teacher Edition.



-----------MyoMex--------------
Esta librería conecta a Matlab con el Myo Armband. Para ello, compila una función en C++ como función MEX.
Nota: el sistema de Reconocimiento de gestos no realiza la instalación de MyoMex; en caso de requerir compilar la función MEX nuevamente, siga las guías de instalación y sobreescribir la librería MyoMex.
