%%%%%%% PRÁCTICA 5 %%%%%%%
%% I. Análisis visual de la imagen
clear all, close all, clc
I = imread('cormoran_rgb.jpg');
figure, imshow(I), title('Imagen Original')

% Primero pasamos la imagen a escala de grises y mostramos su histograma.
I_gris = rgb2gray(I);
imhist(I_gris), axis('auto')
figure, imshow(I_gris), title('Imagen en escala de grises')

I_bw = im2bw(I_gris, 210/255); % 160 y 210 son los umbrales.
figure, imshow(I_bw), title('imagen binarizada')


% II. Características RGB y algoritmo k-medias
close all
I = imread('cormoran_rgb.jpg');
figure, imshow(I), title ('Imagen Original')

% Estracción de cada componente de color RGB
I_R = I(:,:,1);
I_G = I(:,:,2);
I_B = I(:,:,3);

% Visualizamos los componentes.
figure,subplot(1,3,1), imshow(I_R), title('Componente R')
subplot(1,3,2), imshow(I_G), title('Componente G')
subplot(1,3,3), imshow(I_B), title('Componente B')

% obtenemos el tamaño de la imagen (filas, columnas, dimension)
[nrows, ncols, ndim] = size(I);
% Redimensionamos las componentes RGB.
% Esta es una estructura de dos dimensiones y ahora quiero que sea un
% vector. Esto es lo que hace reshape (tambien puede pasar vectores a
% varias dimensiones)
I_R_res = reshape(I_R, nrows*ncols, 1);
I_G_res = reshape(I_G, nrows*ncols, 1);
I_B_res = reshape(I_B, nrows*ncols, 1);

% obtenemos el scaterplot en 3 dimensiones de la imagen.
% plot solo funciona con vectores, por eso anteriormente tuvimos que hacer
% reshape.
figure, plot3(I_R_res, I_G_res, I_B_res, '.b');
xlabel('R'), ylabel('G'), zlabel('B')

% Aplicamos el algoritmo k-medias.
ngrupos = 3;
rgb_res = double([I_R_res, I_G_res, I_B_res]);

