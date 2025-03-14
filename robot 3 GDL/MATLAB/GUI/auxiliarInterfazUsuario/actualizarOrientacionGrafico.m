function actualizarOrientacionGrafico(matrizRotacion,emgVector)
%% EMG
global emgAxes

for kChannel=1:8
    emgAxes{kChannel}.YData=emgVector(:,kChannel);
end


%% rot
magX = sqrt(sum(matrizRotacion(:,1).^2));
magY = sqrt(sum(matrizRotacion(:,2).^2));
magZ = sqrt(sum(matrizRotacion(:,3).^2));
ux = matrizRotacion(1,1)/magX;
vx = matrizRotacion(2,1)/magX;
wx = matrizRotacion(3,1)/magX;
uy = matrizRotacion(1,2)/magY;
vy = matrizRotacion(2,2)/magY;
wy = matrizRotacion(3,2)/magY;
uz = matrizRotacion(1,3)/magZ;
vz = matrizRotacion(2,3)/magZ;
wz = matrizRotacion(3,3)/magZ;


global orientacionGrafico
ejeX=orientacionGrafico{1};
ejeY=orientacionGrafico{2};
ejeZ=orientacionGrafico{3};

xdeProX=orientacionGrafico{4};
xdeProY=orientacionGrafico{5};
xdeProZ=orientacionGrafico{6};
ydeProX=orientacionGrafico{7};
ydeProY=orientacionGrafico{8};
ydeProZ=orientacionGrafico{9};
zdeProX=orientacionGrafico{10};
zdeProY=orientacionGrafico{11};
zdeProZ=orientacionGrafico{12};

ejeX.UData=ux;
ejeX.VData=vx;
ejeX.WData=wx;

ejeY.UData=uy;
ejeY.VData=vy;
ejeY.WData=wy;

ejeZ.UData=uz;
ejeZ.VData=vz;
ejeZ.WData=wz;

%% proyecciones
xdeProX.YData=[0 vx];
xdeProX.ZData=[0 wx];

xdeProY.XData=[0 ux];
xdeProY.ZData=[0 wx];

xdeProZ.XData=[0 ux];
xdeProZ.YData=[0 vx];

% Y
ydeProX.YData=[0 vy];
ydeProX.ZData=[0 wy];

ydeProY.XData=[0 uy];
ydeProY.ZData=[0 wy];

ydeProZ.XData=[0 uy];
ydeProZ.YData=[0 vy];

% z
zdeProX.YData=[0 vz];
zdeProX.ZData=[0 wz];

zdeProY.XData=[0 uz];
zdeProY.ZData=[0 wz];

zdeProZ.XData=[0 uz];
zdeProZ.YData=[0 vz];

end
