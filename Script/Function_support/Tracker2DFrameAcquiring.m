function x = Tracker2DFrameAcquiring(datastruct,tracker_point,displacements_nodes,n_points,n_steps,pixel_spacing)

    points_nodes_distance = tracker_point(:,2:3);
 
 refimage = fullfile(datastruct.reference_save.path,datastruct.reference_save.name);
 image_info = imfinfo(refimage);  % Dettagli dell'immagine
     image_width = image_info.Width;
     image_height = image_info.Height;
 % Posizione del centro dell'immagine in pixel.
 x_center_px = round(image_width/2);
 y_center_px = round(image_height/2);
 nodes_position_0 = zeros(1,2,n_points);
 nodes_position = zeros(n_steps,2,n_points);
 
 for i = 1:n_points              % Posizione iniziale dei nodi in pixel
     nodes_position_0(1,1,i) = points_nodes_distance(i,1)*(pixel_spacing + 1);
     nodes_position_0(1,2,i) = points_nodes_distance(i,2)*(pixel_spacing + 1);
     % Bypasso il dover sommare la posizione del centro della figura cambiandone gli assi in seguito
 end
 
 for j = 1:n_points               % Posizioni nel tempo dei nodi in pixel
    for i = 1:n_steps
        nodes_position(i,1,j) = nodes_position_0(1,1,j) + displacements_nodes(i,1,j);
        nodes_position(i,2,j) = nodes_position_0(1,2,j) + displacements_nodes(i,2,j);
    end
 end
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Acquisizione
 
 tracker_frames(n_steps+1) = struct('cdata',[],'colormap',[]);

 % Cambio gli assi della figura per comodità
 x_axes = (1:image_width)';          x_axes = x_axes - x_center_px;
 y_axes = (1:image_height)';         y_axes = y_axes - y_center_px;

 mess = {'\fontsize{10}\fontname{Calibri}The frames acquisition will start soon.';' ';'Please \bf do not interact \rm with the figure';'before the acquisition is completed'};
title_mess = 'Warning';
CreateStruct.Interpreter = 'tex';
CreateStruct.WindowStyle = 'normal';
message = msgbox(mess,title_mess,'warn',CreateStruct);

uiwait(message)
clear mess title_mess

fig = figure;
h = gca;
    h.Visible = 'On';
imshow(refimage,'Xdata',x_axes,'YData',y_axes);
hold on
for j = 1:n_points
    xi_px = nodes_position_0(1,1,j);
    yi_px = nodes_position_0(1,2,j);
    str = {['Point ' num2str(tracker_point(j,1)) ],'frame : 0',[ 'X = ' num2str(xi_px)],[ 'Y = ' num2str(yi_px)]};
    scatter(xi_px,yi_px,'r','filled')
    [normx,normy] = coordnormalize(h,xi_px,yi_px);
    ha = annotation('textbox','String',str,'FitBoxToText','on');
%     set(ha,'Parent',gca);
    set(ha,'Position',[(normx+0.01) normy 0.1 0.1]);
    set(ha,'String',str);
    set(ha,'BackgroundColor','white');
    set(ha,'FaceAlpha',0.8);
    set(ha,'FitBoxToText','On');
end
tracker_frames(1) = getframe(fig);
delete(findall(fig,'type','annotation'))
hold off

for i = 1:n_steps
    % figure(fig)
    current_image = fullfile(datastruct.current_save(i).path,datastruct.current_save(i).name);
    imshow(current_image,'Xdata',x_axes,'YData',y_axes)
    h = gca;
    h.Visible = 'On';
    hold on
    for j = 1:n_points
        xj_px = nodes_position(i,1,j);
        yj_px = nodes_position(i,2,j);
        str = {['Point ' num2str(tracker_point(j,1)) ],['frame : ' num2str(i)],[ 'X = ' num2str(xj_px)],[ 'Y = ' num2str(yj_px)]};
        scatter(xj_px,yj_px,'r','filled')
        [normx,normy] = coordnormalize(h,xj_px,yj_px);
        ha = annotation('textbox','String',str,'FitBoxToText','on');
        set(ha,'Position',[(normx+0.01) normy 0.1 0.1]);
        set(ha,'String',str);
        set(ha,'BackgroundColor','white');
        set(ha,'FaceAlpha',0.8);
        set(ha,'FitBoxToText','On');
    end
    drawnow
    tracker_frames(i+1) = getframe(fig);
    delete(findall(fig,'type','annotation'))
    hold off
end

if isvalid(fig)
    close(fig);
end
if isvalid(message)
    close(message);
end

x = tracker_frames;
end
