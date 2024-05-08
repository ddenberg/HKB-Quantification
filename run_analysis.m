function [boundary_length, pole_length] = run_analysis(filename, hkb_chan, output_dir)

boundary_size_threshold = 100; % The minimum length (in pixels) we expect the boundary to be.
small_area_threshold = 200; % The maximum size of holes to fill after the active contour segmentation.

I = tiffreadVolume(filename);
I = I(:,:,hkb_chan);
% boundary is a parametric curve and mask is the interior of the embryo.
[boundary, mask] = find_boundary(I, boundary_size_threshold, small_area_threshold);

% posterior pole. We assume that the anterior is on the left side of each image.
[~, pole_midpoint] = max(boundary(:,1));

boundary_width = 20; % Distance in pixels for intensity averaging
% Average pixel intensities around each boundary point with a distance and
% on the interior of the embryo.
boundary_val = boundary_intensity(I, mask, boundary, boundary_width);

% The hkb pole is isolated using the point at which the intensity increases and
% decreases along the boundary.
pole_max_width = 300; 
pole_range = find_pole_range(boundary_val, pole_midpoint, pole_max_width);

pole_border = boundary(pole_range,:);

boundary_length = sum(vecnorm(diff(boundary, 1, 1), 2, 2));
pole_length = sum(vecnorm(diff(pole_border, 1, 1), 2, 2));
% fraction_length = pole_length / boundary_length;

figure(1);
clf;
imagesc(I);
hold on;

plot(boundary(:,1), boundary(:,2), 'g', 'LineWidth', 2);
plot(pole_border(:,1), pole_border(:,2), 'r', 'LineWidth', 2);

[~, name] = fileparts(filename);
title(name, 'Interpreter', 'none');

axis equal off;
xlim([1, size(I, 2)]);
ylim([1, size(I, 1)]);

exportgraphics(gcf, fullfile(output_dir, strcat(name, '.png')));

end