% dimensión de cluster_center: 3x3 cada fila un centro, cada columna al
% componente RGB de ese centro.
% cluster_inx: va a ser un vector de tantas filas como pixeles tenga, una
% única columna, y en esa columna voy a encontrar 3 etiquetas, una
% correspondiente a cada grupo. 
[cluster_idx, cluster_center] = kmeans(rgb_res, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 
% distancia, tipo de distancia: ecuclídea al cuadrado, numero de veces que se va a
% ejecutar el algoritmo k-medias (replicates), en este caso 10. Matlab nos
% va a mostrar solo la mejor ejecucion de las 10 que va a realizar.

figure, hist(cluster_idx) % Van a salir las columnas correspondientes a cada etiqueta
% Dependiendo de la realizacion que escoja matlab, esta grafica puede
% marcar las etiquetas de distinta manera. Lo importante son que tiene que
% aparecer 3 columnas, la etiqueta que tengan asociada no es importante,
% pueden variar las etiquetas.

pixel_labels_rgb = reshape(cluster_idx, nrows, ncols);

figure, plot3(I_R_res, I_G_res, I_B_res, '.b');
xlabel('R'), ylabel('G'), zlabel('B')
hold on
plot3(cluster_center(:,1), cluster_center(:,2), cluster_center(:,3), 'sr', 'MarkerSize', 20, 'MarkerEdge','r');

figure, imshow(pixel_labels_rgb, []), title('Segmentacion - rgb SIN NORMALIZAR')
I_segm = label2rgb(pixel_labels_rgb);
figure, imshow(I_segm), title('Segmentacion a falso color - rgb SIN NORMALIZAR');

% III. Características cromáticas ab
close all
% Cambio al espacio Lab y considero únicamente el espacio ab
[lab_imL, l_L, a_L, b_L] = rgb2lab(I);
a_res = reshape(a_L, nrows*ncols, 1);
b_res = reshape(b_L, nrows*ncols, 1);

figure, mesh(a_L), title('mesh a_L')
figure, mesh(b_L), title('mesh b_L')

% RD_a = max(a_res) - min(a_res)
% RD_b = max(b_res) - min(b_res) parece que la componente b va a influir
% mas, porque su RD es mayor.

ab_res = [a_res, b_res];
[cluster_idx, cluster_center] = kmeans(ab_res, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 

figure, plot(a_res, b_res, '.'), title('espacio ab')
xlabel('a'), ylabel('b')
hold on % Sirve para mantener la figura y sobreescribir encima.
plot(cluster_center(:,1), cluster_center(:,2), 'sr');

pixel_labels_ab = reshape(cluster_idx, nrows, ncols);
I_segm = label2rgb(pixel_labels_ab);
figure, imshow(I_segm), title('segm ab')

std(a_res)
std(b_res)


% normalización
ab_res = [a_res, b_res];
ndim = size(ab_res, 2);
ab_norm = ab_res;
for ind_dim = 1:ndim
    datos = ab_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_norm(:,ind_dim) = datos_norm;
end

[cluster_idx_norm, cluster_center] = kmeans(ab_norm, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 
pixel_labels_ab_norm = reshape(cluster_idx_norm, nrows, ncols);

I_segm = label2rgb(pixel_labels_ab_norm);
figure, imshow(I_segm), title('Segm ab NORM')

figure, plot(ab_norm(:,1), ab_norm(:,2), '.'), , title('espacio ab normalizado')
xlabel('a-norm'), ylabel('b-norm')
hold on
plot(cluster_center(:,1), cluster_center(:,2), 'sr');


% IV. Características de textura
close all

E = entropyfilt(I_gris, ones(7,7));
% A mayor entropia mas homogenea es la imagen en cuanto a caracteristica de
% textura.
S = stdfilt(I_gris, ones(7,7));
R = rangefilt(I_gris, ones(7,7));

figure, subplot(1,3,1), imshow(E,[]),title('E')
subplot(1,3,2), imshow(S,[]),title('S')
subplot(1,3,3), imshow(R,[]),title('R')

% Escogemos dos componentes, normalizamos el rango y hacemos el k-medias.
E_res = reshape(E, nrows*ncols, 1);
S_res = reshape(S, nrows*ncols, 1);
ES_res = [E_res, S_res];

% Este bucle es el algoritmo k-medias.- 
ndim = size(ES_res, 2);
ES_norm = ES_res;
for ind_dim = 1:ndim
    datos = ES_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ES_norm(:,ind_dim) = datos_norm;
end

[cluster_idx_norm, cluster_center] = kmeans(ES_norm, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 
pixel_labels_ES_norm = reshape(cluster_idx_norm, nrows, ncols);

I_segm = label2rgb(pixel_labels_ES_norm);
figure, imshow(I_segm), title('Segm ES NORM')

figure, plot(ES_norm(:,1), ES_norm(:,2), '.'), title('espacio ES normalizado')
xlabel('E-norm'), ylabel('S-norm')
hold on
plot(cluster_center(:,1), cluster_center(:,2), 'sr');


% V. Utilización de características de distinta naturaleza. 
close all

% Hacemos la combinación de ab y E (por ejemplo)
% [cluster_idx_norm, cluster_center] = kmeans([ab_rest,E_res], ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 

[cluster_idx_norm, cluster_center] = kmeans([ab_norm,ES_norm(:,1)], ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 
pixel_labels_abE_norm = reshape(cluster_idx_norm, nrows, ncols);

figure, plot3(ab_norm(:,1), ab_norm(:,2),ES_norm(:,1), '.'), title('Distribucion espacio abE')
hold on
plot3(cluster_center(:,1), cluster_center(:,2),cluster_center(:,3), 'sr', 'MarkerSize', 20, 'MarkerEdge','r');
xlabel('a'), ylabel('b'), zlabel('E')

I_segm = label2rgb(pixel_labels_abE_norm);
figure, imshow(I_segm), title('Segm abE NORM')

% Hacemos un filtro paso bajo de la componente a y de la componente b
mascara = 1/49*ones(7,7);
a_mean = imfilter(a_L, mascara, 'symmetric');
b_mean = imfilter(b_L, mascara, 'symmetric');

a_mean_res = reshape(a_mean, nrows*ncols, 1);
b_mean_res = reshape(b_mean, nrows*ncols, 1);

ab_mean_res = [a_mean_res, b_mean_res];

% Este bucle es la normalizacion de las componentes.
ndim = size(ab_mean_res, 2);
ab_mean_norm = ab_mean_res;
for ind_dim = 1:ndim
    datos = ab_mean_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_mean_norm(:,ind_dim) = datos_norm;
end

[cluster_idx_norm, cluster_center] = kmeans(ab_mean_norm, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 
pixel_labels_ab_mean_norm = reshape(cluster_idx_norm, nrows, ncols);

I_segm = label2rgb(pixel_labels_ab_mean_norm);
figure, imshow(I_segm), title('Segm ab mean NORM')

figure, plot(ab_mean_norm(:,1), ab_mean_norm(:,2), '.'), title('Distribucion espacio ab-mean-norm')
xlabel('a_mean-norm'), ylabel('b_mean-norm')
hold on
plot(cluster_center(:,1), cluster_center(:,2), 'sr');

