%% Práctica 14
clc; clearvars; close all;
%addpath('I:\vc\sample images')

%% Segmentación en el espacio RGB usando K-means
im = imread('peppers.png');
figure, imshow(im,[]), title('Imagen de entrada');
vect = reshape(double(im), 512*512, 3);
figure, scatter3(vect(:,1), vect(:,2), vect(:,3), 1);
xlabel('R'); ylabel('G'); zlabel('B');
title('Espacio de características RGB');
K = 2;
[cluster_eti, cluster_ctr] = kmeans(vect, K, "Distance", "cityblock");
eti = reshape(cluster_eti, 512, 512);
figure, imshow(eti,[]), title('K-means RGB');
colormap prism;

%% Segmentación en el espacio HSV usando K-means
hsv = rgb2hsv(im);
hs = hsv(:,:,1:2);
vect2 = reshape(double(hs), 512*512, 2);
figure, scatter(vect2(:,1), vect2(:,2), 1);
xlabel('Tono'); ylabel('Saturación');
title('Espacio hue-sat');
K = 2;
[cluster_eti2, cluster_ctr2] = kmeans(vect2, K, "Distance", "cityblock");
eti = reshape(cluster_eti2, 512, 512);
figure, imshow(eti,[]), title('K-means hue-sat');
colormap prism;
figure, scatter(vect2(:,1), vect2(:,2), 1, cluster_eti2);
title('hue-sat etiquetado');

%% Transformación del espacio Hue-Saturation a coordenadas sinusoidales
vect3 = vect2;
vect3(:,1) = vect2(:,2) .* sin(2 * pi * vect2(:,1));
vect3(:,2) = vect2(:,2) .* cos(2 * pi * vect2(:,1));
K = 2;
[cluster_eti3, cluster_ctr3] = kmeans(vect3, K, "Distance", "cityblock");
eti = reshape(cluster_eti3, 512, 512);
figure, imshow(eti,[]), title('K-means hue-sat sin_cos');
colormap prism;
figure, scatter(vect3(:,1), vect3(:,2), 1, cluster_eti3);
title('hue-sat sin_cos');

%% Ejercicio: separar café
im = imread('cafe.tif');
figure, imshow(im,[]), title('Imagen de entrada');

% Binarización de la imagen usando el método de Otsu
bw = im2bw(im, graythresh(im));
figure, imshow(bw), title('Binarización por Otsu');
td = bwdist(bw);
figure, mesh(td);

% Encontrar mínimos regionales
marca = imhmin(-td, 2);

% Aplicar Watershed para separar los objetos conectados
eti = watershed(marca);
figure, imshow(bw | ~(eti > 0)), title("Separación del café con marcadores");

% Etiquetar los objetos separados
eti = bwlabel(~(bw | ~(eti > 0)));
figure, imshow(eti,[]), title('Café etiquetado');
colormap colorcube;