function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
[m, n] = size(orig_img);
l = ceil(sqrt(m * m + n * n));
dist = -l:l;
theta = (-89:90) / 180 * pi;

[h_row, h_col] = size(hough_img);

win_x = round(h_row / 250);
win_y = round(h_col / 100);
h_m = max(hough_img(:));

line_num = 1; 
while find(hough_img > hough_threshold * h_m)
    [p, q] = find(hough_img == max(hough_img(:)));
    peak_rho(line_num) = p(1);
    peak_theta(line_num) = q(1);
    line_num = line_num + 1;
    s_i = max(1, p(1) - win_x);
    e_i = min(h_row, p(1) + win_x);
    s_j = max(1, q(1) - win_y);
    e_j = min(h_col, q(1) + win_y);
    hough_img(s_i:e_i, s_j:e_j) = 0;
end

line_num = line_num - 1;
fh1 = figure();
imshow(orig_img);

s_X=ones(1, line_num);
e_X=ones(1, line_num) * m;

for k = 1:line_num
    s_Y(k) = dist(peak_rho(k)) / cos(theta(peak_theta(k)));
    e_Y(k) = (dist(peak_rho(k)) - m*sin(theta(peak_theta(k))))/cos(theta(peak_theta(k)));
    if abs(s_Y(k)-e_Y(k))>n
        s_X(k) = dist(peak_rho(k)) / sin(theta(peak_theta(k)));
        e_X(k) = (dist(peak_rho(k)) - n*cos(theta(peak_theta(k))))/sin(theta(peak_theta(k)));
        e_Y(k) = n;
        s_Y(k) = 1;      
    end
    line([s_Y(k),e_Y(k)], [s_X(k),e_X(k)], 'LineWidth',2.3, 'Color', [0, 1, 0]);
end

set(fh1, 'WindowStyle', 'normal');
img = getimage(fh1);
truesize(fh1, [size(img, 1), size(img, 2)]);
frame = getframe(fh1); 
line_detected_img = frame.cdata;
