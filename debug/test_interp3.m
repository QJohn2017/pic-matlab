A = rand([3 3 3]);

i1 = 1:2;
x1 = i1;
y1 = i1;
z1 = i1;
[X1,Y1,Z1] = meshgrid(x1,y1,z1);
A1 = A(i1+1,i1+1,i1+1);

x2 = 0:2;
y2 = 0:2;
z2 = 0:2;
[X2,Y2,Z2] = meshgrid(x2,y2,z2);
A2 = A(1:3,1:3,1:3);

xq = 1.2;
yq = 1.9;
zq = 1.5;
method = 'linear';

intA1 = interp3(X1,Y1,Z1,A1,xq,yq,zq,method)
intA2 = interp3(X2,Y2,Z2,A2,xq,yq,zq,method)

%%

nPoints = 5;
E = zeros(nPoints,2);
x1 = df04.xi(1); x2 = df04.xi(end);
z1 = df04.xi(1); z2 = df04.zi(end);

x1 = [150 250];
z1 = 0; z2 = 5;

t1 = df04.xi(1); t2 = df04.twci(end);
xP = x1 + (x2-x1).*rand(nPoints,1);
zP = z1 + (z2-z1).*rand(nPoints,1);
tP = t1 + (t2-t1).*rand(nPoints,1);
%%
for iPoint = 3%nPoints  
  tic; [Ex1,Ey1,Ez1,Bx1,By1,Bz1] = df04.interp_EB(xP(iPoint),zP(iPoint),tP(iPoint),2); toc;
  tic; [Ex2,Ey2,Ez2,Bx2,By2,Bz2] = df04.interp_EB(xP(iPoint),zP(iPoint),tP(iPoint),3); toc;
  Ex(iPoint,1) = Ex1;
  Ey(iPoint,2) = Ex2;  
  Ey(iPoint,1) = Ey1;
  Ey(iPoint,2) = Ey2;  
  Ez(iPoint,1) = Ez1;
  Ez(iPoint,2) = Ez2;  
  
end
ax = findobj(gcf,'Type','Axes');
axlarge = find(max([diff(ax(1).XLim) diff(ax(2).XLim)]))
linkprop(ax,{'CLim'})
%linkprop(ax,{'CLim','XLim','YLim','ZLim'})