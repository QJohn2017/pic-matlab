%% Load data
timestep = 08000;
txtfile = sprintf('/Users/cecilia/Data/PIC/data/fields-%05.0f.dat',timestep); % michael's perturbation
%txtfile = sprintf('/Users/cno062/Data/PIC/df_cold_protons_1/data/fields-%05.0f.dat',timestep); % michael's perturbation
%txtfile = sprintf('/Volumes/Fountain/Data/PIC/df_cold_protons_1/data/fields-%05.0f.dat',timestep); % michael's perturbation

%timestep = 055;
%txtfile = sprintf('/Users/cno062/Data/PIC/df_cold_protons_2/data/fields-%05.0f.dat',timestep); % try-out with larger perturbation


%tic; [time,r,e,b,n1,ne,ve,vi,je,ji,pe,pi,dfac,teti,nnx,nnz,wpewce,mass,it,dt,xmax,zmax,q] = read_fields_ieie(txtfile); toc
tic; [x,z,E,B,...
  ni1,ne1,ni2,ne2,...
  vi1,ve1,vi2,ve2,...
  ji1,je1,ji2,je2,...
  pi1,pe1,pi2,pe2,...
  ti1,te1,ti2,te2,...
  dfac,teti,nnx,nnz,wpewce,mass,it,time,dt,xmax,zmax,q] = read_fields(txtfile); toc

% Calculate auxillary quantities
A = vector_potential(x,z,B.x,B.z); % vector potential
[saddle_locations,saddle_values] = saddle(A);
[A_volume,A_map] = fluxtube_volume(A,-30:1:1);
%[saddle_locations,saddle_values] = fluxtube_volume(A);

% Stream functions
c_eval('Se?.xz = vector_potential(x,z,ve?.x,ve?.z);',1:2) % stream function
c_eval('Si?.xz = vector_potential(x,z,vi?.x,vi?.z);',1:2) % stream function

pB = B.abs.^2/2; % magnetic pressure
bcurv = magnetic_field_curvature(x,z,B.x,B.y,B.z); % magnetic curvature
c_eval('ve?xB = cross_product(ve?.x,ve?.y,ve?.z,B.x,B.y,B.z);',1:2) % electron motional electric field
c_eval('vi?xB = cross_product(vi?.x,vi?.y,vi?.z,B.x,B.y,B.z);',1:2) % ion motional electric field
ExB = cross_product(E.x,E.y,E.z,B.x,B.y,B.z); % Poynting flux
vExB = cross_product(E.x,E.y,E.z,B.x./B.abs./B.abs,B.y./B.abs./B.abs,B.z./B.abs./B.abs); % Poynting flux

vExB.x = ExB.x./B.abs./B.abs; vExB.x(B.abs<0.1) = 0;
vExB.y = ExB.y./B.abs./B.abs; vExB.y(B.abs<0.1) = 0;
vExB.z = ExB.z./B.abs./B.abs; vExB.z(B.abs<0.1) = 0;

