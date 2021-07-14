clear all

%% Loading data e raggruppamento in una matrice

node_index = [176 210; 912 944; 1261 1295]; % Nodi di estremità delle linee
image_index = [107,214];

for k = 1:3
    for x = 1:length(image_index)
        linea = k;

        nodo1 = node_index(linea,1);
        nodo2 = node_index(linea,2);
            nnodi = nodo2-nodo1+1;

        path = 'D:\Universita\Tesi-Magistrale\Trazione_LastraSaldate\Output_nodi_rinumerati';

        data1 = readtable(strcat(path,'\Node_',num2str(nodo1),'.xlsx'));
        data1 = table2array(data1);
        [M,N] = size(data1);

        clear data1

        data = zeros([M,N,nnodi]);

        % Creo un matrice che contiene tutte le informazioni
        for i = 1:nnodi
            tablename = fullfile(path,strcat('Node_',num2str(i+nodo1-1),'.xlsx'));
            data_load = readtable(tablename);
            data_load = table2array(data_load);
            [M,N] = size(data_load);
            data(1:M,1:N,i) = data_load;
        end

        % Estrazione dati

        image_confronto = image_index(x);

        Ux = zeros(nnodi,1);
        Uy = zeros(nnodi,1);
        epsY0 = zeros(nnodi,1);
        epsY1 = zeros(nnodi,1);

        for i = 1:nnodi
            Ux(i) = data(image_confronto,12,i);
            Uy(i) = data(image_confronto,13,i);
            epsY0(i) = data(image_confronto,16,i);
            epsY1(i) = data(image_confronto,18,i);
        end

        filename_spostamenti = strcat('D:\Universita\Tesi-Magistrale\Trazione_LastraSaldate\Output_valori_estratti\spostamenti_linea',num2str(linea),'_frame',num2str(image_confronto));
        filename_deformazioni = strcat('D:\Universita\Tesi-Magistrale\Trazione_LastraSaldate\Output_valori_estratti\deformazioniY_linea',num2str(linea),'_frame',num2str(image_confronto));

        save(filename_spostamenti,'Ux','Uy','nnodi')
        save(filename_deformazioni,'epsY0','epsY1','nnodi')

    end
end
