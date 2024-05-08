function boundary_val = boundary_intensity(I, mask, boundary, boundary_width)


% list_inpoly = inpolygon(x_list, y_list, boundary(:,1), boundary(:,2));
[y_list, x_list] = find(mask);


boundary_val = zeros(size(boundary, 1), 1);
for ii = 1:size(boundary, 1)
    x = boundary(ii,1);
    y = boundary(ii,2);
    ind = find((x_list - x).^2 + (y_list  - y).^2 < boundary_width^2);
    x_ = x_list(ind);
    y_ = y_list(ind);

    I_ind = sub2ind(size(I), y_, x_);

    boundary_val(ii) = mean(I(I_ind));

%     cla;
%     imagesc(I);
%     hold on;
%     scatter(x_,y_, 'filled');
%     drawnow;

end

end

