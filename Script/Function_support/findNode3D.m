function [distance,index] = findNode3D(x,y,z,Points3D)

nnodes = size(Points3D,1);
TrackPoint = ones(nnodes,3);
TrackPoint(:,1) = TrackPoint(:,1) * x;
TrackPoint(:,2) = TrackPoint(:,2) * y;
TrackPoint(:,3) = TrackPoint(:,3) * z;

diffVector = Points3D - TrackPoint;
distanceVector = vecnorm(diffVector,2,2);
[distance,index] = min(distanceVector);

end