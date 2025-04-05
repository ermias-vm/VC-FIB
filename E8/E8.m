%% Práctica 8:
clc; clearvars; close all;
%addpath('I:\vc\sample images');

%%
im= imread('blob3.tif');
figure, imshow(im,[]), title('imagen de entrada');

mark = im;
mark(2:end-1, 2:end-1)= 0;
figure, imshow(mark,[]), title('marcadores');

%% Dilatación (original)
% Elemento estructurante de radio 1
ee = strel('disk',1); 
dil = imdilate(mark,ee);
figure, imshow(dil,[]), title('dilatación');

%% Dilatación condicional

for i = 1:10
    dilc = imdilate(dilc,ee) & im;
end
figure, imshow(dilc,[]), title('dilatación condicional');

%% Reconstrucción de imagen
rec = imreconstruct(mark,im);
figure, imshow(rec,[]), title('reconstrucción de imagen');

% Células completas, sin las que tocan los bordes 
% (restamos imagen original - imagen reconstruida)
res = imsubtract(im,rec);
figure, imshow(res,[]), title('células completas');

%% EJERCICIO: Cerrar agujeros
im = imread('pcbholes.tif');
figure, imshow(im, []),title('imagen de entrada');

imN = 1 - im;
figure, imshow(imN, []),title('imagen negada');

mark = imN;
mark(2:end-1,2:end-1)=0;
rec = imreconstruct(mark,imN);
figure, imshow(rec, []),title('imagen reconstruida');

res = imsubtract(imN, rec); % Eliminamos regiones conectadas al borde
figure, imshow(res),title('región corregida');

%% Obtener disco 
im= imread('tools.tif');
figure, imshow(im,[]), title('imagen de entrada');

% Eliminar partes donde el radio < 9 
mark = imerode(im, strel('disk',9));
figure, imshow(mark,[]), title('marcadores');

rec = imreconstruct(mark, im);
figure, imshow(rec,[]), title('disco reconstruido');

%% EJERCICIO: Eliminar disco, tenazas

im= imread('tools.tif');

mark = imerode(im, strel('line',70,2));
figure, imshow(mark,[]), title('marcadores');

rec = imreconstruct(mark, im);
figure, imshow(rec,[]), title('reconstruido sin disco ni tenazas');

%% OPENING (elimina pequeñas estructuras blancas) 
% Erosión seguida de una dilatación
% Se eliminan objetos que han sido erosionados hasta desaparecer

%% CLOSING (operación complementaria al OPENING)
% (dilatación -> erosión) (elimina pequeñas estructuras negras)

%% Obtener dientes del engranaje con opening
im= imread('gear.tif');
figure, imshow(im,[]), title('imagen de entrada');

ee = strel("disk",20,0);
op = imopen(im,ee);
figure, imshow(op,[]), title('opening');

res = imsubtract(im,op);
figure, imshow(res,[]), title('dientes');

%% Etiquetado
% Por defecto el fondo se etiqueta como 0 (negro)
eti = bwlabel(res,8);
figure, imshow(eti,[]),title("imagen etiquetada"),
colormap("colorcube");

Dades = regionprops(eti,'Area');
Arees = [Dades.Area];

areaMax = max(Arees);
areaMin = min(Arees);
