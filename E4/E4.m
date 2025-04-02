%% Práctica 4:
clc; clearvars; close all;
% addpath('I:\vc\sample images');

%% Creación de una imagen binaria y visualización en 3D

im = ones(256); 
im(1:128, 1:128) = 0; 
im(129:256, 129:256) = 0; 

% Mostrar la imagen original
figure, imshow(im), title('Imagen original');

% Visualizar la imagen como una superficie 3D
figure, mesh(im), title('Superficie 3D de la imagen');

%% Convolución manual
% Copiar la imagen original para aplicar convolución manual


result = ones(256);
[n, m] = size(im);


% Definir el kernel de convolución (filtro promedio)
h = [0, 1, 0; 
    1, 2, 1; 
    0, 1, 0] / 6;

% Aplicar convolución manualmente (cropping)
for i = 2:n-1
    for j = 2:m-1
        result(i,j) = sum(im(i-1:i+1, j-1:j+1) .* h, "all");
    end
end

% Mostrar el resultado de la convolución manual
figure, imshow(result, []), title('Imagen después de convolución manual');

%% Convolución usando imfilter
% Aplicar convolución usando la función imfilter
res = imfilter(im, h,'conv');

% Mostrar el resultado de la convolución automática
figure, imshow(res, []), title('Convolución usando imfilter');

%% Filtro de promedio 31x31
% Definir un filtro de promedio de tamaño 31x31
h2 = ones(31) / (31 * 31);

% Aplicar el filtro a la imagen
res2 = imfilter(double(im), h2);

% Mostrar el resultado del filtro de promedio
figure, imshow(res2, []), title('Convolución con filtro promedio 31x31');

%% Filtro con padding replicado
% Aplicar el mismo filtro pero con padding replicado
res3 = imfilter(double(im), h2, 'replicate');

% Mostrar el resultado con padding replicado
figure, imshow(res3, []), title('Convolución con padding replicado');



%% Adición de ruido gaussiano
% Leer una nueva imagen
im = imread('gull.tif');

% Mostrar la imagen original
figure, imshow(im), title('Imagen original');

% Añadir ruido gaussiano a la imagen
img = imnoise(im, 'gaussian');

% Mostrar la imagen con ruido gaussiano
figure, imshow(img), title('Imagen con ruido gaussiano');

%% Filtrado gaussiano
% Crear un filtro gaussiano de tamaño 7x7 y sigma=2
h = fspecial('gaussian', 7, 2);

% Aplicar el filtro gaussiano a la imagen con ruido
res = imfilter(img, h, 'conv');

% Mostrar el resultado del filtrado gaussiano
figure, imshow(res, []), title('Imagen filtrada con filtro gaussiano');

%% Adición de ruido "salt & pepper"
% Añadir ruido "salt & pepper" a la imagen
imsp = imnoise(im, 'salt & pepper');

% Mostrar la imagen con ruido "salt & pepper"
figure, imshow(imsp), title('Imagen con ruido salt & pepper');

%% Filtrado gaussiano para ruido "salt & pepper"
% Aplicar el filtro gaussiano a la imagen con ruido "salt & pepper"
res2 = imfilter(double(imsp), h);

figure, imshow(res2, []), title('Imagen filtrada con filtro gaussiano');

%Probemos un filtro no lineal
res3 = medfilt2(imsp,[5,5]);
figure, imshow(res3),title('imagen filtrado mediana salt & pepper')