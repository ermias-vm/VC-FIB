%% Práctica 19 (Harris, SIFT y emparejamiento de imágenes)
clc; clearvars; close all;
% addpath('I:\vc\sample images');

% EJERCICIO HARRIS
im = imread('rabbit.jpg');
corners = detectHarrisFeatures(im);
figure, imshow(im), title("corners")
hold on
plot(corners)
hold off

%% EJERCICIO SIFT Y EMPAREJAMIENTO
im_obj = imread('coke.jpg');
im_obj = rgb2gray(im_obj);
im_esc = rgb2gray(imread('anunci.jpg'));
% Usa el descriptor de SIFT tambien
kp_obj=detectSIFTFeatures(im_obj);
kp_esc=detectSIFTFeatures(im_esc);
figure, imshow(im_obj),title('model con 100 keypoints')
hold on
plot(selectStrongest(kp_obj,100))
hold off
figure, imshow(im_esc),title('escena con 500 keypoints')
hold on
plot(selectStrongest(kp_esc,500))
hold off
% Visualizar los resultados
[feat_obj,kp_obj]=extractFeatures(im_obj,kp_obj);
[feat_esc,kp_esc]=extractFeatures(im_esc,kp_esc);


pairs = matchFeatures(feat_obj,feat_esc,'MatchThreshold',10);
matched_kp_obj = kp_obj(pairs(:,1),:);
matched_kp_esc = kp_esc(pairs(:,2),:);
figure, showMatchedFeatures(im_obj, im_esc, matched_kp_obj, matched_kp_esc,"montage"), title('aparellaments putatius')
% Matching global, mover el objeto a la posicion de la referencia.
[tform,inlieridx]= estimateGeometricTransform2D(matched_kp_obj,matched_kp_esc,'affine');
inlier_kp_obj= matched_kp_obj(inlieridx,:);
inlier_kp_esc= matched_kp_esc(inlieridx,:);
%Estos definen la trasnformacion afin
figure,
showMatchedFeatures(im_obj,im_esc,inlier_kp_obj,inlier_kp_esc,'montage'),titl
e('inliers')
% Dibujamos la bounding box y la movemos
[miday,midax] = size(im_obj);
box_obj =[1,100;midax,100;midax, miday;1,miday;1,100];
figure,imshow(im_obj),title('bounding box')
hold on
line(box_obj(:,1),box_obj(:,2),'color','y');
newbox_obj = transformPointsForward(tform,box_obj);
figure,imshow(im_esc),title('detected box')
hold on
line(newbox_obj(:,1),newbox_obj(:,2),'color','y');