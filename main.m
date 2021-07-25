%clear;clc;
v1 = VideoWriter('myFile.avi');
%v2 = VideoWriter('myFile2.avi');
rd1 = VideoReader('videos/hn1.avi');
rd2 = VideoReader('videos/hn2.avi');
v1.VideoCompressionMethod
v2.VideoCompressionMethod
numFrames = ceil(rd1.FrameRate*rd1.Duration)-5;
open(v1)
%open(v2)
%im = createOrangeMask(imread('C:\Users\Arya\Desktop\matlab-pp\pictures\games\1\100.png'))
%imshow(single(im))
worldPoints = [0 0 0];
FPS = 30;
x1=0;y1=0;
c = 1;
while hasFrame(rd1)
    I1 = read(rd1,c);
    I2 = read(rd2,c);
    
    I1 =single(createBlueBallMask(I1));
    I2 =single(createBlueBallMask(I2));
    
    [I1,x1,y1] = blob(I1);
    [I2,x2,y2] = blob(I2);
    %[x2,y2]
    if ~isnan(x1)
        mp1 = [x1,y1];
        mp2 = [x2,y2];
        prevPoints = worldPoints; 
        worldPoints = triangulate(mp1,mp2,stereoParams)/10; % we divide by 10 to convert mm to cm 
        spd = norm(prevPoints-worldPoints)* FPS/101; %divide by another 100 to find MPS else it'll be CMPS
        I1 = insertText(I1, [100 315 ], ['coords (cm): ' '[ X: ' num2str(worldPoints(1)) ' Y: ' num2str(-worldPoints(2)) ' Z: ' num2str(worldPoints(3)) ' ]']);
        I1 = insertText(I1, [100 350 ], ['speed: ' num2str(spd) ' Meters Per Sec']);
        
    end
    writeVideo(v1,I1);
   % writeVideo(v2,I2);
    c = c + 1;
end
close(v1)
%close(v2)

!ffmpeg -y -i videos/hn1.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched.avi"
%!ffmpeg -y -i videos/hn2.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched2.avi"