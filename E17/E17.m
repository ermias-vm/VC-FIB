%% Práctica 17: Clasificadores
clc; clearvars; close all;

% Cargar datos
load df_fulles.mat

% Entrenar clasificador
[modelo, precision] = entrenarClasificador(df_fulles);

% Mostrar resultados
fprintf('Precisión de validación: %.2f%%\n', precision * 100);

% Ejemplo de predicción
[prediccion, puntuaciones] = modelo.predictFcn(df_fulles(1:5,:));
disp('Primeras 5 predicciones:');
disp(prediccion);

function [modeloEntrenado, precisionValidacion] = entrenarClasificador(datos)
    % Entrenar clasificador discriminante lineal
    
    % Extraer predictores y respuesta
    tablaEntrada = datos;
    nombresVars = {'SepalLength', 'SepalWidth', 'PetalLength', 'PetalWidth'};
    predictores = tablaEntrada(:, nombresVars);
    respuesta = tablaEntrada.Species;
    
    % Definir clases
    clases = categorical({'setosa'; 'versicolor'; 'virginica'});
    
    % Entrenar clasificador discriminante lineal
    clasificador = fitcdiscr(...
        predictores, ...
        respuesta, ...
        'DiscrimType', 'linear', ...
        'Gamma', 0, ...
        'FillCoeffs', 'off', ...
        'ClassNames', clases);
    
    % Crear función de predicción
    extraerVars = @(t) t(:, nombresVars);
    predecir = @(x) predict(clasificador, x);
    modeloEntrenado.predictFcn = @(x) predecir(extraerVars(x));
    
    % Información adicional del modelo
    modeloEntrenado.RequiredVariables = nombresVars;
    modeloEntrenado.ClassificationDiscriminant = clasificador;
    modeloEntrenado.About = 'Clasificador discriminante lineal entrenado';
    
    % Validación cruzada (5-fold)
    modeloCV = crossval(clasificador, 'KFold', 5);
    
    % Calcular precisión de validación
    precisionValidacion = 1 - kfoldLoss(modeloCV, 'LossFun', 'ClassifError');
end
