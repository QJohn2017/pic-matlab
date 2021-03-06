%% Define times
timesteps = 00200:200:10800;
times = timesteps/50;
ntimes = numel(timesteps);
savedir_root = '/Users/cno062/Research/PIC/df_cold_protons_1/';
data_dir = '/Volumes/Fountain/Data/PIC/df_cold_protons_1/data/';
screensize = get( groot, 'Screensize' );

%% Time loop
tstart = tic;
for itime = 40
  %% Load data
  timestep = timesteps(itime);
  disp(sprintf('timestep = %05.0f/%05.0f',timestep,timesteps(end)))
  txtfile = sprintf('%s/fields-%05.0f.dat',data_dir,timestep); % michael's perturbation
  disp('Loading data...')
  tic; [x,z,E,B,...
        ni1,ne1,ni2,ne2,...
        vi1,ve1,vi2,ve2,...
        ji1,je1,ji2,je2,...
        pi1,pe1,pi2,pe2,...
        ti1,te1,ti2,te2,...
        dfac,teti,nnx,nnz,wpewce,mass,it,time,dt,xmax,zmax,q]... 
        = read_fields(txtfile); toc
  
  x0 = mean(x);
  x = x - x0; % put x = 0 in middle    
  
 
  
  doA = 1;
  if doA % keep A similar between plots
    cA = [0.8 0.8 0.8];
    cA = [0.7 0.7 0.7];
    nA = 40;
    nA = [0:-1:min(A(:))];
    ipxA = ix1:10:ix2;
    ipzA = iz1:10:iz2;
  end
  [X,Z] = ndgrid(x,z);
  
  %% Calculate auxillary quantities
  A = vector_potential(x,z,B.x,B.z); % vector potential
  [saddle_locations,saddle_values] = saddle(A);
  pic_calc_script  
  
  % field-aligned coordinates
  % r1 - b, field aligned
  % r2 - but closest y, with the condition that it's perp to r1
  % r3 = r1 x r2
  [r1,r2,r3] = construct_coordsystem(B,[0 1 0],[]);
  
  te1_fac = rotate_tens(te1,r1,r2,r3);
  te2_fac = rotate_tens(te2,r1,r2,r3);
  ti1_fac = rotate_tens(ti1,r1,r2,r3);
  ti2_fac = rotate_tens(ti2,r1,r2,r3);
  te1.perp = 0.5*(te1_fac.yy + te1_fac.zz);
  te2.perp = 0.5*(te2_fac.yy + te2_fac.zz);
  ti1.perp = 0.5*(ti1_fac.yy + ti1_fac.zz);
  ti2.perp = 0.5*(ti2_fac.yy + ti2_fac.zz);
  te1.par = te1_fac.xx;
  te2.par = te2_fac.xx;
  ti1.par = ti1_fac.xx;
  ti2.par = ti2_fac.xx;
  
  %% Plots 
  if 0 % Plot, energy densities
    %% Save and print info
    subdir = 'energy_density_1';
    savedir = [savedir_root,subdir];
    mkdir(savedir)
    savestr = sprintf('%s_t%05.0f',subdir,timestep);
    % Define what variables to plot
    %varstrs = {'ve1.x','ve2.x','ve1.z','ve2.z','ve1.par','ve2.par','-ve1xB.x','-ve2xB.x','-ve1xB.z','-ve2xB.z','E.x','E.z'};
    varstrs = {'UB.tot','Uke1','Uke2','Uki1','Uki2','Ute1','Ute2','Uti1','Uti2'};
    clim = [-1 1];    
    nvars = numel(varstrs);

    % Initialize figure
    fig = figure(101);
    fig.Position = [screensize(1) screensize(2) screensize(3)*0.4 screensize(4)*0.7];
    npanels = nvars + doTs;
    nrows = 5;
    ncols = ceil(npanels/nrows);
    npanels = nrows*ncols;
    isub = 1; 
    for ipanel = 1:npanels  
      h(isub) = subplot(nrows,ncols,ipanel); isub = isub + 1;  
    end
    clear hb;

    doA = 0;
    if doA    
      cA = [0.8 0.8 0.8];
      nA = 20;
      nA = [0:-2:min(A(:))];
    end
    
    % Plot part of data
    xlim = [x(1) x(end)] + [100 -100];
    zlim = [-10 10];
    ix1 = find(x>xlim(1),1,'first');
    ix2 = find(x<xlim(2),1,'last');
    iz1 = find(z>zlim(1),1,'first');
    iz2 = find(z<zlim(2),1,'last');
    ipx = ix1:2:ix2;
    ipz = iz1:2:iz2;
    
    % Panels
    isub = 1;
    if doTs % ts plot of energy
      hca = h(isub); isub = isub + 1;
      ts_varstrs = {'UB','Uke1','Uke2','Uki1','Uki2','Ute1','Ute2','Uti1','Uti2'};
      variables = nan(numel(ts_varstrs),ntimes);
      for ivar = 1:numel(ts_varstrs)
        variables(ivar,:) = eval([ts_varstrs{ivar} '_ts']);
      end         
      hlines = plot(hca,timesteps/wpewce/mass(1),[UB_ts; Uke1_ts; Uke2_ts; Uki1_ts; Uki2_ts; Ute1_ts; Ute2_ts; Uti1_ts; Uti2_ts]);      
      for iline = 1:numel(hlines)
        hlines(iline).Marker = '.';
      end
      legend(hca,ts_varstrs,'location','eastoutside')
