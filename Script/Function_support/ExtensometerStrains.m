function x = ExtensometerStrains(dx1,dx2,dy1,dy2,x1,x2,y1,y2,n_steps,pixel_spacing)

l_x = zeros(n_steps,1);
l_y = zeros(n_steps,1);

l0_x = abs((x2-x1)*(pixel_spacing+1));    % Distanza iniziale in pixel
l0_y = abs((y2-y1)*(pixel_spacing+1));    % Distanza iniziale in pixel

% Variazione di distanze in pixel
delta_y = dy2 - dy1;
delta_x = dx2 - dx1;

% Distanza durante la prova
l_x(1) = l0_x+delta_x(1);
l_y(1) = l0_y+delta_y(1);
for i = 2:n_steps
   l_x(i) = l_x(i-1) + delta_x(i);
   l_y(i) = l_y(i-1) + delta_y(i);
end

% Allungamenti rispetto alla lunghezza iniziale
eps_y0 = delta_y/l0_y;    
eps_x0 = delta_x/l0_x;

% Allungamenti rispetto alla lunghezza attualizzata
eps_y = log(1+delta_y/l0_y);
eps_x = log(1+delta_x/l0_x);

x = zeros(n_steps,2,2);

x(:,1,1) = eps_x0(:);
x(:,2,1) = eps_y0(:);
x(:,1,2) = eps_x(:);
x(:,2,2) = eps_y(:);

end