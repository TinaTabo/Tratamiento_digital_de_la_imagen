% Integrante-1: Ana Poveda García Herrero
% Integrante-2: Cristina Taboada Mayo.
%% -------------------- PARTE OBLIGATORIA --------------------
clear all, close all, clc
% Cargamos la imagen con la que vamos a trabajar y la visualizamos.
Img = imread('G15.jpeg');
figure, imshow(Img), title('Imagen Original');

%% Pre-procesado de la imagen original para facilitar la segmentación.

% Cambiamos nuestra imagen del espacio RGB al espacio HSI
% Para poder hacer esto nos hemos descargado la función de matlab =>
% convertionRgb2Hsi.m, que adjuntamos junto con el script de la práctica.
I_HSI = convertionRgb2Hsi(Img);
figure, imshow(I_HSI), title('Imagen en el espacio HSI')

% Visualizamos cada componente.
H = I_HSI(:,:,1); % Componente del tono
S = I_HSI(:,:,2); % Componente de saturación.
I = I_HSI(:,:,3); % Componente de brillo.

figure, subplot(1,3,1), imshow(H), title('Componente H')
subplot(1,3,2), imshow(S), title('Componente S')
subplot(1,3,3), imshow(I), title('Componente I')

% Cuando visualizamos las componentes observamos que en la componente H los
% valores mas altos corresponden a los pixeles del balón.
% Visualizamos un mesh para ver cuales son esos valores.
figure, mesh(H), title('Componente H')

% Comprobamos que los valores mas altos, en su mayoria pertenecen al balón.
% Pasamos la imagen correspondiente a la componente H por un filtro paso
% bajo.

% Definimos la máscara y sus coeficientes. 
h = 1/49*ones(7,7);
% Aplicamos el filtro.
H_FPB = imfilter(H,h);
figure, imshow(H_FPB), title('Componente H suavizada')
figure, imhist(H_FPB), title('Histograma H suavizada')
figure, mesh(H_FPB), title('H suavizada')

%% Proceso de segmentacion.

% Tenemos que hacer es umbralizar la imagen correspondiente
% a la componente H, que previamente hemos pasado por un filtro paso bajo
% para unificar los distintos niveles de la imagen.

% Primero, pasamos a la imagen de la componente H a blanco y negro usando
% segmentación binaria por umbralización.
H_U = im2bw(H_FPB,0.8);
figure, imshow(H_U), title('Componente H umbralizada')

% Creamos la capa de segmentación en blanco y negro y la visualizamos.
[Seg_H_U, Nobjetos] = bwlabel(H_U);
imtool(uint8(Seg_H_U)), title('Capa de etiquetas normal')
fprintf('El número de objetos es: %0i\n', Nobjetos);

% Visualizamos la capa de etiquetas en falso color. Blanco en matlab es la etiqueta 0 que
% veíamos en negro en los apuntes.
RGB_Segment = label2rgb(Seg_H_U);
imtool(RGB_Segment), title('Capa de etiquetas en falso color')

% Calculamos el tamaño de los objetos.
Props = regionprops(Seg_H_U, 'Area');
V_Area = [];
for ind_obj = 1:Nobjetos
    V_Area = [V_Area Props(ind_obj).Area];
end
figure,stem(V_Area)
xlabel('Número de objeto'), ylabel('Tamaño')

% Identificamos que la etiqueta asignada a la region de mayor tamaño (el
% balon) es la 4.
V_Interes = [4];

% Bucle que filtra de la imagen binaria I_U las regiones de no interés.
[n_filas, n_cols] = size(H_U); % nos dice el numero de filas y columnas que tiene la imagen.

% recorre todas las filas de la imagen
for ind_nfila=1:n_filas 
    % recorre todas las columnas de la imagen
    for ind_ncol=1:n_cols 
        % Accedemos a la posicion de la matriz de la imagen B/N si en la posición indicada tenemos un pixel de primer plano.
        if H_U(ind_nfila, ind_ncol) 
            % busco si la etiqueta de ese pixel es una de las etiquetas de interes que hemos definido antes.
            numero_et = Seg_H_U(ind_nfila, ind_ncol); 
            % si el pixel pertenece a la region de interes, ismember nos
            % devuelve un valor mayor > 0. Concretamente nos devuelve el
            % valor en binario del numero de la etiqueta que pertenece a mis V_Interes.
            if sum(ismember(V_Interes, numero_et)) == 0 
                % Si se cumple la condición, borramos el pixel en cuestión,
                % y lo convertimos en un pixel de fondo. Es decir,
                % eliminamos la etiqueta que identifica ese pixel como un
                % objeto y le asignamos la etiqueta de fondo.
                H_U(ind_nfila, ind_ncol) = 0;
            end
        end
    end
