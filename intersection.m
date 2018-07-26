function [ res ] = intersection( zone1, zone2)
res = 0;

x1 = double(zone1(1));
y1 = double(zone1(2));
l1 = double(zone1(3));
h1 = double(zone1(4));

x2 = double(zone2(1));
y2 = double(zone2(2));
l2 = double(zone2(3));
h2 = double(zone2(4));

l_x1 = x1:x1+l1-1;
l_x2 = x2:x2+l2-1;
inter_x = double(intersect(l_x1,l_x2));

l_y1 = y1:y1+h1-1;
l_y2 = y2:y2+h2-1;
inter_y = double(intersect(l_y1,l_y2));
if size(inter_x,2)>1 && size(inter_y,2)>1,
    inter = double(size(inter_x,2)*size(inter_y,2));
    res = double(inter/l1*h1);
end
end