c_eval('E_ve?xB.x = E.x + ve?xB.x; E_ve?xB.y = E.y + ve?xB.y; E_ve?xB.z = E.z + ve?xB.z;',1:2) % electron motional electric field
c_eval('E_vi?xB.x = E.x + vi?xB.x; E_vi?xB.y = E.y + vi?xB.y; E_vi?xB.z = E.z + vi?xB.z;',1:2) % electron motional electric field
c_eval('je?E = je?.x.*E.x + je?.y.*E.y + je?.y.*E.z;',1:2)
c_eval('ji?E = ji?.x.*E.x + ji?.y.*E.y + ji?.y.*E.z;',1:2)
c_eval('gradpe? = grad_scalar(x,z,pe?.scalar);',1:2) %
c_eval('gradpi? = grad_scalar(x,z,pi?.scalar);',1:2) %
c_eval('gradpe?_smooth = grad_scalar(x,z,smooth2(pe?.scalar,1));',1:2) %
c_eval('gradpi?_smooth = grad_scalar(x,z,smooth2(pi?.scalar,1));',1:2) %
c_eval('vte? = 2*sqrt(te?.scalar/(mass(2)/mass(1))); vte? = real(vte?);',1:2) % obs, fix temperature instead
c_eval('vti? = 2*sqrt(ti?.scalar/(mass(1)/mass(1))); vti? = real(vti?);',1:2) % obs, fix temperature instead
c_eval('wce? = B.abs/(mass(2)/mass(1));',1:2)
c_eval('wci? = B.abs/(mass(1)/mass(1));',1:2)
c_eval('re? = vte?./wce?;',1:2)
c_eval('ri? = vti?./wci?;',1:2)
UB.tot = 0.5*B.abs.^2;
UB.x = 0.5*B.x.^2;
UB.y = 0.5*B.y.^2;
UB.z = 0.5*B.z.^2;
c_eval('Uke? = mass(2)/mass(1)*0.5*ne?.*(ve?.x.^2 + ve?.y.^2 + ve?.z.^2);',1:2)
c_eval('Uki? = mass(1)/mass(1)*0.5*ni?.*(vi?.x.^2 + vi?.y.^2 + vi?.z.^2);',1:2)
c_eval('Ute? = pe?.scalar;',1:2)
c_eval('Uti? = pi?.scalar;',1:2)
Uktot = Uki1 + Uki2 + Uke1 + Uke2;
Uttot = Uti1 + Uti2 + Ute1 + Ute2;
jtot.x = ji1.x + ji2.x - je1.x - je2.x;
jtot.y = ji1.y + ji2.y - je1.y - je2.y;
jtot.z = ji1.z + ji2.z - je1.z - je2.z;
je.x = je1.x + je2.x;
je.y = je1.y + je2.y;
je.z = je1.z + je2.z;
ji.x = ji1.x + ji2.x;
ji.y = ji1.y + ji2.y;
ji.z = ji1.z + ji2.z;
c_eval('ve?.perp.x = ve?.x-ve?.par.*B.x./B.abs;',1:2)
c_eval('ve?.perp.y = ve?.y-ve?.par.*B.y./B.abs;',1:2)
c_eval('ve?.perp.z = ve?.z-ve?.par.*B.z./B.abs;',1:2)
c_eval('vi?.perp.x = vi?.x-vi?.par.*B.x./B.abs;',1:2)
c_eval('vi?.perp.y = vi?.y-vi?.par.*B.y./B.abs;',1:2)
c_eval('vi?.perp.z = vi?.z-vi?.par.*B.z./B.abs;',1:2)
c_eval('pae? = acosd(ve?.par./sqrt(ve?.x.^2+ve?.y.^2+ve?.z.^2));',1:2)
c_eval('pai? = acosd(vi?.par./sqrt(vi?.x.^2+vi?.y.^2+vi?.z.^2));',1:2)
c_eval('angle_Bve? = angle_vec(B,ve?);',1:2)
c_eval('angle_Bvi? = angle_vec(B,vi?);',1:2)
angle_vi1vi2 = angle_vec(vi1,vi2);
angle_ve1ve2 = angle_vec(ve1,ve2);
angle_jije = angle_vec(ji,je);


%% Plot, define variable in cell array
% Define what variables to plot
varstrs = {'ve1.x','ve2.x','ve1.z','ve2.z','ve1.par','ve2.par','ExB.x','ExB.z','-ve1xB.x','-ve2xB.x','-ve1xB.z','-ve2xB.z','E.x','E.z'};
varstrs = {'ve1.x','ve2.x','B.z','E.z','-ve1xB.x','A'};
varstrs = {'ve1.perp.x','ve2.perp.x','vi1.perp.x','vi2.perp.x','ExB.x'};  
varstrs = {'ve1.perp.z','ve2.perp.z','vi1.perp.z','vi2.perp.z','ExB.z'};
varstrs = {'ne1','ne2','ni1','ni2','te2.scalar','ti2.scalar','pe2.scalar','pi2.scalar'};
varstrs = {'ne1','ne2','ni1','ni2'};