end
figure, imshow(H_U),title('zona de interes')

% Usamos la imagen umbralizada como mascara y conseguimos extraer nuestro
% objeto de interés.
% Como la imagen que queremos segmenta es RGB tenemos que aplicar la
% mascara a cada una de sus componentes y volver a recomponer la imagen.

I_Balon = uint8(H_U).*Img; % .* multiplica px por px.
figure, imshow(I_Balon), title('Balon segmentado')

% Ahora usando el resultado de la segmentación anterior, construimos una
% nueva imagen RGB, de mismo tamaño que la imagen original, que contenga:
%  - el fondo con un color gris intermedio (128,128,128)
%  - el objeto extraido, que mantiene los mismo niveles que en la imagen
%    original, se visualiza en la esquina superior derecha de la imagen.

% Cambiamos el nivel del fondo a gris intermedio.
MC = [128 128 128; 1 1 1]; % Mapa de color.
I_Fondo = uint8(ind2rgb(H_U, MC));
figure, imshow(I_Fondo), title('Imagen de fondo gris')

% Sumamos la imagen del fondo que hemos creado con la imagen segmentada
Seg_Balon = I_Fondo + I_Balon;
figure, imshow(Seg_Balon), title('Imagen segmentada con fondo gris')

% Obtenemos la bounding box que contiene nuestro objeto de interes => el
% balon.
hold on
BB = rectangle('Position',[362, 840, 400, 450])
Balon = imcrop(Seg_Balon,[362, 840, 400, 450]);
figure, imshow(Balon), title('Balón contenido en la Bounding Box')

% Colocamos la bounding box con el objeto en la esquina superior derecha de
% nuestra imagen.
Imagen = uint8(ones(1600,1200));
Ibw = im2bw(Imagen);
Imapa = [1 1 1; 1 1 1];
Irgb = uint8(ind2rgb(Ibw,Imapa));
[Nrows, Ncols] = size(Balon(:,:,1));
for i=1:Nrows
    for j=1:Ncols
        Irgb(i,800+j,1) = Balon(i,j,1);
        Irgb(i,800+j,2) = Balon(i,j,2);
        Irgb(i,800+j,3) = Balon(i,j,3);
    end
end

% Volvemos a asignar al fondo el color gris intermedio.
I_gris = rgb2gray(Irgb);

[Nrows, Ncols] = size(Irgb(:,:,1));
for i=1:Nrows
    for j=1:Ncols
        if I_gris(i,j) == 1
            Irgb(i,j,:) = 128;
        end
    end
end

% Obtenemos el resultado final.
figure, imshow(Irgb), title('Nueva imagen RGB')

%% -------------------- PARTE CREATIVA --------------------
clear all, close all, clc

% Vamos a intentar hacer una segmentación del balon, como en la parte
% obligatoria, pero esta vez utilizando el algoritmo k-medias(técnica no
% supervisada), sobre una imagen en el espacio Lab y haremos la valoración 
% de si es una buena o mala segmentación para nuestra imagen.

% Cargamos la imagen con la que vamos a trabajar y la visualizamos.
Img = imread('G15.jpeg');
figure, imshow(Img), title('Imagen Original');

% Para facilitar el proceso, recortamos la imagen, reduciendo el numero de
% niveles de intensidad en el histograma respecto al de la imagen original.
I_rec = Img(850:1270, 320:830, :);
figure, imshow(I_rec), title('Imagen recortada')

% Calculamos el tamaño de la imagen recortada.
[nrows, ncols, ndim] = size(I_rec);

% Cambiamos nuestra imagen del espacio RGB al espacio Lab.
[lab_imL, l_L, a_L, b_L] = rgb2lab(I_rec);
a_res = reshape(a_L, nrows*ncols, 1);
b_res = reshape(b_L, nrows*ncols, 1);

figure, mesh(a_L), title('mesh a L')
figure, mesh(b_L), title('mesh b L')

% Aplicamos el algoritmo k_medias considerando k = 4.
ngrupos = 4;
ab_res = [a_res, b_res];
[cluster_idx, cluster_center] = kmeans(ab_res, ngrupos, 'distance', 'sqEuclidean', 'Replicates', 10); 

figure, plot(a_res, b_res, '.'), title('espacio ab')
xlabel('a'), ylabel('b')
hold on % Sirve para mantener la figura y sobreescribir encima.
plot(cluster_center(:,1), cluster_center(:,2), 'sr');

pixel_labels_ab = reshape(cluster_idx, nrows, ncols);
I_segm = label2rgb(pixel_labels_ab);
figure, imshow(I_segm), title('segm ab')

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

