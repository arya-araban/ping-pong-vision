function [out, x, y] = blob(bw)
    out = bw;
    x = nan; y = nan;
    labeledImage = logical(bw);
    labeledImage = bwareafilt(labeledImage, 1, 'Largest');
    blobMeasurements = regionprops(labeledImage, 'Centroid');
    % We can get the centroids of ALL the blobs into 2 arrays,
    % one for the centroid x values and one for the centroid y values.
    centroids = cat(1,blobMeasurements.Centroid);
    
    if isequal(size(centroids),[1,2])
        x = centroids(1);
        y = centroids(2);
        out = insertMarker(bw,centroids,'x','color',{'green'},'size',20);
    end
 
end


