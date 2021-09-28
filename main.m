
v1 = VideoWriter('myFile.avi');
rd1 = VideoReader('videos/r1-1.avi');
rd2 = VideoReader('videos/r1-2.avi');
v1.VideoCompressionMethod
numFrames = ceil(rd1.FrameRate*rd1.Duration)-5;
open(v1)

worldPoints = [0 0 0];
prevPoints = [0 0 0];
overall_worldpoints = zeros(numFrames+10,4); %stores balls location in frame seen: x,y,z, speed


FPS = 30.0;
FTC = FPS/2; %frames to consider per second for speed -- to get every frame, put equal to FPS
%time_frame = 0; offset = 0;%this is for gravity accaleration
frames_speed = FPS/FTC;
spd_total=0; missed_frames = 0;

angle = 0; %the angle of the blob, used mostly for if we have racket


c = 1;
while hasFrame(rd1)
    I1 = read(rd1,c);
    I2 = read(rd2,c);
    
    I1 = single(createRedRacketMask(I1));
    I2 = single(createRedRacketMask(I2));
    
    [cnt_img1, angle] = blob(I1);
    [cnt_img2, ~] = blob(I2);
    %[x2,y2]
    if isequal(size(cnt_img1),[1, 2]) && isequal(size(cnt_img2),[1, 2])
        
        
        mp1 = (cnt_img1(1,:));
        mp2 = (cnt_img2(1,:));
        
        worldPoints = triangulate(mp1,mp2,stereoParams);  
        [orn, I1]= construct3dOrientation(I1,I2,worldPoints, stereoParams);
        
        I1 = insertMarker(I1,cnt_img1,'+','color',{'green'},'size',20);
        worldPoints = worldPoints/10;% we divide by 10 to convert mm to cm
        overall_worldpoints(c,[1,2,3]) = worldPoints;
        %time_frame = time_frame + 1; 
        if rem(c,frames_speed) == 0
            %spd_total is the speed considering all axis'. 
            %velocity_seperate has the vel for each axis' (can be either
            %positive or negative, with respect to previous location)
            
            spd_total = norm(worldPoints-prevPoints)* (FTC/(missed_frames+1))/100; %divide by another 100 to find MPS else it'll be CMPS
            
            %now we look to predict trajectory by using trajectory formula x1=x0+(v*deltaT)
            %UNCOMMENT LINES TO GET PREDICTED NEXT POINT
            %{
                velocity_seperate = (worldPoints-prevPoints)/(missed_frames+1); %keep this in CM since world points in CM
                accaleration = [0, 0.5*9.81*(time_frame/FPS)^2+offset, 0];
                predicted_next_points = worldPoints + (velocity_seperate) + accaleration;
                [num2str(c) '---current_world_points:' mat2str(worldPoints) 'predicted next points:' mat2str(predicted_next_points)]
            %}
            
            %reset the valus
            missed_frames =0; 
            overall_worldpoints(c, (4)) = spd_total;
        %note that norm(prevPoints-worldPoints) unit is cmpf (cm per frame)
            prevPoints = worldPoints; 
        end  
        
        I1 = insertText(I1, [100 280 ], ['[ roll: ' num2str(angle.Orientation) ' pitch: ' num2str(orn(2)) ' yaw: ' num2str(orn(3)) ' ]']);
        I1 = insertText(I1, [100 315 ], ['coords (cm): ' '[ X: ' num2str(worldPoints(1)) ' Y: ' num2str(worldPoints(2)) ' Z: ' num2str(worldPoints(3)) ' ]']);
        
        I1 = insertText(I1, [100 350 ], ['speed: ' num2str(spd_total) ' Meters Per Sec']);

    else
        missed_frames = missed_frames + 1; 
    end 
    writeVideo(v1,I1);
    c = c + 1;
end
close(v1)

%remove zero rows from WP's, and then first row(which is nonsensical speed)

overall_worldpoints = overall_worldpoints(any(overall_worldpoints,2),:);
overall_worldpoints = overall_worldpoints((2:end),:);




%plot 3d x y z's of the tracked ball
plot3(overall_worldpoints(:,1),overall_worldpoints(:,2),overall_worldpoints(:,3))

%don't consider points where speed is zero for showing speed text
overall_worldpoints = overall_worldpoints(logical(overall_worldpoints(:,4)),:);


text(overall_worldpoints(:,1),overall_worldpoints(:,2),overall_worldpoints(:,3),num2cell(overall_worldpoints(:,4)))


!ffmpeg -y -i videos/r1-1.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched.avi"
%!ffmpeg -y -i videos/hn2.avi -i myFile.avi -filter_complex hstack -c:v ffv1 ./stiched2.avi"