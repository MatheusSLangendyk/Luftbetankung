%% plot 3D

for n=1:300
  
  l=48;w=38;h=6;
  x=out.Xe.Data(n,1);y=out.Xe.Data(n,2);z=out.Xe.Data(n,3); 
  [a,b,c]=meshgrid([0 1]);
  p=alphaShape(l*a(:)-(l-x),w*b(:)-(w-y),h*c(:)-(0-z));
  plot(p,'edgecolor','red')
  xlabel('x');ylabel('y');zlabel('z');
  grid on;
  hold on;
  l=48;w=38;h=6;
  x1=out.Xe1.Data(n,1);y1=out.Xe1.Data(n,2);z1=out.Xe1.Data(n,3);
  [a,b,c]=meshgrid([0 1]);
  p=alphaShape(l*a(:)-(l-x1),w*b(:)-(w-y1),h*c(:)-(0-z1));
  plot(p,'edgecolor','black')
  xlabel('x');ylabel('y');zlabel('z');  
  axis([-800,3400,-1,6700,-2000,-800]);
  drawnow
  frame(n) = getframe(gcf);
  pause(0.25);
  hold off
end

camlight
%hold off;
% ein Video herstellen
v = VideoWriter('trackOFplane.avi');  % Das erzeugte Video heisst 'trackOFplane.avi'.
v.FrameRate = 5;     % Die Abspielengeschwindigkeit des Videos (wie viele Bilder pro Sekunkde)
v.Quality = 90;            % Videoqualitaet laesst zwischen 0 und 100 eingestellt. Standardmassig ist 75.
open(v);
 for i = 1:1:300
     writeVideo(v,frame(i));
 end
    close(v)