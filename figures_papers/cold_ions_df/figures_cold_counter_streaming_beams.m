%% Figure 1, reconnection rate vs density and temperature
pic = no02m;

zlim = [-0.1 0.1];
xlim = diff(pic.xi([1 end]))/2 + [-130 130];
twcilim = [100 300];
pic_Bz = pic.zlim(zlim).xlim(xlim).twcilim(twcilim); 
Bz_tx = pic_Bz.Bz; 
Bz_tx = squeeze(mean(Bz_tx,2));

n_tx = pic_Bz.ni; 
n_tx = squeeze(mean(n_tx,2));

if 0% Calculate density at and above xline
  % reconnection_rate_vs_density
  pic_Bxline_z1 = interp(pic,pic.x_xline,pic.z_xline+1,pic.twci,'Bx');
  pic_nxline_z1 = interp(pic,pic.x_xline,pic.z_xline+1,pic.twci,'ne');
  pic_nxline_z0 = interp(pic,pic.x_xline,pic.z_xline+0,pic.twci,'ne');
end

nrows = 3;
ncols = 1;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols);
isub = 1;

if 1 % bz(x,t)
  hca = h(isub); isub = isub + 1;
  pcolor(hca,pic_Bz.twci,pic_Bz.xi,Bz_tx)
  shading(hca,'flat')
  hb = colorbar('peer',hca);
  hb.YLabel.String = sprintf('B_z(x,t,%.1f<z<%.1f)',pic_Bz.zi(1),pic_Bz.zi(end));
  hca.XLabel.String = 't (\omega_{ci}^{-1})';
  hca.YLabel.String = 'x (d_i)';
end
if 1 % n(x,t)
  hca = h(isub); isub = isub + 1;
  pcolor(hca,pic_Bz.twci,pic_Bz.xi,n_tx)
  shading(hca,'flat')
  hb = colorbar('peer',hca);
  hb.YLabel.String = sprintf('n(x,t,%.1f<z<%.1f)',pic_Bz.zi(1),pic_Bz.zi(end));
  hca.XLabel.String = 't (\omega_{ci}^{-1})';
  hca.YLabel.String = 'x (d_i)';
end

%% Figure 1
pic = nobg;
% Calculate density at and above xline
pic_Bxline_z05 = pic.interp(pic.x_xline,pic.z_xline+0.5,pic.twci,'Bx');
pic_nxline_z05 = pic.interp(pic.x_xline,pic.z_xline+0.5,pic.twci,'ne');
pic_Bxline_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'Bx');
pic_nxline_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'ne');
pic_nxline_z0 = pic.interp(pic.x_xline,pic.z_xline+0,pic.twci,'ne');
pic_tixline_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'ti');
pic_vA_z1 = squeeze(pic_Bxline_z1./sqrt(pic_nxline_z1));
pic_vA_z05 = squeeze(pic_Bxline_z05./sqrt(pic_nxline_z05));
%%
% Figure
zlim = [-0.5 0.5];
xlim = [100 300];
pic = pic.zlim(zlim).xlim(xlim);

%pic1 = df04.zlim(zlim).xlim(xlim);
%pic2 = df04n.zlim(zlim).xlim(xlim);
%A1 = squeeze(mean(pic1.A,2));
%A2 = squeeze(mean(pic2.A,2));
%R1 = reconnection_rate(timesteps/200,'A',A_ts,'E',E_ts(:,:,:,2));
Alev = -25:1:25;
doA = 0;
istepA = 3;

nrows = 1;
ncols = 5;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols);
isub = 1;
hb = gobjects(0);