varstrs = {'Ute1','Ute2','Uti1','Uti2','Uke1','Uke2','Uki1','Uki2'}; clim = 12*[-1 1];
varstrs = {'pe1.xx','pe1.xy','pe1.yy','pe1.xz','pe1.zz','pe1.yz'}; clim = 0.25*[-1 1];
varstrs = {'ne1','ne2','ni1','ni2'}; clim = 2*[-1 1];
varstrs = {'pe2.xx','pe2.xy','pe2.yy','pe2.xz','pe2.zz','pe2.yz'}; clim = 0.25*[-1 1];
varstrs = {'pi2.xx','pi2.xy','pi2.yy','pi2.xz','pi2.zz','pi2.yz'}; clim = 0.3*[-1 1];
varstrs = {'ve1.x','ve1.y','ve1.z','ExB.x','ExB.y','ExB.z','-ve1xB.x','-ve1xB.y','-ve1xB.z','-E.x','-E.y','-E.z','-ve1xB.x-E.x','-ve1xB.y-E.y','-ve1xB.z-E.z'}; clim = [-1 1];
varstrs = {'vi1.x','vi1.y','vi1.z','ExB.x','ExB.y','ExB.z','vi1xB.x','vi1xB.y','vi1xB.z','E.x','E.y','E.z','vi1xB.x+E.x','vi1xB.y+E.y','vi1xB.z+E.z'}; clim = [-1 1];
varstrs = {'pi1.xx','pi1.xy','pi1.yy','pi1.xz','pi1.zz','pi1.yz','gradpi1.x','gradpi1.y','gradpi1.z'}; clim = 0.3*[-1 1];
varstrs = {'pi1.xx','pi1.zz','gradpi1.x','gradpi1.z','gradpi1_smooth.x','gradpi1_smooth.z','gradpi1.abs','gradpi1_smooth.abs'}; clim = 0.3*[-1 1];
varstrs = {'-ne1.*ve1xB.x','-ne1.*ve1xB.y','-ne1.*ve1xB.z','-ne1.*E.x','-ne1.*E.y','-ne1.*E.z','-ne1.*(ve1xB.x+E.x)','-ne1.*(ve1xB.y+E.y)','-ne1.*(ve1xB.z+E.z)','-gradpe1_smooth.x','-gradpe1_smooth.y','-gradpe1_smooth.z'}; clim = 0.5*[-1 1];
varstrs = {'-ne2.*ve2xB.x','-ne2.*ve2xB.y','-ne2.*ve2xB.z','-ne2.*E.x','-ne2.*E.y','-ne2.*E.z',...
           '-ne2.*(ve2xB.x+E.x)','-ne2.*(ve2xB.y+E.y)','-ne2.*(ve2xB.z+E.z)',...
           '-gradpe2_smooth.x','-gradpe2_smooth.y','-gradpe2_smooth.z',...
           '-ne2.*(ve2xB.x+E.x)-gradpe2_smooth.x','-ne2.*(ve2xB.y+E.y)-gradpe2_smooth.y','-ne2.*(ve2xB.z+E.z)-gradpe2_smooth.z'...
           }; clim = 0.5*[-1 1];
varstrs = {'ve1.x','ve2.x','vi1.x','vi2.x'}; clim = 3*[-1 1];
varstrs = {'te1.scalar','te2.scalar','te2.scalar./te1.scalar','ti1.scalar','ti2.scalar','ti2.scalar./ti1.scalar'}; clim = 0.8*[-1 1];
varstrs = {'te1.scalar','te2.scalar','te1.scalar./te2.scalar','ne1','ne2'}; clim = 3*[-1 1];
varstrs = {'ve1.par','ve1.perp.x','ve1.perp.y','ve1.perp.z','ve1.par./sqrt(ve1.perp.x.^2+ve1.perp.y.^2+ve1.perp.z.^2)'}; clim = 3*[-1 1];
%varstrs = {'vi1.par','vi1.perp.x','vi1.perp.y','vi1.perp.z','vi1.par./sqrt(vi1.perp.x.^2+vi1.perp.y.^2+vi1.perp.z.^2)'}; clim = 3*[-1 1];
varstrs = {'ne1','ne2'}; clim = 3*[-1 1];
varstrs = {'(-ve1xB.y+ve2xB.y)','(-vi1xB.y+vi2xB.y)','vi1.y','vi2.y'}; clim = 0.1*[-1 1];
varstrs = {'(-vi1xB.y+vi2xB.y)','vi1.y','vi2.y'}; clim = [];0.2*[-1 1];
varstrs = {'vi2xB.y','vi2xB.y_zx','vi2xB.y_xz'}; clim = [];0.2*[-1 1];
varstrs = {'vi1xB.y','vi2xB.y','vi1xB.y_zx','vi2xB.y_zx','vi1xB.y_xz','vi2xB.y_xz'}; clim = 0.5*[-1 1];
varstrs = {'vi1xB.y','vi2xB.y','-vi1xB.y+vi2xB.y','vi1xB.y_zx','vi2xB.y_zx','-vi1xB.y_zx+vi2xB.y_zx','vi1xB.y_xz','vi2xB.y_xz','-vi1xB.y_xz+vi2xB.y_xz'}; clim = 0.2*[-1 1];
%varstrs = {'-vi1xB.y+vi2xB.y','-vi1xB.y_zx+vi2xB.y_zx','-vi1xB.y_xz+vi2xB.y_xz','vi1.x','vi1.y','vi1.z','vi2.x','vi2.y','vi2.z'}; clim = 0.2*[-1 1];
%varstrs = {'vte1','vte2','vti1','vti2'}; clim = [];0.2*[-1 1];
%varstrs = {'wce1','wce2','wci1','wci2','vte1','vte2','vti1','vti2','re1','re2','ri1','ri2'}; clim = 10*[-1 1];0.2*[-1 1];
%varstrs = {'vte1','vte2','vti1','vti2','re1','re2','ri1','ri2'}; clim = 3*[-1 1];0.2*[-1 1];
varstrs = {'pi1.scalar','gradpi1.x','gradpi1.z','vExB.x','vExB.y','vExB.z'}; clim = [];
varstrs = {'vExB.x_yz','vExB.x_zy','vExB.y_zx','vExB.y_xz','vExB.z_xy','vExB.z_yx'}; clim = [];
varstrs = {'vExB.x','vExB.y','vExB.z','vExB.x_yz','vExB.x_zy','vExB.y_zx','vExB.y_xz','vExB.z_xy','vExB.z_yx'}; clim = [-2 2];
varstrs = {'vExB.x','vExB.x_yz','vExB.x_zy','vExB.y','vExB.y_zx','vExB.y_xz','vExB.z','vExB.z_xy','vExB.z_yx'}; clim = [-2 2];

