% Integrante-1: Ana Poveda García Herrero
% Integrante-2: Cristina Taboada Mayo.

%% -------------------- PARTE OBLIGATORIA --------------------
%clear all, close all, clc
% Cargamos la imagen que vamos a utilizar.
I = imread('G15.jpeg');

% Primero, realizo un filtrado de la imagen para obtener los
% bordes/contornos verticales de mayor intensidad.

% Definimos el filtro.
% Utilizando directamente este filtro, obtendría los contornos horizontales.
Hprew = fspecial('prewitt'); 
% Definimos la transpuesta de filtro previamente definido para obtener en
% el filtrado los bordes/contornos verticales.
Hprew2 = Hprew';
% Realizamos el filtrado.
I_Hprew2 = imfilter(double(I),Hprew2,'symmetric');

% Convierto la imagen resultante en una imagen binaria.
BW = im2bw(I_Hprew2);

% Mostramos las imagenes resultantes.
figure,subplot(1,3,1),imshow(I),title('Imagen original')
subplot(1,3,2),imshow(uint8(abs(I_Hprew2))), title('Imagen filtrada contornos verticales')
subplot(1,3,3),imshow(BW),title('Imagen binaria bordes/contornos verticales')

%% Otra forma de resolverlo. (El resultado de esta transformacion no es bueno.
% Cargamos la imagen que vamos a utilizar.
I = imread('G15.jpeg');

% Convierto la imagen en una imagen binaria.
BW = im2bw(I);

% Definimos el filtro.
Hprew = fspecial('prewitt'); % Utilizando directamente este filtro, obtendría los bordes/contornos horizontales.
% Definimos la transpuesta de filtro previamente definido para obtener en
% el filtrado los bordes/contornos verticales.
Hprew2 = Hprew';
% Realizamos el filtrado.
I_Hprew2 = imfilter(double(BW),Hprew2,'symmetric');

% Mostramos las imagenes resultantes.
figure,subplot(1,3,1),imshow(I),title('Imagen original')
subplot(1,3,2),imshow(BW),title('Imagen binaria')
subplot(1,3,3),imshow(uint8(abs(I_Hprew2))), title('Imagen filtrada bordes/contornos verticales')

%% -------------------- PARTE CREATIVA --------------------

% Vamos a visualizar el negativo de I

% Cargamos la imagen que vamos a utilizar.
I = imread('G15.jpeg');

% Separamos sus componentes RGB y las visualizamos.
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

figure,subplot(1,3,1),imshow(R),title('Componente roja')
subplot(1,3,2),imshow(G), title('Componente verde')
subplot(1,3,3),imshow(B),title('Componente azul')

% Hallamos el negativo de cada componente y las visualizamos.
NR_R = 255 - R;
NR_G = 255 - G;
NR_B = 255 - B;
figure,subplot(1,3,1),imshow(NR_R),title('Negativo de la componente roja')
subplot(1,3,2),imshow(NR_G), title('Negativo de la componente verde')
subplot(1,3,3),imshow(NR_B),title('Negativo de la componente azul')

% Componenmos la imagen de nuevo con los negativos, para obtener la imagen
% RGB en negativo.
I_Negativo(:,:,1) = NR_R;
I_Negativo(:,:,2) = NR_G;
I_Negativo(:,:,3) = NR_B;


imwrite(I_Negativo, 'I_Negativo.tif');
figure, subplot(1,2,1), imshow(I), title('Imagen original')
subplot(1,2,2), imshow(I_Negativo), title('Imagen negativo') 


