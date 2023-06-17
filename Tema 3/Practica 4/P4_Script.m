%%%%%%% PRÁCTICA 4 %%%%%%%
%% I: Histograma y umbralización y II.Segmentación y caracterización de regiones.

clear all
close all
clc

I = imread('calculadora.tif');

% Pasamos la imagen a blanco y negro umbralizando.
I_U = im2bw(I,230/255);
figure, imshow(I_U), title('imagen original')

% Creamos la capa de segmentación en blanco y negro y la visualizamos.
[Seg_I_U, Nobjetos] = bwlabel(I_U);
imtool(uint8(Seg_I_U)), title('Capa de etiquetas normal')
fprintf('El número de objetos es: %0i\n', Nobjetos);

% Visualizamos la capa de etiquetas en falso color. Blanco en matlab es la etiqueta 0 que
% veíamos en negro en los apuntes.
RGB_Segment = label2rgb(Seg_I_U);
imtool(RGB_Segment), title('Capa de etiquetas en falso color')

% Calculamos el tamaño de los objetos.
Props = regionprops(Seg_I_U, 'Area');
V_Area = [];
for ind_obj = 1:Nobjetos
    V_Area = [V_Area Props(ind_obj).Area];
end
figure,stem(V_Area)
xlabel('Número de objeto'), ylabel('Tamaño')

% Identificamos las etiquetas que hay que quitar "por ejemplo: umbral de
% 5px".
V_No_Interes = [3 10 56 61];

% Bucle que filtra de la imagen binaria I_U las regiones de no interés.
[n_filas, n_cols] = size(I_U); % nos dice el numero de filas y columnas que tiene la imagen.

% recorre todas las filas de la imagen
for ind_nfila=1:n_filas 
    % recorre todas las columnas de la imagen
    for ind_ncol=1:n_cols 
        % Accedemos a la posicion de la matriz de la imagen B/N si en la posición indicada tenemos un pixel de primer plano.
        if I_U(ind_nfila, ind_ncol) 
            % busco si la etiqueta de ese pixel es una de las etiquetas de no interes que hemos definido antes.
            numero_et = Seg_I_U(ind_nfila, ind_ncol); 
            % si el pixel pertenece a la region de no interes, ismember nos
            % devuelve un valor mayor > 0. Concretamente nos devuelve el
            % valor en binario del numero de la etiqueta que pertenece a mis V_No_Interes.
            if sum(ismember(V_No_Interes, numero_et)) > 0 
                % Si se cumple la condición, borramos el pixel en cuestión,
                % y lo convertimos en un pixel de fondo. Es decir,
                % eliminamos la etiqueta que identifica ese pixel como un
                % objeto y le asignamos la etiqueta de fondo.
                I_U(ind_nfila, ind_ncol) = 0;
            end
        end
    end
end
figure, imshow(I_U), title('imagen binaria')
%% III. Procesado para identificación de la tecla 'Enter'

% Filtro de media para unir regiones
% Definición de la máscara
h = 1/(5*5)*ones(5,5);
% como la imagen que tenemos es logical y el tipo al hacer el filtrado se
% hereda, para filtrarla necesito pasala a uint8, provocando un efecto de
% difuminado con niveles mas altos en cada una de las teclas por separado.
I_U_Fmedia = imfilter(255*uint8(I_U), h); 
% Vemos con mesh que al hacer el filtrado, solo quedan picos de nivel
% unidas en cada una de las teclas, y cada una de ellas esta separada por
% un "valle" lo suficiente para que no se solapen.
figure, mesh(double(I_U_Fmedia))
figure, imshow(I_U_Fmedia)

% Umbralizar la imagen
% Vemos que los caracteres de cada una de las teclas quedan unificados y no
% se solapan
I_U_Fmedia_Th = im2bw(I_U_Fmedia, 1/255);
figure, imshow(I_U_Fmedia_Th)


% Volvemos a hacer la segmentacion sobre esta nueva imagen.
[Segm_regs_teclas, Nteclas] = bwlabel(I_U_Fmedia_Th);
imtool(I_U_Fmedia_Th)
fprintf('El número de objetos(teclas) es: %0i\n', Nteclas);

RGB_Segment = label2rgb(Segm_regs_teclas);
imtool(RGB_Segment)

Props = regionprops(Segm_regs_teclas, 'Area');
V_Area = [];
for ind_obj=1:Nteclas
    V_Area = [V_Area Props(ind_obj).Area];
end

figure,stem(V_Area)
xlabel('Número de tecla'), ylabel('Tamaño')

% Identificamos las etiquetas que hay que quitar "por ejemplo: umbral de
% 5px".
V_Interes = [5];

% Bucle que filtra de la imagen binaria I_U las regiones de no interés.
[n_filas, n_cols] = size(I_U_Fmedia_Th); % nos dice el numero de filas y columnas que tiene la imagen.

% recorre todas las filas de la imagen
for ind_nfila=1:n_filas 
    % recorre todas las columnas de la imagen
    for ind_ncol=1:n_cols 
        % Accedemos a la posicion de la matriz de la imagen B/N si en la posición indicada tenemos un pixel de primer plano.
        if I_U_Fmedia_Th(ind_nfila, ind_ncol) 
            % busco si la etiqueta de ese pixel es una de las etiquetas de no interes que hemos definido antes.
            numero_et = Segm_regs_teclas(ind_nfila, ind_ncol); 
            % si el pixel pertenece a la region de no interes, ismember nos
            % devuelve un valor mayor > 0. Concretamente nos devuelve el
            % valor en binario del numero de la etiqueta que pertenece a mis V_No_Interes.
            if sum(ismember(V_Interes, numero_et)) == 0 
                % Si se cumple la condición, borramos el pixel en cuestión,
                % y lo convertimos en un pixel de fondo. Es decir,
                % eliminamos la etiqueta que identifica ese pixel como un
                % objeto y le asignamos la etiqueta de fondo.
                I_U_Fmedia_Th(ind_nfila, ind_ncol) = 0;
            end
        end
    end
end
figure, imshow(I_U_Fmedia_Th),title('zona de interes')

I_Enter = uint8(I_U_Fmedia_Th).*I; % .* multiplica px por px.
figure, imshow(I_Enter)
