function [out,centroids] = multipleblobs(bw)
    out = bw;
    X = []; Y = [];
    labeledImage = logical(bw);
    labeledImage = bwareafilt(labeledImage, 2, 'Largest');
    blobMeasurements = regionprops(labeledImage, 'Centroid');
    % We can get the centroids of ALL the blobs into 2 arrays,
    % one for the centroid x values and one for the centroid y values.
    centroids = cat(1,blobMeasurements.Centroid);
    
    if isequal(size(centroids),[2,2])
    out = insertMarker(bw,centroids,'x','color',{'green'},'size',20);
    end
end 


