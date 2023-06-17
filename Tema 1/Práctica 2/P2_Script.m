%%%%%%%%%%%%%%%%%% Práctica 2 %%%%%%%%%%%%%%%%%%%%%
%% I. Imágenes contaminadas con ruido.
clear all, close all, clc

% Creamos una imagen con Matlab
I = 128*ones(256,256);
I = uint8(I)
figure
subplot(2,1,1), imshow(I)
subplot(2,1,2), imhist(5), axis('auto')

% Contaminamos la imagen con distintos tipos de ruido.
I_speckle = imnoise(I,'speckle',0.02);
I_gauss = imnoise(I,'gaussian',0,0.02);
I_salt_pepper = imnoise(I,'salt & pepper',0.02);

I_gspeesyp = [I_gauss, I_speckle, I_salt_pepper];
figure, imshow(I_gspeesyp)
title('Composición de ruido Gauss(iqda), Granular(med), Sal y Pimienta(der)');

%% II.Filtros espaciales suavizadores

    %% FILTRADO LINEAL
% Definición de la máscara
h = 1/25*ones(5,5);
h_grande = (1/(35*35))*ones(35,35);

% Filtrado lineal paso bajo de la imagen con ruido de tipo gaussiano
% Imagen filtrada con zero padding y su histograma
I_gauss_suav = imfilter(I_gauss,h);
figure, subplot(2,1,1),imshow(I_gauss_suav), title('Filtro Igauss')
subplot(2,1,2), imhist(I_gauss_suav), title('Filtro Igauss')

% Imagen filtrada con mirror padding y su histograma
I_gauss_suav = imfilter(I_gauss,h,'symmetric','same');
figure, subplot(2,1,1), imshow(I_gauss_suav), title('Filtro Igauss Symmetric')
subplot(2,1,2), imhist(I_gauss_suav), title('Filtro Igauss Symmetric')

% Repetimos el proceso con las dos imagenes contaminadas con ruido sal y
% pimienta, y speckle

% Zero padding(de ambas)
I_speckle_suav = imfilter(I_speckle,h);
figure, subplot(2,1,1),imshow(I_speckle_suav), title('Filtro Ispeckle')
subplot(2,1,2), imhist(I_speckle_suav), title('Filtro Ispeckle')

I_salt_pepper_suav = imfilter(I_salt_pepper,h);
figure, subplot(2,1,1),imshow(I_salt_pepper_suav), title('Filtro Isalt_pepper')
subplot(2,1,2), imhist(I_salt_pepper_suav), title('Filtro Isalt_pepper')

% Mirror padding(de ambas)
I_speckle_suav = imfilter(I_speckle,h,'symmetric','same');
figure, subplot(2,1,1), imshow(I_speckle_suav), title('Filtro Ispeckle Symmetric')
subplot(2,1,2), imhist(I_speckle_suav), title('Filtro Ispeckle Symmetric')

I_salt_pepper_suav = imfilter(I_salt_pepper,h,'symmetric','same');
figure, subplot(2,1,1), imshow(I_salt_pepper_suav), title('Filtro Isalt_pepper Symmetric')
subplot(2,1,2), imhist(I_salt_pepper_suav), title('Filtro Isalt_pepper Symmetric')

% Repetimos el filtrado de las 3 imagenes pero ahora utilizando la
% máscara de 35*35

% Zero Padding
I_gauss_suav = imfilter(I_gauss,h_grande);
figure, subplot(2,1,1),imshow(I_gauss_suav), title('Filtro Igauss')
subplot(2,1,2), imhist(I_gauss_suav), title('Filtro Igauss')

I_speckle_suav = imfilter(I_speckle,h_grande);
figure, subplot(2,1,1),imshow(I_speckle_suav), title('Filtro Ispeckle')
subplot(2,1,2), imhist(I_speckle_suav), title('Filtro Ispeckle')

I_salt_pepper_suav = imfilter(I_salt_pepper,h_grande);
figure, subplot(2,1,1),imshow(I_salt_pepper_suav), title('Filtro Isalt_pepper')
subplot(2,1,2), imhist(I_salt_pepper_suav), title('Filtro Isalt_pepper')

% Mirror padding
I_gauss_suav = imfilter(I_gauss,h_grande,'symmetric','same');
figure, subplot(2,1,1), imshow(I_gauss_suav), title('Filtro Igauss Symmetric')
subplot(2,1,2), imhist(I_gauss_suav), title('Filtro Igauss Symmetric')

I_speckle_suav = imfilter(I_speckle,h_grande,'symmetric','same');
figure, subplot(2,1,1), imshow(I_speckle_suav), title('Filtro Ispeckle Symmetric')
subplot(2,1,2), imhist(I_speckle_suav), title('Filtro Ispeckle Symmetric')

