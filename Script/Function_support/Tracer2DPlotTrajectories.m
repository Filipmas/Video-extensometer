function x = Tracer2DPlotTrajectories(selected_point,displacements_nodes_scaled,n_steps,units)

frame_idx = 1:n_steps;

for i = 1:n_points
    figure
    start_point = scatter(0,0,72,'r','filled','MarkerFaceAlpha',1); grid on;
    hold on;
    disp_points = scatter(displacements_nodes_scaled(:,1,i),displacements_nodes_scaled(:,2,i),'b','+');
    disp_points.DataTipTemplate.DataTipRows(1).Label = 'Displacement U';
    disp_points.DataTipTemplate.DataTipRows(2).Label = 'Displacement V';
    row = dataTipTextRow('Frame',frame_idx);
    disp_points.DataTipTemplate.DataTipRows(end+1) = row;
    title(['Point ' num2str(selected_point(i,1)) ' trajectory in ' units],'Fontsize',16);
    ax = gca;
    axis equal
    ax.YDir = 'reverse';
    xlabel('Displacement U','Fontsize',14)
    ylabel('Displacement V','Fontsize',14)
    legend('starting point','displacements','Fontsize',14)
    hold off
end

end