if 1 % RE2, ni
  hca = h(isub); isub = isub + 1;  
  hRE = plot(hca,pic.RA,pic.twci);
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'E_R (B_0v_{A0})';
  hca.XLim = [0 0.4];
  
  ax1_pos = hca.Position; % position of first axes
  ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
  %ax2.YTick = [];
  ax2.XLim = [0 0.75];
  ax2.XTick = [0 0.25 0.5 0.75];
  
  %ax2.XTick = [0:0.2:2];
  
  ax2.YTick = [];
  ax2.YLim = hca.YLim;
  ax2.XLabel.String = 'n (n_0)';
  
  hl = line(squeeze(pic_nxline_z1),pic.twci,'Parent',ax2,'Color','k');
  legend([hRE hl],{'E_R','n(x_x,z_x+1)'},'location','best','box','off')
end
if 1 % RE2, Va
  hca = h(isub); isub = isub + 1;  
  hRE = plot(hca,pic.RE,pic.twci);
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'E_R (B_0v_{A0})';
  hca.XLim = [0 0.4];
  hca.XTick = 0:0.1:0.4;
  
  ax1_pos = hca.Position; % position of first axes
  ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');
  %ax2.YTick = [];
  ax2.XLim = [0 2];
  ax2.XTick = [0.5 1 1.5 2];
  
  %ax2.XTick = [0:0.2:2];
  
  ax2.YTick = [];
  ax2.YLim = hca.YLim;
  ax2.XLabel.String = 'n (n_0)';
  
  hl = line(squeeze(pic_vA_z1),pic.twci,'Parent',ax2,'Color','k');
  legend([hRE hl],{'E_R','v_A(x_x,z_x+1)'},'location','best','box','off')
end
if 0 % Ey1
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Ey,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'E_y';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = pic.A;
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
end
if 1 % Bz1
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Bz,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'B_z';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [-0.7 0.7];
  colormap(hca,pic_colors('blue_red'))
end
if 1 % nall
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.ni,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'n_{i}';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 0.6];
  colormap(hca,pic_colors('candy'))
end
if 0 % nhot
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.n(1),2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'n_{ih}';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 1.6];
  colormap(hca,pic_colors('candy'))
end
if 0 % ncold
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.n(3),2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'n_{ic}';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 0.6];
  colormap(hca,pic_colors('candy'))
end
if 1 % ti all
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.ti,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'T_{i}';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 0.6];
  colormap(hca,pic_colors('candy'))
end
if 0 % Ey2
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Ey,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'E_y';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
end
if 0 % Bz2
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Bz,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'B_z';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
end

fig = gcf; h = findobj(fig.Children,'type','axes');
hlinks = linkprop(h,{'YLim'});
h(1).YLim = pic.twci([1 end]);

for ip = 2:npanels
  h(ip).YTickLabel = [];
  h(ip).YLabel = [];
end


fig = gcf;
allh = findobj(fig.Children,'type','axes');
for ip = 1:numel(allh)
  allh(ip).Position(2) = 0.21;
  allh(ip).Position(4) = 0.5;
  allh(ip).Position(3) = 0.15;
  %h(ip).XTick = 0:50:500;
  allh(ip).YLim = [0 240];
  allh(ip).XGrid = 'on';
  allh(ip).YGrid = 'on';
  allh(ip).FontSize = 14;
  %hb(ip).FontSize = 14;
  
end

%% Vertical
% Figure
zlim = [-0.5 0.5];
xlim = [100 300];
pic = pic.zlim(zlim).xlim(xlim);

%pic1 = df04.zlim(zlim).xlim(xlim);
%pic2 = df04n.zlim(zlim).xlim(xlim);
%A1 = squeeze(mean(pic1.A,2));
%A2 = squeeze(mean(pic2.A,2));
%R1 = reconnection_rate(timesteps/200,'A',A_ts,'E',E_ts(:,:,:,2));
Alev = -25:1:25;
doA = 1;
istepA = 3;

nrows = 5;
ncols = 1;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols);
isub = 1;
hb = gobjects(0);
legs = {'a)','b)','c)','d)','e)'};


if 1 % ni, B inflow
  hca = h(isub); isub = isub + 1;  
  ax = plotyy(hca,pic.twci,pic.RA,pic.twci(3:end),squeeze(pic_nxline_z1(3:end)));
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'B (B_0)';
  %hca.XLim = [0 0.4];
    
  %ax2.XTick = [0:0.2:2];
  
  ax(2).YLabel.String = 'n (n_0)';
    
  legend(hca,{'B(x_x,z_x+1)','n(x_x,z_x+1)'},'location','best','box','off')
