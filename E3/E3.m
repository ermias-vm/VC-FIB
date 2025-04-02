%% Práctica 3:
clc; clearvars; close all;
% addpath('I:\vc\sample images');

%% Modificación de Brillo y Contraste
% Cargar imagen oscura (valores entre 0 y 16)
im = imread('Que_es.png');
figure, imshow(im), title("Imagen original (oscura)");

% Aumentar la iluminación sumando un valor constante
im2 = im + 200; % Suma 200 a cada píxel, si se supera el rango de uint8 (255, se trunca
figure, imshow(im2), title("Imagen iluminada");

% Aumentar el contraste multiplicando por una constante
im3 = im * 10; % Multiplica cada píxel por 10
figure, imshow(im3), title("Imagen contrastada");

% Obtener el negativo de la imagen contrastada
im4 = 255 - im3; % Calcula el complemento restando del máximo valor posible (255)
figure, imshow(im4), title("Imagen negativa");
figure, imshow(im4), title("Image negativa");

%% Histograma Manual
% Calcular el histograma manualmente
h = zeros(256, 1); % Inicializa un vector de 256 posiciones para contar frecuencias
s = size(im); % Obtiene las dimensiones de la imagen (filas, columnas)

for i = 1:s(1) % Itera sobre las filas
    for j = 1:s(2) % Itera sobre las columnas
        index = im(i,j) + 1;
        h(index) = h(index) + 1; % Incrementa el contador para el valor del píxel
    end
end

% Visualizar el histograma manual
figure, plot(h), title('Histograma manual');
figure, bar(h), title('Histograma de barras');

%% Histograma Automático
% Usar la función imhist para calcular el histograma automáticamente
h_auto = imhist(im);
figure, plot(h_auto), title('Histograma automático');

%% Ecualización del Histograma
% Aplicar ecualización del histograma para mejorar el contraste
im5 = histeq(im);
figure, imshow(im5), title("Imagen ecualizada");
figure, imhist(im5), title("Histograma ecualizado");

%% Reescalado de Imágenes
% Cargar una nueva imagen para realizar operaciones de reescalado
im = imread('lenna.tif');
figure, imshow(im), title('Imagen original');

% Reducir la imagen a 1/4 de su tamaño original
im2 = imresize(im, 0.25); % Escala la imagen al 25% del tamaño original
figure, imshow(im2), title('Imagen reescalada a 1/4');

% Aumentar la imagen a 4 veces su tamaño original
im3 = imresize(im, 4); % Escala la imagen a 400% del tamaño original (interpolación predeterminada)
figure, imshow(im3), title('Imagen reescalada a 4x (interpolación predeterminada)');

% Aumentar la imagen a 4 veces su tamaño original usando interpolación "nearest"
im4 = imresize(im, 4, 'nearest'); % Usa interpolación nearest-neighbor
figure, imshow(im4), title('Imagen reescalada a 4x (nearest-neighbor)');

%% Rotación de Imágenes
% Rotar la imagen 45 grados
im5 = imrotate(im, 45); % Rota la imagen 45 grados en sentido antihorario
figure, imshow(im5), title('Imagen rotada 45 grados');

%% Transformación Afín
% Crear una matriz de transformación afín
T = affine2d([1, 0, 0; 0.5, 1, 0; 0, 0, 1]); % Aplica una inclinación horizontal

% Cargar una imagen
im = imread('lenna.tif');

% Aplicar la transformación afín a la imagen
im_transformada = imwarp(im, T);

% Mostrar la imagen original y la transformada

figure;
subplot(1, 2, 1);
imshow(im);
title('Imagen original');

subplot(1, 2, 2);
imshow(im_transformada);
title('Imagen transformada');

% figure, imshow(im), title('Imagen original');
% figure, imshow(im_transformada), title('Imagen transformada');