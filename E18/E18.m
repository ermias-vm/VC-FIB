%% Práctica 18: Descriptores
clc; clearvars; close all;

% Cargar datos
load df_fulles.mat;

% Seleccionar primera muestra para visualización
muestra = df_norm(1,:);

% Opcional: Seleccionar número de descriptores
% N = 40;
% muestra(N+1:end-N) = 0;

% Transformada inversa de Fourier
forma_reconstruida = ifft(muestra);

% Parámetros de visualización
tamaño_imagen = 600;
filas = round(real(forma_reconstruida) + tamaño_imagen/2);
columnas = round(imag(forma_reconstruida) + tamaño_imagen/2);

% Crear imagen binaria de la forma
imagen_forma = zeros(tamaño_imagen);
indices_validos = filas > 0 & filas <= tamaño_imagen & columnas > 0 & columnas <= tamaño_imagen;
imagen_forma(sub2ind(size(imagen_forma), filas(indices_validos), columnas(indices_validos))) = 1;

figure, imshow(imagen_forma), title('Forma reconstruida (IFFT)');

% Preparar características para selección
[num_muestras, num_coefs] = size(df_norm);
caracteristicas = zeros(num_muestras, num_coefs/2 + 1);

% Los coeficientes de Fourier son simétricos, solo usar la primera mitad
caracteristicas(:, 1:end-1) = abs(df_norm(:, 1:num_coefs/2));
caracteristicas(:, end) = label_tree(:);

% Selección de características usando MRMR (Minimum Redundancy Maximum Relevance)
[indices_relevantes, puntuaciones] = fscmrmr(caracteristicas(:, 1:end-1), caracteristicas(:, end));

% Visualizar las 100 características más relevantes
num_top = min(100, length(puntuaciones));
figure, bar(puntuaciones(indices_relevantes(1:num_top)));
xlabel('Rango del predictor');
ylabel('Relevancia del predictor');
title('Top 100 características más relevantes');
grid on;

% Mostrar información
fprintf('Total de características: %d\n', size(caracteristicas, 2) - 1);
fprintf('Característica más relevante: %d (puntuación: %.4f)\n', ...
    indices_relevantes(1), puntuaciones(indices_relevantes(1)));
fprintf('Top 10 características más relevantes:\n');
for i = 1:10
    fprintf('  %d. Característica %d (puntuación: %.4f)\n', ...
        i, indices_relevantes(i), puntuaciones(indices_relevantes(i)));
end
