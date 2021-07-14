function x = Tracker3DPlotting(tracker3D_point,tracker_position)

nframes = size(tracker_position,1);
npoints_tracker = size(tracker3D_point,1);
frame_idx = 1:nframes;

tracker_displacement = zeros(nframes,3,npoints_tracker);
for tt = 1:nframes
    tracker_displacement(tt,:,:) = tracker_position(tt,:,:) - tracker_position(1,:,:);
end

% start_points = zeros(npoints_tracker,1);
fig = figure;
ax = gca;
for ii = 1:npoints_tracker
    hold on;
    scatter3(tracker_position(1,1,ii),tracker_position(1,2,ii),tracker_position(1,3,ii),72,'filled','DisplayName',['Point ' num2str(tracker3D_point(ii,1)) ' initial pos.'])
    p = plot3(tracker_position(:,1,ii),tracker_position(:,2,ii),tracker_position(:,3,ii),'-+','DisplayName',['Point ' num2str(tracker3D_point(ii,1)) ' positions']);
    
    p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Displacement X',tracker_displacement(:,1,ii));
    p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Displacement Y',tracker_displacement(:,2,ii));
    p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Displacement Z',tracker_displacement(:,3,ii));
    p.DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Frame',frame_idx);
    
end
title('Points'' positions and trajectories','Fontsize',16)
% axis equal
grid on;
xlabel('X','Fontsize',12)
ylabel('Y','Fontsize',12)
zlabel('Z','Fontsize',12)
legend
ax.Box = 'on';
hold off;

end