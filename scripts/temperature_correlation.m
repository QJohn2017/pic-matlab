twpe = 10000; xlim = [140 200]; zlim = [-15 15];
twpe = 9000; xlim = [160 210]; zlim = [-10 10];
twpe = 9500; xlim = [150 210]; zlim = [-12.5 12.5];
tag = 'nobg';
pic = nobg.twpelim(twpe,'exact').xlim(xlim).zlim(zlim);

ispecies = [3 5];
especies = [4 6];
tic
ti         = pic.t(ispecies);
tiperp = pic.tperp(ispecies);
tipar   = pic.tpar(ispecies);
ni         = pic.n(ispecies);

te         = pic.t(especies);
teperp = pic.tperp(especies);
tepar   = pic.tpar(especies);
ne         = pic.n(especies);
toc


%% Plot
plev = [0.02 0.05 0.1:0.1:1];
doLog = 1;

nrows = 3;
ncols = 2;
h = setup_subplots(nrows,ncols);
isub = 1;

if 0
  hca = h(isub); isub = isub + 1;
  scatter(hca,ni(:),ti(:),1)
  hold(hca,'on')
  scatter(hca,ne(:),te(:),1)
  hold(hca,'off')
  hca.XLabel.String = 'T_i';
  hca.YLabel.String = 'T_e';
  hcb = colorbar('peer',hca);
end
if 0
  hca = h(isub); isub = isub + 1;
  scatter(hca,ti(:),te(:),1,ni(:))
  hca.XLabel.String = 'T_i';
  hca.YLabel.String = 'T_e';
  hcb = colorbar('peer',hca);
