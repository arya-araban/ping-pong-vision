%clear;clc;
v = VideoWriter('myFile.avi');
rd1 = VideoReader('videos/hn1.avi');
rd2 = VideoReader('videos/hn2.avi');
v.VideoCompressionMethod
open(v)
%im = createOrangeMask(imread('C:\Users\Arya\Desktop\matlab-pp\pictures\games\1\100.png'))
%imshow(single(im))
worldPoints = 0;
NUM_FRAMES = 50;
x1=0;y1=0;
for c = 1:NUM_FRAMES
    I1 = read(rd1,c);
    I2 = read(rd2,c);
    
    I1 =single(createBlueBallMask(I1));
    I2 =single(createBlueBallMask(I2));
    
    [I1,x1,y1] = blob(I1);
    [I2,x2,y2] = blob(I2);
    %[x2,y2]
    mp1 = [x1,y1];
    mp2 = [x2,y2];
    if x1 ~= 0
        worldPoints = triangulate(mp1,mp2,stereoParams);
        I1 = insertText(I1, [100 315 ], ['X: ' num2str(worldPoints(1)) ' Y: ' num2str(-worldPoints(2)) ' Z: ' num2str(worldPoints(3))]);
    end
    writeVideo(v,I1);
end
close(v)
!ffmpeg -y -i videos/hn1.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched.avi"