%% Práctica 10:
clc; clearvars; close all;
%addpath('I:\vc\sample images');


%% Eliminar ruido con open/close
im = imread("Birds.tif");
imshow(im,[]), title('Imagen de entrada');
ee = strel('disk', 1);

op = imopen(im, ee);
figure, imshow(op,[]), title('Apertura');


cl = imclose(im, ee);
figure, imshow(cl,[]), title('Cierre');

clop = imopen(cl, ee);
figure, imshow(clop,[]), title('Cierre-Apertura radio 1');
% Aún hay pequeñas marcas (en intersecciones) donde cabe
% el elemento estructural

ee = strel('disk', 2);
clop2 = imopen(cl, ee);
figure, imshow(clop2,[]), title('Cierre-Apertura radio 2');


%% Residuos
% Residuo de la apertura -> TOP HAT (apertura-imagen)

im = imread("danaus.tif");
figure, imshow(im,[]), title('Imagen de entrada');
ee = strel('disk',1);

dil = imdilate(im,ee);
ero = imerode(im,ee);


% Contorno externo
ce = imsubtract(dil,im);
figure, imshow(ce,[]), title('Contorno externo');

% Contorno interno
ci = imsubtract(im,ero);
figure, imshow(ci,[]), title('Contorno interno');

% Contorno interno + externo
cd = imsubtract(dil,ero);
figure, imshow(cd,[]), title('Ambos contornos');

% Laplaciano -> punto pasa por 0, (contornos)
lap = imsubtract(double(ci),double(ce));
figure, imshow(lap,[]), title('Laplaciano morfológico');


%% TOP HATS

im = imread("nshadow.tif");
figure, imshow(im,[]), title('Imagen de entrada');

% Tomar un objeto más grande que los caracteres, pero más pequeño que el fondo
ee = strel('disk', 5);
op = imopen(im,ee);
figure, imshow(op,[]), title('Apertura');

res = imsubtract(im,op);
figure, imshow(res,[]), title('Residuo de apertura');

% Función directa para obtener el residuo de la apertura
th = imtophat(im,ee);
figure, imshow(th,[]), title('Top Hat');

imbw  = th>30;
figure, imshow(imbw,[]), title('Letras');

%% Ejercicio de Binarización 
im = imread("arros.tif");
figure, imshow(im,[]), title('Imagen de entrada');

ee = strel('disk', 50);
th = imtophat(im,ee);
figure, imshow(th,[]), title('Top Hat');
figure,imhist(th);

imbin  = th>20;
figure, imshow(imbin,[]), title('Arroz');

%% Reconstrucción multinivel
im = imread("bloodcells.tif");
figure, imshow(im,[]), title('Imagen de entrada');

% Eliminar agujeros de la imagen, (es más fácil trabajar sin estos)
marker = im;
marker(2:end-1,2:end-1) = 0;
figure, imshow(marker,[]), title('Marcador');

rec = imreconstruct(marker,im);
figure, imshow(rec,[]), title('Reconstrucción');


%% Máximos 
% Máximos locales -> todos sus vecinos son menores (son muy buenas marcas)
% Máximos regionales -> se encuentra usando reconstrucciones

im = imread("astablet.tif");
figure, imshow(im,[]), title('Imagen de entrada');

% Primero eliminamos pequeñas estructuras blancas 
ee = strel('disk',20,0);
op = imopen(im,ee);

% Obtenemos los máximos regionales
rm = imregionalmax(op);
figure, imshow(rm,[]), title('Máximos regionales');

% Filtrar por altura
% (en este caso no es una buena opción), hay mucha variación debido a los
% reflejos del blister, ya que es metálico
rm2 = imextendedmax(im,15);
figure, imshow(rm2,[]), title('Máximos regionales filtrados por altura');
