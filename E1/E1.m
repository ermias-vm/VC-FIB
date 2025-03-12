%% Práctica 1: Procesamiento básico de imágenes
clc; % Limpia la ventana de comandos (Command Window)
clearvars; % Borra todas las variables del workspace para comenzar limpio
close all; % Esta línea cierra todas las ventanas gráficas abiertas 

%Se agrega la ruta especificada al path
addpath('C:\Users\ejocs\Documents\MATLAB\vc-fib\sampleImages\');
savepath; %Actualiza el archivo pathdef.m, para que sea permanente

%% Carga y visualización básica de una imagen
im = imread('Floppy.bmp'); % Lee la imagen 'Floppy.bmp' y la almacena en la variable 'im'
[files, cols] = size(im); % Obtiene las dimensiones de la imagen (filas y columnas)

% Acceder a un píxel específico de la imagen
im(75, 65); % Muestra el valor del píxel en la fila 75, columna 65
im(74:76, 64:66); % Muestra los valores de un bloque de píxeles (3x3) centrado en (75,65)

imshow(im); % Muestra la imagen en una ventana gráfica
impixelinfo; % Activa la herramienta que muestra información sobre los píxeles bajo el cursor

% Mapa de color y barra de colores
colormap jet; % Cambia el mapa de colores a 'jet' (de azul a rojo)
colorbar; % Añade una barra de colores para visualizar la escala de intensidades

%% Subplots: Visualización de múltiples imágenes
figure; % Crea una nueva ventana gráfica
subplot(1, 2, 1); imshow(im); % Divide la figura en 1 fila, 2 columnas y muestra la imagen original en la primera posición
subplot(1, 2, 2); imshow(255 - im); % Muestra la imagen invertida (negativo) en la segunda posición

%% Representación topográfica de la imagen
figure; mesh(im); % Crea una representación 3D (malla) de la imagen para visualizar su "profundidad"

%% Creación de imágenes aleatorias
im2 = rand(256); % Crea una matriz 256x256 con valores aleatorios entre 0 y 1 (tipo double)
im3 = 1000 * im2; % Escala los valores de la matriz para que estén entre 0 y 1000

figure; % Crea una nueva ventana gráfica
subplot(1, 2, 1); imshow(im2); % Muestra la imagen con valores entre 0 y 1
subplot(1, 2, 2); imshow(im3); % Intenta mostrar la imagen escalada, pero los valores no están en el rango [0,1]

%% Control del rango de visualización con imshow
figure; imshow(im3, [0, 1000]); title('Límites modificados'); 
% Muestra la imagen con un rango de intensidad explícito [0, 1000]

figure; imshow(im3, []); title('Rango automático'); 
% Muestra la imagen ajustando automáticamente el rango de intensidad según los valores mínimos y máximos de la imagen

%% Guardar una imagen
imwrite(im2, 'random.jpg'); % Guarda la imagen aleatoria 'im2' en un archivo llamado 'random.jpg'