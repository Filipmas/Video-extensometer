clear all

set(0,'defaultfigurecolor','white')
%% Loading data

filename = uigetfile('D:\Universita\Tesi-Magistrale','Selezionare il file degli output');
data = load(filename);

% Nel file caricato "reference_save" si riferisce alla reference image mentre "current_save"
% contiene file e path delle current image. Entrambi contengono informazioni sulla ROI.

set(0,'defaultfigurecolor','white')

%% Loading immagini

refimage_name = fullfile(data.reference_save.path,data.reference_save.name);
[image,map] = imread(refimage_name);
logical_mask = data.reference_save.roi.mask;

[M,N] = size(image);
for i = 1:M
    for j = 1:N
        if logical_mask(i,j)
        else
            image(i,j) = 255;
        end
    end
end

coeff_pixel = data.data_dic_save.dispinfo.pixtounits;
units = data.data_dic_save.dispinfo.units;                  % Unità di misura
prop = N/4;
prop = round(prop*coeff_pixel);
l_px = prop/coeff_pixel;

% Schema estensimetro
schema_path = 'D:\Universita\Tesi-Magistrale';
schema_name = 'Schema_estensimetro.png';
[schema,map] = imread(fullfile(schema_path,schema_name));
%% Plotting

rgb = 'black';
linewidth = 2.5;
markersize = 8;

figure
    subplot(2,2,3)
    hold on
    line([-1,1],[-1,-1],'color','k')
    line([1,1],[-1,1],'color','k')
    line([1,-1],[1,1],'color','k')
    line([-1,-1],[1,-1],'color','k')
    quiver(-1.1,0,2.6,0,'Color','k')
    quiver(0,1.1,0,-2.6,'Color','k')
    scatter([-0.3, 0.3, 0, 0],[0,0,0.4,-0.4],'+','k','Linewidth',1)
    text(-0.5,-0.2,'X_1','Fontsize',12)
    text(0.3,0.2,'X_2','Fontsize',12)
    text(-0.3,0.4,'Y_1','Fontsize',12)
    text(0.1,-0.5,'Y_2','Fontsize',12)
    axis off
    axis equal
    hold off
subplot(2,2,1)
    indicazioni = sprintf('Chose the reference point by referring to the diagram below.\n\nPress Enter to continue.');
    annotation('textbox',[0.175 0.6 0.25 0.25],'String',indicazioni,'Fontsize',18,'BackgroundColor','yellow','FaceAlpha',0.2,'VerticalAlignment','middle','HorizontalAlignment','center'); axis off;
    % text(0.1,0.5,indicazioni,'Fontsize',16,'VerticalAlignment','middle'); axis off
    hold off
subplot(1,2,2)
    imshow(image)
    hold on;
    line([N/2,N/2],[0,M],'Color',rgb,'LineWIdth',linewidth,'Marker','v','MarkerSize',markersize,'MarkerFaceColor',rgb,'MarkerIndices',2)
    line([0,N],[M/2,M/2],'Color',rgb,'LineWIdth',linewidth,'Marker','>','MarkerSize',markersize,'MarkerFaceColor',rgb,'MarkerIndices',2)
    text(N*0.53,M*1.03,'Y','FontSize',16)
    text(N*1.03,M*0.53,'X','FontSize',16)
    scatter(N/2,M/2,'filled',rgb)
    % scatter([N*0.6 N*0.4 N/2 N/2],[M/2 M/2 M*0.6 M*0.4],color,'Marker','+','LineWidth',markersize)
    % text(N*0.63,M*0.52,'X_2','Fontsize',16,'Color',color)
    line([N/10 N/10+l_px],[M M],'Color',rgb,'Linewidth',linewidth,'Marker','+','MarkerSize',markersize)
    text((N/10+l_px)/2,M*1.03,[num2str(prop),' ',units],'Fontsize',16)

hold off

%% Dialog bow

prompt = {'  X_1:','  X_2:','  Y_1:','  Y_2:'};
dlgtitle = 'Chose the reference points'; 
definput = {'0','0','0','0'};
dims = [1 60];
opts.Interpreter = 'tex';
opts.Resize = 'on';
coordinates = inputdlg(prompt,dlgtitle,dims,definput,opts);

x1 = str2double(char(answer(1)));
x2 = str2double(char(answer(2)));
y1 = str2double(char(answer(3)));
y2 = str2double(char(answer(4)));