I_salt_pepper_suav = imfilter(I_salt_pepper,h_grande,'symmetric','same');
figure, subplot(2,1,1), imshow(I_salt_pepper_suav), title('Filtro Isalt_pepper Symmetric')
subplot(2,1,2), imhist(I_salt_pepper_suav), title('Filtro Isalt_pepper Symmetric')

    %% FILTRADO NO LINEAL
% Filtrados de mediana con máscara de tamaño 5*5
I_median = medfilt2(I,[5,5],'symmetric');
I_gauss_median = medfilt2(I_gauss,[5,5],'symmetric');
I_salt_pepper_median = medfilt2(I_salt_pepper,[5,5],'symmetric');
I_speckle_median = medfilt2(I_speckle,[5,5],'symmetric');

figure, subplot(2,1,1),imshow(I_gauss_median), title('Filtro de mediana ruido Gaussiano y mirror padding')
subplot(2,1,2), imhist(I_gauss_median)

figure, subplot(2,1,1),imshow(I_speckle_median),title('Filtro de mediana ruido Speckle y mirror padding')
subplot(2,1,2), imhist(I_speckle_median)

figure, subplot(2,1,1),imshow(I_salt_pepper_median),title('Filtro de mediana ruido Sal y Pimienta y mirror padding')
subplot(2,1,2), imhist(I_salt_pepper_median)

%% III.Filtros espaciales de realce de contornos(Filtros paso alto)
clear all, close all, clc
% Cargamos la imagen monedas
I = imread('coins.png');
figure, imshow(I)
figure, mesh(double(I)) % mesh permite representar en 3D variables que sean del tipo double. La altura representa los niveles de intensidad de cada pixel.
                        % Double permite que matlab tenga en cuenta los valores negativos.
H_prew = fspecial('prewitt');
I_Hprew = imfilter(double(I),H_prew,'symmetric'); % Este filtro, filtra las horizontales.
H_prew2 = H_prew'; % Definimos H_prew2 como la traspuesta de H_prew. Por eso lleva '.
I_Hprew2 = imfilter(double(I),H_prew2,'symmetric'); % Este filtro, filtra las verticales.
I_grad_Prewitt = uint8(0.5*(double(abs(I_Hprew))+double(abs(I_Hprew2)))); % Sumamos las componentes horizontales y verticales.
figure, subplot(1,3,1), imshow(uint8(abs(I_Hprew))),title('I Hprew')
subplot(1,3,2), imshow(uint8(abs(I_Hprew2))),title('I Hprew2')
subplot(1,3,3), imshow(I_grad_Prewitt),title('I grad Prewitt')

% Utilizando un filtro de mediana(filtro paso bajo no lineal, difumina el interior de la moneda pero no difumina los contornos como el FPB lineal)
I_median= medfilt2(I,[11,11],'symmetric');
% Umbralizamos la imagen(La convertimos en una imagen blanco y negro).
% Visualizamos el histograma de la imagen de la mediana para conocer el
% umbral.
figure,imhist(I_median)
% Decidimos que los valores de intensidad comprendidos entre 100-255 seran
% '1' lógicos, es decir, blanco, y el resto de niveles serán '0', es decir,
% negro.
% Como el umbral debe ser un numero comprendido entre 0 y 1, el umbral que
% hemos decidido, en este caso 100, lo dividimos entre 255.(Es una regla de
% 3: 100/level=255/1) 
I_BW = im2bw(I_median, 100/255);
h = -ones(3,3);
h(2,2)= 8;
I_BW_realce = imfilter(I_BW,h,'symmetric');
figure,subplot(1,3,1), imshow(I_median),title('I median')
subplot(1,3,2), imshow(I_BW),title('I BW')
subplot(1,3,3), imshow(I_BW_realce),title('I BW realce')

%% IV.Composición de imágenes.

% Creamos la imagen RGB. Como es una imagen en escala de grises, sus 3
% componentes son iguales.
I_R = I;
I_G = I;
I_B = I;

% Hacemos lo mismo con la imagen I_BW_realce.
% Como es de tipo logical antes debemos convertirla en una imagen uint8:
I_BW_realce2 = uint8(I_BW_realce*255);
R_BW = I_BW_realce2;
G_BW = 0;
B_BW = 0;

% Creamos una matriz de unos del mismo tamaño de la imagen que queremos
% componer, y le asignamos las misma componentes con las que hemos creado
% las imagenes RGB:
I_unos = uint8(ones(246,300,3)); % medidas de la imagen.
I_unos(:,:,1) = I_R;
I_unos(:,:,2) = I_G;
I_unos(:,:,3) = I_B;

I_BW_unos = uint8(ones(246,300,3));
I_BW_unos(:,:,1) = R_BW;
I_BW_unos(:,:,2) = G_BW;
I_BW_unos(:,:,3) = B_BW;

% Sumando las dos matrices conseguimos la composicion de la imagen que
% buscabamos.
Composicion = imadd(I_unos,I_BW_unos);
imtool(Composicion)