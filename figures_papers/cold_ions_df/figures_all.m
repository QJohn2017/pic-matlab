%% Figure 1, change of inflow parameters, compression of current sheet
%% Figure 1, prepare data
pic = no02m;

x0 = no02m.xi(end)/2;
twpe1 = 1000; twpe1 = no02m.twpelim(twpe1).twpe; twci1 = no02m.twpelim(twpe1).twci;
twpe2 = 24000; twpe2 = no02m.twpelim(twpe2).twpe; twci2 = no02m.twpelim(twpe2).twci;

%pic_Bxline_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'Babs');
pic_Bxline_z1_ = pic.get_points(pic.x_xline,pic.z_xline+1,pic.twci,[-0.1 0.1],'Babs');
%pic_nxline_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'ni');
pic_nxline_z1_ = pic.get_points(pic.x_xline,pic.z_xline+1,pic.twci,[-0.1 0.1],'ni');
%pic_nhot_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'n(1)');
pic_nhot_z1_ = pic.get_points(pic.x_xline,pic.z_xline+1,pic.twci,[-0.1 0.1],'n(1)');
%pic_ncold_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'n(3)');
pic_ncold_z1_ = pic.get_points(pic.x_xline,pic.z_xline+1,pic.twci,[-0.1 0.1],'n(3)');
%pic_tixline_z1 = pic.interp(pic.x_xline,pic.z_xline+1,pic.twci,'ti');
%pic_vA_z1 = squeeze(pic_Bxline_z1./sqrt(pic_nxline_z1));
pic_vA_z1_ = squeeze(pic_Bxline_z1_./sqrt(pic_nxline_z1_));



zlim = [-0.5 0.5];
xlim = x0 + 40*[-1 1];
pic = no02m.zlim(zlim).xlim(xlim);
pic_Bz_tx = squeeze(mean(pic.Bz,2));
pic_A_tx = squeeze(mean(pic.A,2));
%% Figure 1, plot
colors = pic_colors('matlab');
Alev = -25:1:25;
doA = 0;
istepA = 3;

nrows = 5;
ncols = 1;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols);
isub = 1;
hb = gobjects(0);


if 1 % zcut at early times
  hca = h(isub); isub = isub + 1;
  pic = no02m.twpelim(twpe1).xlim(x0+[-1 1]);
  hn1 = plot(hca,pic.zi,mean(pic.n(1),1),'color',colors(2,:));
  hold(hca,'on')
  hn2 = plot(hca,pic.zi,smooth(mean(pic.n([3 5]),1),5),'color',colors(1,:));
  hB = plot(hca,pic.zi,mean(pic.Babs,1),'k');
  hold(hca,'off')
  hca.XLim = [-10 10];
  if 0 % Add axes for A
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
    ax2.YLabel.String = 'A (B_0d_i)';
  end
  hca.XLabel.String = 'z (d_i)';
  hca.YLabel.String = 'n, B';  
  %legend([hn1,hn2,hB,hA],{'n_{hot}','n_{cold}','|B|','A_y'},'location','northwest','Box','off')
  %pos = hca.Position;
  legend([hn1,hn2,hB],{'n_{hot}','n_{cold}','|B|'},'location','east','Box','off')
  %legend([hn1,hn2,hB],{'n_{hot}','n_{cold}','|B|'},'location','northoutside','Box','off','Orientation','horizontal')
  %hca.Position = pos;
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  irf_legend(hca,{['inflow at t\omega_{ci}= ' num2str(twci1)]},[0.02 0.9],'fontsize',14,'color',[0 0 0])
end

if 0 % zcut at, vs A 
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
if 0 % xcut vs A
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
if 0 % ni, Bx, vA, RE
  hca = h(isub); isub = isub + 1;  
  h_ = plot(hca,pic.twci,pic_nxline_z1,pic.twci,pic_Bxline_z1,pic.twci,pic_vA_z1,pic.twci,pic.RE);
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'n, B_x';
  %hca.XLim = [0 0.4];
  legend(hca,{'n(x_x,z_x+1)','B_x(x_x,z_x+1)'},'location','southwest','box','off')
