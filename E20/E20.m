%% Práctica 20
clc; clearvars; close all;
% addpath('I:\vc\sample images');

%%
im = imread('cameraman.tif');
imshow(im),title('input image');

bw = edge(im, 'canny');
figure,imshow(bw),title('contorns');

[H,alfa,rho] = hough(bw);
figure,mesh(H),title('taula de Hough');

figure,imshow(mat2gray(H),'XData',alfa, 'YData',rho, 'InitialMagnification','fit')
xlabel('\alpha')
xlabel('\rho')
axis on
axis normal


[fila,col]=find(H==max(H(:)));

hold on 
x =alfa(col);
y =rho(fila);
plot(x,y,'s','Color', 'red');

% Seleció de màxims usant funció
P = houghpeaks(H,3);
hold on 
x =alfa(P(:,2));
y =rho(P(:,1));
plot(x,y,'s','Color', 'green');


% Dibuixar rectes trobades sobre imatges original
lines = houghlines(bw,alfa,rho,P);

figure,imshow(im),title('rectes principals')
hold on
for k =1:length(lines)
    xy=[lines(k).point1;lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end





%% Exercici cantonades

% Derivada sobel (derivada) , (filtrar amb integral ) 

im = imread('gear.tif');
figure, imshow(im), title('Imatge original');
im = double(im);

%% Derivada amb sobel
Sobel_Y = fspecial('sobel')/4;
Sobel_X = Sobel_Y';

Gy = imfilter(im, Sobel_Y, "conv");
Gx = imfilter(im, Sobel_X, "conv");

figure, imshow(Gy, []), title('Gradient Sobel en Y');
figure, imshow(Gx, []), title('Gradient Sobel en X');

%% Filtre d'integració 
conv = [1, 1, 1; 
        1, 1, 1; 
        1, 1, 1];

Gx2 = imfilter(Gx.^2, conv);
Gy2 = imfilter(Gy.^2, conv);
GxGy = imfilter(Gx.*Gy, conv);

%% Harris 
% R = det(M) - k * trace(M)²
k = 0.05;
R = (Gx2.*Gy2) - (GxGy.^2) - k * (Gx2 + Gy2).^2;


figure, imshow(R, []), title('Resultat Harris');

figure, mesh(R), title('Resultat Harris en 3D');
colormap jet;
colorbar;

corners = R > 5;
figure, imshow(corners), title('Cantonades detectades');

figure, imshow(imfuse(im, corners, 'blend')), title('Imatge original amb cantonades');

