function [orientation,img] = construct3dOrientation2(img1,img2, stereoParams)
%this function takes in two colored images(two images of same frame),
%and we use markers on the racket to find the two points we want.
%then triangulate the corresponding points to end up with two 3d vectors. we use these two
%vectors to find the euler angles. note that we also output the bin_img1
%with marked endpoints into "img"
    img1 = createBlueMarkerMask1(img1);
 
    img2 = createBlueMarkerMask1(img2);
    img1 = uint8(img1);
    num_blobs = 2;
    a = zeros(num_blobs,3);
  
    
    [cnt_img1] = multipleblobs(img1,num_blobs);
    [cnt_img2] = multipleblobs(img2,num_blobs);
   
    if isequal(size(cnt_img1),[num_blobs, 2]) && isequal(size(cnt_img2),[num_blobs, 2])
        for i=1:num_blobs
            mp1 = (cnt_img1(i,:));
            mp2 = (cnt_img2(i,:));
            a(i,:) = triangulate(mp1,mp2,stereoParams);
        end
        img = insertMarker(img1,cnt_img1(1,:),'x','color',{'red'},'size',20);
        img = insertMarker(img,cnt_img1(2,:),'x','color',{'red'},'size',20);
    else 
        img = img1;
    end
    
    
    
    v = a(1,:)-a(2,:);
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
    
    
  
end
