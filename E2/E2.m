%% Práctica 14:
clc; clearvars; close all;
% addpath('I:\vc\sample images');

%% TEORÍA
% Normalización del color
% r = R/(R+G+B); g = G/(R+G+B); b = B/(R+G+B)
% - Solo funciona con iluminación blanca y homogénea.
% - Es más robusto porque r + g + b = 1 (son linealmente dependientes), por lo que sobra uno.
%

% Conversión RGB-HSI (Teoría 1):
% H (Hue - Tono): 
% Representa el color percibido (rojo, verde, azul, etc.).
% - Rango: [0, 1] en MATLAB (equivalente a [0°, 360°]).
%   * 0 = Rojo, 1/3 ≈ Verde, 2/3 ≈ Azul.
% Ejemplo: Un tono de 1/3 (verde) indica un color puro.

% S (Saturation - Saturación): 
% Indica la "pureza" del color.
% - Rango: [0, 1].
%   * S ≈ 1: Color puro (vivo).
%   * S ≈ 0: Color desaturado (grisáceo).

% I (Intensity - Intensidad): 
% Representa el brillo o cantidad de luz.
% - Fórmula: I = (R + G + B) / 3.
% Ejemplo: Alta intensidad = Píxel brillante.
%

% Observaciones:
% - Si S es muy pequeña o nula, provoca singularidades o errores al calcular H.
% - En zonas blancas o negras, el valor de H puede parecer aleatorio.
%
% Tipos de distancias y definiciones de vecindad (ver Teoría 1).

%% PRACTICA

%% SETUP
im = imread('flowers.tif'); % Carga la imagen
imshow(im), title('Imagen en color');
impixelinfo; % Activa la herramienta para ver información de los píxeles

% Extraer los canales RGB
r = im(:,:,1); % Canal rojo
g = im(:,:,2); % Canal verde
b = im(:,:,3); % Canal azul

%% AISLAR Y VISUALIZAR UN SOLO COLOR
% Visualizar el canal verde como escala de grises
figure, imshow(g), title('Componente verde (escala de grises)');

% Crear un mapa de colores personalizado para visualizar el verde
%(LUT) -> Look-UP Table
mapa = zeros(256, 3); % Inicializa un mapa de colores vacío
mapa(:, 2) = 0:255;   % Asigna valores al canal verde
mapa = mapa / 255;    % Normaliza el mapa de colores al rango [0, 1]
colormap(mapa);       % Aplica el mapa de colores

% Concatenar los canales RGB para reconstruir la imagen
rgb = cat(3, r, g, b);
figure, imshow(rgb), title('Imagen RGB concatenada');

%% IMAGEN EN ESCALA DE GRISES
% Convertir la imagen a escala de grises
gris = rgb2gray(im); % Usando la función rgb2gray
% gris = uint8((double(r) + double(g) + double(b)) / 3); % Alternativa manual

figure, imshow(gris), title('Imagen en escala de grises');

%% IMAGEN NORMALIZADA
% Normalizar los canales RGB para que r + g + b = 1
R = uint8(255 * double(r) ./ (double(r) + double(g) + double(b)));
G = uint8(255 * double(g) ./ (double(r) + double(g) + double(b)));
B = uint8(255 * double(b) ./ (double(r) + double(g) + double(b)));

normalizada = cat(3, R, G, B); % Concatenar los canales normalizados
figure, imshow(normalizada), title('Imagen normalizada');

%% TRABAJAR CON HSV
% Convertir la imagen de RGB a HSV
hsv = rgb2hsv(im);
figure, imshow(hsv), title('HSV mostrado como RGB (no interpretable directamente)');

% Convertir de vuelta a RGB para verificar la conversión
rgb_hsv = hsv2rgb(hsv);
figure, imshow(rgb_hsv), title('RGB -> HSV -> RGB');

% Extraer los componentes HSV
hue = hsv(:,:,1); % Componente Hue (color)
sat = hsv(:,:,2); % Componente Saturación
val = hsv(:,:,3); % Componente Valor (intensidad)

% Visualizar los componentes HSV
figure, imshow(hue), title('Componente Hue');
colormap HSV; colorbar;

figure, imshow(sat), title('Componente Saturación');

figure, imshow(val), title('Componente Valor');

%% NORMALIZAR IMAGEN HSV
% Normalizar el componente Valor (V) para eliminar efectos de iluminación
val = ones(size(hue)) * (1/3); % Asignar un valor constante al componente Valor
normalizada_hsv = cat(3, hue, sat, val); % Reconstruir la imagen HSV

% Convertir de vuelta a RGB
rgb_normalizada = hsv2rgb(normalizada_hsv);
figure, imshow(rgb_normalizada), title('RGB -> HSV normalizada -> RGB');

%% COMPARACIÓN DE PILLS
% Pastilles verdes = 1 , altres = 0


im2 = imread('Pills.tif');
figure, imshow(im2), title('Imagen original Pills');

% Convertir a HSV
hsv = rgb2hsv(im2); % mateix que hsi -> v = i
hue = hsv(:,:,1); % Componente Hue
sat = hsv(:,:,2); % Componente Saturación
val = hsv(:,:,3); % Componente Valor

% Filtrar el componente Hue en un rango específico
h = hue > 0.25;  % Máscara para valores mayores que 0.25
h2 = hue < 0.45; % Máscara para valores menores que 0.45
hue_filtrado = hue .* h .* h2; % Aplicar ambas máscaras

% Visualizar el resultado filtrado
figure, imshow(hue_filtrado), title('Hue filtrado');
colormap HSV; colorbar;

% Crear una versión binaria del filtro
hue_binario = h .* h2;
figure, imshow(hue_binario), title('Selección binaria');