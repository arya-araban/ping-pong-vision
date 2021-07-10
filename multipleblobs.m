function [out] = multipleblobs(bw)
%bw = single(imread('C:\Users\Arya\Desktop\matlab-pp\pictures\games\1\100.png')));
%figure
%imshow(bw);
out = zeros(size(bw));

labeledImage = bwlabel(bw);
blobMeasurements = regionprops(labeledImage, 'Centroid');
% We can get the centroids of ALL the blobs into 2 arrays,
% one for the centroid x values and one for the centroid y values.
allBlobCentroids = [blobMeasurements.Centroid];
centroidsX = fix(allBlobCentroids(1:2:end-1));
centroidsY = fix(allBlobCentroids(2:2:end));
% Put the labels on the rgb labeled image also.
%plot(fix(centroidsX(1)), fix(centroidsY(1)), 'r*', 'LineWidth', 2, 'MarkerSize', 15)

pos = zeros(0);
for c = 1:length(centroidsX)
    box_color{c} = 'blue';
    pos= [pos;centroidsX(c) centroidsY(c)];
    text_str{c} = ['X: ' num2str(pos(length(pos)),'%d') ' Y: ' num2str(pos(length(pos)-1),'%d')];
end
 out = insertText(bw,pos,text_str,'FontSize',12,'BoxColor',...
     box_color,'BoxOpacity',0.4,'TextColor','white');
 
end


