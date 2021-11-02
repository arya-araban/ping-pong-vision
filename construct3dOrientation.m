function [orientation,img] = construct3dOrientation(img1,img2, stereoParams,racket_masked_img1)
%this function takes in two colored images(two images of same frame),
%and we use markers on the racket to find the three points we want.
%then triangulate the corresponding points to end up with three 3d vectors.
%we use these three vectors to find the euler angles.
%note that we also output the bin_img1 with marked endpoints into "img"

%we only give the masked_image1 as input so we can show the markers on the
%output. 

    img1 = createBlueMarkerMask1(img1);
    img2 = createBlueMarkerMask1(img2);
    num_blobs = 3;
    a = zeros(num_blobs,3); % matrix which will contain each of the 3d points, one in each row 
  
    
    [cnt_img1] = multipleblobs(img1,num_blobs);
    [cnt_img2] = multipleblobs(img2,num_blobs);
   
    if isequal(size(cnt_img1),[num_blobs, 2]) && isequal(size(cnt_img2),[num_blobs, 2])
        for i=1:num_blobs
            mp1 = (cnt_img1(i,:));
            mp2 = (cnt_img2(i,:));
            a(i,:) = triangulate(mp1,mp2,stereoParams);
        end
        
        img = insertMarker(racket_masked_img1,cnt_img1(1,:),'x','color',{'red'},'size',20);
        img = insertMarker(img,cnt_img1(2,:),'x','color',{'red'},'size',20);
        img = insertMarker(img,cnt_img1(3,:),'x','color',{'red'},'size',20);
    else 
        img = racket_masked_img1;
    end
    
    P1 = a(1,:); 
    P2 = a(2,:);
    P3 = a(3,:);
    
    v1=P2-P1;
    v2=P3-P1;
    
    X = normalize((P1+P2)/2 -P3);
    Z = normalize(cross(v1,v2));
    Y = cross(Z,X);
    
    rotation_matrix = [X' Y' Z'];
    
    orientation=rotm2eul( rotation_matrix );
    orientation = rad2deg(orientation);

  
end


