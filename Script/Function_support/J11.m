function x = J11(xc,yx,theta,X,Y)

l = sqrt((X-xc)^2+(Y-yc)^2);
lx1 =  - (2*X - 2*xc)/(2*sqrt((X - xc)^2 + (Y - yc)^2));
lx2 = 1/sqrt((X - xc)^2 + (Y - yc)^2) - (2*X - 2*xc)^2/(4*((X - xc)^2 + (Y - yc)^2)^(3/2));

beta = acos((X-xc)/l)*sign(Y-yc);
betax1 = (sign(Y - yc)*(1/l + ((X - xc)*lx1)/l^2))/sqrt(1 - (X - xc)^2/l^2);
betax2 =  - (sign(Y - yc)*((2*lx1)/l^2 + (2*lx1^2*(X - xc))/l^3 - ((X - xc)*lx2)/l^2))/sqrt(1 - (X - xc)^2/l^2) - (sign(Y - yc)*(1/l + ((X - xc)*lx1)/l^2)*((2*X - 2*xc)/l^2 + (2*(X - xc)^2*lx1)/l^3))/((1 - (X - xc)^2/l^2)^(3/2)*2);


x = (sin(theta + beta)*lx1 + cos(theta + beta)*l*betax1)^2*2 ...
    + (cos(theta + beta)*lx1 - sin(theta + beta)*l*betax1 + 1)^2*2 ...
    - (xc - X + cos(theta + beta)*l)*(- cos(theta + beta)*lx2 + sin(theta + beta)*l*betax2 ...
    + 2*sin(theta + beta)*lx1*betax1 + cos(theta + beta)*betax1^2*l)*2 ...
    + (yc - Y + sin(theta + beta)*l)*(sin(theta + beta)*lx2 + 2*cos(theta + beta)*lx1*betax1 ...
    - sin(theta + beta)*betax1^2*l + cos(theta + beta)*l*betax2)*2;
end