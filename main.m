%clear;clc;
v = VideoWriter('myFile.avi');
rd1 = VideoReader('bl11.avi');
rd2 = VideoReader('bl22.avi');
v.VideoCompressionMethod
open(v)
%im = createOrangeMask(imread('C:\Users\Arya\Desktop\matlab-pp\pictures\games\1\100.png'))
%imshow(single(im))
NUM_FRAMES = 100;
for c = 1:NUM_FRAMES
    I1 = read(rd1,c);
    I2 = read(rd2,c);
    
    I1 =single(createBlueMask(I1));
    I2 =single(createBlueMask(I2));
    
    [I1,x1,y1] = blob(I1);
    [I2,x2,y2] = blob(I2);
    mp1 = [x1,y1];
    mp2 = [x2,y2];
    worldPoints = triangulate(mp1,mp2,stereoParams);
    I1 = insertText(I1, [100 315 ], ['X: ' num2str(worldPoints(1)) ' Y: ' num2str(worldPoints(2)) ' Z: ' num2str(worldPoints(3))]);
    writeVideo(v,I1);
end
close(v)
!ffmpeg -y -i bl11.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched.avi"