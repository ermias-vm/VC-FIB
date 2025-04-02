%% Práctica 5:
clc; clearvars; close all;
% addpath('I:\vc\sample images');

%% Suavizado Gaussiano
% El suavizado es un filtro pasa-bajas (FPB).
% Los bordes o contornos son componentes de alta frecuencia.
% Para eliminar parte de la imagen, restamos: imagen total - parte a eliminar.
im = imread('rabbit.jpg'); % Cargar la imagen original
imshow(im), title("Imagen de entrada");
h = fspecial('gaussian', 7); % Crear un filtro gaussiano de tamaño 7x7
im2 = imfilter(im, h, 'conv'); % Aplicar el filtro gaussiano (suavizado)
figure, imshow(im2), title('Imagen suavizada (Filtro Pasa-Bajas)');

%% Diferencia absoluta (para obtener los bordes)
% La diferencia entre la imagen original y la imagen suavizada resalta los bordes.
im3 = imabsdiff(im, im2); % Calcular la diferencia absoluta
figure, imshow(im3, []), title('Residuo (bordes resaltados)');

%% Primera derivada para obtener transiciones
% La primera derivada se utiliza para detectar cambios bruscos en la imagen.
% Se calcula usando dos componentes: horizontal y vertical.
% - El módulo del gradiente indica la intensidad del cambio.
% - La dirección indica la orientación del cambio.
% Para calcular la derivada discreta, usamos diferencias entre píxeles vecinos.
% Utilizamos dos máscaras de convolución:
% - Mx = [-1, 0, 1] para detectar cambios horizontales.
% - My = [1, 0, -1] para detectar cambios verticales.
% Se utilizan máscaras impares para evitar desplazamientos en el resultado
% el resultado se asigna al píxel central.

Mx = [-1, 0, 1]; % Máscara para gradientes horizontales
My = [1; 0; -1]; % Máscara para gradientes verticales

% Aplicar convolución horizontal usando Mx
imMx = imfilter(double(im), Mx, 'conv'); % Gradiente horizontal
figure, imshow(imMx, []), title('Gradiente horizontal (Mx)');

% Aplicar convolución vertical usando My
imMy = imfilter(double(im), My, 'conv'); % Gradiente vertical
figure, imshow(imMy, []), title('Gradiente vertical (My)');

%% Operadores tipo gradiente (SOBEL)
% El operador Sobel es un filtro separable que da más peso a los píxeles centrales.
% Esto mejora la robustez frente al ruido.
Sobel_Y = [1, 2, 1; 
           0, 0, 0; 
          -1, -2, -1] / 4; % Filtro Sobel vertical
Gy = imfilter(double(im), Sobel_Y, "conv"); % Aplicar filtro Sobel vertical
figure, imshow(Gy, []), title('Gradiente Sobel en Y');

Sobel_X = Sobel_Y'; % Transponer para obtener el filtro Sobel horizontal
Gx = imfilter(double(im), Sobel_X, "conv"); % Aplicar filtro Sobel horizontal
figure, imshow(Gx, []), title('Gradiente Sobel en X');

% Valor absoluto del gradiente horizontal
figure, imshow(abs(Gx), []), title('Valor absoluto del gradiente horizontal');

% Direccó del gradient
dir = atan2(Gy,Gx);
figure, imshow(dir, []), title('Direcció del gradient');


%% Módulo del gradiente
% El módulo del gradiente indica la intensidad o magnitud de los cambios en la imagen.
% Se calcula combinando los gradientes horizontal (Gx) y vertical (Gy).
mod = sqrt(Gx.^2 + Gy.^2); % Calcular el módulo del gradiente
figure, imshow(mod, []), title('Módulo del gradiente');

%% Representación 3D del gradiente
% Visualizamos el módulo del gradiente como una superficie 3D para observar las variaciones de intensidad.
figure, mesh(mod), title('Gradiente en 3D');

%% Máscara para resaltar gradientes importantes
% Fijamos un umbral para identificar regiones con gradientes significativos.
% Esto permite separar bordes importantes del ruido de fondo.
mask = mod > 20; % Crear una máscara binaria para gradientes mayores a 20
figure, imshow(mask), title('Gradientes importantes');

%% Diferenciar entre borde (edge) y contorno
% Un contorno debe ser fino (idealmente de 1 píxel de grosor).
% Para obtenerlo, debemos encontrar los máximos locales del gradiente.
% Además, fijamos un umbral para eliminar el ruido de fondo y resaltar solo los bordes relevantes.

%% Operador Laplaciano
% El operador Laplaciano es un filtro basado en la segunda derivada.
% Se utiliza para realzar bordes y detalles finos en la imagen.
% Sin embargo, como la segunda derivada también amplifica el ruido,
% puede generar falsos contornos o artefactos no deseados.

lap = fspecial("laplacian"); % Crear el filtro Laplaciano
resLap = imfilter(double(im), lap, 'conv'); % Aplicar el filtro a la imagen

figure, imshow(resLap, []), title('Resultado del filtro Laplaciano');

% Aunque el operador Laplaciano resalta los bordes de la imagen,
% también amplifica el ruido presente en la imagen. Esto puede causar
% la aparición de falsos contornos, ya que el ruido se realza junto
% con los detalles importantes.