
% Input directory of tif files to analyze
input_dir = './2024hkb/20A/to_analyze';
filestruct = dir(fullfile(input_dir, '*.tif'));

% Directory for where to write the output table
output_table_dir = './2024hkb/20A';
if ~exist(output_table_dir, 'dir')
    mkdir(output_table_dir);
end

% Directory for where to write the output images
output_images_dir = './2024hkb/20A/output';
if ~exist(output_images_dir, 'dir')
    mkdir(output_images_dir);
end

% variables to save the boundary length and pole length
boundary_length = zeros(length(filestruct), 1);
pole_length = zeros(length(filestruct), 1);

figure(1);
fprintf('Resize the figure and press any key to continue...\n');
pause; % pause here to allow the user to resize the figure

% Which channel the hkb signal is on
hkb_chan = 1;
for ii = 1:length(filestruct)
    [b_, p_] = run_analysis(fullfile(filestruct(ii).folder, filestruct(ii).name), hkb_chan, output_images_dir);

    boundary_length(ii) = b_;
    pole_length(ii) = p_;
end
fraction_length = pole_length ./ boundary_length;

names = {filestruct.name};
names = names(:);
tbl = table(names, fraction_length, boundary_length, pole_length, ...
    'VariableNames', {'Name', 'fraction_length', 'boundary_length', 'pole_length'});
writetable(tbl, fullfile(output_table_dir, 'table.csv'));
