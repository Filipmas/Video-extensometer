function x = RefUpdateDisplacementsMatrix(matrix,datastruct)

  % Questa function ha lo scopo di correggere gli spostamenti dei nodi nei casi in cui la reference
  % image è stata aggiornata durante l'analisi.
  
  % Deve essere applicata a una vettore di matrici in cui i primi due indici indicano il generico
  % nodo mentre il terzo indice indica il frame corrispondente.
  
  % Somma gli spostamenti rispetto a una certa reference image gli spostamenti della reference image
  % stessa.
  
  n = numel(datastruct.data_dic_save.dispinfo.imgcorr);    % Numero totale di reference images

  % Ha senso aggiornare gli spostamenti solo se esiste più di una immagine di riferimento n>1.
  
  if n>1
  [k,l,m] = size(matrix);    % k e l indicano il nodo, m il frame.
  ref_index = zeros(n,1);
  
  % Estraggo gli indici delle reference image usate durante l'analisi.
  for i = 1:n
      ref_index(i) = datastruct.data_dic_save.dispinfo.imgcorr(i).idx_ref;
  end
  
      for i = 2:n
          ref_updated_image = ref_index(i);
          for j = (ref_index(i)+1):m
              matrix(:,:,j) = matrix(:,:,j) + matrix(:,:,ref_updated_image);
          end
      end
  end
  
  x = matrix;
end