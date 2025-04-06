%% Práctica 9:
clc; clearvars; close all;
addpath('I:\vc\sample images');


%% EQUELETOS
% Afinar objeto hasta obtener un conjunto de líneas.
% Es un algoritmo poco robusto, un pequeño cambio en la imagen modifica
% completamente el esqueleto.

% SKIZ (Esqueleto por Zonas de Influencia) -> (Esqueleto del fondo)

im = imread('blob3.tif');
figure, imshow(im,[]), title('Imagen de entrada');

% Esqueleto de las células (podría utilizarse como marca)
sk = bwskel(im);
figure, imshow(sk,[]), title('Esqueleto');

% Esqueleto del fondo (fronteras)
% Es un buen marcador para el fondo
skiz = bwskel(~im);
figure, imshow(skiz,[]), title('Esqueleto del fondo');
figure, imshow(imfuse(im,skiz),[]), title('Esqueleto del fondo fusionado');

%% Dilatación multinivel
% Umbra conjunto de puntos que quedan por debajo de la función

im = imread('n2538.tif');
figure, imshow(im,[]), title('Imagen de entrada');

ee = strel('disk',3);
dil = imdilate(im,ee);
figure, imshow(dil,[]), title('Dilatación');

ero = imerode(im, ee);
figure, imshow(ero,[]), title('Erosión');


op = imopen(im,ee); % Elimina pequeñas partes blancas -> ero -> dil (parte superior de la función)
figure, imshow(cl,[]), title('Cierre');
figure, imshow(op,[]), title('Apertura');

cl = imclose(im,ee); % Elimina pequeñas partes negras -> dil -> ero (parte inferior de la función)
figure, imshow(cl,[]), title('Cierre');

%% EJERCICIO 1

im = imread('pcb1bin.tif');
figure,imshow(im),title('Imagen de entrada')


% Obtener los agujeros
imN = 1 - im;
mark = imN;
mark(2:end-1,2:end-1)=0;
rec = imreconstruct(mark,imN);
puntos = imsubtract(imN, rec);
figure, imshow(puntos),title('Agujeros')

% Obtener los PADS rectangulares
im = im + puntos;
ee = strel('rectangle',[8,34]);
rectangulos = imopen(im,ee);
figure, imshow(rectangulos),title('PADS Rectangulares')
im = imsubtract(im,rectangulos);

im = imopen(im,strel('disk',1));
% Obtener los PADS cuadrados
ee = strel('square',15);
cuadrados = imopen(im,ee);
figure, imshow(cuadrados),title('PADS Cuadrados')
im = imsubtract(im,cuadrados);
im = imopen(im,strel('disk',1));

% Obtener el triángulo
ee = strel('rectangle',[7,25]);
triangulo = imopen(im,ee);
im = imsubtract(im,triangulo);
im = imopen(im,strel('disk',1));

% Obtener los PADS redondos
ee = strel('disk',8,0);
circulos = imopen(im,ee);
figure, imshow(circulos),title('PADS Redondos')
im = imsubtract(im,circulos);
im = imopen(im,strel('disk',1));

% Obtener las pistas gruesas 2
ee = strel('square',5);
lineasGruesas = imopen(im,ee);
im = imsubtract(im,lineasGruesas);
im = imopen(im,strel('disk',1));

% Obtener las pistas finas
lineasGruesas = lineasGruesas + triangulo;
figure, imshow(lineasGruesas),title('Líneas Gruesas')
figure, imshow(im),title('Líneas Finas')

%% EJERCICIO 2


imL = imread('letters.tif');
figure, imshow(imL,[]), title('Letras');

ee = strel("disk",2,0);
op = imopen(imL,ee);
figure, imshow(op,[]), title('Apertura');

recF = imreconstruct(op, imL);
figure, imshow(recF,[]), title('Reconstrucción F');

imSenseF = imsubtract(imL,recF);
figure, imshow(imSenseF,[]), title('Sin F');

ee = strel("rectangle",[13,2]);
op2 = imopen(imSenseF,ee);
figure, imshow(op2,[]), title('Apertura 2');

imPsi = imreconstruct(op2, double(imL));
figure, imshow(imPsi,[]), title('PSI');
