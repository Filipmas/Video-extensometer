function x = clearNanTerms(coordinates)

% Questa funzione elimina da un vettore a più ingressi tutte le righe in cui appare un termine Nan,
% ovvero le righe che corrispondono a un nodo che scompare durante la prova.

coord1 = coordinates(:,:,1);
coord2 = coordinates(:,:,2);

x1 = coord1;
x2 = coord2;

x1(any(isnan(coord2),2),:) = [];
x2(any(isnan(coord2),2),:) = [];

coord1 = x1;

x1(any(isnan(coord1),2),:) = [];
x2(any(isnan(coord1),2),:) = [];

x(:,:,1) = x1;
x(:,:,2) = x2;
end