function [proj_points, t, R] = ar_cube(H,render_points,K)
%% ar_cube
% Estimate your position and orientation with respect to a set of 4 points on the ground
% Inputs:
%    H - the computed homography from the corners in the image
%    render_points - size (N x 3) matrix of world points to project
%    K - size (3 x 3) calibration matrix for the camera
% Outputs: 
%    proj_points - size (N x 2) matrix of the projected points in pixel
%      coordinates
%    t - size (3 x 1) vector of the translation of the transformation
%    R - size (3 x 3) matrix of the rotation of the transformation



h1 = H(:,1);
h2 = H(:,2);
h3 = H(:,3);

Rt = [h1, h2, cross(h1, h2)];
[U, S, V] = svd(Rt);
R = U * [1, 0, 0; 0, 1, 0; 0, 0, det(U* V')] * V';
t = H(:,3)/norm(H(:,1))* sign(H(3,3));

n = size(render_points, 1);

proj_points = zeros(n,2);

for i = 1:n

    pts = K*(R * render_points(i,:)' + t); 
    proj_points(i,1) = pts(1)/pts(3);
    proj_points(i,2) = pts(2)/pts(3);
end
end