end
if 1 % ER vA inflow
  hca = h(isub); isub = isub + 1;  
  ax = plotyy(hca,pic.twci,pic.RA,pic.twci(2:end),squeeze(pic_vA_z1(2:end)));
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'E_R (B_0v_{A0})';
  hca.YLim = [-0.05 0.4];
  hca.YTick = 0:0.1:0.4;
    
  %ax2.XTick = [0:0.2:2];
  
  ax(2).YLabel.String = 'v_A (V_{A0})';
  ax(2).YLim = [0.5 2];
  
  legend(hca,{'E_R','v_A(x_x,z_x+1)'},'location','best','box','off')
end

if 0 % Ey1
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Ey,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'E_y';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = pic.A;
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
end
if 1 % Bz1
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Bz,2));
  pcolor(hca,pic.twci,pic.xi,varplot)
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'B_z';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.twci,pic.xi(1:istepA:end),plA(1:istepA:end,:),Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [-1.2 1.2];
  colormap(hca,pic_colors('blue_red'))
end
if 1 % nall
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.ni,2));
  pcolor(hca,pic.twci,pic.xi,varplot)
  shading(hca,'flat')
  colormap(hca,pic_colors('waterfall'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'n_{i}';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.twci,pic.xi(1:istepA:end),plA(1:istepA:end,:),Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 1.5];
  colormap(hca,pic_colors('candy'))
end
if 0 % nhot
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.n(1),2));
  pcolor(hca,pic.twci,pic.xi,varplot)
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'n_{ih}';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.twci,pic.xi(1:istepA:end),plA(1:istepA:end,:),Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 1.6];
  colormap(hca,pic_colors('candy'))
end
if 0 % ncold
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.n(3),2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'n_{ic}';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.xi(1:istepA:end),pic.twci,plA(1:istepA:end,:)',Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 0.6];
  colormap(hca,pic_colors('candy'))
