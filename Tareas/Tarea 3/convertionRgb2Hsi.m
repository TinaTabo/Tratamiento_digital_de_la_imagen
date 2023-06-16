function [hsi]=convertionRgb2Hsi(image)
%HSI: Tono, Saturación e Intensidad
%RGB: Matriz numérica Rojo, Verde y Azul

%Extraer componentes componentes individuales de color
rgb = im2double(image);
R = rgb(:,:,1);
G = rgb(:,:,2);
B = rgb(:,:,3);

%ecuacion conversion
num = 0.5*((R - G)+(R - B));
den = sqrt((R - G).^2 + (R - B).*(G - B));
angulo = acos(num./(den + eps));
H = angulo;
H(B > G) = 2*pi - H(B > G);
H = H/(2*pi);
num = min(min(R,G),B);
den = R + G + B;
den(den == 0) = eps;
S = 1 - 3.*num./den;
H(S == 0) = eps;
I = (R + G + B)/3;

% combinacion de cada resultado en la imagen hsi
hsi = cat(3, H, S, I);
end