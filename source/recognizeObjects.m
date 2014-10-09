function output_img = recognizeObjects(orig_img, labeled_img, obj_db)

num = max(labeled_img(:));
obj_num = size(obj_db, 2);
res=[];

for n = 1:num
    [j, i] = find(labeled_img == n);
    A = length(i);
    X(n) = round(sum(i)/A);
    Y(n) = round(sum(j)/A);
    i = i - X(n);
    j = j - Y(n);
    a = sum(i.^2);
    b = 2 * sum(i.*j);
    c = sum(j.^2);
    theta(n) = 0.5 * atan2(b, a - c);
    theta2 = theta(n) + 0.5 * pi;
    Emin = a * sin(theta(n))^2 - b * sin(theta(n)) * cos(theta(n)) + c * cos(theta(n))^2;
    Emax = a * sin(theta2)^2 - b * sin(theta2) * cos(theta2) + c * cos(theta2)^2;
    R = Emin / Emax;
    E = log(Emin);
    
    for nd = 1:obj_num
        Rd = obj_db(6,nd);
        Ed = obj_db(4,nd);
        if (E < 1.05 * Ed && E> 0.95 * Ed)
            if(R < 1.05 * Rd && R > 0.95 * Rd)
                res=[res, n];
            end
        end
    end
end

fh1 = figure;
imshow(orig_img, 'border','tight','initialmagnification','fit');
hold on; plot(X(res(:)), Y(res(:)), 'ro', 'MarkerFaceColor', [1 0 0]);
num=length(res);

window = 70;
s_X = X - window;
s_Y = round(Y - window * tan(theta(:))');
e_X = X + window;
e_Y = round(Y + window * tan(theta(:))');

for n = 1:num
    if abs(s_Y(n) - e_Y(n)) > 2 * window
        s_Y(n) = Y(n) - window;
        s_X(n) = round(X(n) - window * cot(theta(n))');
        e_Y(n) = Y(n) + window;
        e_X(n) = round(X(n) + window * cot(theta(n))');
    end
    line([s_X(res(n)), e_X(res(n))], [s_Y(res(n)), e_Y(res(n))], 'LineWidth',1.2, 'Color', [0, 1, 0]);
end
set(fh1, 'WindowStyle', 'normal');
img = getimage(fh1);
truesize(fh1, [size(img, 1), size(img, 2)]);
frame = getframe(fh1);
output_img = frame.cdata;