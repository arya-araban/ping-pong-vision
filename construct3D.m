function [orientation] = construct3D(imageLeft,imageRight, stereoParams)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[imageLeftRect, imageRightRect] =rectifyStereoImages(imageLeft, imageRight, stereoParams);



disparityMap = disparitySGM(imageLeftRect, imageRightRect);

props = regionprops3(imageLeftRect, 'Volume');
sortedVolumes = sort([props.Volume], 'descend');
firstBiggest = sortedVolumes(1);
binaryImage2 = bwareaopen(imageLeftRect, firstBiggest);


tbl = regionprops3(binaryImage2, 'EigenVectors', 'EigenValues');
v1 = cell2mat(tbl.EigenVectors);
v2 = cell2mat(tbl.EigenValues);

orientation = acosd( v1*v2 / (norm(v1) * norm(v2)) )

    % regionprops3(filtered_vol, 'Orientation');
end

