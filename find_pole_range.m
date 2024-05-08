function pole_ind = find_pole_range(boundary_val, midpoint, pole_max_width)

pole_ind1 = max(midpoint-pole_max_width, 1):midpoint;
pole_ind2 = midpoint:min(midpoint+pole_max_width, length(boundary_val));

pole_val1 = boundary_val(pole_ind1);
pole_val2 = boundary_val(pole_ind2);

[~, rt_lt, ~] = risetime(pole_val1, 'PercentReferenceLevels', [45, 55], 'Tolerance', 5);
[~, ft_lt, ~] = falltime(pole_val2, 'PercentReferenceLevels', [45, 55], 'Tolerance', 5);

if isempty(rt_lt)
    rt_lt = length(pole_val1) / 2;
end

if isempty(ft_lt)
    ft_lt = length(pole_val2) / 2;
end

pole_ind = pole_ind1(round(rt_lt(1))):pole_ind2(round(ft_lt(1)));

end