varstrs = {'vExB.x','vExB.y','vExB.z','vDi1.x','vDi1.y','vDi1.z'}; clim = [];
varstrs = {'vExB.x','vExB.y','vExB.z','vDi1.x','vDi1.y','vDi1.z','vDi2.x','vDi2.y','vDi2.z','vDe1.x','vDe1.y','vDe1.z','vDe2.x','vDe2.y','vDe2.z'}; clim = [-1.1 1.1];
varstrs = {'vi1.y','vDi1.y','vExB.y','vDi1.y+vExB.y','vi2.y','vDi2.y','vExB.y','vDi2.y+vExB.y','ve1.y','vDe1.y','vExB.y','vDe1.y+vExB.y','ve2.y','vDe2.y','vExB.y','vDe2.y+vExB.y'}; clim = [-1.1 1.1];

nvars = numel(varstrs);

%xlim = torow(x([1 end])) + [100 -100];
%zlim = [-15 15];z([1 end]);

% Initialize figure
npanels = nvars;
nrows = 4;
ncols = ceil(npanels/nrows);
npanels = nrows*ncols;
isub = 1; 
for ipanel = 1:npanels  
  h(isub) = subplot(nrows,ncols,ipanel); isub = isub + 1;  
end
linkaxes(h);

xlim = [x(1) x(end)] + 150*[1 -1];
zlim = [z(1) z(end)]; zlim = 5*[-1 1];
ipx1 = find(x>xlim(1),1,'first');
ipx2 = find(x<xlim(2),1,'last');
ipz1 = find(z>zlim(1),1,'first');
ipz2 = find(z<zlim(2),1,'last');
ipx = ipx1:2:ipx2;
ipz = ipz1:2:ipz2;
    
% Flux function
doA = 1;
cA = 0*[0.8 0.8 0.8];
nA = 20;
nA = [0:-1:min(A(:))];
ipxA = ipx1:20:ipx2;
ipzA = ipz1:20:ipz2;

%sepA = A(find(B.abs(:)==min(B.abs(:))));

% Quivers
doQ = 0;
nQx = 200;
nQz = 50;
[Z,X] = meshgrid(z,x);
ipxQ = fix(linspace(ipx1,ipx2,nQx));
ipzQ = fix(linspace(ipz1,ipz2,nQz));
[dataQx,dataQz] = meshgrid(ipxQ,ipzQ);
ipXQ = dataQx; ipZQ = dataQz;
dataQ.x = ve2.x;
dataQ.y = ve2.y;
dataQ.z = ve2.z;
maxQ = 0.3;
dataQ.abs = sqrt(dataQ.x.^2 + dataQ.z.^2);
dataQ.x(dataQ.abs>maxQ) = NaN;
dataQ.y(dataQ.abs>maxQ) = NaN;
dataQ.z(dataQ.abs>maxQ) = NaN;


