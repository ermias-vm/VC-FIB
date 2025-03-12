%% ENTREGABLE 0
clc; clearvars; close all;

%% 1. Genera una matriu A de 10x10 amb valors aleatoris entre 0 i 255 de tipus enter
A = randi([0, 255], 10, 10);

%% 2. Obté un vector amb la 4ª fila de A
fila4deA = A(4, :);

%% 3. Obté un vector amb la 4ª columna de A
columna4deA = A(:, 4);

%% 4. Obté una matriu on s'hagi suprimit la 4ª columna de A
AsenseColumna4 = A(:, [1:3, 5:10]);

%% 5. Obté un vector amb el valor màxim de cada columna de A
valorsMaxColumnesA = max(A);
    %per a valor max per files -> max(A, [], 2);

%% 6. Obté el valor màxim de la matriu A
valorMaximA = max(A(:)); 
% A(:) converteix la matriu A en un vector columna amb tots els seus elements.
% max(A(:)) calcula el valor màxim de tots els elements de la matriu.
  
%% 7. Obté una matriu amb només les files parells de A
filesParellesA = A(2:2:end, :);
% 2:2:end -> seleciona les files parelles de la matriu A, començant per la
% 2 y avançant de 2 en 2 fins al final

%% 8. Obté la fila i columna on es troba el valor mínim de A
[minValor, posMin] = min(A(:));
[filaMin, columnaMin] = ind2sub(size(A), posMin);

% min(A(:)) troba el valor mínim de tota la matriu A i la seva posició lineal (posMin).
% ind2sub(size(A), posMin) converteix la posició lineal en coordenades de fila i columna.

%% 9. Genera la matriu B trasposant la matriu A
B = A';

%% 10. Obté el producte de les matrius A i B
AB = A * B;

%% 11. Obté el producte element a element de A i B
productElement_Element = A .* B;

%% 12. Genera una matriu booleana on cada element (i,j) valgui 1 si A(i,j) > B(i,j), i 0 en cas contrari
matriuBooleana = A > B;

%% 13. Genera un vector amb tots els elements A(i,j) més grans que B(i,j)
vectorElementsMesGrans = A(A > B);
 
% A(A > B) selecciona només els elements de A que compleixen la condició.
% El resultat és un vector columna amb tots els elements de A que són més grans que els corresponents de B.
     
%% 14. Genera una matriu on cada element (i,j) valgui A(i,j) si A(i,j)>B(i,j) , i 0 en cas contrari
matriuCondicio = A .* (A > B);
