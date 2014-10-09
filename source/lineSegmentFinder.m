function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)

[m, n] = size(orig_img);
l = ceil(sqrt(m * m + n * n));
dist = -l:l;
theta = (-89:90)/180*pi;
[h_row, h_col] = size(hough_img);
win_x = round(h_row/250);
win_y = round(h_col/100);
h_m = max(hough_img(:));
line_num = 1;
while find(hough_img > hough_threshold * h_m)
    [p, q] = find(hough_img == max(hough_img(:)));
    peak_rho(line_num) = p(1);
    peak_theta(line_num) = q(1);
    line_num = line_num + 1;
    s_i = max(1, p(1)-win_x);
    e_i = min(h_row, p(1)+win_x);
    s_j = max(1, q(1)-win_y);
    e_j = min(h_col, q(1)+win_y);
    hough_img(s_i:e_i, s_j:e_j) = 0;
end

line_num = line_num - 1;
fh1 = figure();
imshow(orig_img);
hold on;
edge_img = edge(orig_img, 'canny', 0.05);

theta = (-89:90) / 180 * pi;
[i, j] = find(edge_img > 0);
sin_x= i * sin(theta);
cos_y= j * cos(theta);
M = round(sin_x + cos_y + l + 1);

for k=1:line_num
    index1 = find(M(:, peak_theta(k)) <= 1.002 * peak_rho(k));
    index2 = find(M(index1(:), peak_theta(k)) >= 0.998 * peak_rho(k));
    v_x = i(index1(index2(:)));
    v_y = j(index1(index2(:)));
    [xmax, idx1] = max(v_x);
    [xmin, idx2] = min(v_x);
    [ymax, idy1] = max(v_y);
    [ymin, idy2] = min(v_y);
    if abs(v_x(idx1) - v_x(idx2)) > 5
        start_x(k) = xmin;
        end_x(k) = xmax;
        id = find(v_x == xmin);
        start_y(k) = mean(v_y(id));
        id = find(v_x == xmax);
        end_y(k) = mean(v_y(id));
    else     
        start_y(k) = ymin;
        end_y(k) = ymax;
        id = find(v_y == ymin);
        start_x(k) = mean(v_x(id));
        id = find(v_y == ymax);
        end_x(k) = mean(v_x(id));
    end
end
plot([start_y, end_y], [start_x, end_x], 'rs', 'MarkerFaceColor', [1 0 0]);
for k = 1:line_num
   line([start_y(k), end_y(k)], [start_x(k), end_x(k)], 'LineWidth',2, 'Color', [0, 1, 0]);
end

set(fh1, 'WindowStyle', 'normal');
img = getimage(fh1);
truesize(fh1, [size(img, 1), size(img, 2)]);
frame = getframe(fh1);
pause(0.5); 
cropped_line_img = frame.cdata;

fh2 = figure();
imshow(orig_img);

hold on, plot([start_y, end_y], [start_x, end_x], 'rs', 'MarkerFaceColor', [1 0 0]);
for k = 1:line_num
   line([start_y(k), end_y(k)], [start_x(k), end_x(k)], 'LineWidth',2, 'Color', [0, 1, 0]);
end

set(fh2, 'WindowStyle', 'normal');
img = getimage(fh2);
truesize(fh2, [size(img, 1), size(img, 2)]);
frame = getframe(fh2);
pause(0.5); 

