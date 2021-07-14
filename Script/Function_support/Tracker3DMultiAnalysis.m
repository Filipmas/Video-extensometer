function [x,y,z] = Tracker3DMultiAnalysis(tracker3D_point,Points,n_analysis,nframesV)

 npoints_tracker = size(tracker3D_point,1);
 Nframes = sum(nframesV,1) - (n_analysis-1);

 tracker_position = zeros(Nframes,3,npoints_tracker);
 tracker_displacements = zeros(Nframes,3,npoints_tracker);
 anonymous_position = zeros(n_analysis,3,npoints_tracker); % Supporto per multi-analisi
 distanceError = zeros(n_analysis,npoints_tracker);
 
 for pp = 1:npoints_tracker
     frame_count = 1;
     for aa = 1:n_analysis
         position = zeros(nframesV(aa),3);
         node_index = tracker3D_point(pp,2);
         
         if aa>1
             a_x = anonymous_position(aa-1,1,pp);
             a_y = anonymous_position(aa-1,2,pp);
             a_z = anonymous_position(aa-1,3,pp);
            [dist,node_index] = findNode3D(a_x,a_y,a_z,Points(aa).coordinates(:,:,1));
             distanceError(aa,pp) = dist;
         end
 
         for tt = 1:nframesV(aa)
              position(tt,:) = Points(aa).coordinates(node_index,:,tt);
         end
         
         tracker_position(frame_count:frame_count+nframesV(aa)-1,1:3,pp) = position(:,:);
         anonymous_position(aa,:,pp) = position(end,:);
         
         frame_count = frame_count + nframesV(aa) - 1;  % Update di frame_count
            
     end
     for tt = 1:Nframes
         tracker_displacements(tt,:,pp) = tracker_position(tt,:,pp) - tracker_position(1,:,pp);
     end
 end
 
 x = tracker_position;
 y = tracker_displacements;
 z = distanceError;
 
end