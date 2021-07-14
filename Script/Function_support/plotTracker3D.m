function p = plotTracker3D(axis,points3D,smoothvalue)

 x_coord = points3D(:,1);
 y_coord = points3D(:,2);
 z_coord = points3D(:,3);
 
 color = [.0745    0.6235    1.0000];
 p = plot3(axis,x_coord,y_coord,z_coord,'+','Color',color,'MarkerSize',2,'MarkerIndices',1:smoothvalue:length(x_coord));
 grid(axis,'on');
 axis.DataAspectRatio = [1 1 1];
 axis.Box = 'on';
 axis.XLabel.String = 'X';
 axis.YLabel.String = 'Y';
 axis.ZLabel.String = 'Z';
 
end