end
if 1 % ti all
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.ti,2));
  pcolor(hca,pic.twci,pic.xi,varplot)
  shading(hca,'flat')
  colormap(hca,pic_colors('waterfall'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'T_{i}';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'x/d_i';
  if doA
    hold(hca,'on')
    plA = squeeze(mean(pic.A,2));
    %contour(hca,pic.xi(iAx),pic.zi(iAz),A(iAx,iAz)',Alev,'k');        
    contour(hca,pic.twci,pic.xi(1:istepA:end),plA(1:istepA:end,:),Alev,'color',[0 0 0])
    hold(hca,'off')
  end
  hca.CLim = [0 1];
  colormap(hca,pic_colors('candy'))
end
if 0 % Ey2
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Ey,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'E_y';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
end
if 0 % Bz2
  hca = h(isub); isub = isub + 1;
  varplot = squeeze(mean(pic.Bz,2));
  pcolor(hca,pic.xi,pic.twci,varplot')
  shading(hca,'flat')
  colormap(hca,pic_colors('blue_red'))
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hcb = colorbar('peer',hca);
  hcb.Location = 'northoutside';
  hb(isub-1) = hcb;
  hcb.YLabel.String = 'B_z';
  hca.YLabel.String = 't\omega_{ci}';
  hca.XLabel.String = 'x/d_i';
end

fig = gcf; h = findobj(fig.Children,'type','axes');
hlinks = linkprop(h,{'XLim'});
h(1).XLim = pic.twci([1 end]);

%for ip = 2:npanels
%  h(ip).YTickLabel = [];
%  h(ip).YLabel = [];
%end

compact_panels(0.005)
%%
fig = gcf;
allh = findobj(fig.Children,'type','axes');
for ip = 1:numel(allh)
  allh(ip).YAxis.Color = [0.1500    0.1500    0.1500];
  %allh(ip).Position(2) = 0.21;
  %allh(ip).Position(4) = 0.5;
  allh(ip).Position(3) = 0.7;
  %h(ip).XTick = 0:50:500;
  allh(ip).XLim = [100 210];
  allh(ip).XGrid = 'on';
  allh(ip).YGrid = 'on';
  allh(ip).FontSize = 14;
  %hb(ip).FontSize = 14;
  
end

%% Figure 2. State of simulation: ni Ti
zlim = [-12 12];
xlim = [140 210];
twci = [160 180 200];
ntimes = numel(twci);
Alev = -25:1:25;
doA = 1;
istepA = 3;

legFontSize = 14;

nrows = ntimes;
ncols = 3;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols);
isub = 1;

isN = [];
isT = [];
isP = [];

for itime = 1:ntimes
  col = 0;
  %itime
  pic = no02m.twcilim(twci(itime),'exact').xlim(xlim).zlim(zlim);  
  picA = no02m.twcilim(twci(itime),'exact').xlim(xlim+[-1 1]).zlim(zlim+[-1 1]);  
  if doA
    plA = picA.A;
  end
  
  if 1 % ni(x,t)
    col = col + 1;
    isN(end+1) = isub;
    hca = h(isub); isub = isub + 1;
    pcolor(hca,pic.xi,pic.zi,pic.ni')
    shading(hca,'flat')
    if itime == 1
      hb = colorbar('peer',hca);
      hb.YLabel.String = ['n_i'];
      hb.Location = 'northoutside';
    end
    irf_legend(hca,['t\omega_{ci} = ' num2str(twci(itime))],[0.99 0.98],'color',[1 1 1],'fontsize',legFontSize)
    hca.XLabel.String = 'x (d_i)';
    if col == 1
      hca.YLabel.String = 'z (d_i)';
    else
      hca.YTick = [];
    end
    colormap(hca,pic_colors('waterfall'))
    
    if doA
      clim = hca.CLim;
      hold(hca,'on')      
      contour(hca,picA.xi(1:istepA:end),picA.zi(1:istepA:end),plA(1:istepA:end,1:istepA:end,:)',Alev,'color',[0 0 0])
      hold(hca,'off')
      hca.CLim = clim;
    end
  end
  if 1 % Ti(x,t)
    col = col + 1;
    isT(end+1) = isub;
    hca = h(isub); isub = isub + 1;
    pcolor(hca,pic.xi,pic.zi,pic.ti')
    shading(hca,'flat')
    if itime == 1
      hb = colorbar('peer',hca);
      hb.YLabel.String = 'T_i';
      hb.Location = 'northoutside';
    end
    irf_legend(hca,['t\omega_{ci} = ' num2str(twci(itime))],[0.99 0.98],'color',[1 1 1],'fontsize',legFontSize)
    hca.XLabel.String = 'x (d_i)';
    if col == 1
      hca.YLabel.String = 'z (d_i)';
    else
      hca.YTick = [];
    end
    colormap(hca,pic_colors('waterfall'))
    
    if doA
      clim = hca.CLim;
      hold(hca,'on')      
      contour(hca,picA.xi(1:istepA:end),picA.zi(1:istepA:end),plA(1:istepA:end,1:istepA:end,:)',Alev,'color',[0 0 0])
      hold(hca,'off')
      hca.CLim = clim;
    end
  end
  if 1 % Pi(x,t)
    col = col + 1;
    isP(end+1) = isub;
    hca = h(isub); isub = isub + 1;
    pcolor(hca,pic.xi,pic.zi,pic.pi')
    shading(hca,'flat')
    if itime == 1
      hb = colorbar('peer',hca);
      hb.YLabel.String = 'P_i';
      hb.Location = 'northoutside';
    end
    irf_legend(hca,['t\omega_{ci} = ' num2str(twci(itime))],[0.99 0.98],'color',[1 1 1],'fontsize',legFontSize)
    hca.XLabel.String = 'x (d_i)';
    if col == 1
      hca.YLabel.String = 'z (d_i)';
    else
      hca.YTick = [];
    end
    colormap(hca,pic_colors('waterfall'))
    
    if doA
      clim = hca.CLim;
      hold(hca,'on')      
      contour(hca,picA.xi(1:istepA:end),picA.zi(1:istepA:end),plA(1:istepA:end,1:istepA:end,:)',Alev,'color',[0 0 0])
      hold(hca,'off')
      hca.CLim = clim;
    end
  end
end

hlink = linkprop(h,{'XLim','YLim'});
hlinkT = linkprop(h(isT),{'CLim'});
hlinkN = linkprop(h(isN),{'CLim'});
hlinkP = linkprop(h(isP),{'CLim'});
compact_panels(0.01,0.01)

h(1).CLim = [0 0.55];
h(2).CLim = [0 1];

for ip = 1:npanels
  h(ip).FontSize = 14;
end

%% Figure 4. State of simulation: viy Ez
zlim = [-12 12];
xlim = [140 210];
twci = [160 180 200];
twci = [40 60 80];
ntimes = numel(twci);
Alev = -25:1:25;
doA = 1;
istepA = 3;

legFontSize = 14;
legColor = [0 0 0];

nrows = ntimes;
ncols = 2;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols);
isub = 1;

isV = [];
isEz = [];


for itime = 1:ntimes
  col = 0;
  %itime
  pic = nobg.twcilim(twci(itime),'exact').xlim(xlim).zlim(zlim);  
  picA = nobg.twcilim(twci(itime),'exact').xlim(xlim+[-1 1]).zlim(zlim+[-1 1]);  
  if doA
    plA = picA.A;
  end
  
  if 1 % Ez(x,t)
    col = col + 1;
    isEz(end+1) = isub;
    hca = h(isub); isub = isub + 1;
    pcolor(hca,pic.xi,pic.zi,pic.Ez')
    shading(hca,'flat')
    if itime == 1
      hb = colorbar('peer',hca);
      hb.YLabel.String = 'E_z (B_0v_{A0})';
      hb.Location = 'northoutside';
    end
    irf_legend(hca,['t\omega_{ci} = ' num2str(twci(itime))],[0.99 0.98],'color',legColor,'fontsize',legFontSize)
    hca.XLabel.String = 'x (d_i)';
    if col == 1
      hca.YLabel.String = 'z (d_i)';
    else
      hca.YTick = [];
    end
    colormap(hca,pic_colors('blue_red'))
    
    if doA
      clim = hca.CLim;
      hold(hca,'on')      
      contour(hca,picA.xi(1:istepA:end),picA.zi(1:istepA:end),plA(1:istepA:end,1:istepA:end,:)',Alev,'color',[0 0 0])
      hold(hca,'off')
      hca.CLim = clim;
    end
  end  
  if 1 % viy(x,t)
    col = col + 1;
    isV(end+1) = isub;
    hca = h(isub); isub = isub + 1;
    pcolor(hca,pic.xi,pic.zi,pic.viy')
    shading(hca,'flat')
    if itime == 1
      hb = colorbar('peer',hca);
      hb.YLabel.String = ['v_{iy} (v_{A0})'];
      hb.Location = 'northoutside';
    end
    irf_legend(hca,['t\omega_{ci} = ' num2str(twci(itime))],[0.99 0.98],'color',legColor,'fontsize',legFontSize)
    hca.XLabel.String = 'x (d_i)';
    if col == 1
      hca.YLabel.String = 'z (d_i)';
    else
      hca.YTick = [];
    end
    colormap(hca,pic_colors('blue_red'))
    
    if doA
      clim = hca.CLim;
      hold(hca,'on')      
      contour(hca,picA.xi(1:istepA:end),picA.zi(1:istepA:end),plA(1:istepA:end,1:istepA:end,:)',Alev,'color',[0 0 0])
      hold(hca,'off')
      hca.CLim = clim;
    end
  end
end

hlink = linkprop(h,{'XLim','YLim'});
hlinkT = linkprop(h(isV),{'CLim'});
hlinkEz = linkprop(h(isEz),{'CLim'});
compact_panels(0.01,0.01)

%h(1).CLim = [0 0.55];
%h(2).CLim = [0 1];

for ip = 1:npanels
  h(ip).FontSize = 14;
end


%% Figure 3. Reduced distributions f(x,vx), f(x,vy), f(x,vz) for a few different times

%% Formation of DF due to density decrease
% compare initial conditions with df conditions at a later time
x0 = no02m.xi(end)/2;
twpe1 = 1000; twpe1 = no02m.twpelim(twpe1).twpe; twci1 = no02m.twpelim(twpe1).twci;
twpe2 = 23000; twpe2 = no02m.twpelim(twpe2).twpe; twci2 = no02m.twpelim(twpe2).twci;
colors = pic_colors('matlab');

nrows = 4;
ncols = 1;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols,'vertical');
%compact_panels(h(1:2),0)
%compact_panels(h(3:4),0)
isub = 1;

if 1 % zcut at 
  hca = h(isub); isub = isub + 1;
  pic = no02m.twpelim(twpe1).xlim(x0+[-1 1]);
  hn1 = plot(hca,pic.zi,mean(pic.n(1),1),'color',colors(2,:));
  hold(hca,'on')
  hn2 = plot(hca,pic.zi,mean(pic.n([3 5]),1),'color',colors(1,:));
  hB = plot(hca,pic.zi,mean(pic.Babs,1),'k');
  hold(hca,'off')
  hca.XLim = [-10 10];
  if 1 % Add axes for A
    %hold(hca,'on')
    ax1 = hca;
    ax1_pos = ax1.Position; % position of first axes
    ax2 = axes('Position',ax1_pos,...
      'XAxisLocation','top',...
      'YAxisLocation','right',...
      'Color','none');
    ax2all(isub-1) = ax2;
    hA = line(ax2,pic.zi,mean(pic.A,1),'color',[0 0 0],'linestyle','--');
    ax2.XLim = hca.XLim;
    ax2.XTick = [];
  end
  hca.XLabel.String = 'z (d_i)';
  ax1.YLabel.String = 'n, B';
  ax2.YLabel.String = 'A (B_0d_i)';
  %legend([hn1,hn2,hB,hA],{'n_{hot}','n_{cold}','|B|','A_y'},'location','northwest','Box','off')
  pos = hca.Position;
  legend([hn1,hn2,hB,hA],{'n_{hot}','n_{cold}','|B|','A_y'},'location','northoutside','Box','off','Orientation','horizontal')
  hca.Position = pos;
end
if 1 % xcut
  hca = h(isub); isub = isub + 1;
  pic = no02m.twpelim(twpe2).xgrid(2:no02m.nx-1).zlim(0+[-1 1]);
  hn1 = plot(hca,pic.xi,mean(pic.n(1),2),'color',colors(2,:));
  hold(hca,'on')
  hn2 = plot(hca,pic.xi,mean(pic.n([3 5]),2),'color',colors(1,:));
  hB = plot(hca,pic.xi,mean(pic.Babs,2),'k');
  hold(hca,'off')  
  hca.XLim = x0 + [-50 50];
  if 1 % Add axes for A
    %hold(hca,'on')
    ax1 = hca;
    ax1_pos = ax1.Position; % position of first axes
    ax2 = axes('Position',ax1_pos,...
      'XAxisLocation','top',...
      'YAxisLocation','right',...
      'Color','none');
    ax2all(isub-1) = ax2;
    hA = line(ax2,pic.xi,mean(pic.A,2),'color',[0 0 0],'linestyle','--');
    ax2.XLim = hca.XLim;
    ax2.XTick = [];
  end
  hca.XLabel.String = 'x (d_i)';
  ax1.YLabel.String = 'n, B';
  ax2.YLabel.String = 'A (B_0d_i)';
  %legend([hn1,hn2,hB,hA],{'n_{hot}','n_{cold}','|B|','A_y'},'location','north','Box','off')
end
if 1 % zcut at 
  hca = h(isub); isub = isub + 1;
  pic = no02m.twpelim(twpe1).xlim(x0+[-1 1]);
  A = mean(pic.A,1);
  plot(hca,A,mean(pic.n(1),1),'color',colors(2,:))
  hold(hca,'on')
  plot(hca,A,smooth(mean(pic.n([3 5]),1),5),'color',colors(1,:))
  plot(hca,A,mean(pic.Babs,1),'k')
  hold(hca,'off')
  %hca.XLim = [-10 10];  
  hca.XLim = [min(A) max(A)];
  hca.XLabel.String = 'A (B_0d_i)';
  hca.YLabel.String = 'n, B';
  %legend(hca,{'n_{hot}','n_{cold}','|B|'},'location','northwest','box','off')
end
if 1 % xcut
  hca = h(isub); isub = isub + 1;
  pic = no02m.twpelim(twpe2).xgrid(2:no02m.nx-1).zlim(0+[-1 1]);
  A = mean(pic.A,2);
  nh = mean(pic.n(1),2);
  plot(hca,A,nh,'color',colors(2,:))
  hold(hca,'on')
  plot(hca,A,mean(pic.n([3 5]),2),'color',colors(1,:))
  plot(hca,A,mean(pic.Babs,2),'k')
  hold(hca,'off')  
  %hca.XLim = x0 + [-50 50];
  hca.XLim = [min(A) max(A)];
  hca.XLabel.String = 'A (B_0d_i)';
  hca.YLabel.String = 'n, B';
  %legend(hca,{'n_{hot}','n_{cold}','|B|'},'location','northwest','box','off')
end

h(1).YLim = [0 1.7];
h(2).YLim = h(1).YLim;

ax2all(1).YLim = [4 11.3];
ax2all(1).YLim = [0 17];
ax2all(2).YLim = ax2all(1).YLim;

h(3).XLim = [4 11.3];
h(4).XLim = h(3).XLim;
h(3).YLim = [0 1.7];
h(4).YLim = h(3).YLim;


h(2).Position(4) = h(1).Position(4);
ax2all(2).Position(4) = h(2).Position(4);

h(3).Position(4) = h(1).Position(4);
h(4).Position(4) = h(1).Position(4);

h(4).Position(2) = 0.1;
h(3).Position(2) = h(4).Position(2) + h(4).Position(4);
h(2).Position(2) = h(3).Position(2) + h(3).Position(4) + 0.07;
h(1).Position(2) = h(2).Position(2) + h(2).Position(4) + 0.07;



%compact_panels(h(1:2),0)
%compact_panels(h(3:4),0)
%h(4).Position(2) = h(3).Position(2)-h(3).Position(4);
%h(3).Position(4) = h(3).Position(4);

hall = findobj(gcf,'type','axes'); hall = hall(end:-1:1);
for ip = 1:numel(hall)
  hall(ip).FontSize = 12;
  hall(ip).XGrid = 'on';
  hall(ip).YGrid = 'on';
end

ax2all(1).Position = h(1).Position;
ax2all(2).Position = h(2).Position;

irf_legend(h(1),{['inflow: t\omega_{ci} = ' sprintf('%g',twci1)]},[0.02 0.98],'fontsize',14,'color',[0 0 0],'fontweight','bold')
irf_legend(h(2),{['outflow: t\omega_{ci} = ' sprintf('%g',twci2)]},[0.02 0.98],'fontsize',14,'color',[0 0 0],'fontweight','bold')
irf_legend(h(3),{['inflow: t\omega_{ci} = ' sprintf('%g',twci1)]},[0.02 0.98],'fontsize',14,'color',[0 0 0],'fontweight','bold')
irf_legend(h(4),{['outflow: t\omega_{ci} = ' sprintf('%g',twci2)]},[0.02 0.98],'fontsize',14,'color',[0 0 0],'fontweight','bold')