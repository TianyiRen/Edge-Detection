function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
rho_num = length(rho_num_bins);
theta_num = length(theta_num_bins);
hough_img = zeros(rho_num, theta_num);
[i, j] = find(img > 0);
point_num = length(i);

sin_x= i * sin(theta_num_bins);
cos_y= j * cos(theta_num_bins);

M = round(sin_x + cos_y + (rho_num-1)/2 + 1);

for n = 1:theta_num
    for m = 1:point_num
        %Vote for every bin 
        hough_img(M(m, n), n) = hough_img(M(m, n), n) + 1;
    end
end
%Scale
max_hough_img = max(hough_img(:));
hough_img = hough_img / max_hough_img * 255;