%clear;clc;
v = VideoWriter('myFile.avi');
rd1 = VideoReader('videos/output1.avi');
rd2 = VideoReader('videos/output2.avi');
v.VideoCompressionMethod
numFrames = ceil(rd1.FrameRate*rd1.Duration)-5;
open(v)
%im = createOrangeMask(imread('C:\Users\Arya\Desktop\matlab-pp\pictures\games\1\100.png'))
%imshow(single(im))
worldPoints = [0 0 0];
FPS = 30;
x1=0;y1=0;
c = 1;

a = [];
text_y = 315;
NUM_BLOBS = 2;
dist_nums = zeros(numFrames+10,1);

while hasFrame(rd1)
    I1 = read(rd1,c);
    I2 = read(rd2,c);
    
    I1 =single(createRedBlueMask3(I1));
    I2 =single(createRedBlueMask3(I2));
    
    [cnt_img1] = multipleblobs(I1,NUM_BLOBS);
    [cnt_img2] = multipleblobs(I2,NUM_BLOBS);
    
    if isequal(size(cnt_img1),[NUM_BLOBS, 2]) && isequal(size(cnt_img2),[NUM_BLOBS, 2])
        I1 = insertMarker(I1,cnt_img1,'x','color',{'green'},'size',20);
        for i=1:NUM_BLOBS
            mp1 = (cnt_img1(i,:));
            mp2 = (cnt_img2(i,:));
            worldPoints = triangulate(mp1,mp2,stereoParams)/10;
            a = [a;worldPoints];
            I1 = insertText(I1, [100 text_y], ['blob ' num2str(i, "%d") ' coords: ' '[ X: ' num2str(worldPoints(1)) ' Y: ' num2str(worldPoints(2)) ' Z: ' num2str(worldPoints(3)) ' ]']);
            text_y = text_y + 45;
        end 
        
        
        if NUM_BLOBS == 2
            dst = norm(a(1,:)-a(2,:));
            I1 = insertText(I1, [100 100], ['distance: ' num2str(dst)]);
            a = [];
            if dst>12 && dst < 30
                dist_nums(c) = dst;
            end
            
        end
         
        
    %resetting values
    text_y = 315;
        
    end
    writeVideo(v,I1);
    c = c + 1;
end
close(v)
!ffmpeg -y -i videos/output1.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched.avi"

%dist_nums = nonzeros(dist_nums)
%fprintf('std: %f\nmean: %f\n', std(dist_nums,1), mean(dist_nums))