end
if 0 % ni, Bx, vA
  hca = h(isub); isub = isub + 1;  
  [AX,H1,H2] = plotyy(hca,pic.twci,[pic_nxline_z1,pic_Bxline_z1]',pic.twci,smooth(pic_vA_z1,1));  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'n, B_x';
  AX(2).YLabel.String = 'v_A';
  AX(2).YColor = [0 0 0];
  H2.LineStyle = '-.';
  H2.Color = [0 0 0];
  %hca.XLim = [0 0.4];
  legend(hca,{'n(x_X,z_X+1)','B_x(x_X,z_X+1)','v_A(x_X,z_X+1)'},'location','northeast','box','off')
end
if 0 % ni, tot/hot/cold, Bx
  hca = h(isub); isub = isub + 1;  
  H1 = plot(hca,pic.twci,[pic_nxline_z1,pic_nhot_z1,pic_ncold_z1,pic_Bxline_z1]');  
  H1(1).Color = colors(4,:);
  H1(2).Color = colors(2,:);
  H1(3).Color = colors(1,:);
  H1(4).Color = colors(5,:);
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'n, |B|';
  AX(2).YLabel.String = 'v_A';
  AX(2).YColor = [0 0 0];
  H2.LineStyle = '-.';
  H2.Color = [0 0 0];
  %hca.XLim = [0 0.4];
  legend(hca,{'n(x_X,z_X+1)','n_{hot}(x_X,z_X+1)','n_{cold}(x_X,z_X+1)','B_x(x_X,z_X+1)'},'location','northeast','box','off')
end
pic = no02m.zlim(zlim).xlim(xlim);
if 1 % ni, tot/hot/cold, Bx, vA
  hca = h(isub); isub = isub + 1; 
  
  [AX,H1,H2] = plotyy(hca,pic.twci,[pic_nxline_z1_,pic_nhot_z1_,pic_ncold_z1_,pic_Bxline_z1_]',pic.twci,smooth(pic_vA_z1_,1));  
  [AX,H1,H2] = plotyy(hca,pic.twci,[pic_nxline_z1,pic_nhot_z1,pic_ncold_z1,pic_Bxline_z1]',pic.twci,smooth(pic_vA_z1_,1));  
  H1(1).Color = colors(4,:);
  H1(2).Color = colors(2,:);
  H1(3).Color = colors(1,:);
  H1(4).Color = [0 0 0];
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'n, |B|';
  AX(2).YLabel.String = 'v_A';
  AX(2).YColor = [0 0 0];
  H2.LineStyle = '-.';
  H2.Color = colors(5,:);
  AX(1).YLim = [0 0.75];
  AX(1).YTick = [0 0.25 0.5 0.75];
  AX(2).YLim = [0 1.5];
  AX(2).YTick = [0 0.25 0.5 0.75]*2;
  AX(1).XLim = [5 125];
  AX(2).XLim = [5 125];
  %hca.XLim = [0 0.4];
  %legend(hca,{'n(x_X,z_X+1)','B_x(x_X,z_X+1)','v_A(x_X,z_X+1)'},'location','northeast','box','off')
  %hleg = legend(hca,{'n(x_X,z_X+1)','n_{hot}(x_X,z_X+1)','n_{cold}(x_X,z_X+1)','B_x(x_X,z_X+1)','v_A(x_X,z_X+1)'},'location','northwest','box','off','orientation','horizontal');
  %hleg = legend(hca,{'n','n_{hot}','n_{cold}','|B|','v_A'},'location','northwest','box','off','orientation','horizontal');
  hleg = legend([H1(1) H2],{'n','v_A'},'location','southwest','box','off');
  irf_legend(hca,{'inflow values 1d_i above X line'},[0.02 0.98],'fontsize',14,'color',[0 0 0])
end
if 0 % ni, Bx
  hca = h(isub); isub = isub + 1;  
  h_ = plot(hca,pic.twci,pic_nxline_z1,pic.twci,pic_Bxline_z1);
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'n, B_x';
  %hca.XLim = [0 0.4];
  legend(hca,{'n(x_x,z_x+1)','B_x(x_x,z_x+1)'},'location','southwest','box','off')
end
if 0 % vA
  hca = h(isub); isub = isub + 1;  
  h_ = plot(hca,pic.twci,pic_vA_z1);
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'v_x';
  %hca.XLim = [0 0.4];
  legend(hca,{'v_A(x_x,z_x+1)'},'location','southwest','box','off')
end
if 1 % RE
  hca = h(isub); isub = isub + 1;  
  h_ = plot(hca,pic.twci,pic.RE);
  h_.Color = colors(3,:);
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'E_R';
  %hca.XLim = [0 0.4];
  %legend(hca,{'v_A(x_x,z_x+1)'},'location','southwest','box','off')
  hca.XLim = [5 125];
  hca.YLim = [0 0.17];
end
if 1 % Bz(x,t)
  hca = h(isub); isub = isub + 1;  
  pic = no02m.zlim(zlim).xlim(xlim);
  h_ = pcolor(hca,pic.twci,pic.xi,pic_Bz_tx);
  shading(hca,'flat')
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.XLabel.String = 't\omega_{ci}';
  hca.YLabel.String = 'x (d_i)';
  colormap(hca,pic_colors('blue_red'))
  clim = hca.CLim;
  pos = hca.Position;
  hcb = colorbar('peer',hca);
  hcb.Title.String = 'B_z';
  if 1 % A
    hold(hca,'on')
    contour(hca,pic.twci,pic.xi,pic_A_tx,0:0.5:25,'color',[0 0 0]);
    plot(hca,pic.twci,pic.x_xline,'linewidth',2,'color',[0 0 0])
    hold(hca,'off')
  end
  colormap(hca,pic_colors('blue_red'))    
  hca.CLim = clim;
  hca.Position = pos;
  %legend(hca,{'v_A(x_x,z_x+1)'},'location','southwest','box','off')
  hca.XLim = [5 125];
  %hca.YLim = [0 0.17];
end
if 1 % xcut at late times
  hca = h(isub); isub = isub + 1;
  pic = no02m.twpelim(twpe2).xgrid(2:no02m.nx-1).zlim(0+[-1 1]);
  hn1 = plot(hca,pic.xi,mean(pic.n(1),2),'color',colors(2,:));
  hold(hca,'on')
  hn2 = plot(hca,pic.xi,mean(pic.n([3 5]),2),'color',colors(1,:));
  hB = plot(hca,pic.xi,mean(pic.Babs,2),'k');
  hold(hca,'off')  
  hca.XLim = x0 + [-50 50];
  if 0 % Add axes for A
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
    ax2.YLabel.String = 'A (B_0d_i)';
    legend([hn1,hn2,hB],{'n_{hot}','n_{cold}','|B|'},'location','west','Box','off')
  end
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'n, B';
  %legend([hn1,hn2,hB,hA],{'n_{hot}','n_{cold}','|B|','A_y'},'location','north','Box','off')
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  irf_legend(hca,{['outflow at t\omega_{ci}= ' num2str(twci2)]},[0.20 0.9],'fontsize',14,'color',[0 0 0])
end

legends = {'a)','b)','c)','d)','e)','f)'};
for ip = 1:numel(h)
  irf_legend(h(ip),legends{ip},[-0.1 1.00],'fontsize',14)  
end

hall = findobj(gcf,'type','axes'); hall = hall(end:-1:1);
for ip = 1:numel(hall)
  hall(ip).FontSize = 12;
  hall(ip).XGrid = 'on';
  hall(ip).YGrid = 'on';
end

compact_panels(h([2 3 4]))

% Set up panels
if 1
  %%
  h(1).Position([2 4]) = [0.83 0.15];
  h(2).Position([2 4]) = [0.61 0.15];
  h(3).Position([2 4]) = [0.505 0.10];
  h(4).Position([2 4]) = [0.3 0.20];
  h(5).Position([2 4]) = [0.08 0.15];
else
  h(2).Position(4) = h(1).Position(4);
  h(2).Position(2) = h(2).Position(2)+0.015;
  h(1).Position(2) = h(1).Position(2)+0.030;
end

hl = findobj(gcf,'type','line');
c_eval('hl(?).LineWidth = 1;',1:numel(hl))

%% Figure 2, overview at t=120
% what do we want to show here?
varstrs = {'n([3 5])','n(3)';'t([3 5])','t(3)'}';
%varstrs = {'n([3 5])','n(3)','t([3 5])','t(3)'}';
clims = {[0 0.5],[0 0.5],[0 0.5],[0 0.5]};

xlim = [40 165];
zlim = 0.99*[-10 10];
cmapth = pic_colors('thermal');
cmaps = {cmapth,cmapth,cmapth,cmapth};
cbarlabels = {'n_{i,cold}','n_{i,cold}^{top}','T_{i,cold}','T_{i,cold}^{top}'};
pic = no02m.twpelim(24000).xlim(xlim).zlim(zlim);
h = pic.plot_map(varstrs,'A',1,'clim',clims,'cmap',cmaps,'cbarlabels',cbarlabels);

for ip = 1:numel(h)
  h(ip).FontSize = 12;
  h(ip).XGrid = 'on';
  h(ip).YGrid = 'on';
end
hl = findobj(gcf,'Type','Contour');
c_eval('hl(?).Color = 0.5 + [0 0 0];',1:numel(hl))

legends = {'a)','b)','c)','d)','e)','f)'};
if 1 % 2x2
  %%
  compact_panels(h,0.002,0.002)
  for ip = 1:numel(h)
    irf_legend(h(ip),{[legends{ip} ' ' cbarlabels{ip}]},[0.02 0.98],'color',[1 1 1],'fontweight','bold','fontsize',12)
  end
  hcbar = findobj(gcf,'Type','ColorBar');
  delete(hcbar(2:end))
  hcbar(1).Position = [0.85 0.11 0.02 0.815];
  hcbar(1).YLabel.String = 'n, T';
  h(3).YTickLabels = [];
  h(3).YLabel.String = [];
  h(4).YTickLabels = [];
  h(4).YLabel.String = [];  
  for ip = 1:numel(h)
    h(ip).Position(2) = h(ip).Position(2) + 0.05;
  end
  hcbar(1).Position(2) = hcbar(1).Position(2) + 0.05;
  hcbar(1).FontSize = 12;
  h(1).Title.String = '';
end

%% Figure 3, reduced distributions
%ds100 = PICDist('/Volumes/Fountain/Data/PIC/no_hot_bg_n02_m100/data_h5/dists.h5');
%% Figure 3, prepare data
twpe = 24000; xlim = [50 155]; zlim = [-15 15];
sep = no02m.twpelim(twpe).separatrix_location;
for zpick = [0 2 4]
  ds = ds100.twpelim(twpe).zfind(zpick).xlim(xlim).findtag({'line horizontal'});
  
  xdist = (ds.xi1{1}+ds.xi2{1})/2;
  zdist = (ds.zi1{1}+ds.zi2{1})/2;
  tdist = repmat(twpe,size(xdist));
  vExBx_tmp = no02m.twpelim(twpe).get_points(xdist,zdist,tdist,[-0.25 0.25],'vExBx'); eval(sprintf('vExBx_z%g = vExBx_tmp;',zpick))
  vExBy_tmp = no02m.twpelim(twpe).get_points(xdist,zdist,tdist,[-0.25 0.25],'vExBy'); eval(sprintf('vExBy_z%g = vExBy_tmp;',zpick))
  vExBz_tmp = no02m.twpelim(twpe).get_points(xdist,zdist,tdist,[-0.25 0.25],'vExBz'); eval(sprintf('vExBz_z%g = vExBz_tmp;',zpick))
  pic_lim = no02m.xlim(xlim).zlim(zlim).twpelim(twpe);
  pic = no02m.twpelim(twpe);
  Bx_ = pic.Bx;
  By_ = pic.By;
  Bz_ = pic.Bz;
  Bx = interpfield(pic.xi,pic.zi,Bx_,xdist,zdist); 
  By = interpfield(pic.xi,pic.zi,By_,xdist,zdist); 
  Bz = interpfield(pic.xi,pic.zi,Bz_,xdist,zdist); 
  %fred5_tmp = ds.reduce_1d_new('x',[5],[],'vpar',{Bx,By,Bz},'pitch',{Bx,By,Bz}); eval(sprintf('fred5_z%g = fred5_tmp;',zpick))
  %fred3_tmp = ds.reduce_1d_new('x',[3],[],'vpar',{Bx,By,Bz},'pitch',{Bx,By,Bz}); eval(sprintf('fred3_z%g = fred3_tmp;',zpick))
  %fred35_tmp = ds.reduce_1d_new('x',[3 5],[],'vpar',{Bx,By,Bz},'pitch',{Bx,By,Bz}); eval(sprintf('fred35_z%g = fred35_tmp;',zpick))
  %fred46_tmp = ds.reduce_1d_new('x',[4 6],[],'vpar',{Bx,By,Bz},'pitch',{Bx,By,Bz}); eval(sprintf('fred46_z%g = fred46_tmp;',zpick))    
end
%% Figure 3, plot
% What to include
% - overview of where boxes are
fi_clim = [0 0.13];
fe_clim = [0 0.02];
fe_clim = [-4 log10(0.02)];

nrows = 3;
ncols = 3;
h = setup_subplots(nrows,ncols,'horizontal');
isub = 1;
doE = 0; colorE = [0 0.8 0.8];
doV = 0; colorV = 0*[1 1 1];
doN = 0; colorN = [0 0 0];
doExB = 1; colorExB = 0*[1 1 1]+0.0;
doPhi = 0; colorPhi = [0.5 0.5 0];
doSep = 1;

cmap_dist = pic_colors('waterfall');

freds = {fred35_z4,fred35_z4,fred35_z4,fred35_z2,fred35_z2,fred35_z2,fred35_z0,fred35_z0,fred35_z0};
%freds = {fred35_z2,fred35_z2,fred35_z2};
%freds = {fred5_z4,fred5_z4,fred5_z4;fred5_z2,fred5_z2,fred5_z2;fred5_z0,fred5_z0,fred5_z0}';
%freds = {fred3_z4,fred3_z4,fred3_z4,fred3_z2,fred3_z2,fred3_z2,fred3_z0,fred3_z0,fred3_z0};
labstrs = {'x','y','z','x','y','z','x','y','z'};
legends = {'a)','b)','c)','d)','e)','f)','g)','h)','i)'}; 

for ifred = 1:numel(freds)
  if 1 % fi(v_) z_
    hca = h(isub); isub = isub + 1;
    fred = freds{ifred};
    labstr = labstrs{ifred};
    fredplot = eval(['fred.fv' labstr]);
    pcolor(hca,fred.x,fred.v,log10(fredplot)')
    shading(hca,'flat')
    hca.XLabel.String = 'x (d_i)';
    hca.YLabel.String = sprintf('v_{%s}',labstr);
    colormap(hca,pic_colors('candy4')) 
    %irf_legend(hca,{sprintf('f_{cold}(x,v_%s)',labstr)},[0.02 0.98],'color',[0 0 0],'fontsize',14)
    %irf_legend(hca,{sprintf('%s z = %g',legends{ifred},unique(fred.z))},[0.02 0.98],'color',[0 0 0],'fontsize',14)
    irf_legend(hca,{sprintf('%s f(v_%s,z=%g)',legends{ifred},labstr,unique(fred.z))},[0.02 0.98],'color',[0 0 0],'fontsize',14)
    %hcb = colorbar('peer',hca);  
    %hcb.YLabel.String = sprintf('f_{i,cold}(l_{||},v_{%s})',labstr);
    %hca.CLim(2) = prctile(fred.fvx(:),99);
    hca.XGrid = 'on';
    hca.YGrid = 'on';
    hca.Layer = 'top';
    hca.FontSize = 12;
    if 0*doE
      hold(hca,'on')
      plot(hca,arclength,Ey*max(abs(hca.YLim))/max(abs(Ey)),'color',colorE)
      hold(hca,'off')
    end
    if 0*doV
      hold(hca,'on')
      plot(hca,arclength,viy,'color',colorV,'linewidth',1.5)
      hold(hca,'off')
    end
    if doExB
      hold(hca,'on')
      xx = eval(['x_z' num2str(unique(fred.z))]);
      vv = eval(['vExB' labstr '_z' num2str(unique(fred.z))]);
      hExB = plot(hca,xx,vv,'color',colorExB,'linewidth',0.5);
      %plot(hca,pic_sm.zi,mean(pic_sm.vExBy,1),'color',colorExB,'linewidth',1.5)
      hold(hca,'off')
    end    
    if doSep
      hold(hca,'on')   
      if 1           
        zz = unique(fred.z);
        [PKS,LOCS] = findpeaks(-abs(sep.z-zz),'sort','descend');
        [~,iz] = min(abs(sep.z-zz));
        if zz == 0
          xx = sep.x(LOCS(1));
          hSep = plot(hca,xx(1)*[1 1],hca.YLim,'color',0*colorExB,'linewidth',1,'linestyle',':');      
        else
          xx = sep.x(LOCS(1:2));
          hSep = plot(hca,xx(1)*[1 1],hca.YLim,'color',0*colorExB,'linewidth',1,'linestyle',':');      
          hSep = plot(hca,xx(2)*[1 1],hca.YLim,'color',0*colorExB,'linewidth',1,'linestyle',':');      
        end
      elseif 0
        xx = unique(fred.x);
        [~,ix] = min(abs(sep.x-xx));
        zz = sep.z(ix);
      end      
      hold(hca,'off')      
    end
  end
end
drawnow
compact_panels(h(1:end),0.01,0.05)
%h(1).Title.String = ['nobg, t\omega_{pe} = ' num2str(twpe,'%05.0f')];
hl = findobj(h(1),'type','line');
legend(hl([3 2]),{'v_{ExB}','separatrix'},'box','off','location','north')
%legend([hExB,hSep],{'v_{ExB}','separatrix'})
fig = gcf; h_ = findobj(fig.Children,'type','axes');
hlinks = linkprop(h(1:end),{'XLim','YLim','CLim'});
hl = findobj(h(8),'type','line'); delete(hl(2));
hl = findobj(h(9),'type','line'); delete(hl(2));

hcb = colorbar('peer',h(9));
hcb.Position = [0.91 0.13 0.015 0.795];
hcb.YLabel.String = 'log_{10} f(x,v_{x,y,z})';
c_eval('h(?).YLabel.String = []; h(?).YTickLabel = [];',[2 3 5 6 8 9])
c_eval('h(?).YLabel.String = ''v'';',[1 4 7])
compact_panels(h,0.002,0.002)
%hlinks.Targets(1).XLim = arclength([1 end]);
%irf_plot_axis_align
h(1).CLim = 0.99*[-4 2];
h(1).YLim = 0.99*4*[-1 1];

%% Figure x, f(vy), py
%% Reduced distributions, plot
twpe = 24000;
pic = no02m.twpelim(twpe);
fred = fred35_z0;
twpe = 24000;
fontsize = 12;
% What to include
% - overview of whxx  ere boxes are
fi_clim = [0 0.13];
fe_clim = [0 0.02];
fe_clim = [-4 log10(0.02)];
zlim_line = [-0.5 0.5];
xlim_line = [min(fred3_z0.x) max(fred3_z0.x)];

py0 = [8 7 6.5 5.8 5.2 4.6];
py0 = [8 6.9 6.3 5.6 5.1 4.6];
py0 = [8 6.9 6.3 5.6 5.1 4.6];
py0 = [8 7 6.5 5.8 5.4 4.6];
xmin = [70 70 71 73 80 82];
xmax = [80 85 87 93 95 100];


py0 = [8.5 8.1 7.7 7.4 6.9 6.3 5.8 5.2 4.6];
xmin = [71 71 71 71 71 71.5 73 80 83];
xmax = [74 77 79 81 84 87 92 96 97]+00;
npy = numel(py0);

nrows = 1;
ncols = 1;
npanels = nrows*ncols;
h = setup_subplots(nrows,ncols,'horizontal');
isub = 1;
doE = 1; colorE = [0 0.8 0.8];
doV = 1; colorV = 0*[1 1 1];
doN = 1; colorN = [0 0 0];
doExB = 1; colorExB = 0*[1 1 1]+0.5;
doPhi = 1; colorPhi = [0.5 0.5 0];
doTraj = 1; colorTraj = [0 0 0];
trs = tr100.find([tr100.z0] == 0,[tr100.vy0] > 0.5,[tr100.x0] > 73,[tr100.xstart] < 100);
trs = tr100.find([tr100.z0] == 0,[tr100.vy0] > 0.5).lim('t',[23000 25000]/200);

cmap_dist = pic_colors('waterfall');

%freds = {fred3_z4,fred3_z4,fred3_z4,fred3_z2,fred3_z2,fred3_z2,fred3_z0,fred3_z0,fred3_z0};
labstrs = {'x','y','z','x','y','z','x','y','z'};

if 0 % A(x),
  hca = h(isub); isub = isub + 1; 
  pic_tmp = pic.xlim(xlim_line).zlim(zlim_line);
  plot(hca,pic_tmp.xi,mean(pic_tmp.A,2))  
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'A_{y}';    
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.FontSize = 12;  
end
if 1 % fi(v_y)
  hca = h(isub); isub = isub + 1;
  fred = fred35_z0;    
  pcolor(hca,fred.x,fred.v,log10(fred.fvy)')
  shading(hca,'flat')
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'v_{y}';
  colormap(hca,pic_colors('candy4'))   
  irf_legend(hca,{sprintf('z = %g',unique(fred.z))},[0.02 0.98],'color',[0 0 0],'fontsize',14)
  hcb = colorbar('peer',hca,'fontsize',14);  
  hcb.YLabel.String = 'f_{i,cold}(x,v_{y})';  
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.FontSize = 12;
  hca.CLim = 0.99*[-4 2];
  hca.CLim = 0.99*[-4 2];
  hca.YLim = 0.99*4*[-1 1];
  
  for ipy = 1:npy
    hold(hca,'on')
    pic_tmp = pic.xlim([xmin(ipy) xmax(ipy)]).zlim(zlim_line);
    A = squeeze(mean(pic_tmp.A,2));    
    xx = pic_tmp.xi;
    yy = f_vy_A(py0(ipy),A);
    plot(hca,xx,yy,':k','linewidth',0.5)
    hold(hca,'off')
    ht = text(hca,xx(end),yy(end),sprintf(' %.1f',py0(ipy)),'fontsize',fontsize);
    ht.HorizontalAlignment = 'left';
    dy = (yy(end)-yy(end-1))./diff(hca.YLim);
    dx = (xx(end)-xx(end-1))./diff(hca.XLim);
    ht.Rotation = atand(dy/dx);
    
  end
  if 0*doE
    hold(hca,'on')
    plot(hca,arclength,Ey*max(abs(hca.YLim))/max(abs(Ey)),'color',colorE)
    hold(hca,'off')
  end
  if 0*doV
    hold(hca,'on')
    plot(hca,arclength,viy,'color',colorV,'linewidth',1.5)
    hold(hca,'off')
  end
  if 0 % doExB
    hold(hca,'on')
    xx = eval(['x_z' num2str(unique(fred.z))]);
    vv = eval(['vExB' labstr '_z' num2str(unique(fred.z))]);
    plot(hca,xx,vv,'color',colorExB,'linewidth',1.5)
    %plot(hca,pic_sm.zi,mean(pic_sm.vExBy,1),'color',colorExB,'linewidth',1.5)
    hold(hca,'off')
  end
end
if 0 % fi(v_y)
  hca = h(isub); isub = isub + 1;
  fred = fred3_z0;    
  pcolor(hca,fred.x,fred.v,log10(fred.fvy)')
  shading(hca,'flat')
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'v_{y}';
  colormap(hca,pic_colors('candy4'))   
  irf_legend(hca,{sprintf('z = %g',unique(fred.z))},[0.02 0.98],'color',[0 0 0],'fontsize',14)
  hcb = colorbar('peer',hca,'fontsize',14);  
  hcb.YLabel.String = 'f_{i,cold}(x,v_{y})';  
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.FontSize = 12;
  hca.CLim = 0.99*[-4 2];
  hca.CLim = 0.99*[-2 1];
  hca.YLim = 0.99*4*[-1 1];
  
%   for ipy = 1:npy
%     hold(hca,'on')
%     pic_tmp = pic.xlim([xmin(ipy) xmax(ipy)]).zlim(zlim_line);
%     A = squeeze(mean(pic_tmp.A,2));
%     plot(hca,pic_tmp.xi,f_vy_A(py0(ipy),A),'--k')
%     hold(hca,'off')
%   end

   for itr = 1:trs.ntr
      hold(hca,'on')
      plot(hca,trs(itr).x,trs(itr).vy,'k')
      hold(hca,'off')
   end
end
if 0 % fi_top(v_y)/fi_tot(v_y)
  hca = h(isub); isub = isub + 1;
  fred = fred3_z0;    
  pcolor(hca,fred.x,fred.v,fred3_z0.fvy'./fred35_z0.fvy')
  shading(hca,'flat')
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'v_{y}';
  colormap(hca,pic_colors('waterfall'))   
  irf_legend(hca,{sprintf('z = %g',unique(fred.z))},[0.02 0.98],'color',[0 0 0],'fontsize',14)
  hcb = colorbar('peer',hca,'fontsize',14);  
  hcb.YLabel.String = 'f_{i,top}/f_{i,tot}(x,v_{y})';  
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.FontSize = 12;
  hca.CLim = 1*[0 1];  
  hca.YLim = 0.99*4*[-1 1];
  
%   for ipy = 1:npy
%     hold(hca,'on')
%     pic_tmp = pic.xlim([xmin(ipy) xmax(ipy)]).zlim(zlim_line);
%     A = squeeze(mean(pic_tmp.A,2));
%     plot(hca,pic_tmp.xi,f_vy_A(py0(ipy),A),'--k')
%     hold(hca,'off')
%   end

   for itr = 1:trs.ntr
      hold(hca,'on')
      plot(hca,trs(itr).x,trs(itr).vy,'k')
      hold(hca,'off')
   end
end
if 0 % A0(v_y,A)
  hca = h(isub); isub = isub + 1; 
  A_ = no02m.interp(fred.x,fred.z,no02m.twpelim(twpe).twci,'A');
  [VY,A] = meshgrid(fred.v,A_);  
  A0map = f_A0_vy_py0(A,VY);
  A0map(fred.fvy==0) = NaN;
  %[Ccont,hcont] = contourf(hca,fred.x,fred.v,A0map',-30:1:30);
  [Ccont,hcont] = contourf(hca,fred.x,fred.v,A0map',[0 sort(py0)]);
  clabel(Ccont,hcont,'LabelSpacing',72,'Color','k','FontWeight','bold');
  shading(hca,'flat')
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'v_{y}';
  colormap(hca,pic_colors('waterfall'))   
  irf_legend(hca,{sprintf('z = %g',unique(fred.z))},[0.02 0.98],'color',[0 0 0],'fontsize',14)
  hcb = colorbar('peer',hca,'fontsize',14);  
  hcb.YLabel.String = 'A_{y0}(A_{y,loc},v_y,v_{y0}=0)';  
  irf_legend(hca,{'A_{y0} = A_{y,loc} - v_{y,loc}';'assuming v_{y0}=0'},[0.98 0.1],'color',[0 0 0])
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.FontSize = 12;
  %hca.CLim = 0.99*[-4 2];
  %hca.CLim = 0.99*[-2 1];
  hca.YLim = 0.99*4*[-1 1];
  
  for ipy = 1:npy
    hold(hca,'on')
    pic_tmp = pic.xlim([xmin(ipy) xmax(ipy)]).zlim(zlim_line);
    A = squeeze(mean(pic_tmp.A,2));
    xx = pic_tmp.xi;
    yy = f_vy_A(py0(ipy),A);
    plot(hca,xx,yy,'--k')
    hold(hca,'off')
    ht = text(hca,xx(end),yy(end),sprintf('p_y = %.1f',py0(ipy)),'fontsize',fontsize);
  end
  if 0*doE
    hold(hca,'on')
    plot(hca,arclength,Ey*max(abs(hca.YLim))/max(abs(Ey)),'color',colorE)
    hold(hca,'off')
  end
  if 0*doV
    hold(hca,'on')
    plot(hca,arclength,viy,'color',colorV,'linewidth',1.5)
    hold(hca,'off')
  end
  if 0 % doExB
    hold(hca,'on')
    xx = eval(['x_z' num2str(unique(fred.z))]);
    vv = eval(['vExB' labstr '_z' num2str(unique(fred.z))]);
    plot(hca,xx,vv,'color',colorExB,'linewidth',1.5)
    %plot(hca,pic_sm.zi,mean(pic_sm.vExBy,1),'color',colorExB,'linewidth',1.5)
    hold(hca,'off')
  end
end
if 0 % ExB_x
  hca = h(isub); isub = isub + 1; 
  pic_tmp = pic.xlim(xlim_line).zlim(zlim_line);
  plot(hca,pic_tmp.xi,mean(pic_tmp.vExBx,2),pic_tmp.xi,mean(pic_tmp.vix,2))
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'v_{x}';    
  legend(hca,{'v_{ExB}','v_i'},'location','best')
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.FontSize = 12;  
end
if 0 % A(x), for different times
  hca = h(isub); isub = isub + 1; 
  pic_tmp = no02m.twpelim(19000:1000:24000,'exact').xlim(xlim_line).zlim(zlim_line);
  plot(hca,pic_tmp.xi,squeeze(mean(pic_tmp.A,2)))  
  hca.XLabel.String = 'x (d_i)';
  hca.YLabel.String = 'A_{y}';    
  
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  hca.FontSize = 12;  
end
drawnow
compact_panels(h(1:end),0.01,0.05)
%h(1).Title.String = ['nobg, t\omega_{pe} = ' num2str(twpe,'%05.0f')];
fig = gcf; h_ = findobj(fig.Children,'type','axes');
hlinks = linkprop(h(1:end),{'XLim'});
%hlinks.Targets(1).XLim = arclength([1 end]);
%irf_plot_axis_align
for ip = 1:nrows*ncols
  axwidth(ip) = h(ip).Position(3);
  h(ip).FontSize = 14;
end
for ip = 1:nrows*ncols
  h(ip).Position(3) = 0.7;%min(axwidth);
end
% for ip = 1:nrows*ncols
%   h(ip).Position(2) = h(ip).Position(2)-0.05;
% end

%c_eval('h(?).YTickLabel = []; h(?).YLabel = [];',[2 3 5 6 8 9])
%c_eval('h(?).YTick = -10:1:10;',1)
