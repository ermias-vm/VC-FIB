clc; clearvars; close all;
% addpath('I:\vc\sample images');

%% Dilatación
im = false(128);
im(64,:) = 1;
im(:,64) = 1;
imshow(im,[]), title('Imagen de entrada');

% Elemento estructurante
EE = [1,1,1];
im2 = im;
for i = 2:127 
    for j = 2:127
        if (im(i,j) == 1)
           im2(i,j-1) = 1; 
           im2(i,j+1) = 1;
        end 
    end
end
figure, imshow(im2), title('Imagen dilatada (manual)');

%% Dilatación automática
ee = strel([1,1,1]);
dil = imdilate(im,ee);
figure, imshow(dil), title('Dilatación automática');

% Leer imagen
im = imread('blob.tif');
figure, imshow(im), title('Imagen de entrada');

ee = strel('square',3);
dil2 = imdilate(im,ee);
figure, imshow(dil2), title('Dilatación con elemento estructurante');

%% Erosión
ero = imerode(im,ee);
figure, imshow(ero), title('Erosión');

%% Residuos
im = imread('blob3.tif');
figure, imshow(im), title('Imagen de entrada');

% Contorno externo
ee = strel('disk', 1);
dil = imdilate(im,ee);
figure, imshow(dil), title('Dilatación');

c_ext = imsubtract(dil,im);
figure, imshow(c_ext), title('Contorno externo');

% Contorno interno
ero = imerode(im,ee);
c_inter = imsubtract(im,ero);
figure, imshow(c_inter), title('Contorno interno');

% Superposición de contornos
figure, imshow(imfuse(c_inter,c_ext)), title('Superposición de contornos');

lap = imsubtract(double(c_ext), double(c_inter));
figure, imshow(lap,[]), title('Laplaciano morfológico');

%% Transformada de distancia
im = imread("touchcell.tif");
figure, imshow(im), title('Imagen de entrada');

tdist = double(im);
ee = strel('disk', 1); % Radio = 1

% Erosión en bucle
num_iter = 5;
for k = 1:num_iter
    ero = imerode(im, ee);
    tdist = tdist + ero;
    im = ero; % Actualizar imagen para la siguiente iteración
end

figure, imshow(ero,[]), title('Erosión múltiple');
figure, imshow(tdist,[]), title('Transformada de distancia');
figure, mesh(tdist);

% Función optimizada
Td = bwdist(~im);
figure, imshow(Td,[]), title('Transformada de distancia (óptima)');
figure, mesh(Td);
