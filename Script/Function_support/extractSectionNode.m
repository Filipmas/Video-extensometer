function x = extractSectionNode(nodes,points3D)

% Questa function permette di estrarre una matrice con le coordinate dei nodi nei vari frames che
% corrispondono ai nodi appartenenti alla sezione scelta.
% Se non � stato possibile trovare nessun nodo la function dar� errore.

N = size(nodes,1);
nframes = size(points3D,3);

x = zeros(N,3,nframes);

for j=1:nframes
    for i = 1:N
        x(i,:,j) = points3D(nodes(i),:,j);
    end
end
end


