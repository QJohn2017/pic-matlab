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