% Panels
isub = 1;
tic;
for ivar = 1:nvars  
  hca = h(isub); isub = isub + 1;
  varstr = varstrs{ivar};
  variable = eval(varstr);  
  himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  %hca.Title.String = sprintf('%s, sum(%s) = %g',varstr,varstr,sum(variable(:))); 
  hca.Title.String = sprintf('%s',varstr); 
  hca.Title.Interpreter = 'none';  
  if any(abs(himag.CData(not(isnan(himag.CData(:)))))) % do if any value is non-zero
    hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  end
  hcb = colorbar('peer',hca);
  hb(isub-1) = hcb;
  %hcb.YLim = hca.CLim(2)*[-1 1];
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x(ipx),z(ipz),A(ipx,ipz)',nA,'color',cA,'linewidth',0.5); 
%     for ixline = 1:size(saddle_locations,1)
%       sepA = saddle_values(ixline);
%       hcont = contour(hca,x(ipx),z(ipz),A(ipx,ipz)',sepA*[1 1],'color',cA.^4,'linewidth',2.0);  
%     end
    hold(hca,'off')  
  end
  if doQ
    hold(hca,'on')
    hquiv = quiver(hca,X(ipxQ,ipzQ),Z(ipxQ,ipzQ),dataQ.x(ipxQ,ipzQ),dataQ.z(ipxQ,ipzQ));
    hold(hca,'off')  
  end
end


for ipanel = 1:npanels
  h(ipanel).YDir = 'normal';
  h(ipanel).XLim = xlim;
  h(ipanel).YLim = zlim;
  if not(isempty(clim)), h(ipanel).CLim = clim; end
end
toc

%% (OLD) Plot, 4 species plasma properties, 1 species per column
% Initialize figure
nrows = 5;
ncols = 4;
npanels = nrows*ncols;
isub = 1; 
for ipanel = 1:npanels  
  h(isub) = subplot(nrows,ncols,ipanel); isub = isub + 1;  
end

% Panels
doA = 0;
cA = [0.8 0.8 0.8];
nA = 20;
nA = [0:-2:min(A(:))];
ipx = 1:2:nnx;
ipz = 1:2:nnz;
isub = 1;
if 0 % A
  hca = h(isub); isub = isub + 1;
  varstr = 'A';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr; 
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  hcb.YLim = hca.CLim(2)*[-1 0];
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % babs
  hca = h(isub); isub = isub + 1;
  varstr = 'B.abs';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr; 
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  hcb.YLim = hca.CLim(2)*[0 1];
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % bx
  hca = h(isub); isub = isub + 1;
  varstr = 'B.x';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % by
  hca = h(isub); isub = isub + 1;
  varstr = 'B.y';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % bz
  hca = h(isub); isub = isub + 1;
  varstr = 'B.z';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % epar
  hca = h(isub); isub = isub + 1;
  varstr = 'E.par';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);  
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ex
  hca = h(isub); isub = isub + 1;
  varstr = 'E.x';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ey
  hca = h(isub); isub = isub + 1;
  varstr = 'E.y';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ez
  hca = h(isub); isub = isub + 1;
  varstr = 'E.z';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ne1
  hca = h(isub); isub = isub + 1;
  varstr = 'ne1';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ne2
  hca = h(isub); isub = isub + 1;
  varstr = 'ne2';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ni1
  hca = h(isub); isub = isub + 1;
  varstr = 'ni1';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ni2
  hca = h(isub); isub = isub + 1;
  varstr = 'ni2';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vepar1
  hca = h(isub); isub = isub + 1;  
  varstr = 've1.par';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;  
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);  
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vepar2
  hca = h(isub); isub = isub + 1;
  varstr = 've2.par';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);  
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vipar1
  hca = h(isub); isub = isub + 1;
  varstr = 'vi1.par';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);  
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % vipar2
  hca = h(isub); isub = isub + 1;
  varstr = 'vi2.par';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);  
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vex1
  hca = h(isub); isub = isub + 1;
  varstr = 've1.x';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vex2
  hca = h(isub); isub = isub + 1;
  varstr = 've2.x';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vix1
  hca = h(isub); isub = isub + 1;
  varstr = 'vi1.x';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vix2
  hca = h(isub); isub = isub + 1;
  varstr = 'vi2.x';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vey1
  hca = h(isub); isub = isub + 1;
  varstr = 've1.y';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vey2
  hca = h(isub); isub = isub + 1;
  varstr = 've2.y';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % viy1
  hca = h(isub); isub = isub + 1;
  varstr = 'vi1.y';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % viy2
  hca = h(isub); isub = isub + 1;
  varstr = 'vi2.y';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vez1
  hca = h(isub); isub = isub + 1;
  varstr = 've1.z';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % vez2
  hca = h(isub); isub = isub + 1;
  varstr = 've2.z';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % viz1
  hca = h(isub); isub = isub + 1;
  varstr = 'vi1.z';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % viz2
  hca = h(isub); isub = isub + 1;
  varstr = 'vi2.z';
  variable = eval(varstr);  
  himag = imagesc(hca,x,z,variable(ipx,ipz)');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = varstr;
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,xe,ze,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pxx e1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe1.xx');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e1xx}';
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pxx e2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe2.xx');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e2xx}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pxx i1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi1.xx');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{i1xx}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pxx i2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi2.xx');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{i2xx}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pyy e1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe1.yy');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e1yy}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pyy e2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe2.yy');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e2yy}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pyy i1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi2.yy');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{i1yy}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pyy i2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi1.yy');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{i2yy}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pzz e1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe1.zz');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e1zz}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pzz e2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe2.zz');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e2zz}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pzz i1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi1.zz');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{i1zz}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pzz i2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi2.zz');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{izz2}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pscalar e1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe1.scalar');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e1scalar}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pscalar e2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pe2.scalar');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{e2scalar}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pscalar i1 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi1.scalar');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{i1scalar}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % pscalar i2 
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,pi2.scalar');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'p_{i2scalar}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb.YLim = [0 hca.CLim(2)];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ve1xB_x
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ve1xB.x');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{e1}xB)_x';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ve2xB_x
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ve2xB.x');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{e2}xB)_x';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % vi1xB_x
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,vi1xB.x');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{i1}xB)_x';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % vi2xB_x
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,vi2xB.x');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{i2}xB)_x';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ve1xB_y
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ve1xB.y');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{e1}xB)_y';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ve2xB_y
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ve2xB.y');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{e2}xB)_y';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % vi1xB_y
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,vi1xB.y');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{i1}xB)_y';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % vi2xB_y
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,vi2xB.y');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{i2}xB)_y';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ve1xB_z
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ve1xB.z');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{e1}xB)_z';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ve2xB_z
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ve2xB.z');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{e2}xB)_z';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % vi1xB_z
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,vi1xB.z');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{i1}xB)_z';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % vi2xB_z
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,vi2xB.z');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = '(v_{i2}xB)_z';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % je1E
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,je1E');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'j_{e1}\cdot E';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % je2E
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,je2E');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'je2E';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ji1E
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ji1E');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'ji1E';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % ji2E
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,ji2E');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'ji1E';
  hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
    
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uek1
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uek1');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{ek1}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uek2
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uek2');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{ek2}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uik1
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uik1');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{ik1}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uik2
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uik2');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{ik2}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uet1
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uet1');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{et1}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uet1
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uet2');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{et2}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uit1
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uit1');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{it1}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 1 % Uit2
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uit2');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{it2}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % Uktot
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uktot');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{ktot}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % Uktot
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,Uttot');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{ttot}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % UB
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,UB');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{B}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end
if 0 % UB + Uk + Ut
  hca = h(isub); isub = isub + 1;
  himag = imagesc(hca,x,z,UB' + Uttot' + Uktot');
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'z (d_i)';
  hca.Title.String = 'U_{B} + U_{ttot} + U_{ktot}';

  hcb = colorbar('peer',hca);
  colormap(hca,cn.cmap('blue_red'));
  hcb.YLim(1) = 0;
  hca.CLim = hca.CLim(2)*[-1 1];
  
  if doA
    hold(hca,'on')
    hcont = contour(hca,x,z,A',nA,'color',cA,'linewidth',1.0);  
    hold(hca,'off')  
  end
end


for ipanel = 1:npanels
  h(ipanel).YDir = 'normal';
  h(ipanel).YLim = [-10 10];
end