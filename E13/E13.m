%% Práctica 13:
clc; clearvars; close all;
%addpath('I:\vc\sample images');

%% Watershed 
im = imread("rabbit.jpg");
figure, imshow(im,[]), title('Imagen de entrada');

% Imagen de gradiente
ee = strel('disk',1);
grad = imsubtract(imdilate(im,ee), imerode(im,ee));
figure, imshow(grad,[]), title('Imagen de gradiente');

% Sobressegmentación, debido a muchos mínimos locales
segm = watershed(grad);
figure, imshow(segm,[]), title('Segmentación');
figure, imshow(segm == 0,[]), title('Líneas de watershed');

%% Watershed con marcadores

rm = imregionalmin(grad);
figure, imshow(rm,[]), title('Mínimos regionales');

% Mínimos con 5 niveles de profundidad (niveles de gris)
rm5 = imextendedmin(grad,5);
figure, imshow(rm5,[]), title('Mínimos regionales con profundidad 5');

grad2 = imimposemin(grad,rm5);
segm2 = watershed(grad2);
figure, imshow(segm2,[]), title('Segmentación con marcadores');
figure, imshow(segm2 == 0,[]), title('Líneas de watershed con marcadores de profundidad');

%% Watershed eliminando regiones por tamaño
% Elimina huecos menores de radio 15
ee = strel('disk',15);
grad3 = imclose(grad,ee);
segm3 = watershed(grad3);
figure, imshow(segm3,[]), title('Segmentación con marcadores');
figure, imshow(segm3 == 0,[]), title('Líneas de watershed con marcadores de profundidad');

%% Watershed combinado

rm6 = imextendedmin(grad3,6);
figure, imshow(rm5,[]), title('Mínimos regionales con profundidad 5');

grad4 = imimposemin(grad3,rm6);
segm4 = watershed(grad4);
figure, imshow(segm4,[]), title('Segmentación con marcadores');
figure, imshow(segm4 == 0,[]), title('Líneas de watershed con marcadores de profundidad');

%% Separación de objetos tocándose

im2 = imread("touchcell.tif");
figure, imshow(im2,[]), title('Imagen de entrada');

% Utilizamos la transformada de distancia
td = bwdist(~im2);
figure, imshow(td,[]), title('Transformada de distancia');
figure, mesh(-td);

seg = watershed(-td);
figure, imshow(seg==0,[]), title('Watershed');

res = im2;
res(seg==0) = 0;
figure, imshow(res,[]), title('Objetos separados');

%% Segmentación de córnea

im3 = imread("cornea.tif");
figure, imshow(im3,[]), title('Imagen de entrada');

ee = strel('disk',1);
grad = imsubtract(imdilate(im3,ee), imerode(im3,ee));
figure, imshow(grad,[]), title('Imagen de gradiente');

segmC = watershed(grad);
figure, imshow(segmC == 0,[]), title('Imagen de gradiente');

ee = strel('disk',2);
filt = imopen(imclose(im3,ee),ee);

rm = imregionalmax(filt);
figure, imshow(rm,[]), title('Máximos regionales');

segm2 = watershed(imimposemin(grad,rm));
figure, imshow(segm2 == 0,[]), title('Watershed con marcadores (células)');
figure, imshow(imfuse(im3,segm2==0),[]);

%% Segmentación de córnea añadiendo marcador de fondo
% Esqueleto de todo lo que no son marcadores de células
fons = bwskel(~rm);
figure, imshow(fons,[]), title('Marcador del fondo');

markers = fons | rm;
figure, imshow(markers,[]), title('Marcadores fondo y células');

segm3 = watershed(imimposemin(grad,markers));
figure, imshow(imfuse(im3,segm3==0),[]), title('Watershed con marcadores (células y fondo)');
