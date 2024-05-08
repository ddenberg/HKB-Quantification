function [boundary, BW] = find_boundary(I, boundary_size_threshold, small_area_threshold)

BW = imbinarize(I); % Otsu thresholding
BW = imfill(BW, 'holes');

% active contour
BW_dilate = imdilate(BW, strel('disk', 10)); % initially grow the mask
BW_ac = activecontour(I, BW_dilate);

BW_ac = bwareaopen(BW_ac, small_area_threshold); % fill small holes

boundaries = bwboundaries(BW_ac); % get boundary curve

boundary_size = cellfun('length', boundaries);
% get rid of potential wrong boundaries.
% THIS IS UNECESSARY AND CAN BE REMOVED GIVEN THE NEXT STEP (keeping just in case it breaks something)
boundaries = boundaries(boundary_size > boundary_size_threshold);

boundary_size = cellfun('length', boundaries);
[~, ind] = max(boundary_size); % take the boundary with the maximum length
boundary = boundaries{ind};

% flip direction
boundary = fliplr(boundary);

% smooth boundary
window_size = 61;
boundary_rep = [boundary(end-window_size+1:end,:); boundary; boundary(1:window_size,:)];
boundary_rep_smooth = sgolayfilt(boundary_rep, 2, window_size);

boundary = boundary_rep_smooth(window_size+1:end-window_size,:);

end

