function [db, out_img] = compute2DProperties(orig_img, labeled_img)
num_objects = max(labeled_img(:)); 

for n = 1:num_objects
    [j, i] = find(labeled_img == n); 
    
    %caculate area
    A = length(i); 
    
    %calculate center
    X(n) = round(sum(i)/A);
    Y(n) = round(sum(j)/A);
    
    %change coordinatex' = x - X, y' = y - Y
    i = i - X(n);
    j = j - Y(n);
    
    %calculate a, b, c
    a = sum(i.^2);
    b = 2 * sum(i.*j);
    c = sum(j.^2);
    
    %caculate orientation
    theta(n) = 0.5 * atan2(b, a - c); 
    theta2 = theta(n) + 0.5 * pi;  
    
    %caculate moment of inertia
    Emin = a * sin(theta(n))^2 - b * sin(theta(n)) * cos(theta(n)) + c * cos(theta(n))^2; 
    Emax = a * sin(theta2)^2 - b * sin(theta2) * cos(theta2) + c * cos(theta2)^2; 
    R = Emin / Emax;
    
    db(6,n) = R;
    db(1,n) = n;
    db(2,n) = Y(n);
    db(3,n) = X(n);
    db(4,n) = log(Emin); %used log(E) here 
    db(5,n) = theta(n) / pi * 180; 
end

fh1 = figure;
imshow(orig_img, 'border','tight','initialmagnification','fit');
hold on; plot(X(:), Y(:), 'ro', 'MarkerFaceColor', [1 0 0]);

window = 60;
s_X = X - window;
s_Y = round(Y - window * tan(theta(:))');
e_X = X + window;
e_Y = round(Y + window * tan(theta(:))');

for n = 1:num_objects
    if abs(s_Y(n) - e_Y(n)) > 2 * window
        s_Y(n) = Y(n) - window;
        s_X(n) = round(X(n) - window * cot(theta(n))');
        e_Y(n) = Y(n) + window;
        e_X(n) = round(X(n) + window * cot(theta(n))');
    end
    line([s_X(n), e_X(n)], [s_Y(n), e_Y(n)], 'LineWidth',1.2, 'Color', [0, 1, 0]);
end
set(fh1, 'WindowStyle', 'normal');
img = getimage(fh1);
truesize(fh1, [size(img, 1), size(img, 2)]);
frame = getframe(fh1);
out_img = frame.cdata;