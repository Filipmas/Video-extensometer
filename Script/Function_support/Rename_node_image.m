clear all

filename = 'Node';
path = 'D:\Universita\Tesi-Magistrale\Trazione_LastraSaldate\Output_nodi_convertiti\';
finalpath = 'D:\Universita\Tesi-Magistrale\Trazione_LastraSaldate\Output_nodi_rinumerati\';
n_nodes = 1505;    % Meno quelli amancanti per la forma del provino


% Da 0 a 10
for i = 1:9
    nodename = strcat(path,filename,'000',num2str(i),'.xlsx');
    data = readtable(nodename);
    n_frames = size(data.imageIndex,1);
    new_index = 1:n_frames;
    new_index = new_index';
    data.imageIndex = new_index;
    
    newfile = strcat(finalpath,filename,'_',num2str(i),'.xlsx');
    writetable(data,newfile)
end

% Da 10 a 99
for i = 10:99
    nodename = strcat(path,filename,'00',num2str(i),'.xlsx');
    data = readtable(nodename);
    n_frames = size(data.imageIndex,1);
    new_index = 1:n_frames;
    new_index = new_index';
    data.imageIndex = new_index;
    
    newfile = strcat(finalpath,filename,'_',num2str(i),'.xlsx');
    writetable(data,newfile)
end

% Da 100 alla fine

for i = 946:999
    if any(i==[631 666 700 701 735 736 770 771 805 806 840 841 875 876 910 911 945 946 980]);
        continue
    end
    nodename = strcat(path,filename,'0',num2str(i),'.xlsx');
    data = readtable(nodename);
    n_frames = size(data.imageIndex,1);
    new_index = 1:n_frames;
    new_index = new_index';
    data.imageIndex = new_index;
    
    newfile = strcat(finalpath,filename,'_',num2str(i),'.xlsx');
    writetable(data,newfile)
end
    
for i = 1000:n_nodes
    nodename = strcat(path,filename,num2str(i),'.xlsx');
    data = readtable(nodename);
    n_frames = size(data.imageIndex,1);
    new_index = 1:n_frames;
    new_index = new_index';
    data.imageIndex = new_index;
    
    newfile = strcat(finalpath,filename,'_',num2str(i),'.xlsx');
    writetable(data,newfile)
end