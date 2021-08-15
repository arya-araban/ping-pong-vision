%clear;clc;
v1 = VideoWriter('myFile.avi');
%v2 = VideoWriter('myFile2.avi');
rd1 = VideoReader('videos/hn1.avi');
rd2 = VideoReader('videos/hn2.avi');
v1.VideoCompressionMethod
%v2.VideoCompressionMethod
numFrames = ceil(rd1.FrameRate*rd1.Duration)-5;
open(v1)
%open(v2)

worldPoints = [0 0 0];
prevPoints = [0 0 0];
overall_worldpoints = zeros(numFrames+10,4); %stores balls location in frame seen: x,y,z, speed
FPS = 30;

FTC = 30.0; %frames to consider per second -- for every frame, put equal to FPS

frames_speed = FPS/FTC;

x1=0;y1=0;
c = 1;
while hasFrame(rd1)
    I1 = read(rd1,c);
    I2 = read(rd2,c);
    
    I1 =single(createBlueBallMask(I1));
    I2 =single(createBlueBallMask(I2));
    
    [cnt_img1] = blob(I1);
    [cnt_img2] = blob(I2);
    %[x2,y2]
    if isequal(size(cnt_img1),[1, 2]) && isequal(size(cnt_img2),[1, 2])
        I1 = insertMarker(I1,cnt_img1,'x','color',{'green'},'size',20);
        
        mp1 = (cnt_img1(1,:));
        mp2 = (cnt_img2(1,:));
       
      
        worldPoints = triangulate(mp1,mp2,stereoParams)/10; % we divide by 10 to convert mm to cm 
        if rem(c,frames_speed) == 0
            spd = norm(prevPoints-worldPoints)* FTC/100; %divide by another 100 to find MPS else it'll be CMPS
            overall_worldpoints(c,:) = [worldPoints,spd];
        %note that norm(prevPoints-worldPoints) unit is cmpf (cm per frame)
            prevPoints = worldPoints; 
        end  
        I1 = insertText(I1, [100 315 ], ['coords (cm): ' '[ X: ' num2str(worldPoints(1)) ' Y: ' num2str(-worldPoints(2)) ' Z: ' num2str(worldPoints(3)) ' ]']);
        I1 = insertText(I1, [100 350 ], ['speed: ' num2str(spd) ' Meters Per Sec']);
        
    end
    writeVideo(v1,I1);
    c = c + 1;
end
close(v1)

%remove zero rows from WP's 
overall_worldpoints = overall_worldpoints(any(overall_worldpoints,2),:)

%plot 3d x y z's of the tracked ball
xs = overall_worldpoints(:,1); ys = overall_worldpoints(:,2);
zs = overall_worldpoints(:,3); speeds = overall_worldpoints(:,4);
plot3(xs,ys,zs)
text(xs,ys,zs,num2cell(speeds))


!ffmpeg -y -i videos/hn1.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched.avi"
%!ffmpeg -y -i videos/hn2.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched2.avi"