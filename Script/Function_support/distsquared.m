function F = distsquared(coord1,coord2)

% Questa function calcola la distanza al quadrato tra un punto e la posizione che avrebbe se
% se compisse una rotazione theta attorno a un centro (x,y).
% In output fornisce una anonymous function nelle coordinate del centro di rotazione e dell'angolo
% di rotazione theta espresso in radianti.

xold = coord1(1);
yold = coord1(2);

xnew = coord2(1);
ynew = coord2(2);

F = @(x,y,theta) (xnew-x-sqrt((xold-x)^2+(yold-y)^2)*((xold-x)/sqrt((xold-x)^2+(yold-y)^2)*cos(theta)-(yold-y)/sqrt((xold-x)^2+(yold-y)^2)*sin(theta)))^2 ...
                +(ynew-y-sqrt((xold-x)^2+(yold-y)^2)*((yold-y)/sqrt((xold-x)^2+(yold-y)^2)*cos(theta)+(xold-x)/sqrt((xold-x)^2+(yold-y)^2)*sin(theta)))^2;

end