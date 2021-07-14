function [xc,yc,rot] = findRotation(coordinates,originCenter)

% Partendo da una matrice contenente le coordinate dei nodi di una certa sezione in due istanti
% successivi la function permette di approssimare il centro di rotazione della sezione e l'angolo di
% rotazione espresso in radianti.

% Prima di calcolare le distanze bisognare eliminare i nodi che non hanno un valore definito perché
% scompaiono durante la prova.
coordinates = clearNanTerms(coordinates);

N = size(coordinates,1);
coord1 = coordinates(:,:,1);
coord2 = coordinates(:,:,2);

    F = @(x,y,theta) 0;
    for i = 1:N
        Fi = distsquared(coord1(i,:),coord2(i,:));
        F =  @(x,y,theta) F(x,y,theta) + Fi(x,y,theta);
    end
        
    if originCenter
        xc = 0;
        yc = 0;
        NewF = @(theta) F(0,0,theta);
        
        rot = fminbnd(NewF,-pi/2,pi/2);

    else
        NewF = @(z) F(z(1),z(2),z(3));

        % Starting point 
        X0 = [0 0 0]';

        %options = optimset('Display','iter','PlotFcns',@optimplotfval);

        sol = fminsearch(NewF,X0);
        xc = sol(1);
        yc = sol(2);
        rot = sol(3);

    end

end