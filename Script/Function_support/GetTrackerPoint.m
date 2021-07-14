function x = GetTrackerPoint(reference_image,mask,coeff_pixel,units)

 % Questa function serve a scegliere quanti e quali punti della prova da tracciare.
 % L'output è una matrice nx2 in cui le righe corrispondono alle coordinate x e y dei punti da
 % tracciare mentre il numero della riga corrisponde al nodo.
 
 [image,map] = imread(reference_image);

 % Elimina le parti al di fuori della ROI, Region of Interest
 [M,N] = size(image);
 for i = 1:M
     for j = 1:N
         if mask(i,j)
         else
             image(i,j) = 255;
         end
     end
 end

 % Dimensionamento della scala
 segmento = N/4;
 segmento = round(segmento*coeff_pixel);     % Lunghezza nelle unità fisiche
 l_px = segmento/coeff_pixel;                % Lunghezza in pixel del segmento
 
 % Plotting schema e immagine di riferimento

rgb = 'black';
linewidth = 2.5;
markersize = 8;

fig = figure('WindowState','maximized');
figure(fig)
subplot(2,2,1)          % Istruzioni
    indicazioni = sprintf('Chose the tracking point(s) by referring to the diagram below.\n\nPress Enter to continue.');
    annotation('textbox',[0.175 0.6 0.25 0.25],'String',indicazioni,'Fontsize',18,'BackgroundColor','yellow','FaceAlpha',0.2,'VerticalAlignment','middle','HorizontalAlignment','center'); axis off;
    hold off
    
subplot(2,2,3)          % Schema di riferimento
    hold on
    line([-1,1],[-1,-1],'color','k')
    line([1,1],[-1,1],'color','k')
    line([1,-1],[1,1],'color','k')
    line([-1,-1],[1,-1],'color','k')
    quiver(-1.1,0,2.6,0,'Color','k')
    quiver(0,1.1,0,-2.6,'Color','k')
    scatter([-0.45, 0.45, 0, 0],[0,0,0.45,-0.45],'+','k','Linewidth',1)
    scatter(0,0,'k','filled')
    text(-0.65,-0.2,'X_1','Fontsize',12)
    text(0.5,0.15,'X_2','Fontsize',12)
    text(-0.3,0.5,'Y_1','Fontsize',12)
    text(0.1,-0.55,'Y_2','Fontsize',12)
    text(0.05,0.1,'C','Fontsize',12)
    axis off
    axis equal
    hold off

subplot(1,2,2)          % Reference image
    imshow(image)
    hold on;
    line([N/2,N/2],[0,M],'Color',rgb,'LineWIdth',linewidth,'Marker','v','MarkerSize',markersize,'MarkerFaceColor',rgb,'MarkerIndices',2)
    line([0,N],[M/2,M/2],'Color',rgb,'LineWIdth',linewidth,'Marker','>','MarkerSize',markersize,'MarkerFaceColor',rgb,'MarkerIndices',2)
    text(N*0.53,M*1.03,'Y','FontSize',16)
    text(N*1.03,M*0.53,'X','FontSize',16)
    scatter(N/2,M/2,'filled',rgb)
    line([N/10 N/10+l_px],[M M],'Color',rgb,'Linewidth',linewidth,'Marker','+','MarkerSize',markersize)
    text((N/10+l_px)/2,M*1.03,[num2str(segmento),' ',units],'Fontsize',16)
hold off

pause

prompt = 'Number of point to be tracked: ';
dlgtitle = ' ';
definput = {'1'};
dims = [1 30];
opts.Interpreter = 'tex';
opts.Resize = 'on';
n_point = inputdlg(prompt,dlgtitle,dims,definput,opts);
n_point = str2double(char(n_point));

x = zeros(n_point,2);

for i = 1:n_point
    prompt = {append(' X_',num2str(i)),append(' Y_',num2str(i))};
    dlgtitle = append('Point ',num2str(i));
    definput = {'0','0'};
    dims = [1 45];
    opts.Interpreter = 'tex';
    opts.Resize = 'on';
    coordinates = inputdlg(prompt,dlgtitle,dims,definput,opts);
    x(i,1) = str2double(char(coordinates(1)));
    x(i,2) = str2double(char(coordinates(2)));
end
    
close(fig)              % Chiudere la figura dopo aver scelto i punti

end

