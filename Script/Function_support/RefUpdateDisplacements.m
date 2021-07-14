function x = RefUpdateDisplacements(vector,datastruct)

  % Questa function ha lo scopo di correggere gli spostamenti dei nodi nei casi in cui la reference
  % image è stata aggiornata durante l'analisi.
  % La function va applicata ai vettori degli spostamenti dopo che questi sono stati estratti dalla
  % struttura degli output dell'analisi.
  
  n = numel(datastruct.data_dic_save.dispinfo.imgcorr);    % Numero totale di reference images
  
  % Sommo agli spostamenti rispetto alla nuova immagine di riferimento gli spostamenti della nuova
  % immagine di riferimento. Va fatto solo se la reference image è stata aggiornata durante
  % l'analisi, quindi se esiste più di una reference image: n>1.
  
  if n>1
  m = length(vector);
  ref_index = zeros(n,1);
  
  % Estrapolo gli indici delle immagini usate come reference. Il primo sarà sempre 0.
  for i = 1:n
      ref_index(i) = datastruct.data_dic_save.dispinfo.imgcorr(i).idx_ref;
  end
  
      for i = 2:n
          ref_updated_image = ref_index(i);
          for j = (ref_index(i)+1):m
              vector(j) = vector(j) + vector(ref_updated_image);
          end
      end
  end
  
  x = vector;

end