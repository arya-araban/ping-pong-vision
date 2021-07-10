clear;clc;
v = VideoWriter('myFile.avi');
rd = VideoReader('bl2.avi');
v.VideoCompressionMethod
open(v)
%im = createOrangeMask(imread('C:\Users\Arya\Desktop\matlab-pp\pictures\games\1\100.png'))
%imshow(single(im))
NUM_FRAMES = 48;
for c = 1:NUM_FRAMES
    I = read(rd,c);
    I =single(createBlueMask(I));
    I = blob(I);
    if c == 100
    figure
    imshow(I)
    end
    writeVideo(v,I);
end
close(v)
!ffmpeg -i OrangeSharpie.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched.avi"