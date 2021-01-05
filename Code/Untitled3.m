clear
clc
x=2;
y=3;
z=5;
l=20;
w=32;
h=15;
[a,b,c]=meshgrid([0 1]);
p=alphaShape(l*a(:)-(l-x),w*b(:)-(w-y),h*c(:)-(0-z));
plot(p,'edgecolor','none')
xlabel('x');ylabel('y');zlabel('z')
camlight