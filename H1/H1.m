%% Entregable H1:
clc; clearvars; close all;

% addpath('I:\vc\sample images');

%% Ejercicio 1
% Obtener la imagen diferencia entre el patrón y la imagen Blispac2, y comprobar si la falta 
% de alineación entre las imágenes puede causar problemas en el control de calidad.

%Cargar y visualizar imágenes originales
% Leer las imágenes y normalizar sus valores al rango [0, 1]
imagen1 = double(imread('Blispac1.tif')) / 255; % Imagen de referencia
imagen2 = double(imread('Blispac2.tif')) / 255; % Imagen a comparar

% Mostrar las imágenes originales en una misma figura usando subplot
figure;
subplot(1, 3, 1), imshow(imagen1), title('Imagen 1 (Referencia)'), impixelinfo;
subplot(1, 3, 2), imshow(imagen2), title('Imagen 2 (Comparación)'), impixelinfo;


blister1 = imread('Blispac1.tif');
figure, subplot(2,2,1), imshow(blister1), title("Blister 1")
blister2 = imread('Blispac2.tif');
subplot(2,2,2), imshow(blister2), title("Blister 2")
%Observamos el desfase inicial
result = blister1 - blister2;
subplot(2,2,3), imshow(result), title("Resta de los blisters")

% Procesamos los blisters
paqueteBlisters = cat(4,blister1,blister2);
P = [];
for i=1:2
    rgb = paqueteBlisters(:,:,:,i);
    green = rgb(:,:,2);
    % Creamos una máscara con las pastillas
    h = uint8(green > 50);
    green = green .* h;
    green = green ~= 0;
    % Eliminamos el ruido de la imagen
    greenFiltered = medfilt2(green,[11,11]);
    % Etiquetamos las regiones conexas de la imagen
    labeledImage = bwlabel(greenFiltered);
    % Obtenemos la lista de píxeles de cada pastilla
    stats = regionprops(labeledImage, 'PixelList');
    % Calculamos los centros de masas
    centros = [];
    for k = 1:length(stats)
        pixelList = stats(k).PixelList;
        cx = mean(pixelList(:,1));
        cy = mean(pixelList(:,2));
        centros = [centros; cx, cy];
    end
    % Extraemos los centros de las pastillas por fila
    f1 = sortrows(centros([1:4],:),2);
    f2 = sortrows(centros([5:8],:),2);
    f3 = sortrows(centros([9:12],:),2);
    % Seleccionamos 3 pastillas que generen un sistema l.i
    p1 = [f1(1,:),1];
    p2 = [f1(4,:),1];
    p3 = [f3(1,:),1];
    P = cat(1,P,p1,p2,p3);
end
p11 = P(1,:);
p21 = P(2,:);
p31 = P(3,:);
p12 = P(4,:);
p22 = P(5,:);
p32 = P(6,:);

%% Ejercicio 2
% Obtener la matriz de transformación afín (T) que permita alinear las dos imágenes.
% Los valores de la matriz T se deben obtener resolviendo las ecuaciones pertinentes,
% a partir de las coordenadas de las pastillas en las imágenes (pueden obtenerse manualmente).

R = [p12(1:2) p22(1:2) p32(1:2)]';
M = [p11,0,0,0; 0,0,0,p11; p21,0,0,0; 0,0,0,p21; p31,0,0,0; 0,0,0,p31];
I = M\R;
I = round(I);

%% Ejercicio 3
% Transformar geométricamente una de las imágenes para que quede alineada con la otra.
% (se puede usar la función imwarp)

T = affine2d([I(1:2)',0;I(4:5)',0;0 0 1]);
blisterModificado = imwarp(blister1, T);
blisterM = imtranslate(blisterModificado, [I(3),I(6)]);
blisterM = imresize(blisterM, size(blister1, [1, 2]));
result = blisterM - blister2;

figure;
tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
nexttile;
imshow(blisterM), title('Transformación afín + traslación');
nexttile;
imshow(result), title('Resta con blisters ajustados');

%% Ejercicio 4
% Obtener la imagen diferencia entre las dos imágenes alineadas y detectar la presencia de pastillas de color diferente.

hsv = rgb2hsv(result);
hue = hsv(:,:,1);
% Aplicamos la máscara a los valores de tono (hue)
h = hue > 0.65;
h2 = hue < 0.68;
hue = hue .* h .* h2;
hue = hue ~= 0;
% Eliminamos el ruido de la imagen
hueFiltered = medfilt2(hue,[13,13]);

figure;
tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
nexttile;
imshow(hue), title('Pastillas Diferentes');
nexttile;
imshow(hueFiltered), title('Pastillas Diferentes sin ruido');

%% Calcular la diferencia absoluta entre las imágenes
% Usar imabsdiff para calcular la diferencia absoluta entre las dos imágenes
diferencia = imabsdiff(imagen1, imagen2);

% Mostrar la diferencia en la misma figura
figure, imshow(diferencia), title('Diferencia Absoluta'), impixelinfo;
