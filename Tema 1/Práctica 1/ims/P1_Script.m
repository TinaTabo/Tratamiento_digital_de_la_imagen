%%%%%%% Práctica 1 %%%%%%%
%% I. Lectura, visualización y almacenamiento de imágenes.
clear all, close all, clc
[Pimientos, MAP_Pimientos]=imread('peppers.png');
[Monedas, Map_Monedas]=imread('coins.png');
[Cara, MAP_Cara]=imread('cara.tif');

% Mostramos las imagenes
figure, imshow(Pimientos)
figure, imshow(Monedas)
figure, imshow(Cara)

%Mostramos el tamaño de las imágenes.
sz_Pimientos = size(Pimientos)
sz_Monedas = (Monedas)
sz_Cara = size(Cara)

% Una imagen binaria pase a ser RGB.
Cara_mapa = [255 255 0; 255 0 0];
Cara_rgb = ind2rgb(Cara, Cara_mapa);
imtool(Cara_rgb)
imwrite(Cara_rgb, 'Cara_rgb.tif')

% Una imagen RGB pase a escala de grises.
Pimientos_gray = rgb2gray(Pimientos);
imtool(Pimientos_gray)

% Una imagen RGB pase a una imagen indexada con 255 niveles.
[Pimientos_index, Pimientos_mapa] = rgb2ind(Pimientos, 255);
imtool(Pimientos_index, Pimientos_mapa)

% Una imagen RGB pase a una imagen indexada con 5 niveles.
[Pimientos_index5, Pimientos_mapa5] = rgb2ind(Pimientos, 5);
imtool(Pimientos_index5, Pimientos_mapa5)
imwrite(Pimientos_index5, Pimientos_mapa5, 'Pimientos_index5.tif')

% Una imagen de grises pase a binaria.
MonedasBW = im2bw(Monedas);
imtool(MonedasBW)


%% II. Modificación de la resolución y del número de niveles.
close all, clc
Lena = imread('Lena_512.tif');
figure, imshow(Lena)

% A partir de una imagen creamos otra con menor resolución.
Lena_256 = imresize(Lena,0.5);
figure, imshow(Lena_256)
imwrite(Lena_256, 'Lena_256.tif')

Lena_128 = imresize(Lena,0.25);
figure, imshow(Lena_128)
imwrite(Lena_128, 'Lena_128.tif')

% A partir de una imagen creamos otra con mayor resolucion.

Lena_512a = imresize(Lena_128,4,'nearest');
figure, imshow(Lena_512a)

Lena_512b = imresize(Lena_128,4,'bilinear');
figure, imshow(Lena_512b)

% Variar la resolucion de intensidad.
close all

[Lena_512_16, MAP_16] = gray2ind(Lena,16);
figure, imshow(Lena_512_16, MAP_16); title('16 Niveles')
imwrite(Lena_512_16, MAP_16, 'Lena_512_16.tif')

[Lena_512_4, MAP_4] = gray2ind(Lena,4);
figure, imshow(Lena_512_4, MAP_4); title('4 Niveles')
imwrite(Lena_512_4, MAP_4, 'Lena_512_4.tif')

[Lena_512_2, MAP_2] = gray2ind(Lena,2);
figure, imshow(Lena_512_2, MAP_2); title('2 Niveles')
imwrite(Lena_512_2, MAP_2, 'Lena_512_2.tif')

%% III. Histograma y mejora de contrate.

figure
subplot(4,1,1), imhist(Lena, 256), title('Histograma original')
subplot(4,1,2), imhist(Lena_512_16, MAP_16), title('Histograma 16')
subplot(4,1,3), imhist(Lena_512_4, MAP_4), title('Histograma 4')
subplot(4,1,4), imhist(Lena_512_2, MAP_2), title('Histograma 2')
% en la funcion subplot los dos primeros valores indican los valores de la
% sección, es decir, 4 filas y 1 columna.

%return
%figure
%subplot(4,1,1), imhist(Lena, 256), title('Histograma original')
%subplot(4,1,2), imhist(Lena_512_16), title('Histograma 16')
%subplot(4,1,3), imhist(Lena_512_4), title('Histograma 4')
%subplot(4,1,4), imhist(Lena_512_2), title('Histograma 2')

%figure, imhist(Lena_512_2,256), axis auto

% Si dejo esto, el programa muestra el histograma de las fotos de Lena y se
% queda atascado aqui, no continua su ejecución, pero tampoco da error.

% Ecualización del histograma

I = imread('pout.tif');
figure, imshow(I), title('Imagen original')

I_eq = histeq(I);
figure, imshow(I_eq), title('Imagen ecualizada')
figure
subplot(2,1,1), imhist(I), axis auto, title('Histograma imagen original')
subplot(2,1,2), imhist(I_eq), axis auto, title('Histograma imagen ecualizada')

%% IV. Interpretación del color y transformaciones puntuales
clear all, close all, clc

[Pimientos, MAP_Pimientos] = imread('peppers.png');

% Visualizamos la componente roja R
R = Pimientos(:,:,1);
imtool(R)
% Visualizamos la componente verde G
G = Pimientos(:,:,2);
imtool(G)
% Visualizamos la componente azul B
B = Pimientos(:,:,3);
imtool(B)
% Histograma de las componentes RGB
figure
subplot(3,1,1), imhist(R), axis auto, title('Histograma componente roja R')
subplot(3,1,2), imhist(G), axis auto, title('Histograma componente verde G')
subplot(3,1,3), imhist(B), axis auto, title('Histograma componente azul B')

% Visualizamos el negativo de la componente roja R

NR_a = R - 255;
figure, imshow(NR_a), title('Negativo de la componente R: R-255')% Esta no está
%bien así, se ve una imagen negra.

% Esta es la forma correcta de ver el negativo de la componente R
NR_b = 255 - R;
imtool(NR_b)

% Volvemos a componer la imagen sustituyendo la componente roja por su
% negativo, dejando las componentes verde y azul como estaban.
nueva_fig.Pimientos(:,:,1) = NR_b;
nueva_fig.Pimientos(:,:,2) = G
nueva_fig.Pimientos(:,:,3) = B

imwrite(nueva_fig.Pimientos, 'nueva_fig.Pimientos.tif');
figure, imshow(Pimientos), title('Imagen original')
figure, imshow(nueva_fig.Pimientos), title('imagen modificada') 

% Visualizamos la componente roja como una imagen RGB en la que el color
% predominante será el rojo.

Pimientos_Rojos = uint8(zeros(size(Pimientos)));
Pimientos_Rojos(:,:,1) = Pimientos(:,:,1);
figure,imshow(Pimientos_Rojos)



