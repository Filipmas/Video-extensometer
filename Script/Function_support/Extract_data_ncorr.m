% Loading data
data = load('D:\Universita\Tesi-Magistrale\Trazione_LastraSaldate\Risultati_ncorr_finali.mat','data_dic_save');

set(0,'defaultfigurecolor','white')
%% Scelta del frame 

frame = 107;

% Spostamenti
U_dic = data.data_dic_save.displacements(frame).plot_u_dic;
U_ref_formatted = data.data_dic_save.displacements(frame).plot_u_ref_formatted;
U_cur_formatted = data.data_dic_save.displacements(frame).plot_u_cur_formatted;

V_dic = data.data_dic_save.displacements(frame).plot_v_dic;
V_ref_formatted = data.data_dic_save.displacements(frame).plot_v_ref_formatted;
V_cur_formatted = data.data_dic_save.displacements(frame).plot_v_cur_formatted;

roi_dic = data.data_dic_save.displacements(frame).roi_dic.mask;
roi_ref_formatted = data.data_dic_save.displacements(frame).roi_ref_formatted.mask;
roi_cur_formatted = data.data_dic_save.displacements(frame).roi_cur_formatted.mask;

% Deformazioni 
exx_ref = data.data_dic_save.strains(frame).plot_exx_ref_formatted;
exx_cur = data.data_dic_save.strains(frame).plot_exx_cur_formatted;

exy_ref = data.data_dic_save.strains(frame).plot_exy_ref_formatted;
exy_cur = data.data_dic_save.strains(frame).plot_exy_cur_formatted;

eyy_ref = data.data_dic_save.strains(frame).plot_eyy_ref_formatted;
eyy_cur = data.data_dic_save.strains(frame).plot_eyy_cur_formatted;

roi_strain_ref =  data.data_dic_save.strains(frame).roi_ref_formatted.mask;
roi_strain_cur =  data.data_dic_save.strains(frame).roi_cur_formatted.mask;

%% Eliminare le regioni fuori dalla ROI

[M,N] = size(roi_dic);
for i = 1:M
    for j = 1:N
        if (roi_dic(i,j))
        else
            U_dic(i,j) = nan;
            V_dic(i,j) = nan;
        end
    end
end

[M,N] = size(roi_ref_formatted);
for i = 1:M
    for j = 1:N
        if (roi_ref_formatted(i,j))
        else
            U_ref_formatted(i,j) = nan;
            V_ref_formatted(i,j) = nan;
        end
    end
end

[M,N] = size(roi_cur_formatted);
for i = 1:M
    for j = 1:N
        if (roi_cur_formatted(i,j))
        else
            U_cur_formatted(i,j) = nan;
            V_cur_formatted(i,j) = nan;
        end
    end
end

[M,N] = size(roi_ref_formatted);
for i = 1:M
    for j = 1:N
        if (roi_dic(i,j))
        else
            U_dic(i,j) = nan;
            V_dic(i,j) = nan;
        end
    end
end

[M,N] = size(roi_strain_ref);
for i = 1:M
    for j = 1:N
        if (roi_strain_ref(i,j))
        else
            exx_ref(i,j) = nan;
            exy_ref(i,j) = nan;
            eyy_ref(i,j) = nan;
        end
    end
end

[M,N] = size(roi_strain_cur);
for i = 1:M
    for j = 1:N
        if (roi_strain_cur(i,j))
        else
            exx_cur(i,j) = nan;
            exy_cur(i,j) = nan;
            eyy_cur(i,j) = nan;
        end
    end
end

%% Plotting

figure(1)
subplot(2,1,1)
    surf(U_dic,'EdgeColor','none')
    daspect([1 1 1])
subplot(2,1,2)
    surf(V_dic,'EdgeColor','none')
    daspect([1 1 1])
    
figure(2)
subplot(2,1,1)
    surf(exx_ref,'EdgeColor','none')
    daspect([1 1 0.1])
subplot(2,1,2)
    surf(eyy_ref,'EdgeColor','none')
    daspect([1 1 0.1])

