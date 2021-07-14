function x = findSection3D(coordinates3D,z,distance)

% Questa function permette di estrarre gli indici dei nodi che distano meno di "distance" dalla
% sezione ad altezza z.
% La matrice in ingresso deve avere 2 indici.

j=1;
indx = [0];
N = size(coordinates3D,1);
for i = 1:N
    err = abs(coordinates3D(i,3)-z);
    if err <= distance
        indx(j) = i;
        j=j+1;
    end
end

x = indx';

end