end
if 0 % ti, te
  hca = h(isub); isub = isub + 1;
  [N edges mid loc] = histcn([ti(:) te(:)],linspace(0.03,1.5,100),linspace(0,0.7,100));
  pcolor(hca,mid{1:2},log10(N(:,:,ceil(end/2))'))
  shading(hca,'flat')
  hcb = colorbar('peer',hca);
  colormap(hca,pic_colors('candy'))
  hca.XLabel.String = 'T_i';
  hca.YLabel.String = 'T_e';
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
end
if 1 % ni, ti
  hca = h(isub); isub = isub + 1;
  [N edges mid loc] = histcn([ni(:) ti(:)],linspace(0,0.5,100),linspace(0.01,1.8,100));
  if doLog
    pcolor(hca,mid{1:2},log10(N(:,:,ceil(end/2))'))
  else
    pcolor(hca,mid{1:2},N(:,:,ceil(end/2))')
  end
  shading(hca,'flat')
  hcb = colorbar('peer',hca);
  colormap(hca,pic_colors('candy'))
  hca.XLabel.String = 'n_i';
  hca.YLabel.String = 'T_i';
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  if 1 % p contours
    [X,Y] = meshgrid(linspace(hca.XLim(1),hca.XLim(2),20),linspace(hca.YLim(1),hca.YLim(2),20));
    C = X.*Y;
    ylim = hca.YLim;
    hold(hca,'on')
    [cc,ch] = contour(hca,X,Y,C',plev,'k');    
    clabel(cc,ch)
    hold(hca,'off')
    hca.YLim = ylim;
  end
end
if 1 % ne, te
  hca = h(isub); isub = isub + 1;
  [N edges mid loc] = histcn([ne(:) te(:)],linspace(0,0.5,100),linspace(0.01,0.8,100));
  if doLog
    pcolor(hca,mid{1:2},log10(N(:,:,ceil(end/2))'))
  else
    pcolor(hca,mid{1:2},N(:,:,ceil(end/2))')
  end
  shading(hca,'flat')
  hcb = colorbar('peer',hca);
  colormap(hca,pic_colors('candy'))
  hca.XLabel.String = 'n_e';
  hca.YLabel.String = 'T_e';
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
end
if 1 % ni, tipar
  hca = h(isub); isub = isub + 1;
  [N edges mid loc] = histcn([ni(:) tipar(:)],linspace(0,0.5,100),linspace(0.01,1.8,100));
  if doLog
    pcolor(hca,mid{1:2},log10(N(:,:,ceil(end/2))'))
  else
    pcolor(hca,mid{1:2},N(:,:,ceil(end/2))')
  end
  shading(hca,'flat')
  hcb = colorbar('peer',hca);
  colormap(hca,pic_colors('candy'))
  hca.XLabel.String = 'n_i';
  hca.YLabel.String = 'T_{i,||}';
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  if 1 % pressure contours
    [X,Y] = meshgrid(linspace(hca.XLim(1),hca.XLim(2),20),linspace(hca.YLim(1),hca.YLim(2),20));
    C = X.*Y.^(5  /2);
    ylim = hca.YLim;
    hold(hca,'on')
    [cc,ch] = contour(hca,X,Y,C',plev,'k');  
    clabel(cc,ch)
    hold(hca,'off')
    hca.YLim = ylim;
  end
end
if 1 % ne, tepar
  hca = h(isub); isub = isub + 1;
  [N edges mid loc] = histcn([ne(:) tepar(:)],linspace(0,0.5,100),linspace(0.01,0.8,100));
  if doLog
    pcolor(hca,mid{1:2},log10(N(:,:,ceil(end/2))'))
  else
    pcolor(hca,mid{1:2},N(:,:,ceil(end/2))')
  end
  shading(hca,'flat')
  hcb = colorbar('peer',hca);
  colormap(hca,pic_colors('candy'))
  hca.XLabel.String = 'n_e';
  hca.YLabel.String = 'T_{e,||}';
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
end
if 1 % ni, tiperp
  hca = h(isub); isub = isub + 1;
  [N edges mid loc] = histcn([ni(:) tiperp(:)],linspace(0,0.5,100),linspace(0.01,1.8,100));
  if doLog
    pcolor(hca,mid{1:2},log10(N(:,:,ceil(end/2))'))
  else
    pcolor(hca,mid{1:2},N(:,:,ceil(end/2))')
  end
  shading(hca,'flat')
  hcb = colorbar('peer',hca);
  colormap(hca,pic_colors('candy'))
  hca.XLabel.String = 'n_i';
  hca.YLabel.String = 'T_{i,\perp}';
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
  if 1 % pressure contours
    [X,Y] = meshgrid(linspace(hca.XLim(1),hca.XLim(2),20),linspace(hca.YLim(1),hca.YLim(2),20));
    C = X.*Y;
    ylim = hca.YLim;
    hold(hca,'on')
    [cc,ch] = contour(hca,X,Y,C',plev,'k'); 
    clabel(cc,ch)
    hold(hca,'off')
    hca.YLim = ylim;
  end
end
if 1 % ne, teperp
  hca = h(isub); isub = isub + 1;
  [N edges mid loc] = histcn([ne(:) teperp(:)],linspace(0,0.5,100),linspace(0.01,0.8,100));
  if doLog
    pcolor(hca,mid{1:2},log10(N(:,:,ceil(end/2))'))
  else
    pcolor(hca,mid{1:2},N(:,:,ceil(end/2))')
  end
  shading(hca,'flat')
  hcb = colorbar('peer',hca);
  colormap(hca,pic_colors('candy'))
  hca.XLabel.String = 'n_e';
  hca.YLabel.String = 'T_{e,\perp}';
  hca.XGrid = 'on';
  hca.YGrid = 'on';
  hca.Layer = 'top';
end
if 0 % empty
  hca = h(isub); isub = isub + 1;
  
  hca.XLabel.String = '';
  hca.YLabel.String = '';
end


h(1).Title.String = sprintf('%s, tw_{pe}= %g, x = [%g,%g], z = [%g,%g]',tag,twpe,xlim(1),xlim(2),zlim(1),zlim(2));
h(1).Title.Position(1) = 0.6;
compact_panels(0.01,0.14)
hlink = linkprop(h,{'CLim'});