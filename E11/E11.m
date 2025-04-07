%% Práctica 11:
clc; clearvars; close all;
% addpath('I:\vc\sample images');

%% Binarización
im = imread("airplane.tif");
figure, imshow(im,[]), title('imagen de entrada');
figure, imhist(im);
imbin = im>70;
figure, imshow(imbin,[]), title('imagen umbralizada');
% No se puede binarizar directamente, no tiene un histograma bimodal
% se debe utilizar segmentación 

%% Binarización con Otsu
th = graythresh(im);
imbin = im2bw(im,th);
figure, imshow(imbin,[]), title('binarización por OTSU');

%% Umbrales locales
% para cada píxel p, se encuentra la media u

im = imread("textsheet.jpg");
figure, imshow(im,[]), title('imagen de entrada');
k = 10;
size = 80;
kernel = ones(size)/(size*size); 

imPromig = imfilter(double(im), kernel,'replicate');
figure, imshow(imPromig,[]), title('imagen con promedio');
imbw= im>(imPromig-k);
figure, imshow(imbw,[]), title('imagen binarizada');

%% Ejercicio arroz completo

im = imread("arros.tif");
figure, imshow(im,[]), title('imagen de entrada');

ee = strel('disk', 20);
th = imtophat(im,ee); % Residuo de apertura
figure, imshow(th,[]), title('top hat');
figure, imhist(th);

imbw  = im2bw(th,graythresh(th));
figure, imshow(imbw,[]), title('arroz');

% Eliminar granos de los bordes
marker = imbw;
marker(2:end-1,2:end-1) = 0;
rec = imreconstruct(marker,imbw);   
figure, imshow(rec,[]), title('granos grandes en los bordes');

res = imsubtract(imbw, rec);
figure, imshow(res,[]), title('granos grandes completos');

% Etiquetado
eti = bwlabel(res,4);
figure, imshow(eti,[]), title('imagen etiquetada');
colormap("colorcube");

dades = regionprops(eti,'all');
arees = [dades.Area];
figure, histogram(arees,20), title('áreas');

%% Ejercicio FINAL
% Detectar errores (partes negras sobre blancas), binarizar y etiquetar
im = imread('r4x2_256.tif');
figure, imshow(im), title('imagen de entrada');
ee = strel('disk',20);

pistas = imtophat(im,ee);
imbw = im2bw(pistas, graythresh(pistas));
figure, imshow(imbw), title('pistas binarizadas');
im2 = 1 - imbw;

ee = strel('rectangle',[50,1]);
defectos = imtophat(im2,ee);
figure, imshow(defectos), title('defectos con ruido');

ee = strel('disk',1);
op = imopen(defectos,ee);
figure, imshow(op), title('defectos detectados');