%      labels = arrayfun(@(x,y) {[num2str(x) ' > Q_{||} > ' num2str(y)]}, edgesQ(end:-1:2),edgesQ(end-1:-1:1));
      hca.XLim = [0 (timesteps(end)+200)/wpewce/mass(1)];
      hca.XLabel.String = 'time (omega_{ci})';
      hca.YLabel.String = 'Energy density (...)';
    end
    for ivar = 1:nvars  
      hca = h(isub); isub = isub + 1;
      varstr = varstrs{ivar};
      variable = eval(varstr);  
      himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      %hca.Title.String = sprintf('%s, sum(%s) = %g',varstr,varstr,sum(variable(:))); 
      hca.Title.String = sprintf('%s',varstr); 
      hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
      hcb = colorbar('peer',hca);
      hb(ivar) = hcb;
      %hcb.YLim = hca.CLim(2)*[-1 1];
      colormap(hca,pic_colors('blue_red'));

      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipx),z(ipz),A(ipx,ipz)',nA,'color',cA,'linewidth',1.0);  
        hold(hca,'off')  
      end
    end
    for ipanel = 2:npanels
      h(ipanel).YDir = 'normal';
      h(ipanel).XLim = xlim;
      h(ipanel).YLim = zlim;
      h(ipanel).CLim = clim;
      hb(ipanel-1).Limits(1) = 0;
    end
    
    print('-dpng','-r200',[savedir '/' savestr '.png']);
  end
  if 0 % Plot, vector potential
    %% Save and print info
    subdir = 'vector_potential';
    savedir = [savedir_root,subdir];
    mkdir(savedir)
    savestr = sprintf('%s_t%05.0f',subdir,timestep);                  

    % Initialize figure
    fig = figure(103);
    fig.Position = [screensize(1) screensize(2) screensize(3)*0.4 screensize(4)*0.7];
    npanels = nvars + doTs;
    nrows = 3;
    ncols = ceil(npanels/nrows);
    npanels = nrows*ncols;
    isub = 1; 
    for ipanel = 1:npanels  
      h(isub) = subplot(nrows,ncols,ipanel); isub = isub + 1;  
    end
    clear hb;

    doA = 0;
    if doA    
      cA = [0.8 0.8 0.8];
      nA = 20;
      nA = [0:-2:min(A(:))];
    end
    
    % Plot part of data
    xlim = [x(1) x(end)];
    zlim = [-10 10];
    ix1 = find(x>xlim(1),1,'first');
    ix2 = find(x<xlim(2),1,'last');
    iz1 = find(z>zlim(1),1,'first');
    iz2 = find(z<zlim(2),1,'last');
    ipx = ix1:2:ix2;
    ipz = iz1:2:iz2;
    
    % Panels
    isub = 1;
    if 1 % plot of fluxtube volume vs A
      hca = h(isub); isub = isub + 1;
      hline = plot(hca,levels_centers,A_volume);
      hline.Marker = '.';
      hca.XLabel.String = 'A_level';
      hca.XLabel.Interpreter = 'none';  
      hca.YLabel.String = 'A_volume';
      hca.YLabel.Interpreter = 'none';  
    end
    if 1 % plot of fluxtube volume vs A, hold on between time steps
      hca = h(isub); isub = isub + 1;
      hold(hca,'on')
      hline = plot(hca,levels_centers,A_volume);
      hline.Marker = '.';
      hca.XLabel.String = 'A_level';
      hca.XLabel.Interpreter = 'none';  
      hca.YLabel.String = 'A_volume';
      hca.YLabel.Interpreter = 'none';  
      hca.Box = 'on';
    end
    if 0 % A
      hca = h(isub); isub = isub + 1;
      imagesc(hca,x,z,A')
      hca.Title.String = 'A';
      hca.Title.Interpreter = 'none';
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = 'rel. vol.';
    end
    if 1 % A_levels
      hca = h(isub); isub = isub + 1;
      imagesc(hca,x,z,A_levels')
      hcb = colorbar('peer',hca);
      hca.Title.String = 'A_levels';
      hca.Title.Interpreter = 'none';
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
    end
    if 1 % A_volume, automatic caxis
      hca = h(isub); isub = isub + 1;
      xlim = [x(2) x(end-1)];
      zlim = [z(2) z(end-1)];
      himag = imagesc(hca,x(lim2ind(x,xlim)),z(lim2ind(z,zlim)),A_map(lim2ind(x,xlim),lim2ind(z,zlim))');
      hca.CLim = [0.019 0.04];
      hca.Title.String = 'A_map';
      hca.Title.Interpreter = 'none';
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
      hcb = colorbar('peer',hca);  
      hcb.YLabel.String = 'rel. fluxtube vol.';
    end
    if 1 % A_volume, automatic caxis
      hca = h(isub); isub = isub + 1;
      xlim = mean(x) + [-50 50];
      zlim = mean(z) + [-10 10];
      himag = imagesc(hca,x(lim2ind(x,xlim)),z(lim2ind(z,zlim)),A_map(lim2ind(x,xlim),lim2ind(z,zlim))');
      hca.CLim = [0.019 0.04];
      hca.Title.String = 'A_map';
      hca.Title.Interpreter = 'none';
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
      hcb = colorbar('peer',hca);  
      hcb.YLabel.String = 'rel. fluxtube vol.';
      hca.XLim = xlim;
      hca.YLim = zlim;
    end
    if 1 % A_volume, automatic caxis
      hca = h(isub); isub = isub + 1;
      xlim = mean(x) + [-25 25];
      zlim = mean(z) + [-5 5];
      himag = imagesc(hca,x(lim2ind(x,xlim)),z(lim2ind(z,zlim)),A_map(lim2ind(x,xlim),lim2ind(z,zlim))');
      hca.CLim = [0.019 0.04];
      hca.Title.String = 'A_map';
      hca.Title.Interpreter = 'none';
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
      hcb = colorbar('peer',hca);  
      hcb.YLabel.String = 'rel. fluxtube vol.';
      hca.XLim = xlim;
      hca.YLim = zlim;
    end
    if 0 % A_volume, outside outermost saddle point (main x line)
      hca = h(isub); isub = isub + 1;
      himag = imagesc(hca,x,z,A_map_outer');
      hca.CLim(1) = 0.018;
      hcb = colorbar('peer',hca);
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
    end
    if 0 % A_volume, inside outermost saddle point (main x line)
      hca = h(isub); isub = isub + 1;
      himag = imagesc(hca,x,z,A_map_inner');
      hcb = colorbar('peer',hca);
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
    end
    if 0 % A_levels, outside outermost saddle point (main x line)
      hca = h(isub); isub = isub + 1;
      himag = imagesc(hca,x,z,A_levels_outer');
      hcb = colorbar('peer',hca);
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
    end
    if 0 % A_levels, inside outermost saddle point (main x line)
      hca = h(isub); isub = isub + 1;
      himag = imagesc(hca,x,z,A_levels_inner');
      hcb = colorbar('peer',hca);
      hca.XLabel.String = 'x (di)';
      hca.YLabel.String = 'z (di)';
    end


    for ipanel = 1:npanels
      h(ipanel).YDir = 'normal';
    end
    
    print('-dpng','-r200',[savedir '/' savestr '.png']);
  end        
  
  species_clim_temperature = [0.3 0.18 1.0 0.3];
  species_strs = {'e1','e2','i1','i2'}; % Temperature 
  for ispecies = 1:4 % Temperature 
    %% Save and print info     
    subdir = 'temperature/';
    species_str = species_strs{ispecies};
    save_str_mov = sprintf('temperatures_%s',species_str);
    save_str_png = sprintf('temperatures_%s',species_str);
    
    % set figure position
    screensize = get(groot,'Screensize');
    figure_position(1) = 1;
    figure_position(2) = 1;
    figure_position(3) = screensize(3)/4*ncols;
    figure_position(4) = figure_position(3)*nrows/ncols*0.3;
    
    savedir = [savedir_root,subdir];
    mkdir(savedir)
    savestr = sprintf('%s_t%05.0f',subdir,timestep);            

    % Initialize figure
    fig = figure(102);
    fig.Position = figure_position;

    nrows = 4;
    ncols = 1;
    npanels = nrows*ncols;
    h = setup_subplots(nrows,ncols);
    clear hb;
    
    doA = 1;
    if doA    
      cA = [0.8 0.8 0.8];
      cA = [0.7 0.7 0.7];
      nA = 40;
      nA = [0:-1:min(A(:))];
      ipxA = ix1:5:ix2;
      ipzA = iz1:5:iz2;
    end
     
    % Panels
    isub = 1;
    if 1 % t**.scalar
      hca = h(isub); isub = isub + 1;
      varstr = sprintf('t%s.scalar',species_str);
      variable = eval(varstr);
      himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      hca.CLim = species_clim_temperature(ispecies)*[0 1];
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;
      hb(ivar) = hcb;
      colormap(hca,pic_colors('candy'));
      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
    end
    if 1 % t**.par
      hca = h(isub); isub = isub + 1;
      varstr = sprintf('t%s.par',species_str);
      variable = eval(varstr);
      himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      hca.CLim = species_clim_temperature(ispecies)*[0 1];
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;
      hb(ivar) = hcb;
      colormap(hca,pic_colors('candy'));
      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
    end
    if 1 % t**.perp
      hca = h(isub); isub = isub + 1;
      varstr = sprintf('t%s.perp',species_str);
      variable = eval(varstr);
      himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      hca.CLim = species_clim_temperature(ispecies)*[0 1];
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;      
      hb(ivar) = hcb;      
      colormap(hca,pic_colors('candy'));
      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
    end
    if 1 % log2(t**.par./t**.perp)
      hca = h(isub); isub = isub + 1;
      varstr = sprintf('log2(t%s.par./t%s.perp)',species_str',species_str);
      variable = eval(varstr);
      himag = imagesc(hca,x(ipx),z(ipz),real(variable(ipx,ipz))');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      hca.CLim = 3*[-1 1];
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;
      hb(ivar) = hcb;
      colormap(hca,pic_colors('blue_red'));
      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
    end
    compact_panels
    for ipanel = 1:npanels
      h(ipanel).YDir = 'normal';
      h(ipanel).XDir = 'reverse';
      h(ipanel).XLim = xlim;
      h(ipanel).YLim = zlim; 
      h(ipanel).Position(3) = h(1).Position(3);
    end
    h(1).Title.String = sprintf('time = %g (1/wci) = %g (1/wpe)',time,timestep);
    set(gcf,'color',[1 1 1]);
    c_eval('h(?).XLabel.String = [];',1:3)
    
    if 0
    if doMovie(iplot) % Collect frame for movie    
      currentBackgroundColor = get(gcf,'color');
      %set(gcf,'color',[0 1 0]);
      drawnow
      imovie = sum(doMovie(1:iplot));
      tmp_frame = getframe(gcf);
      %cell_movies{imovie}(itime) = tmp_frame;
      if itime == 1 % initialize animated gif matrix
        [im_tmp,map] = rgb2ind(tmp_frame.cdata,256,'nodither');
        %map(end+1,:) = get(gcf,'color');
        im_tmp(1,1,1,ntimes) = 0;
        cell_movies{imovie,1} = map;
        cell_movies{imovie,2} = im_tmp;
      else
        cell_movies{imovie,2}(:,:,1,itime) = rgb2ind(tmp_frame.cdata,cell_movies{imovie,1},'nodither');
      end       
    else % print
      print('-dpng','-r200',[savedir '/' save_str_png '.png']);
    end
    end
    print('-dpng','-r200',[savedir '/' save_str_png '.png']);
    
  end
  if 0 % B.y with current vectors
    %%
    % Save and print info     
    subdir = 'mov/';
    
    % Plot part of data   
    xlim = [-150 150]; [x(1) x(end)];
    zlim = [-15 15];   [z(1) z(end)];

    ix1 = find(x>xlim(1),1,'first');
    ix2 = find(x<xlim(2),1,'last');
    iz1 = find(z>zlim(1),1,'first');
    iz2 = find(z<zlim(2),1,'last');
    ipx = ix1:2:ix2; % every second index, just to save some time
    ipz = iz1:2:iz2;
  
    % set figure position
    screensize = get(groot,'Screensize');
    figure_position(1) = 1;
    figure_position(2) = 1;
    figure_position(3) = 1200;%screensize(3)/4*ncols;
    figure_position(4) = 400;%figure_position(3)*nrows/ncols*0.5;
    figure_position(3) = screensize(3)/4*ncols;
    figure_position(4) = figure_position(3)*nrows/ncols*0.5;
    
    savedir = [savedir_root,subdir];
    %mkdir(savedir)
    %savestr = sprintf('%s_t%05.0f',subdir,timestep);            

    doQ = 1;
    varstr_Q = {'vi'};
    dataQ = eval(varstr_Q{1});
    cQ = [0 0 0];
    scaleQ = 2;
    ipxQ = ix1:25:ix2;
    ipzQ = iz1:15:iz2; 
    
    % Initialize figure
    fig = figure(102);
    fig.Position = figure_position;

    nrows = 1;
    ncols = 1;
    npanels = nrows*ncols;
    h = setup_subplots(nrows,ncols);
    isub = 1; 
   
    if 1 % B.y
      hca = h(isub); isub = isub + 1;
      varstr = 'B.y';
      variable = eval(varstr);
      himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      %hca.Title.String = sprintf('%s, sum(%s) = %g',varstr,varstr,sum(variable(:))); 
      hca.Title.String = sprintf('%s',varstr); 
      hca.Title.Interpreter = 'none';
      if 0 %abs(himag.CData(not(isnan(himag.CData)))) % dont do if is zero
        hca.CLim = max(abs(himag.CData(:)))*[-1 1];          
      end
      hca.CLim = 0.4*[-1 1];
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;
      %hcb.YLim = ;
      hb(ivar) = hcb;
      %hcb.YLim = hca.CLim(2)*[-1 1];
      colormap(hca,pic_colors('blue_red'));
      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
      if doQ
        hold(hca,'on')
        dataQx = dataQ.x; %dataQx = smooth_data(dataQx);
        dataQz = dataQ.z; %dataQz = smooth_data(dataQz);
        hquiv = quiver(hca,X(ipxQ,ipzQ),Z(ipxQ,ipzQ),dataQx(ipxQ,ipzQ),dataQz(ipxQ,ipzQ),scaleQ,'color',cQ);
        legend(hquiv,varstr_Q)
        hold(hca,'off')  
      end      
    end    
    
    for ipanel = 1:npanels
      h(ipanel).YDir = 'normal';
      h(ipanel).XDir = 'reverse';
      h(ipanel).XLim = xlim;
      h(ipanel).YLim = zlim;   
    end
    
    h(1).Title.String = sprintf('time = %g (1/wci) = %g (1/wpe)',time,timestep);    
    clear hb;
    set(gcf,'color',[1 1 1]);
    %%
    if 0
    if doMovie(iplot) % Collect frame for movie    
      currentBackgroundColor = get(gcf,'color');
      %set(gcf,'color',[0 1 0]);
      drawnow
      imovie = sum(doMovie(1:iplot));
      tmp_frame = getframe(gcf);
      %cell_movies{imovie}(itime) = tmp_frame;
      if itime == 1 % initialize animated gif matrix
        [im_tmp,map] = rgb2ind(tmp_frame.cdata,256,'nodither');
        %map(end+1,:) = get(gcf,'color');
        im_tmp(1,1,1,ntimes) = 0;
        cell_movies{imovie,1} = map;
        cell_movies{imovie,2} = im_tmp;
      else
        cell_movies{imovie,2}(:,:,1,itime) = rgb2ind(tmp_frame.cdata,cell_movies{imovie,1},'nodither');
      end       
    else % print
      print('-dpng','-r200',[savedir '/' savestr '.png']);
    end
    end
    
  end
  if 0 % B.y with vi and ve
    %%
    % Save and print info     
    subdir = 'mov/';
    
    % Plot part of data   
    xlim = [0 100]; [x(1) x(end)];
    zlim = [0 7];   [z(1) z(end)];

    ix1 = find(x>xlim(1),1,'first');
    ix2 = find(x<xlim(2),1,'last');
    iz1 = find(z>zlim(1),1,'first');
    iz2 = find(z<zlim(2),1,'last');
    ipx = ix1:2:ix2; % every second index, just to save some time
    ipz = iz1:2:iz2;
    
    % set figure position
    screensize = get(groot,'Screensize');
    figure_position(1) = 1;
    figure_position(2) = 1;
    figure_position(3) = 1200;%screensize(3)/4*ncols;
    figure_position(4) = 400;%figure_position(3)*nrows/ncols*0.5;
    %figure_position(3) = screensize(3)/4*ncols;
    %figure_position(4) = figure_position(3)*nrows/ncols*0.5;
    
    savedir = [savedir_root,subdir];
    %mkdir(savedir)
    %savestr = sprintf('%s_t%05.0f',subdir,timestep);            

    doQ = 1;
    varstrs_Q = {'vi','ve'};
    %varstrs_Q = {'vi'};
    cQ = pic_colors('1m');%[0 0 0;pic_colors];
    scaleQ = 1;
    ipxQ = ix1:25:ix2;
    ipzQ = iz1:15:iz2; 
    
    % Initialize figure
    fig = figure(102);
    fig.Position = figure_position;

    nrows = 1;
    ncols = 1;
    npanels = nrows*ncols;
    h = setup_subplots(nrows,ncols);
    isub = 1; 
   
    if 1 % B.y
      hca = h(isub); isub = isub + 1;
      varstr = 'B.y';
      variable = eval(varstr);
      himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      %hca.Title.String = sprintf('%s, sum(%s) = %g',varstr,varstr,sum(variable(:))); 
      hca.Title.String = sprintf('%s',varstr); 
      hca.Title.Interpreter = 'none';
      if 0 %abs(himag.CData(not(isnan(himag.CData)))) % dont do if is zero
        hca.CLim = max(abs(himag.CData(:)))*[-1 1];          
      end
      hca.CLim = 0.4*[-1 1];
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;
      %hcb.YLim = ;
      hb(ivar) = hcb;
      %hcb.YLim = hca.CLim(2)*[-1 1];
      colormap(hca,pic_colors('blue_red'));
      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
      if doQ
        for iQ = 1:numel(varstrs_Q)
          hold(hca,'on')
          dataQ = eval(varstrs_Q{iQ}); %dataQx = smooth_data(dataQx);
          dataQx = dataQ.x;
          dataQy = dataQ.z;
          hquiv_tmp = quiver(hca,X(ipxQ,ipzQ),Z(ipxQ,ipzQ),dataQx(ipxQ,ipzQ),dataQz(ipxQ,ipzQ),scaleQ,'color',cQ(iQ,:),'linewidth',1.5);                    
          %hquiv_tmp = quiver(hca,X(ipzQ,ipxQ),Z(ipzQ,ipxQ),dataQx(ipxQ,ipzQ)',dataQz(ipxQ,ipzQ)',scaleQ,'color',cQ(iQ,:));                    
          hold(hca,'off')    
          hquiv(iQ) = hquiv_tmp;
        end
        legend(hquiv(1:numel(varstrs_Q)),varstrs_Q(1:numel(varstrs_Q)))
      end      
    end    
    
    for ipanel = 1:npanels
      h(ipanel).YDir = 'normal';
      h(ipanel).XDir = 'reverse';
      h(ipanel).XLim = xlim;
      h(ipanel).YLim = zlim;   
    end
    
    h(1).Title.String = sprintf('time = %g (1/wci) = %g (1/wpe)',time,timestep);    
    clear hb;
    set(gcf,'color',[1 1 1]);
    
    if 0
    if doMovie(iplot) % Collect frame for movie    
      currentBackgroundColor = get(gcf,'color');
      %set(gcf,'color',[0 1 0]);
      drawnow
      imovie = sum(doMovie(1:iplot));
      tmp_frame = getframe(gcf);
      %cell_movies{imovie}(itime) = tmp_frame;
      if itime == 1 % initialize animated gif matrix
        [im_tmp,map] = rgb2ind(tmp_frame.cdata,256,'nodither');
        %map(end+1,:) = get(gcf,'color');
        im_tmp(1,1,1,ntimes) = 0;
        cell_movies{imovie,1} = map;
        cell_movies{imovie,2} = im_tmp;
      else
        cell_movies{imovie,2}(:,:,1,itime) = rgb2ind(tmp_frame.cdata,cell_movies{imovie,1},'nodither');
      end       
    else % print
      print('-dpng','-r200',[savedir '/' savestr '.png']);
    end
    end
    
  end
  if 0 % B.y with vi1 and vi2
    %%
    % Save and print info     
    subdir = 'mov/';
    
    % Plot part of data   
    xlim = [0 100]; [x(1) x(end)];
    zlim = [0 7];   [z(1) z(end)];

    ix1 = find(x>xlim(1),1,'first');
    ix2 = find(x<xlim(2),1,'last');
    iz1 = find(z>zlim(1),1,'first');
    iz2 = find(z<zlim(2),1,'last');
    ipx = ix1:2:ix2; % every second index, just to save some time
    ipz = iz1:2:iz2;
    
    % set figure position
    screensize = get(groot,'Screensize');
    figure_position(1) = 1;
    figure_position(2) = 1;
    figure_position(3) = 1200;%screensize(3)/4*ncols;
    figure_position(4) = 400;%figure_position(3)*nrows/ncols*0.5;
    %figure_position(3) = screensize(3)/4*ncols;
    %figure_position(4) = figure_position(3)*nrows/ncols*0.5;
    
    savedir = [savedir_root,subdir];
    %mkdir(savedir)
    %savestr = sprintf('%s_t%05.0f',subdir,timestep);            

    doQ = 1;
    varstrs_Q = {'E','vi1'};
    %varstrs_Q = {'vi'};
    cQ = pic_colors('1m');%[0 0 0;pic_colors];
    scaleQ = 1;
    ipxQ = ix1:25:ix2;
    ipzQ = iz1:15:iz2; 
    
    % Initialize figure
    fig = figure(102);
    fig.Position = figure_position;

    nrows = 1;
    ncols = 1;
    npanels = nrows*ncols;
    h = setup_subplots(nrows,ncols);
    isub = 1; 
   
    if 1 % B.y
      hca = h(isub); isub = isub + 1;
      varstr = 'B.y';
      variable = eval(varstr);
      himag = imagesc(hca,x(ipx),z(ipz),variable(ipx,ipz)');
      hca.XLabel.String = 'x (d_i)';
      hca.YLabel.String = 'z (d_i)';
      %hca.Title.String = sprintf('%s, sum(%s) = %g',varstr,varstr,sum(variable(:))); 
      hca.Title.String = sprintf('%s',varstr); 
      hca.Title.Interpreter = 'none';
      if 0 %abs(himag.CData(not(isnan(himag.CData)))) % dont do if is zero
        hca.CLim = max(abs(himag.CData(:)))*[-1 1];          
      end
      hca.CLim = 0.4*[-1 1];
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;
      %hcb.YLim = ;
      hb(ivar) = hcb;
      %hcb.YLim = hca.CLim(2)*[-1 1];
      colormap(hca,pic_colors('blue_red'));
      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
      if doQ
        for iQ = 1:numel(varstrs_Q)
          hold(hca,'on')
          dataQ = eval(varstrs_Q{iQ}); %dataQx = smooth_data(dataQx);
          dataQx = dataQ.x;
          dataQy = dataQ.z;
          hquiv_tmp = quiver(hca,X(ipxQ,ipzQ),Z(ipxQ,ipzQ),dataQx(ipxQ,ipzQ),dataQz(ipxQ,ipzQ),scaleQ,'color',cQ(iQ,:),'linewidth',1.5);                    
          %hquiv_tmp = quiver(hca,X(ipzQ,ipxQ),Z(ipzQ,ipxQ),dataQx(ipxQ,ipzQ)',dataQz(ipxQ,ipzQ)',scaleQ,'color',cQ(iQ,:));                    
          hold(hca,'off')    
          hquiv(iQ) = hquiv_tmp;
        end
        legend(hquiv(1:numel(varstrs_Q)),varstrs_Q(1:numel(varstrs_Q)))
      end      
    end    
    
    for ipanel = 1:npanels
      h(ipanel).YDir = 'normal';
      h(ipanel).XDir = 'reverse';
      h(ipanel).XLim = xlim;
      h(ipanel).YLim = zlim;   
    end
    
    h(1).Title.String = sprintf('time = %g (1/wci) = %g (1/wpe)',time,timestep);    
    clear hb;
    set(gcf,'color',[1 1 1]);
    
    if 0
    if doMovie(iplot) % Collect frame for movie    
      currentBackgroundColor = get(gcf,'color');
      %set(gcf,'color',[0 1 0]);
      drawnow
      imovie = sum(doMovie(1:iplot));
      tmp_frame = getframe(gcf);
      %cell_movies{imovie}(itime) = tmp_frame;
      if itime == 1 % initialize animated gif matrix
        [im_tmp,map] = rgb2ind(tmp_frame.cdata,256,'nodither');
        %map(end+1,:) = get(gcf,'color');
        im_tmp(1,1,1,ntimes) = 0;
        cell_movies{imovie,1} = map;
        cell_movies{imovie,2} = im_tmp;
      else
        cell_movies{imovie,2}(:,:,1,itime) = rgb2ind(tmp_frame.cdata,cell_movies{imovie,1},'nodither');
      end       
    else % print
      print('-dpng','-r200',[savedir '/' savestr '.png']);
    end
    end
    
  end
disp(sprintf('Total elapsed time is %.0f seconds',toc(tstart)))
end