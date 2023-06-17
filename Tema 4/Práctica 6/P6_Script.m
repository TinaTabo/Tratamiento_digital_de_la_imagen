%%%%%%% PRÁCTICA 6 %%%%%%%
%% I. Transformación del espacio de representación.
clear all, close all, clc

Img = imread('Board_Recorte.tif');
figure, imshow(Img), title('Imagen original')
figure, imhist(Img), axis('auto'), title('Histograma Img. Original')

% Visualizamos las componentes RGB de la img.
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
figure, subplot(1,3,1), imshow(R), title('Componente Roja')
subplot(1,3,2), imshow(G), title('Componente Verde')
subplot(1,3,3), imshow(B), title('Componente Azul')
% Ninguna de ellas es mas relevante que la otra, por lo que sera dificil
% utilizar una de ellas como capa de segmentación y obtener solo los 8
% chips mas grandes.

% Cambiamos la imagen al espacio HSI.
[H,S,I] = rgb2hsi(Img);
figure, subplot(1,3,1), imshow(H), title('Componente H')
subplot(1,3,2), imshow(S), title('Componente S')
subplot(1,3,3), imshow(I), title('Componente I')

% Rango de variación -> lo sabemos visualizando el histograma de cada una.
figure, imhist(H), axis('auto'), title('Histograma Componente H')
figure, imhist(S), axis('auto'), title('Histograma Componente S')
figure, imhist(I), axis('auto'), title('Histograma Componente I')
% Vemos que el rango dinamico esta comprendido entre 0 y 1.


% Escogemos la componente S, ya que destacan mas las zonas correspondientes
% a los chips.
Componente = S;

% II. Umbralización y filtrado.

% Visualizamos el histograma de la componentes S.
figure, imhist(S), axis('auto'), title('Histograma Componente S')

% Para obtener automaticamente el valor umbral, utilizamos el método Otsu
% con el siguiente comando.
Umbral = graythresh(Componente);
fprintf('Valor umbral obtenido: %0i\n', Umbral);

S_U = im2bw(Componente,Umbral);
S_U = uint8(S_U*255);
figure, imshow(S_U), title('Img. umbralizada en uint8')


% Aplicamos un filtro de mediana para homogeneizar el interior de los
% chips.
I_median = medfilt2(S_U,[5,5],'symmetric');
figure, imshow(I_median), title('Img. filtrada')


% III. Aplicación de operadores morfológicos.

% Creamos el elemento estructurante.
EE_cuadrado = strel('square', 35);

% Erosión.
Erosion = imerode(I_median, EE_cuadrado);
figure, imshow(Erosion), title('Erosión')

% Dilatación.
Dilatacion = imdilate(I_median, EE_cuadrado);
figure, imshow(Dilatacion), title('Dilatacion')

% Apertura.
Apertura = imopen(I_median, EE_cuadrado);
figure, imshow(Apertura), title('Apertura')

% Cierre.
Cierre = imclose(I_median, EE_cuadrado);
figure, imshow(Cierre), title('Cierre')


% IV. Segmentación y caracterización de objetos.

% Utilizaremos el cierre para hacer la segmentación, ya que es donde mejor
% se observan los 7 chips.

% Vamos a obtener la capa de etiquetas( bwlabel utiliza vecindad a 8)
[IM_Seg,n] = bwlabel(Cierre);
% n es el numero de objetos conectados, en este caso solo hay uno (el que
% sale en azul) salen mas objetos en blanco pero no estan conectados por
% eso no cuentan.
figure, imshow(IM_Seg), title('Capa de etiquetas')

% Pasamos la capa de etiquetas a RGB y la pintamos.
RGB_Segment = label2rgb(IM_Seg);
figure, imshow(RGB_Segment), title('Capa de etiquetas en falso color')
% Vemos que se coge el fondo como primer plano.

% Para poder quedarnos con los chips en primer plano, hacemos el negativo
% de la imagen cierre.
Negativo_Cierre = 255 - Cierre;
figure, imshow(Negativo_Cierre), title('Negativo del Cierre')

% Vamos a obtener la capa de etiquetas( bwlabel utiliza vecindad a 8)
[IM_Seg,n] = bwlabel(Negativo_Cierre);
figure, imshow(IM_Seg), title('Capa de etiquetas')

% Pasamos la capa de etiquetas a RGB y la pintamos.
RGB_Segment = label2rgb(IM_Seg);
figure, imshow(RGB_Segment), title('Capa de etiquetas en falso color')
% Ahora si obtenemos los chips con distintas etiquetas y no coge el fondo.

% Obtenemos el numero de objetos.
Num_objetos = max(IM_Seg(:));
% Salen 13 objetos, mas de los chip que queremos obtener.
% Tenemos que hacer algo mas para que nos salgan 7.

% Calculamos el tamaño de los objetos.
imtool(IM_Seg,[])
Props = regionprops(IM_Seg, 'Eccentricity');
% Ver el valor del primer objeto.
Props(1).Eccentricity

% Obtenemos las fronteras (ultimo parte de la practica)

% Primero definimos el EE(forma y tamaño).
EE_cuadrado = strel('square', 5);

% Aplicamos Dilatacion con el EE.
Dilatacion = imdilate(Negativo_Cierre, EE_cuadrado);
figure, imshow(Dilatacion), title('Dilatacion')

% Aplicamos Erosion con el EE
Erosion = imerode(Negativo_Cierre, EE_cuadrado);
figure, imshow(Erosion), title('Erosión')

% Calculamos el gradiente.
Gradiente = Dilatacion - Erosion;
figure, imshow(Gradiente), title('Gradiente')

% Mapa del gradiente.
Gradiente_map = [0 0 0; 255 0 0];
Gradiente_Rojo = ind2rgb(Gradiente, Gradiente_map);
figure, imshow(Gradiente_Rojo), title('Img. Gradiente Rojo')

% Vemos la marcación de los chips sobre la imagen original sumando ambas
% imagenes.
I_Gradiente = uint8(Gradiente_Rojo) + Img;
figure, imshow(I_Gradiente), title('Segmentacion final')

% Me quedo con los chips rectangulares.


