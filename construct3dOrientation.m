function [orientation,img] = construct3dOrientation(bin_img1,bin_img2,centroid, stereoParams)
%this function takes in two binary images, and finds the one minor axis,
%and one major axis endpoint for each image. we then triangulate the
%corresponding points to end up with two 3d vectors. we use these two
%vectors to find the euler angles. note that we also output the bin_img1
%with marked endpoints into "img"

    labeledImage = bwareafilt(logical(bin_img1), 1, 'Largest');
    blobMeasurements = regionprops(labeledImage, 'Centroid', 'MajorAxisLength','MinorAxisLength', 'Orientation');
    
    pt1_img1 = zeros(1,2);
    pt1_img1([1,2]) = [ blobMeasurements.Centroid(1)+blobMeasurements.MajorAxisLength*cosd(blobMeasurements.Orientation)/2,
        blobMeasurements.Centroid(2)+blobMeasurements.MajorAxisLength*sind(blobMeasurements.Orientation)/2];
    
    pt2_img1 = zeros(1,2);
    pt2_img1([1,2]) = [ blobMeasurements.Centroid(1)-blobMeasurements.MinorAxisLength*sind(blobMeasurements.Orientation)/2,
        blobMeasurements.Centroid(2)+blobMeasurements.MinorAxisLength*cosd(blobMeasurements.Orientation)/2];
    
    
    
    labeledImage = bwareafilt(logical(bin_img2), 1, 'Largest');
    blobMeasurements = regionprops(labeledImage, 'Centroid', 'MajorAxisLength','MinorAxisLength', 'Orientation');
    
    pt1_img2 = zeros(1,2);
    pt1_img2([1,2]) = [ blobMeasurements.Centroid(1)+blobMeasurements.MajorAxisLength*cosd(blobMeasurements.Orientation)/2,
        blobMeasurements.Centroid(2)+blobMeasurements.MajorAxisLength*sind(blobMeasurements.Orientation)/2];

    pt2_img2 = zeros(1,2);
    pt2_img2([1,2]) = [ blobMeasurements.Centroid(1)-blobMeasurements.MinorAxisLength*sind(blobMeasurements.Orientation)/2,
        blobMeasurements.Centroid(2)+blobMeasurements.MinorAxisLength*cosd(blobMeasurements.Orientation)/2];
    
    
    
    P1 = triangulate(pt1_img1, pt1_img2, stereoParams);
    P2 = triangulate(pt2_img1, pt2_img2,stereoParams);
    
    v = P1-P2;
% Let's define si and theta in such a way that.
% v = [r*cos(si)*cos(theta), r*sin(theta), r*sin(si)*cos(theta)]
    r = norm(v);
    si = atan2(v(3),v(1));
    theta = atan2(v(2),sqrt(v(1).^2+v(3).^2));
    j = [cos(si)*cos(theta), sin(theta), sin(si)*cos(theta)];
    % Correspond to j vector you can also find orthonormal vector to j
    i = [sin(si), 0, -cos(si)];
    k = [cos(si)*sin(theta), -cos(theta), sin(si)*sin(theta)];
    % Rotation matrix;
    m = [i',j',k'];
    % You can use MATLAB inbuilt function to convert rotation matrix to Euler system
    orientation = rad2deg(rotm2eul(m, "ZYX")); %this will contain roll-pitch-yaw
    img = insertShape(bin_img1, 'FilledCircle', [pt1_img1,10], ...
    'LineWidth',10, 'Color','red');
    img = insertShape(img, 'FilledCircle', [pt2_img1,10], ...
    'LineWidth',10, 'Color','red');
  
end
