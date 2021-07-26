function [centroids] = multipleblobs(bw, num_blobs)
    labeledImage = logical(bw);
    labeledImage = bwareafilt(labeledImage, num_blobs, 'Largest');
    blobMeasurements = regionprops(labeledImage, 'Centroid');
    % We can get the centroids of ALL the blobs into 2 arrays,
    % one for the centroid x values and one for the centroid y values.
    centroids = cat(1,blobMeasurements.Centroid);
end 


