%% Práctica 15: Análisis de propiedades geométricas y descriptores de Fourier
clc; clearvars; close all;

%% Lectura y preprocesamiento de la imagen
imagenOriginal = imread("head.png");
imagenRedimensionada = imresize(imagenOriginal, 0.5);
imshow(imagenRedimensionada), title("Imagen original redimensionada")

%% Detección de contornos mediante erosión
imagenErosionada = imerode(imagenRedimensionada, strel('disk',1));
contornoBinario = xor(imagenRedimensionada, imagenErosionada);
figure, imshow(contornoBinario), title("Contorno detectado")

%% Cálculo de propiedades geométricas
areaObjeto = sum(imagenRedimensionada(:));
perimetroObjeto = sum(contornoBinario(:));
propiedadesRegiones = regionprops(imagenRedimensionada, 'all');
compacidad = propiedadesRegiones.Circularity;

%% Códigos de Freeman
% Obtener coordenadas del primer punto del contorno
[filaInicio, columnaInicio] = find(contornoBinario, 1);
% Trazar contorno con bwtraceboundary
coordenadasContorno = bwtraceboundary(contornoBinario, [filaInicio, columnaInicio], 'E');
imagenContornoFreeman = zeros(size(imagenRedimensionada));
imagenContornoFreeman(sub2ind(size(imagenContornoFreeman), ...
    coordenadasContorno(:,1), coordenadasContorno(:,2))) = 1;
figure, imshow(imagenContornoFreeman), title("Contorno trazado con coordenadas")

% Cálculo de direcciones de movimiento entre píxeles consecutivos del contorno
diferencias = coordenadasContorno(2:end,:) - coordenadasContorno(1:end-1,:);
codigoFreeman1 = 3 * diferencias(:,1) + diferencias(:,2);
codigoFreeman2 = diferencias(:,1) + diferencias(:,2) * 1i;

%% Descriptores de Fourier
% Calcular coordenadas relativas al centroide del contorno
centroide = mean(coordenadasContorno);
coordenadasRelativas = coordenadasContorno - centroide;
serieCompleja = coordenadasRelativas(:,1) + coordenadasRelativas(:,2) * 1i;

% Transformada de Fourier
transformadaFourier = fft(serieCompleja);

% Visualización del espectro
figure, plot(abs(transformadaFourier)), title('Espectro de Fourier')
figure, plot(log(abs(transformadaFourier))), title('Espectro en escala logarítmica')

% Reconstrucción con transformada inversa
serieReconstruida = ifft(transformadaFourier);
filasReconstruidas = round(real(serieReconstruida) + centroide(1));
columnasReconstruidas = round(imag(serieReconstruida) + centroide(2));
imagenReconstruida = zeros(size(imagenRedimensionada));
imagenReconstruida(sub2ind(size(imagenReconstruida), ...
    filasReconstruidas(:,1), columnasReconstruidas(:,1))) = 1;
figure, imshow(imagenReconstruida), title("Reconstrucción con Fourier")

% Normalización para obtener invariancia a la escala
serieNormalizada = ifft(transformadaFourier / transformadaFourier(2) * 100000);
filasNormalizadas = round(real(serieNormalizada) + centroide(1));
columnasNormalizadas = round(imag(serieNormalizada) + centroide(2));
imagenNormalizada = zeros(size(imagenRedimensionada));
imagenNormalizada(sub2ind(size(imagenNormalizada), ...
    filasNormalizadas(:,1), columnasNormalizadas(:,1))) = 1;
figure, imshow(imagenNormalizada), title("Reconstrucción normalizada (invarianza a escala)")

%% Visualización progresiva según el número de descriptores de Fourier
for numeroDescriptores = 3:10:83
    transformadaReducida = transformadaFourier;
    transformadaReducida(numeroDescriptores+1:end-numeroDescriptores) = 0;

    % Reconstrucción con número limitado de descriptores
    tamanoVisualizacion = 500;
    imagenReducida = zeros(tamanoVisualizacion);
    serieReducida = ifft(transformadaReducida);
    filasRed = round(real(serieReducida) + tamanoVisualizacion / 2);
    columnasRed = round(imag(serieReducida) + tamanoVisualizacion / 2);
    imagenReducida(sub2ind(size(imagenReducida), ...
        filasRed(:,1), columnasRed(:,1))) = 1;

    figure, imshow(imagenReducida), ...
        title("Reconstrucción con " + string(numeroDescriptores) + " descriptores")
end
