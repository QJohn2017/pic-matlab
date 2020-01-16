 classdef PIC
  % Load PIC simulation data
  %   Does not contain all the data, but loads it in an easily accesible manner  
  %
  %   pic = PIC(h5FilePath)
  %   Bx = pic.Bx; % Bx is a (nt x nx x ny) matrix
  %   B = pic.B; % structure with 3 (nt x nx x ny) matrices  
  
  properties (SetAccess = immutable)
    file
    namelist
    software
    attributes
    info
    species
  end
  
  properties (Access = protected)
    % Access = protected – access from class or subclasses
    % Data can be arbitrary size, so the class contains a pointer to the 
    % data file and each time loads the data with
    fields_
    iteration_
    twpe_
    twci_
    xe_
    ze_
    xi_
    zi_
    grid_
    indices_
    it_
    ix_
    iz_
%    wpewce_ = [];
%    mime_ = [];
    
  end
  
  properties (Dependent = true)
    % Can be checked when setting, for example, right size, right type
    % Dependent properties don't store a value and can't be assigned
    % a value in their set method.
    fields
    iteration
    twpe
    twci
    xe
    ze
    xi
    zi
    grid
    indices
    it
    ix
    iz
    %wpewce
    %mime
    
  end
  
  properties (Constant = true)    
  end
  
  properties (Constant = true, Hidden = true)
    %MAX_TENSOR_ORDER = 2;
    %BASIS = {'xyz','xzy'}; % in order to use, need to define transformations between these
    %BASIS_NAMES = {'smilei','michael'};
  end

  properties (SetAccess = protected)
    wpewce
    mime
    teti
    mass
    charge
  end  
      
  properties
    userData = []; % anything can be added here
  end
  
  methods
    function obj = PIC(h5filePath,nameList)
      % sm = SMILEI(pathFields)
      % sm = SMILEI(pathFields,[],[]) - current implementation
      %
      % Fields:
      %   file - path to hdf5 file
      %   info - hdf5 structure and contents: h5info(file)
      %   mass - mass of species
      %   mime - mp/me
      %   teti - Te0/Tp0 - Harris sheet population
      %   wpewce - wpe0/wce0 (based on B0 and n0) 
      %   iteration - simulation iteration, one iteration is one step
      %   twpe0 - time in inverse electron plasma frequencies
      %   twci0 - time in inverse ion cyclotron frequencies
      %   xe, ze - x, z coordinate in terms of electron inertial lengths
      %   xi, zi - x, z coordinate in terms of proton inertial lengths
      %   m                   
      
      obj.file = h5filePath; 
      obj.info = h5info(h5filePath);
      
      % Check if it's SMILEI or micPIC (mic stands for Michael)
      obj.attributes = get_attributes(obj);
      obj.software = get_software(obj);
      
      if strcmp(obj.software,'Smilei') && nargin == 2
        % meta data
        obj.namelist = nameList;
        namelist = parse_namelist(obj);
        obj.species = namelist.name;
        obj.charge = namelist.charge;
        obj.mass = namelist.mass;
        obj.mime = namelist.mime;
        obj.wpewce = namelist.wpewce;
        obj.teti = namelist.teti;
        % grid
        obj.xe = namelist.xe;
        obj.ze = namelist.ze;
      else strcmp(obj.software,'micPIC')
        % meta data
        obj.charge = obj.get_charge;
        obj.mass = obj.get_mass;
        uniqueMass = sort(unique(obj.mass));
        obj.mime = uniqueMass(2)/uniqueMass(1); % second lightest/lightest
        obj.wpewce = h5read(h5filePath,'/simulation_information/wpewce');
        obj.teti = h5read(h5filePath,'/simulation_information/teti');
        % grid
        obj.xe = h5read(h5filePath,'/simulation_information/xe'); % de
        obj.ze = h5read(h5filePath,'/simulation_information/ze'); % de
      end
      
      obj.xi = obj.xe/sqrt(obj.mime);
      obj.zi = obj.ze/sqrt(obj.mime);
      obj.grid = {1:1:numel(obj.xe),1:1:numel(obj.ze)}; % originally, complete grid
      obj.ix = 1:1:numel(obj.xe);
      obj.iz = 1:1:numel(obj.ze);
      
        
      obj.iteration = get_iterations(obj);      
      obj.twpe = get_twpe(obj);      
      obj.twci = obj.twpe/(obj.wpewce*obj.mime);
      obj.indices_ = 1:numel(obj.iteration);
      obj.it = 1:1:numel(obj.twpe);
      
      obj.fields_ = get_fields(obj);
    end
    
    function [varargout] = subsref(obj,idx)
      %SUBSREF handle indexing
%      nargout
%      idx(:)
      switch idx(1).type
        % Use the built-in subsref for dot notation
        case '.'
          [varargout{1:nargout}] = builtin('subsref',obj,idx);
        case '()'
          %nargout
          % first index is time
          s = substruct(idx(1).type,idx(1).subs(1));
          obj.iteration_ = builtin('subsref',obj.iteration,s);
          obj.twpe_ = builtin('subsref',obj.twpe,s);
          obj.twci_ = builtin('subsref',obj.twci,s);
          obj.indices_ = builtin('subsref',obj.indices,s);
          obj.it_ = builtin('subsref',obj.it,s);
          if numel(idx(1).subs) == 3 % time and two spatial indices
            s = substruct(idx(1).type,idx(1).subs(2));
            newgrid{1} = builtin('subsref',obj.grid{1},s); 
            obj.xe_ = builtin('subsref',obj.xe,s); 
            obj.xi_ = builtin('subsref',obj.xi,s); 
            obj.ix_ = builtin('subsref',obj.ix,s); 
            s = substruct(idx(1).type,idx(1).subs(3));
            newgrid{2} = builtin('subsref',obj.grid{2},s);
            obj.ze_ = builtin('subsref',obj.ze,s); 
            obj.zi_ = builtin('subsref',obj.zi,s); 
            obj.iz_ = builtin('subsref',obj.iz,s); 
            obj.grid_ = newgrid;
            %obj.gridsize_ = [numel(obj.grid{1}),numel(obj.grid{2})];      
          end
          
%           obj.iteration_ = builtin('subsref',obj.iteration,idx(1));
%           obj.twpe_ = builtin('subsref',obj.twpe,idx(1));
%           obj.twci_ = builtin('subsref',obj.twci,idx(1)); 
%           if numel(idx(1).subs)  1 % only time index
%             
%           end
          if numel(idx) > 1
            obj = builtin('subsref',obj,idx(2:end));
          end
          try
          [varargout{1:nargout}] = obj;
          catch
            1;
          end
        case '{}'
          error('SMILEI:subsref',...
            'Not a supported subscripted reference.')
      end
    end  
    
    function value = length(obj)
      value = numel(obj.iteration);
    end
   
    % Get subset of data, time and/or space, using subsrefs for this for
    % now
    function obj = ilim(obj,value)
      % Get subset of output
      obj.twpe_ = obj.twpe_(value);
      obj.twci_ = obj.twci_(value);
      obj.iteration_ = obj.iteration_(value);      
      obj.indices_ = obj.indices_(value);      
    end
    function obj = i(obj,varargin)
      % Get subset of output
      nargs = numel(varargin);
      switch nargs 
        case 1 % time
          it = varargin{1};
          obj = obj.ilim(it);
        case 3 % time, x, z
          it = varargin{1};
          ix = varargin{2};
          iz = varargin{3};
          obj = obj.ilim(it);
          obj.xe_ = obj.xe_(ix);
          obj.xi_ = obj.xi_(ix);      
          obj.grid_{1} = obj.grid_{1}(ix);
          obj.ze_ = obj.ze_(iz);
          obj.zi_ = obj.zi_(iz);      
          obj.grid_{2} = obj.grid_{2}(iz);
        otherwise
          error('Number of inputs not supported.')
      end          
    end
    function obj = xlim(obj,value,varargin)
      % Get subset of x          
      inds = obj.ind_from_lim(obj.xi_,value,varargin{:});
      
      % Update grid and indices
      obj.xe_ = obj.xe_(inds);
      obj.xi_ = obj.xi_(inds);      
      obj.grid_{1} = obj.grid_{1}(inds);
      obj.ix_ = obj.grid_{1};        
    end
    function obj = zlim(obj,value,varargin)
      % Get subset of z
      inds = obj.ind_from_lim(obj.zi_,value,varargin{:});

      obj.ze_ = obj.ze_(inds);
      obj.zi_ = obj.zi_(inds);      
      obj.grid_{2} = obj.grid_{2}(inds);
      obj.iz_ = obj.grid_{2};  
    end
    function obj = twpelim(obj,value,varargin)
      % Get subset of twpe
      inds = obj.ind_from_lim(obj.twpe_,value,varargin{:});
      obj.twpe_ = obj.twpe_(inds);
      obj.twci_ = obj.twci_(inds);
      obj.it_ = obj.it_(inds);
      obj.iteration_ = obj.iteration_(inds);
    end
    function obj = twcilim(obj,value,varargin)
      % Get subset of twci
      inds = obj.ind_from_lim(obj.twci,value,varargin{:});
      obj.twpe_ = obj.twpe_(inds);
      obj.twci_ = obj.twci_(inds);
      obj.it_ = obj.it_(inds);
      obj.indices_ = obj.indices_(inds);
      obj.iteration_ = obj.iteration_(inds);
    end
    
    % Plotting routines, for simple diagnostics etc
    function [all_im, map] = make_gif(obj,fields,nrows,ncols,varargin)
      % [all_im, map] = MAKE_GIF(obj,fields,nrows,ncols)      
      % make gif
      % imwrite(im,map,'delme.gif','DelayTime',0.0,'LoopCount',0)  
      
      % Subsref error: Does not accept two outputs
      
      % Default options, values
      doAdjustCLim = 0;
      cmap = pic_colors('blue_red');
      doA = 0;
      
      nfields = numel(fields);
      ntimes = obj.length;
      
      nargs = numel(varargin);      
      if nargs > 0, have_options = 1; args = varargin(:); end
      
      while have_options
        l = 1;
        switch(lower(args{1}))
          case 'a'            
            if numel(args{2}) == 1              
              doA = args{2};
              levA = -25:1:0;
            else
              doA = 1;
              levA = args{2};
            end            
            args = args(l+1:end);
          case 'clim'
            l = 2;
            doAdjustCLim = 1;  
            clims = args{2};
            args = args(l+1:end);
          otherwise
            warning(sprintf('Input ''%s'' not recognized.',args{1}))
            args = args(l+1:end);
        end        
        if isempty(args), break, end    
      end
      
      % First load all data once and check what color limits we should use.
      %
      if 0% nfields == 1
        all_data = get_field(obj,fields{1});
        cmax = max(all_data(:));
        clim = cmax*[-1 1];
        doAdjustCLim = 1;
        cmap = pic_colors('blue_red');
      end
      
      % setup figure
      fig = figure;
      h = setup_subplots(nrows,ncols); % external function, must include in SMILEI.m
      disp('Adjust figure size, then hit any key to continue.')
      pause
      for itime = 1:ntimes
        for ifield = 1:nfields
          %tic;
          hca = h(ifield);
          S(1).type='()'; S(1).subs = {itime};
          data = get_field(obj.subsref(S),fields{ifield});
          imagesc(hca,obj.xi,obj.zi,squeeze(data)')
          hb = colorbar('peer',hca);
          hb.YLabel.String = fields{ifield};
          if doAdjustCLim
            hca.CLim = clims{ifield};            
            %colormap(cmap)
          end
          if doA
            hold(hca,'on')
            iAx = 1:4:obj.nx;
            iAz = 1:4:obj.nz;
            A = squeeze(get_field(obj.subsref(S),'A'));
            contour(hca,obj.xi(iAx),obj.zi(iAz),A(iAx,iAz)',levA,'k');
            hold(hca,'off')
          end
          hca.YDir = 'normal';
          hca.XLabel.String = 'x/d_i';
          hca.YLabel.String = 'z/d_i';
          %toc
        end
        if itime == 1
          colormap(cmap)
        end
        pause(0.1)
        if 1 % collect frames, for making gif
          iframe = itime;
          nframes = ntimes;
          currentBackgroundColor = get(gcf,'color');
          set(gcf,'color',[1 1 1]);
          drawnow      
          tmp_frame = getframe(gcf);
          %cell_movies{imovie}(itime) = tmp_frame;
          if iframe == 1 % initialize animated gif matrix
            [im_tmp,map] = rgb2ind(tmp_frame.cdata,256,'nodither');
            %map(end+1,:) = get(gcf,'color');
            im_tmp(1,1,1,nframes) = 0;                                                
            all_im = im_tmp;
          else
            all_im(:,:,1,iframe) = rgb2ind(tmp_frame.cdata,map,'nodither');
          end       
        end
      end
      %out = {all_im,map};
      
      % collect frames
      
    end
              
    % Data analysis routines, time derivatives, interpolation, etc.
    % Interpolate fields
    
    function out = interp(obj,x,z,t,field,varargin)
      % Interpolates fields to given x,z,t
      
      % Check input
      
      % Check if inteprolation is needed
      
      % Load bounding data
      
      % Interpolate field to a any number of point (x,z,t)
      %
      % PIC.INTERP_EB3 - Interpolate for a number of given points.
      %
      % To be implemented:
      %  - interpolation for several timesteps
      %  - shape preserving interpolation
      %  - different interpolation types for temporal and spatial
      %    dimensions, particularly important for temporal dimension where
      %    the time steps are quite large
      
      method = 'linear';
      if strcmp(method,'linear')
        nClosest = 2;
      end
      
      nPoints = numel(t);      
      var = nan(nPoints,1);
      
      for iP = 1:nPoints      
        tmppic = obj.xlim(x(iP),'closest',nClosest).zlim(z(iP),'closest',nClosest).twcilim(t(iP),'closest',nClosest);  

        tmpt =  tmppic.twci;
        tmpx =  tmppic.xi;
        tmpz =  tmppic.zi;
        tmpvar = tmppic.(field);
      
        % Interpolate to particle position
        % Vq = interp3(V,Xq,Yq,Zq) assumes X=1:N, Y=1:M, Z=1:P where [M,N,P]=SIZE(V).      

        [X,Z,T] = meshgrid(tmpx,tmpz,tmpt);        
        var(iP) = interp3(X,Z,T,permute(tmpvar,[2 1 3]),x(iP),z(iP),t(iP),method);        
      end
      out = var;
    end
    function [Ex,Ey,Ez,Bx,By,Bz] = interp_EB(obj,x,z,t)
      % Interpolate field to a given point (x,z,t)
      %
      % To be implemented:
      %  - interpolation for several timesteps
      %  - shape preserving interpolation
      %  - different interpolation types for temporal and spatial
      %    dimensions, particularly important for temporal dimension where
      %    the time steps are quite large
      
      method = 'linear';
      if strcmp(method,'linear')
        nClosestT = 2;
        nClosestXZ = 5;
      end
      method = 'spline';
      
      nPoints = numel(t); 
      
      tmppic = obj.xlim(x,'closest',nClosestXZ).zlim(z,'closest',nClosestXZ).twcilim(t,'closest',nClosestT);  
      
      tmpt =  tmppic.twci;
      tmpx =  tmppic.xi;
      tmpz =  tmppic.zi;
      tmpEx = tmppic.Ex; %tmpEx(:,:,1) = smooth2(tmpEx(:,:,1),2,2); tmpEx(:,:,2) = smooth2(tmpEx(:,:,2),2,2);
      tmpEy = tmppic.Ey; 
      tmpEz = tmppic.Ez;
      tmpBx = tmppic.Bx;
      tmpBy = tmppic.By;
      tmpBz = tmppic.Bz;
      
      % Interpolate to particle position
      % Vq = interp3(V,Xq,Yq,Zq) assumes X=1:N, Y=1:M, Z=1:P where [M,N,P]=SIZE(V).      

      [X,Z,T] = meshgrid(tmpx,tmpz,tmpt);
      Ex = interp3(X,Z,T,permute(tmpEx,[2 1 3]),x,z,t,method);
      Ey = interp3(X,Z,T,permute(tmpEy,[2 1 3]),x,z,t,method);
      Ez = interp3(X,Z,T,permute(tmpEz,[2 1 3]),x,z,t,method);
      Bx = interp3(X,Z,T,permute(tmpBx,[2 1 3]),x,z,t,method);
      By = interp3(X,Z,T,permute(tmpBy,[2 1 3]),x,z,t,method);
      Bz = interp3(X,Z,T,permute(tmpBz,[2 1 3]),x,z,t,method);
      
      %disp(sprintf('intEx = %g, meanEx = %g',Ex,mean(tmpEx(:))))
      % For debugging purposes
%       doPlot = 1;
%       if doPlot
%         figure(31)
%         if mod(nClosest,2) == 0 % even number          
%           hca = subplot(1,2,2);
%         else
%           hca = subplot(1,2,1);
%         end
%         scale = 2000;
%         scatter3(hca,X(:),Z(:),T(:),abs(tmpEx(:))*scale,abs(tmpEx(:)))
%         for ip = 1:numel(X)
%           text(hca,X(ip),Z(ip),T(ip),sprintf('%.3f',tmpEx(ip)))
%         end
%         hb = colorbar('peer',hca);
%         %plot3(hca,X(:),Z(:),T(:),'k.',x,z,t,'ro')
%         hold(hca,'on')
%         plot3(hca,x,z,t,'k+')
%         scatter3(hca,x,z,t,abs(Ex)*scale,abs(Ex))
%         hold(hca,'off')
%         hca.XLabel.String = 'x';
%         hca.YLabel.String = 'z';
%         hca.ZLabel.String = 't';
%         %pause
%       end
    end
    function [Ex,Ey,Ez,Bx,By,Bz] = interp_EB3(obj,x,z,t)
      % Interpolate field to a any number of point (x,z,t)
      %
      % PIC.INTERP_EB3 - Interpolate for a number of given points.
      %
      % To be implemented:
      %  - interpolation for several timesteps
      %  - shape preserving interpolation
      %  - different interpolation types for temporal and spatial
      %    dimensions, particularly important for temporal dimension where
      %    the time steps are quite large
      
      method = 'linear';
      if strcmp(method,'linear')
        nClosest = 2;
      end
      
      nPoints = numel(t);
      
      Ex = nan(nPoints,1);
      Ey = nan(nPoints,1);
      Ez = nan(nPoints,1);
      Bx = nan(nPoints,1);
      By = nan(nPoints,1);
      Bz = nan(nPoints,1);
      
      for iP = 1:nPoints
      
        tmppic = obj.xlim(x(iP),'closest',nClosest).zlim(z(iP),'closest',nClosest).twcilim(t(iP),'closest',nClosest);  

        tmpt =  tmppic.twci;
        tmpx =  tmppic.xi;
        tmpz =  tmppic.zi;
        tmpEx = tmppic.Ex;
        tmpEy = tmppic.Ey;
        tmpEz = tmppic.Ez;
        tmpBx = tmppic.Bx;
        tmpBy = tmppic.By;
        tmpBz = tmppic.Bz;
      
        % Interpolate to particle position
        % Vq = interp3(V,Xq,Yq,Zq) assumes X=1:N, Y=1:M, Z=1:P where [M,N,P]=SIZE(V).      

        [X,Z,T] = meshgrid(tmpx,tmpz,tmpt);
        try
        Ex(iP) = interp3(X,Z,T,permute(tmpEx,[2 1 3]),x(iP),z(iP),t(iP),method);
        Ey(iP) = interp3(X,Z,T,permute(tmpEy,[2 1 3]),x(iP),z(iP),t(iP),method);
        Ez(iP) = interp3(X,Z,T,permute(tmpEz,[2 1 3]),x(iP),z(iP),t(iP),method);
        Bx(iP) = interp3(X,Z,T,permute(tmpBx,[2 1 3]),x(iP),z(iP),t(iP),method);
        By(iP) = interp3(X,Z,T,permute(tmpBy,[2 1 3]),x(iP),z(iP),t(iP),method);
        Bz(iP) = interp3(X,Z,T,permute(tmpBz,[2 1 3]),x(iP),z(iP),t(iP),method);
        catch
          1;
        end
      
      end
    end
    function [Ex,Ey,Ez,Bx,By,Bz] = interp_EB2(obj,x,z,t)
      % Interpolate field to a given point (x,z,t)
      %
      % PIC.INTERP_EB2 - Different interpolation for time and space 
      %
      % To be implemented:
      %  - interpolation for several timesteps
      %  - shape preserving interpolation
      %  - different interpolation types for temporal and spatial
      %    dimensions, particularly important for temporal dimension where
      %    the time steps are quite large
   
      nClosestXZ = 2;
      nClosestT = 5;            
      
      tmppic = obj.xlim(x,'closest',nClosestXZ).zlim(z,'closest',nClosestXZ).twcilim(t,'closest',nClosestT);
      
      tmpt =  tmppic.twci;
      tmpx =  tmppic.xi;
      tmpz =  tmppic.zi;
      tmpEx = tmppic.Ex;
      tmpEy = tmppic.Ey;
      tmpEz = tmppic.Ez;
      tmpBx = tmppic.Bx;
      tmpBy = tmppic.By;
      tmpBz = tmppic.Bz;
      
      % Interpolate to particle position
      % Vq = interp3(V,Xq,Yq,Zq) assumes X=1:N, Y=1:M, Z=1:P where [M,N,P]=SIZE(V).      

%      for iT = 1:nClosestT
        
      [X,Z,T] = meshgrid(tmpx,tmpz,tmpt);
      Ex = interp3(X,Z,T,permute(tmpEx,[2 1 3]),x,z,t,method);
      Ey = interp3(X,Z,T,permute(tmpEy,[2 1 3]),x,z,t,method);
      Ez = interp3(X,Z,T,permute(tmpEz,[2 1 3]),x,z,t,method);
      Bx = interp3(X,Z,T,permute(tmpBx,[2 1 3]),x,z,t,method);
      By = interp3(X,Z,T,permute(tmpBy,[2 1 3]),x,z,t,method);
      Bz = interp3(X,Z,T,permute(tmpBz,[2 1 3]),x,z,t,method);
      
   
    end
    function [vx,vy,vz] = interp_v(obj,x,z,t,iSpecies)
      % Interpolate field to a given point (x,z,t)
      %   [vx,vy,vz] = interp_v(obj,x,z,t,iSpecies)
      %
      % To be implemented:
      %  - interpolation for several timesteps
      %  - shape preserving interpolation
      %  - different interpolation types for temporal and spatial
      %    dimensions, particularly important for temporal dimension where
      %    the time steps are quite large
      
      method = 'linear';
      if strcmp(method,'linear')
        nClosest = 2;
      end
      
      nPoints = numel(t); 
      
      tmppic = obj.xlim(x,'closest',nClosest).zlim(z,'closest',nClosest).twcilim(t,'closest',nClosest);  
      
      tmpt =  tmppic.twci;
      tmpx =  tmppic.xi;
      tmpz =  tmppic.zi;
      tmpVx = tmppic.vx(iSpecies);
      tmpVy = tmppic.vy(iSpecies);
      tmpVz = tmppic.vz(iSpecies);

      % Interpolate to particle position
      % Vq = interp3(V,Xq,Yq,Zq) assumes X=1:N, Y=1:M, Z=1:P where [M,N,P]=SIZE(V).      

      [X,Z,T] = meshgrid(tmpx,tmpz,tmpt);
      vx = interp3(X,Z,T,permute(tmpVx,[2 1 3]),x,z,t,method);
      yy = interp3(X,Z,T,permute(tmpVy,[2 1 3]),x,z,t,method);
      zz = interp3(X,Z,T,permute(tmpVz,[2 1 3]),x,z,t,method);
      
    end
    function out = integrate_trajectory(obj,r0,v0,tspan,m,q)
      % out = integrate_trajectory(r0,v0,tspan,m,q)
      % tspan = [tstart tstop] - only back or forward, if tstart > tstop, integrating is done backward in time
      %     or  [tstop_back tstart tstop_forw] -  integration is done forward and backward      
      
      doPrintInfo = 0;
      
      if numel(tspan) == 2 % [tstart tstop]
        tstart = tspan(1);
        tstop_all = tspan(2);
      elseif numel(tspan) == 3 % [tstop_back tstart tstop_forw]
        tstart = tspan(2);
        tstop_all = tspan([1 3]);
      end
      
      x_sol = [];
      for tstop = tstop_all        
        % Print information
        if doPrintInfo
          if tstart < tstop, disp(['Integrating trajectory forward in time.'])
          else, disp(['Integrating trajectory backward in time.'])
          end
        end
        ttot = tic;
        x_init = [r0, v0]; % di, vA
        disp(sprintf('tstart = %5.2f, tstop = %5.2f, [x0,y0,z0] = [%5.1f, %5.1f, %5.1f], [vx0,vy0,vz0] = [%5.2f, %5.2f, %5.2f]',...
          tstart,tstop,x_init(1),x_init(2),x_init(3),x_init(4),x_init(5),x_init(6)))

        % Integrate trajectory
        options = odeset();
        options = odeset('AbsTol',1e-14,'Events',@exitBox);
        %options = odeset('AbsTol',1e-7,'AbsTol',1e-9,'Events',@exitBox);
        %options = odeset('RelTol',1e-6);
        EoM = @(ttt,xxx) eom_pic(ttt,xxx,obj,m,q); 

        [t,x_sol_tmp] = ode45(EoM,[tstart tstop],x_init,options);%,options); % 
        x_sol_tmp(:,7) = t; % x_sol = (x,y,z,vx,vy,vz,t)

        x_sol = [x_sol; x_sol_tmp];
        
        doPlot = 0; % diagnostics
        if doPlot
          %%
          h = setup_subplots(2,2);

          hca = h(1);
          plot3(hca,x_sol(:,1),x_sol(:,2),x_sol(:,3),...
                    x_sol(1,1),x_sol(1,2),x_sol(1,3),'g*',...
                    x_sol(end,1),x_sol(end,2),x_sol(end,3),'r*')
          hca.XLabel.String = 'x';
          hca.YLabel.String = 'y';        
          hca.ZLabel.String = 'z';
          hca.XGrid = 'on';
          hca.YGrid = 'on';
          hca.ZGrid = 'on';

          hca = h(2);
          plot(hca,x_sol(:,4),x_sol(:,5),...
                    x_sol(1,4),x_sol(1,5),'g*',...
                    x_sol(end,4),x_sol(end,5),'r*')
          hca.XLabel.String = 'vx';
          hca.YLabel.String = 'vy';
          hca.XGrid = 'on';
          hca.YGrid = 'on';

          hca = h(3);
          plot(hca,x_sol(:,4),x_sol(:,6),...
                    x_sol(1,4),x_sol(1,6),'g*',...
                    x_sol(end,4),x_sol(end,6),'r*')
          hca.XLabel.String = 'vx';
          hca.YLabel.String = 'vz';
          hca.XGrid = 'on';
          hca.YGrid = 'on';

          hca = h(4);
          plot(hca,x_sol(:,5),x_sol(:,6),...
                    x_sol(1,5),x_sol(1,6),'g*',...
                    x_sol(end,5),x_sol(end,6),'r*')
          hca.XLabel.String = 'vy';
          hca.YLabel.String = 'vz';
          hca.XGrid = 'on';
          hca.YGrid = 'on';
          drawnow
        end
        tt = toc(ttot);
        %out = x_sol;
      end
      % sort by time
      [~,I] = sort(x_sol(:,7));
      out.t = x_sol(I,7);
      out.x = x_sol(I,1);
      out.y = x_sol(I,2);
      out.z = x_sol(I,3);
      out.vx = x_sol(I,4);
      out.vy = x_sol(I,5);
      out.vz = x_sol(I,6);
      out.x0 = r0(1);
      out.y0 = r0(2);
      out.z0 = r0(3);
      out.vx0 = v0(1);
      out.vy0 = v0(2);
      out.vz0 = v0(3);
      out.options = options;      
    end    
    function out = integrate_trajectory_constant_EB(obj,r0,v0,tstart,tstop,m,q)
      % out = integrate_trajectory(r0,v0,tstart,tstop,m,q)
      % if tstart > tstop, integrating is done backward in time
      
      T = tstop-tstart;
      
      if T > 0
        doForward = 1;
        %integration_string = 'forward';
        disp(['Integrating trajectory forward in time.'])
      else
        doForward = 0;
        %integration_string = 'backward';
        disp(['Integrating trajectory backward in time.'])        
      end
            
      
      ttot = tic;
      x_init = [r0, v0]; % di, vA
      disp(sprintf('tstart = %5.2f, tstop = %5.2f, [x0,y0,z0] = [%5.1f, %5.1f, %5.1f], [vx0,vy0,vz0] = [%5.2f, %5.2f, %5.2f]',...
        tstart,tstop,x_init(1),x_init(2),x_init(3),x_init(4),x_init(5),x_init(6)))

      % Integrate trajectory
      options = odeset('AbsTol',1e-14);
      [XI,ZI] = meshgrid(obj.xi,obj.zi);
      fields.x = XI;
      fields.z = ZI;
      fields.Bx = obj.Bx;
      fields.By = obj.By;
      fields.Bz = obj.Bz;
      fields.Ex = smooth_data(obj.Ex,10);
      fields.Ey = smooth_data(obj.Ey,10);
      fields.Ez = smooth_data(obj.Ez,10);
      
      if doForward
        EoM = @(ttt,xxx) eom_pic(ttt,xxx,fields,m,q);
      else
        %EoM = @(ttt,xxx) eom_pic_back(ttt,xxx,obj,m,q);
        EoM = @(ttt,xxx) eom_pic(ttt,xxx,fields,m,q);
      end        
      [t,x_sol] = ode45(EoM,[tstart tstop],x_init,options);%,options); % 
      x_sol(:,7) = t; % x_sol = (x,y,z,vx,vy,vz,t)

      doPlot = 1;
      if doPlot
        %%
        h = setup_subplots(2,2);
        
        hca = h(1);
        plot3(hca,x_sol(:,1),x_sol(:,2),x_sol(:,3),...
                  x_sol(1,1),x_sol(1,2),x_sol(1,3),'g*',...
                  x_sol(end,1),x_sol(end,2),x_sol(end,3),'r*')
        hca.XLabel.String = 'x';
        hca.YLabel.String = 'y';        
        hca.ZLabel.String = 'z';
        hca.XGrid = 'on';
        hca.YGrid = 'on';
        hca.ZGrid = 'on';
        
        hca = h(2);
        plot(hca,x_sol(:,4),x_sol(:,5),...
                  x_sol(1,4),x_sol(1,5),'g*',...
                  x_sol(end,4),x_sol(end,5),'r*')
        hca.XLabel.String = 'vx';
        hca.YLabel.String = 'vy';
        hca.XGrid = 'on';
        hca.YGrid = 'on';
        
        hca = h(3);
        plot(hca,x_sol(:,4),x_sol(:,6),...
                  x_sol(1,4),x_sol(1,6),'g*',...
                  x_sol(end,4),x_sol(end,6),'r*')
        hca.XLabel.String = 'vx';
        hca.YLabel.String = 'vz';
        hca.XGrid = 'on';
        hca.YGrid = 'on';
        
        hca = h(4);
        plot(hca,x_sol(:,5),x_sol(:,6),...
                  x_sol(1,5),x_sol(1,6),'g*',...
                  x_sol(end,5),x_sol(end,6),'r*')
        hca.XLabel.String = 'vy';
        hca.YLabel.String = 'vz';
        hca.XGrid = 'on';
        hca.YGrid = 'on';
        drawnow
      end
      toc(ttot)
      %out = x_sol;
      out.t = x_sol(:,7);
      out.x = x_sol(:,1);
      out.y = x_sol(:,2);
      out.z = x_sol(:,3);
      out.vx = x_sol(:,4);
      out.vy = x_sol(:,5);
      out.vz = x_sol(:,6);
    end
    
    % Get simulation meta data and parameters 
    function out = parse_namelist(obj)
      % PARSE_NAMELIST Find basic information of simulation.
      % textscan
      % regexp
      
      buffer = fileread(obj.namelist);
      % Simulation information
      out.mime = str2double(regexpi(buffer, '(?<=mime\s*=\s*)\d*', 'match'));
      out.wpewce = str2double(regexpi(buffer, '(?<=wpewce\s*=\s*)\d*', 'match'));
      out.c = str2double(regexpi(buffer, '(?<=c\s*=\s*)\d*', 'match'));     
      out.teti = str2double(regexpi(buffer, '(?<=theta\s*=\s*)(\d*\.\d*|\d*)', 'match'));
      % Plasma species information
      names = regexpi(buffer, '(?<=name\s*=\s*)''(\w*)''', 'match');
      for iname = 1:numel(names)
        names{iname} = strrep(names{iname},'''','');
      end
      out.name = names;
      mass_ = regexpi(buffer, '(?<=mass\s*=\s*)(\w*|\d*)', 'match');
      for imass = 1:numel(mass_)
      if strcmp(mass_{imass},'mime')
        out.mass(imass) = out.mime;
      else
        out.mass(imass) = str2double(mass_{imass});
      end
      end
        
      out.charge = str2double(regexpi(buffer, '(?<=charge\s*=\s*)(-\d*|\d*)', 'match'));
      
      % expression for box size
      [~,gr] = grep('-s',regexpi(buffer,'\nbox_size\s*=\s*','match'),obj.namelist);
      str_box_size = gr.match{1};
      str_box_size = strrep(str_box_size,'m.','');
      str_box_size = strrep(str_box_size,'mime','out.mime');
      eval([str_box_size,';']);
      resx = str2double(regexpi(buffer, '(?<=resx\s*=\s*)\d*', 'match'));
      resy = str2double(regexpi(buffer, '(?<=resy\s*=\s*)\d*', 'match'));
      cell_length = [1./resx, 1./resy];
      grid_length = box_size;
      out.nx = box_size(1)/cell_length(1);
      out.nz = box_size(2)/cell_length(2);
      out.xe = 0:cell_length(1):(box_size(1));
      out.ze = 0:cell_length(2):(box_size(2));
      %particles_per_cell = regexpi(buffer, '(?<=particles_per_cell\s*=\s*)''\w*''', 'match');
      
      %number_of_patches = str2double(regexpi(buffer, '(?<=number_of_patches \s* = \s*[)\d*(])', 'match'));
      
    end
    function out = get_software(obj)
      nAttr = numel(obj.info.Attributes);
      for iAttr = 1:nAttr
        %attributes{iAttr} = obj.info.Attributes(iAttr).Name;
        if strcmp(obj.info.Attributes(iAttr).Name,'software')
          out = obj.info.Attributes(iAttr).Value;
          return
        end
      end
    end
    function out = get_attributes(obj)
      nAttr = numel(obj.info.Attributes);
      for iAttr = 1:nAttr
        attributes.(obj.info.Attributes(iAttr).Name) = obj.info.Attributes(iAttr).Value;        
      end
      out = attributes;
    end
    function out = get_twpe(obj)
      fileInfo = obj.info;
      iGroup = find(contains({fileInfo.Groups.Name},'/data'));
      nIter = numel(fileInfo.Groups(iGroup).Groups); % number of iterations
      
      for iIter = 1:nIter
        % /data/00000xxxxx/ 
        % redo to actually find the 
        iAtt = find(contains({fileInfo.Groups(iGroup).Groups(iIter).Attributes.Name},'time'));
        time(iIter) = fileInfo.Groups(iGroup).Groups(iIter).Attributes(iAtt).Value;
      end
      out = time;
    end
    function out = get_iterations(obj)
      fileInfo = obj.info;
      iGroup = find(contains({fileInfo.Groups.Name},'/data'));
      nOutput = numel(fileInfo.Groups(iGroup).Groups);
      for iOutput = 1:nOutput
        str = fileInfo.Groups(iGroup).Groups(iOutput).Name;
        split_str = strsplit(str,'/');
        iterations(iOutput) = str2num(split_str{3});
      end

      out = iterations;
    end
    function out = get_fields(obj)
      %%
      % needs to be adapted for the species subgroups
      fileInfo = obj.info;
      % fields structure is the same for all times, but different for
      % micPIC and Smilei      
      if strcmp(obj.software,'micPIC') % plasma moments are in subgroup with datasets for each species
        fields = {fileInfo.Groups(1).Groups(1).Datasets.Name};
        split_str = cellfun(@(x) strsplit(x,'/'),{fileInfo.Groups(1).Groups(1).Groups.Name},'UniformOutput',false);
        for iout = 1:numel(split_str)
          fields{end+1} = split_str{iout}{end};
        end
      else % all data are in the same group
        all_fields = {fileInfo.Groups(1).Groups(1).Datasets.Name};
        namelist = parse_namelist(obj);        
        species = namelist.name;      
        ifield = 1;
        for iOut = 1:numel(all_fields)              
          if strfind(all_fields{iOut},'_') % is plasma field
            tokens = strsplit(all_fields{iOut},'_');
            % check if field already exist            
            tmp = cellfun(@(x)logical(strfind(x,tokens{1})),fields,'UniformOutput',false);            
            if isempty([tmp{:}])                       
              fields{ifield} = tokens{1};
            else
              continue;
            end
          else
            fields{ifield} = all_fields{iOut};
          end
          ifield = ifield + 1;
        end
      end
      out = fields;
    end
    function out = get_gridsize(obj)
      out = [numel(obj.xe) numel(obj.ze)];
    end
    function out = get_mass(obj)
      fileInfo = obj.info;
      if strcmp(obj.software,'micPIC')
        iGroup = find(contains({fileInfo.Groups.Name},'/data'));
        iAtt = find(contains({fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets(1).Attributes.Name},'mass'));
        nSpecies = numel(fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets);
        for iSpecies = 1:nSpecies
          mass(iSpecies) = fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets(iSpecies).Attributes(iAtt).Value;
        end
        out = mass;
      else
        out = [];
      end
    end
    function out = get_charge(obj)
      fileInfo = obj.info;
      if strcmp(obj.software,'micPIC')
        iGroup = find(contains({fileInfo.Groups.Name},'/data'));
        iAtt = find(contains({fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets(1).Attributes.Name},'charge'));
        nSpecies = numel(fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets);
        for iSpecies = 1:nSpecies
        charge(iSpecies) = fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets(iSpecies).Attributes(iAtt).Value;
        end
        out = charge;
      else 
        out = obj.charge; % this was already loaded in using namelist
      end      
    end
    function out = get_dfac(obj)
      fileInfo = obj.info;
      iGroup = find(contains({fileInfo.Groups.Name},'/data'));
      iAtt = find(contains({fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets(1).Attributes.Name},'dfac'));
      nSpecies = numel(fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets);
      for iSpecies = 1:nSpecies
        dfac(iSpecies) = fileInfo.Groups(iGroup).Groups(1).Groups(1).Datasets(iSpecies).Attributes(iAtt).Value;
      end
      out = dfac;
    end
    function out = nx(obj)
      out = numel(obj.xi);
    end
    function out = nz(obj)
      out = numel(obj.zi);
    end
    function out = nt(obj)
      out = obj.length;
    end
    
    % Get fields
    function out = A(obj)
      if any(contains(obj.fields,'A')) % stored as field
        out = get_field(obj,'A');
      else % calculate it
         if strcmp(obj.software,'micPIC')
          Bx =  obj.Bx;
          Bz =  obj.Bz;
          A = calc_A(obj.xi,obj.zi,Bx,Bz);
        elseif strcmp(obj.software,'Smilei')
          Bx =  obj.Bx;
          By =  obj.By;
          A = calc_A(obj.xi,obj.zi,Bx,By);
        end
      end
      out = A;
      % nested function
      function out = calc_A(x,z,bx,bz)
        % Grid
        dx = x(2)-x(1);
        dz = z(2)-z(1);
        nz = numel(z);
        nx = numel(x);


        ntimes = size(bx,3);
        A = bx*0;
        for itime = 1:ntimes
          bx_tmp = squeeze(bx(:,:,itime));
          bz_tmp = squeeze(bz(:,:,itime));
          A_tmp = zeros(nx,nz);
          % Dont put zero right at the edge 
          ixm = 10;    
          % Advance up
          A_tmp(ixm,:) = cumsum(bx_tmp(ixm,:),2)*dz;
          % Advance to the right
          A_tmp((ixm+1):end,:) = repmat(A_tmp(ixm,:),nx-ixm,1) + cumsum(-bz_tmp((ixm+1):end,:),1)*dx;
          % Advance to the left
          A_tmp((ixm-1):-1:1,:) = repmat(A_tmp(ixm,:),ixm-1,1) + cumsum(-bz_tmp((ixm-1):-1:1,:),1)*dx;
          A(:,:,itime) = A_tmp;
        end
        out = A;
      end
    end
    function out = Bx(obj)
      if strcmp(obj.software,'micPIC')
        out = get_field(obj,'bx')*obj.wpewce;
      elseif strcmp(obj.software,'Smilei')
        out = get_field(obj,'Bx')*obj.wpewce;
      end
    end
    function out = By(obj)
      if strcmp(obj.software,'micPIC')
        out = get_field(obj,'by')*obj.wpewce;
      elseif strcmp(obj.software,'Smilei')
        out = get_field(obj,'By')*obj.wpewce;
      end
    end
    function out = Bz(obj)
      if strcmp(obj.software,'micPIC')
        out = get_field(obj,'bz')*obj.wpewce;
      elseif strcmp(obj.software,'Smilei')
        out = get_field(obj,'Bz')*obj.wpewce;
      end
    end
    function out = Ex(obj)
      if strcmp(obj.software,'micPIC')
        out = get_field(obj,'ex')*sqrt(obj.mime)*obj.wpewce^2;
      elseif strcmp(obj.software,'Smilei')
        out = get_field(obj,'Ex')*sqrt(obj.mime)*obj.wpewce^2;
      end      
    end
    function out = Ey(obj)
      if strcmp(obj.software,'micPIC')
        out = get_field(obj,'ey')*sqrt(obj.mime)*obj.wpewce^2;
      elseif strcmp(obj.software,'Smilei')
        out = get_field(obj,'Ey')*sqrt(obj.mime)*obj.wpewce^2;
      end      
    end
    function out = Ez(obj)
      if strcmp(obj.software,'micPIC')
        out = get_field(obj,'ez')*sqrt(obj.mime)*obj.wpewce^2;
      elseif strcmp(obj.software,'Smilei')
        out = get_field(obj,'Ez')*sqrt(obj.mime)*obj.wpewce^2;
      end     
    end    
    function out = PB(obj)
      % Magnetic field pressure
      %   out = PB(obj,value)      
      Bx = obj.Bx;
      By = obj.By;
      Bz = obj.Bz;
      out = 0.5*(Bx.^2 + By.^2 + Bz.^2);
    end
    
    % Density
    function out = n(obj,species)
      % Get density n of selected populations
      
      % Check that only a single species is given (unique charge)
      % Different masses are ok (for example protons and oxygen)
      if not(numel(unique(obj.charge(species))) == 1)
        error('Selected species have different mass and/or charge. This is not supported.')
      end
      nSpecies = numel(species);
      
      if strcmp(obj.software,'micPIC')
        dfac = obj.get_dfac;
        n = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          n = n + obj.get_field(sprintf('dns/%.0f',iSpecies))*dfac(iSpecies);
        end        
      elseif strcmp(obj.software,'Smilei')
        n = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          pop_str = obj.species{iSpecies};
          n = n + obj.get_field(['Rho_' pop_str]);
        end    
      end      
      out = n;
    end
    function out = ne(obj)
      % Get total electron density
      iSpecies = find(obj.get_charge == -1); % negatively charge particles are electrons
      out = obj.n(iSpecies);
    end
    function out = ni(obj)
      % Get total ion density
      iSpecies = find(obj.get_charge == 1); % negatively charge particles are electrons
      out = obj.n(iSpecies);
    end
    % Flux
    function out = jx(obj,species)
      % Get jx
      
      % Check that only a single species of a given charge is given
      if not(numel(unique(obj.charge(species))) == 1)
        error('Selected species have different charge. This is not supported.')
      end
      nSpecies = numel(species);
      if strcmp(obj.software,'micPIC')
        dfac = obj.get_dfac;
        var = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          var = var + obj.get_field(sprintf('vxs/%.0f',iSpecies))*dfac(iSpecies)*obj.wpewce*sqrt(obj.mime);
        end
      elseif strcmp(obj.software,'Smilei')
        var = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          pop_str = obj.species{iSpecies};
          var = var + obj.get_field(['Jx_' pop_str])*obj.wpewce*sqrt(obj.mime); % normalization ???
        end
      end
      out = var;
    end
    function out = jy(obj,species)
      % Get jy
      
      % Check that only a single species of a given charge is given
      if not(numel(unique(obj.charge(species))) == 1)
        error('Selected species have different charge. This is not supported.')
      end
      nSpecies = numel(species);
      if strcmp(obj.software,'micPIC')
        dfac = obj.get_dfac;
        var = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          var = var + obj.get_field(sprintf('vys/%.0f',iSpecies))*dfac(iSpecies)*obj.wpewce*sqrt(obj.mime);
        end
      elseif strcmp(obj.software,'Smilei')
        var = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          pop_str = obj.species{iSpecies};
          var = var + obj.get_field(['Jy_' pop_str])*obj.wpewce*sqrt(obj.mime); % normalization ???
        end
      end
      out = var;    
    end
    function out = jz(obj,species)
      % Get jz
      
      % Check that only a single species of a given charge is given
      if not(numel(unique(obj.charge(species))) == 1)
        error('Selected species have different charge. This is not supported.')
      end
      nSpecies = numel(species);
      if strcmp(obj.software,'micPIC')
        dfac = obj.get_dfac;
        var = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          var = var + obj.get_field(sprintf('vzs/%.0f',iSpecies))*dfac(iSpecies)*obj.wpewce*sqrt(obj.mime);
        end
      elseif strcmp(obj.software,'Smilei')
        var = zeros(obj.nx,obj.nz,obj.nt);
        for iSpecies = species
          pop_str = obj.species{iSpecies};
          var = var + obj.get_field(['Jz_' pop_str])*obj.wpewce*sqrt(obj.mime); % normalization ???
        end
      end
      out = var;  
    end
    function out = jex(obj)
      % Get electron flux, x
      iSpecies = find(obj.get_charge == -1); % negatively charge particles are electrons
      out = obj.jx(iSpecies);
    end
    function out = jey(obj)
      % Get electron flux, y
      iSpecies = find(obj.get_charge == -1); % negatively charge particles are electrons
      out = obj.jy(iSpecies);
    end
    function out = jez(obj)
      % Get electron flux, z
      iSpecies = find(obj.get_charge == -1); % negatively charge particles are electrons
      out = obj.jz(iSpecies);
    end
    function out = jix(obj)
      iSpecies = find(obj.get_charge == 1); % negatively charge particles are electrons
      out = obj.jx(iSpecies);
    end
    function out = jiy(obj)
      iSpecies = find(obj.get_charge == 1); % negatively charge particles are electrons
      out = obj.jy(iSpecies);
    end
    function out = jiz(obj)
      iSpecies = find(obj.get_charge == 1); % negatively charge particles are electrons
      out = obj.jz(iSpecies);
    end
    % Velocity
    function out = vx(obj,species)
      % Get velocity vx            
      n = obj.n(species);
      jx = obj.jx(species);      
      out = jx./n;      
    end
    function out = vy(obj,species)
      % Get velocity vx            
      n = obj.n(species);
      jy = obj.jy(species);      
      out = jy./n;      
    end
    function out = vz(obj,species)
      % Get velocity vx            
      n = obj.n(species);
      jz = obj.jz(species);      
      out = jz./n;      
    end
    function out = vex(obj)
      % Get electron velocity, x
      out = obj.jex./obj.ne;
    end
    function out = vey(obj)
      % Get electron velocity, y
      out = obj.jey./obj.ne;
    end
    function out = vez(obj)
      % Get electron velocity, z
      out = obj.jez./obj.ne;
    end
    % Current
    function out = Jx(obj)
      out = obj.jix - obj.jex;
    end
    function out = Jy(obj)
      out = obj.jiy - obj.jey;
    end
    function out = Jz(obj)
      out = obj.jiz - obj.jez;
    end
    % Stress tensor, not implemented for Smilei
    function out = vexx(obj)
      iSpecies = find(obj.get_charge == -1); % negatively charge particles are electrons
      dfac = obj.get_dfac;      
      var = zeros([obj.get_gridsize,1]);
      for iComp = 1:numel(iSpecies)
        dataset = sprintf('vxx/%.0f',iSpecies(iComp));
        var_tmp = get_field(obj,dataset);
        var = var + var_tmp*dfac(iComp)*mass(iSpecies)*wpewce^2;
      end
      out = var;
      out = [];
    end
    function out = vxx(obj,value)
      % Get total density of select species
      %   out = n(obj,value)
      dfac = obj.get_dfac;         
      dataset = sprintf('vxx/%.0f',value);
      out = obj.mass(value)*obj.wpewce^2*get_field(obj,dataset)*dfac(value);      
    end
    function out = vyy(obj,value)
      % Get total density of select species
      %   out = n(obj,value)
      dfac = obj.get_dfac;         
      dataset = sprintf('vyy/%.0f',value);
      out = obj.mass(value)*obj.wpewce^2*get_field(obj,dataset)*dfac(value);      
    end
    function out = vzz(obj,value)
      % Get total density of select species
      %   out = n(obj,value)
      dfac = obj.get_dfac;         
      dataset = sprintf('vzz/%.0f',value);
      out = obj.mass(value)*obj.wpewce^2*get_field(obj,dataset)*dfac(value);      
    end
    function out = vv_diag(obj,value)
      %   out = vv_diag(obj,value)
      dfac = obj.get_dfac;         
      vxx = get_field(obj,sprintf('vxx/%.0f',value))*dfac(value);
      vyy = get_field(obj,sprintf('vyy/%.0f',value))*dfac(value);
      vzz = get_field(obj,sprintf('vzz/%.0f',value))*dfac(value);
      out = obj.mass(value)*obj.wpewce^2*(vxx + vyy + vzz)/3;
    end
    function out = pD(obj,species)
      % Get dynamical pressure mn(vx^2 + vy^2 + vz^2)/3
      % Kinetic energy is (3/2)*p_dyn (=mv^2/2)
      
      mass_sp = obj.mass; 
      if numel(unique(mass_sp(species))) > 1
        error('All species do not have the same mass.'); 
      else
        mass_sp = mass_sp(species(1));
      end
      charge = obj.get_charge; charge(species);
      if numel(unique(charge(species))) > 1
        error('All species do not have the same charge.');         
      end
      
      dfac = obj.get_dfac;
      % Initialize variables
      n = zeros(numel(obj.xi),numel(obj.zi),obj.length);
      vxs = zeros(numel(obj.xi),numel(obj.zi),obj.length);
      vys = zeros(numel(obj.xi),numel(obj.zi),obj.length);
      vzs = zeros(numel(obj.xi),numel(obj.zi),obj.length);
      
      % Sum over species
      for iSpecies = species                
        n = n + obj.get_field(sprintf('dns/%.0f',iSpecies))*dfac(iSpecies);  % density      
        vxs = vxs + obj.get_field(sprintf('vxs/%.0f',iSpecies))*dfac(iSpecies); % flux
        vys = vys + obj.get_field(sprintf('vys/%.0f',iSpecies))*dfac(iSpecies); % flux
        vzs = vzs + obj.get_field(sprintf('vzs/%.0f',iSpecies))*dfac(iSpecies); % flux
      end        
      % p_dyn =  mnvv
      out = mass_sp*obj.wpewce^2*(vxs.*vxs + vys.*vys + vzs.*vzs)./n/3;
    end
    % Pressure, not implemented for Smilei
    function out = pxx(obj,species)
      % pxx = pxx(obj,species)
      
      nSpecies = numel(species);
      dfac = obj.get_dfac;
      
      % check so that all species have the same mass and charge
      mass_sp = obj.mass; 
      if numel(unique(mass_sp(species))) > 1
        error('All species do not have the same mass.'); 
      else
        mass_sp = mass_sp(species(1));
      end
      charge = obj.get_charge; charge(species);
      if numel(unique(charge(species))) > 1
        error('All species do not have the same charge.');         
      end
      
      % Initialize variables
      n = zeros(numel(obj.xi),numel(obj.zi),obj.length);      
      vxs = zeros(numel(obj.xi),numel(obj.zi),obj.length);
      vxx = zeros(numel(obj.xi),numel(obj.zi),obj.length);      
        
      % Sum over species
      for iSpecies = species                
        n = n + obj.get_field(sprintf('dns/%.0f',iSpecies))*dfac(iSpecies);  % density      
        vxs = vxs + obj.get_field(sprintf('vxs/%.0f',iSpecies))*dfac(iSpecies); % flux     
        vxx = vxx + obj.get_field(sprintf('vxx/%.0f',iSpecies))*dfac(iSpecies); % nvv
      end        
      % p = P - mnvv
      out = mass_sp*obj.wpewce^2*(vxx - vxs.*vxs./n); % pxx
    end
    function out = pyy(obj,species)
      % pxx = pxx(obj,species)
      
      nSpecies = numel(species);
      dfac = obj.get_dfac;
      
      % check so that all species have the same mass and charge
      mass_sp = obj.mass; 
      if numel(unique(mass_sp(species))) > 1
        error('All species do not have the same mass.'); 
      else
        mass_sp = mass_sp(species(1));
      end
      charge = obj.get_charge; charge(species);
      if numel(unique(charge(species))) > 1
        error('All species do not have the same charge.');         
      end
      
      % Initialize variables
      n = zeros(numel(obj.xi),numel(obj.zi),obj.length);      
      vxs = zeros(numel(obj.xi),numel(obj.zi),obj.length);
      vxx = zeros(numel(obj.xi),numel(obj.zi),obj.length);      
        
      % Sum over species
      for iSpecies = species                
        n = n + obj.get_field(sprintf('dns/%.0f',iSpecies))*dfac(iSpecies);  % density      
        vxs = vxs + obj.get_field(sprintf('vys/%.0f',iSpecies))*dfac(iSpecies); % flux     
        vxx = vxx + obj.get_field(sprintf('vyy/%.0f',iSpecies))*dfac(iSpecies); % nvv
      end        
      % p = P - mnvv
      out = mass_sp*obj.wpewce^2*(vxx - vxs.*vxs./n); % pxx
    end
    function out = pzz(obj,species)
      % pxx = pxx(obj,species)
      
      nSpecies = numel(species);
      dfac = obj.get_dfac;
      
      % check so that all species have the same mass and charge
      mass_sp = obj.mass; 
      if numel(unique(mass_sp(species))) > 1
        error('All species do not have the same mass.'); 
      else
        mass_sp = mass_sp(species(1));
      end
      charge = obj.get_charge; charge(species);
      if numel(unique(charge(species))) > 1
        error('All species do not have the same charge.');         
      end
      
      % Initialize variables
      n = zeros(numel(obj.xi),numel(obj.zi),obj.length);      
      vxs = zeros(numel(obj.xi),numel(obj.zi),obj.length);
      vxx = zeros(numel(obj.xi),numel(obj.zi),obj.length);      
        
      % Sum over species
      for iSpecies = species                
        n = n + obj.get_field(sprintf('dns/%.0f',iSpecies))*dfac(iSpecies);  % density      
        vxs = vxs + obj.get_field(sprintf('vys/%.0f',iSpecies))*dfac(iSpecies); % flux     
        vxx = vxx + obj.get_field(sprintf('vyy/%.0f',iSpecies))*dfac(iSpecies); % nvv
      end        
      % p = P - mnvv
      out = mass_sp*obj.wpewce^2*(vxx - vxs.*vxs./n); % pxx
    end
    function out = p(obj,species)
      % p = (pxx+pyy+pzz)/3
      out = (obj.pxx(species) + obj.pyy(species) + obj.pzz(species))/3;
    end
    
    % Sets of moments, not implemented for Smilei
    function [vxx,vxy,vxz,vyy,vyz,vzz] = vv(obj,iSpecies_orig)
      % [vxx,vxy,vxz,vyy,vyz,vzz] = vv(obj,iSpecies_orig)
      %nargout      
      mass_sp = obj.mass; 
      if numel(unique(mass_sp(iSpecies_orig))) > 1
        error('All species do not have the same mass.'); 
      else
        mass_sp = mass_sp(iSpecies_orig(1));
      end        
      dfac = obj.get_dfac;
      nSpecies = numel(iSpecies_orig);
      
      vxx = zeros(obj.length,obj.nx,obj.nz);
      vyy = zeros(obj.length,obj.nx,obj.nz);
      vzz = zeros(obj.length,obj.nx,obj.nz);
      vxy = zeros(obj.length,obj.nx,obj.nz);
      vxz = zeros(obj.length,obj.nx,obj.nz);
      vyz = zeros(obj.length,obj.nx,obj.nz);
        
      for iSpecies = iSpecies_orig
        dset_vxx = sprintf('vxx/%.0f',iSpecies);
        dset_vxy = sprintf('vxy/%.0f',iSpecies);
        dset_vxz = sprintf('vxz/%.0f',iSpecies);
        dset_vyy = sprintf('vyy/%.0f',iSpecies);
        dset_vyz = sprintf('vyz/%.0f',iSpecies);
        dset_vzz = sprintf('vzz/%.0f',iSpecies);
        vxx = vxx + obj.get_field(dset_vxx)*dfac(iSpecies)*mass_sp*obj.wpewce^2;
        vxy = vxy + obj.get_field(dset_vxy)*dfac(iSpecies)*mass_sp*obj.wpewce^2;
        vxz = vxz + obj.get_field(dset_vxz)*dfac(iSpecies)*mass_sp*obj.wpewce^2;
        vyy = vyy + obj.get_field(dset_vyy)*dfac(iSpecies)*mass_sp*obj.wpewce^2;
        vyz = vyz + obj.get_field(dset_vyz)*dfac(iSpecies)*mass_sp*obj.wpewce^2;
        vzz = vzz + obj.get_field(dset_vzz)*dfac(iSpecies)*mass_sp*obj.wpewce^2;         
      end
      
      
    end
    function [n,jx,jy,jz,pxx,pxy,pxz,pyy,pyz,pzz] = njp(obj,iSpecies,varargin)
      % [n,jx,jy,jz,pxx,pxy,pxz,pyy,pyz,pzz] = njp(obj,iSpecies)
      doMean = 0;
      iSpecies_orig = iSpecies;
      nSpecies = numel(iSpecies);
      dfac = obj.get_dfac;
      args = varargin;
      nargs = numel(args);
      if nargs > 0
        doMean = 1;
        dirMean = args{2};
      end
      
      % Get density, flux and pressure of given species
      if nSpecies == 1 % only one species
        % n
        dset_n = sprintf('dns/%.0f',iSpecies);
        n = obj.get_field(dset_n)*dfac(iSpecies);
        % j
        dset_jx = sprintf('vxs/%.0f',iSpecies);
        dset_jy = sprintf('vys/%.0f',iSpecies);
        dset_jz = sprintf('vzs/%.0f',iSpecies);
        vxs = obj.get_field(dset_jx)*dfac(iSpecies);
        vys = obj.get_field(dset_jy)*dfac(iSpecies);
        vzs = obj.get_field(dset_jz)*dfac(iSpecies);      
        jx = vxs*obj.wpewce*sqrt(obj.mime);
        jy = vys*obj.wpewce*sqrt(obj.mime);
        jz = vzs*obj.wpewce*sqrt(obj.mime);
        % p
        dset_vxx = sprintf('vxx/%.0f',iSpecies);
        dset_vxy = sprintf('vxy/%.0f',iSpecies);
        dset_vxz = sprintf('vxz/%.0f',iSpecies);
        dset_vyy = sprintf('vyy/%.0f',iSpecies);
        dset_vyz = sprintf('vyz/%.0f',iSpecies);
        dset_vzz = sprintf('vzz/%.0f',iSpecies);
        vxx = obj.get_field(dset_vxx)*dfac(iSpecies);
        vxy = obj.get_field(dset_vxy)*dfac(iSpecies);
        vxz = obj.get_field(dset_vxz)*dfac(iSpecies);
        vyy = obj.get_field(dset_vyy)*dfac(iSpecies);
        vyz = obj.get_field(dset_vyz)*dfac(iSpecies);
        vzz = obj.get_field(dset_vzz)*dfac(iSpecies);       
          
        pxx = obj.mass(iSpecies)*obj.wpewce^2*( vxx - vxs.*vxs./n );
        pxy = obj.mass(iSpecies)*obj.wpewce^2*( vxy - vxs.*vys./n );
        pxz = obj.mass(iSpecies)*obj.wpewce^2*( vxz - vxs.*vzs./n );
        pyy = obj.mass(iSpecies)*obj.wpewce^2*( vyy - vys.*vys./n );
        pyz = obj.mass(iSpecies)*obj.wpewce^2*( vyz - vys.*vzs./n );
        pzz = obj.mass(iSpecies)*obj.wpewce^2*( vzz - vzs.*vzs./n );
      else % group multiple species
        % check so that all species have the same mass and charge
        mass_sp = obj.mass; 
        if numel(unique(mass_sp(iSpecies_orig))) > 1
          error('All species do not have the same mass.'); 
        else
          mass_sp = mass_sp(iSpecies_orig(1));
        end
        charge = obj.get_charge; charge(iSpecies_orig);
        if numel(unique(charge(iSpecies_orig))) > 1
          error('All species do not have the same charge.');         
        end
        
        n = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        jx = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        jy = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        jz = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vxs = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vys = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vzs = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        pxx = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        pyy = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        pzz = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        pxy = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        pxz = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        pyz = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vxx = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vyy = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vzz = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vxy = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vxz = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        vyz = zeros(numel(obj.xi),numel(obj.zi),obj.length);
        
        for iSpecies = iSpecies_orig
          % n 
          % number of macroparticles, this can be added straight up
          dset_n = sprintf('dns/%.0f',iSpecies);
          n = n + obj.get_field(dset_n)*dfac(iSpecies);
          % v (j)
          dset_jx = sprintf('vxs/%.0f',iSpecies);
          dset_jy = sprintf('vys/%.0f',iSpecies);
          dset_jz = sprintf('vzs/%.0f',iSpecies);
          vxs = vxs + obj.get_field(dset_jx)*dfac(iSpecies);
          vys = vys + obj.get_field(dset_jy)*dfac(iSpecies);
          vzs = vzs + obj.get_field(dset_jz)*dfac(iSpecies);          
          % vv
          dset_vxx = sprintf('vxx/%.0f',iSpecies);
          dset_vxy = sprintf('vxy/%.0f',iSpecies);
          dset_vxz = sprintf('vxz/%.0f',iSpecies);
          dset_vyy = sprintf('vyy/%.0f',iSpecies);
          dset_vyz = sprintf('vyz/%.0f',iSpecies);
          dset_vzz = sprintf('vzz/%.0f',iSpecies);
          vxx = vxx + obj.get_field(dset_vxx)*dfac(iSpecies);
          vxy = vxy + obj.get_field(dset_vxy)*dfac(iSpecies);
          vxz = vxz + obj.get_field(dset_vxz)*dfac(iSpecies);
          vyy = vyy + obj.get_field(dset_vyy)*dfac(iSpecies);
          vyz = vyz + obj.get_field(dset_vyz)*dfac(iSpecies);
          vzz = vzz + obj.get_field(dset_vzz)*dfac(iSpecies);
        end
        % j = nv
        jx = vxs*obj.wpewce*sqrt(obj.mime);
        jy = vys*obj.wpewce*sqrt(obj.mime);
        jz = vzs*obj.wpewce*sqrt(obj.mime);
        % p = P - mnvv
        pxx = mass_sp*obj.wpewce^2*(vxx - vxs.*vxs./n); 
        pxy = mass_sp*obj.wpewce^2*(vxy - vxs.*vys./n);
        pxz = mass_sp*obj.wpewce^2*(vxz - vxs.*vzs./n);
        pyy = mass_sp*obj.wpewce^2*(vyy - vys.*vys./n);
        pyz = mass_sp*obj.wpewce^2*(vyz - vys.*vzs./n);
        pzz = mass_sp*obj.wpewce^2*(vzz - vzs.*vzs./n);
      end
      if doMean
        n = mean(n,dirMean);
        jx = mean(jx,dirMean);
        jy = mean(jy,dirMean);
        jz = mean(jz,dirMean);
        pxx = mean(pxx,dirMean);
        pxy = mean(pxy,dirMean);
        pxz = mean(pxz,dirMean);
        pyy = mean(pyy,dirMean);
        pyz = mean(pyz,dirMean);
        pzz = mean(pzz,dirMean);
      end
      
    end    
    
    % Ge derived quantities
    % Stored, not implemented for Smilei
    function out = UB(obj)
      % Magnetic energy density 0.5*(Bx^2 + By^2 + Bz^2) summed up 
      out = h5read(obj.file,'/scalar_timeseries/U/B');
      out = out(obj.indices_);
    end
    function out = dUB(obj)
      % Magnetic energy density 0.5*(Bx^2 + By^2 + Bz^2) summed up 
      out = h5read(obj.file,'/scalar_timeseries/U/B');
      out = abs([0 cumsum(diff(out-out(1)))]);
      out = out(obj.indices_);
    end
    function out = UK(obj,value)
      % 
      out = h5read(obj.file,['/scalar_timeseries/U/K/' num2str(value)]);
      out = out(obj.indices_);
    end
    function out = UT(obj,value)
      % 
      out = h5read(obj.file,['/scalar_timeseries/U/T/' num2str(value)]);
      out = out(obj.indices_);
    end
    function out = RE(obj)
      % Reconnection rate from out-of-plane electric field Ey at X line
      out = h5read(obj.file,'/scalar_timeseries/R/Ey');
      out = out(obj.indices_);
    end
    function out = RA(obj)
      % Reconnection rate from vector potential dA/dt at X line
      out = h5read(obj.file,'/scalar_timeseries/R/A');
      out = out(obj.indices_);
    end        
    % Calculated each time, not implemented for Smilei
    function out = xline(obj)
      % Not implemented.
      % Assume xline is close to middle of box in z
      %zlim = [-0.2 0.2];
      % Assume xline has not moved too much left and right
      %xlim = [-50 50];
      A = obj.A;      
    end
    function out = saddle(obj)
      % Not implemented.
      % Assume xline is close to middle of box in z
      %zlim = [-0.2 0.2];
      % Assume xline has not moved too much left and right
      %xlim = [-50 50];
      A = obj.A;      
    end
    function [x,v,a,B] = xva_df(obj)
      % [xDF,vDF,aDF,BDF] = df04.xva_df;
      % Divided into left and right o center of box
      
      % Find main X line and divide box into left and right of this
      % Never mind, jsut pick 0.
      
      nt = obj.nt;
      tlim = obj.twci([1 end]);
      zlim = [-0.4 0.4];
      xlims = {[obj.xi(1) obj.xi(fix(obj.nx/2))],[obj.xi(fix(obj.nx/2)) obj.xi(end)]};
      
      x = zeros(2,obj.nt);
      v = zeros(2,obj.nt);
      a = zeros(2,obj.nt);
      B = zeros(2,obj.nt);
      multiplier = [-1 1];
      for ixlim = 1:2 
        xlim = xlims{ixlim};        
        pic = obj.xlim(xlim).zlim(zlim).twcilim(tlim);
        dt = reshape(diff(pic.twci),[nt-1,1]);
        t_centered = reshape(pic.twci(1:end-1),[nt-1 1])+dt;
        
        Bz_mean = squeeze(mean(pic.Bz,2)); % mean over z range
        [Bz_peak,ind_Bz_peak] = max(abs(Bz_mean)); % find peak Bz
        xDF = reshape(pic.xi(ind_Bz_peak),[nt,1]); % get x-locations of peak Bz
        
        dxDF = diff(xDF);
        vDF = dxDF./dt;
        vDF_interp = reshape(interp1(t_centered,vDF,pic.twci),[nt,1]); % interpolate to original timeseries
        %tcentered_2 = tocolumn(pic.twci(2:pic.nt-1));
        aDF = reshape(diff(vDF),[nt-2,1])./dt(2:end);
        aDF = [aDF(1); aDF; aDF(end)];     
        x(ixlim,:) = xDF;
        v(ixlim,:) = vDF_interp*multiplier(ixlim);
        a(ixlim,:) = aDF*multiplier(ixlim);
        B(ixlim,:) = Bz_peak;
      end
    end
    
    % Get and set properties    
    function obj = set.fields(obj,value)
      obj.fields_ = value;
    end
    function obj = set.iteration(obj,value)
      obj.iteration_ = value;
    end
    function obj = set.twpe(obj,value)
      obj.twpe_ = value;
    end
    function obj = set.twci(obj,value)
      obj.twci_ = value;
    end
    function obj = set.xe(obj,value)
      obj.xe_ = value;
    end
    function obj = set.ze(obj,value)
      obj.ze_ = value;
    end
    function obj = set.xi(obj,value)
      obj.xi_ = value;
    end
    function obj = set.zi(obj,value)
      obj.zi_ = value;
    end
    function obj = set.grid(obj,value)
      obj.grid_ = value;
    end
    function obj = set.indices(obj,value)
      obj.indices_ = value;
    end
    function obj = set.it(obj,value)
      obj.it_ = value;
    end
    function obj = set.ix(obj,value)
      obj.ix_ = value;
    end
    function obj = set.iz(obj,value)
      obj.iz_ = value;
    end
    
    function value = get.fields(obj)
      value = obj.fields_;
    end   
    function value = get.iteration(obj)
      value = obj.iteration_;
    end 
    function value = get.twpe(obj)
      value = obj.twpe_;
    end
    function value = get.twci(obj)
      value = obj.twci_;
    end 
    function value = get.xe(obj)
      value = obj.xe_;
    end
    function value = get.ze(obj)
      value = obj.ze_;
    end
    function value = get.xi(obj)
      value = obj.xi_;
    end
    function value = get.zi(obj)
      value = obj.zi_;
    end
    function value = get.grid(obj)
      value = obj.grid_;
    end
    function value = get.indices(obj)
      value = obj.indices_;
    end
    function value = get.it(obj)
      value = obj.it_;
    end
    function value = get.ix(obj)
      value = obj.ix_;
    end
    function value = get.iz(obj)
      value = obj.iz_;
    end
  end
  
  methods (Static) % does not require object as input, but still needs to be called as obj.func (?)
    function out = ind_from_lim(var,value,varargin)
      % method is the same for xlim, zlim ilim, i, twpelim, twcilim
      
      % Defaults
      doBounding = 0;
      nBounding = 0;
      doClosest = 0;
      nClosest = 1; % only the closest index
      
      if numel(value) == 1
        doClosest = 1;        
      end
      
      % Check input
      have_options = 0;
      nargs = numel(varargin);      
      if nargs > 0, have_options = 1; args = varargin(:); end
      
      while have_options
        l = 1;
        switch(lower(args{1}))
          case 'closest'
            l = 2;
            doClosest = 1;
            nClosest = args{2};            
            args = args(l+1:end);    
          case 'bounding'
            l = 2;
            doBounding = 1;
            nBounding = args{2};            
            args = args(l+1:end);        
          otherwise
            warning(sprintf('Input ''%s'' not recognized.',args{1}))
            args = args(l+1:end);
        end        
        if isempty(args), break, end    
      end
      
      % Find indices
      if doBounding
        i0 = find(abs(var-value(1)) == min(abs(var-value(1))));
        i1 = i0 - nBounding;
        i2 = i0 + nBounding;
        % Check so that indices are not outside range
        if i1 < 1
          i1 = 1; 
        end
        if i2 > numel(var) 
          i2 = numel(var) ; 
        end
        inds = i1:i2;
      elseif doClosest
        try
        ii = abs(var-value(1));
        [is, index] = sort(abs(var-value(1)));
        inds = sort(index(1:nClosest));
        catch
          1;
        end
      else        
        i1 = find(var >= value(1),1,'first'); 
        i2 = find(var <= value(2),1,'last'); 
        inds = i1:i2;
      end
      
      out = inds;
    end
    function out = eom()
    end      
  end
  
  methods (Access = protected)
    function out = get_field(obj,field)
      % get iterations
      iterations = obj.iteration;
      nIter = obj.length;
      % initialize matrix
      data = nan([obj.get_gridsize,nIter]);
      for iIter = 1:nIter
        iter = iterations(iIter);
        str_iter = sprintf('%010.0f',iter);
        if strcmp(obj.software,'micPIC')
          data_tmp = h5read(obj.file,...
             ['/data/' str_iter '/' field],...
             [obj.grid{1}(1) obj.grid{2}(1)],... % start indices
             [numel(obj.grid{1}) numel(obj.grid{2})]); % number of counts
          %disp(sprintf('Reading %s: [%g %g] datapoints starting at [%g %g]',field,numel(obj.grid{1}),numel(obj.grid{2}),obj.grid{1}(1),obj.grid{2}(1)))
        else % Smilei
          data_tmp = h5read(obj.file,...
            ['/data/' str_iter '/' field],...
            [obj.grid{2}(1) obj.grid{1}(1)]',... % start indices
            [numel(obj.grid{2}) numel(obj.grid{1})]'); % number of counts
          data_tmp = data_tmp';
        end
        data(:,:,iIter) = data_tmp;
      end
      out = data;
    end
    function Ts = changeBasis(obj, flag)
      % Tranform from one coordinate system to another and return new
      % TimeSeries.
      % flag: = 'xyz>rlp' - Cartesian XYZ to spherical latitude
      %         'rlp>xyz' - Spherical latitude to cartesian XYZ
      %         'xyz>rpz' - Cartesian XYZ to cylindrical
      %         'rpz>xyz' - Cylidrical to cartesian XYZ
      %         'xyz>rtp' - Cartesian XYZ to spherical colatitude
      %         'rtp>xyz' - Spherical colatitude to cartesian XYZ
      %         'rtp>rlp' - Spherical colatitude to spherical latitude
      %         'rlp>rtp' - Spherical latitude to colatitude
      switch lower(flag)
        case 'xyz>rlp'
          [phi, lambda, r] = cart2sph(obj.x.data, obj.y.data, obj.z.data);
          Ts = TSeries(obj.time, [r, lambda, phi], 'vec_rlp');
        case 'rlp>xyz'
          [x, y, z] = sph2cart(obj.phi.data, obj.lambda.data, obj.r.data);
          Ts = TSeries(obj.time, [x, y, z], 'vec_xyz');
        case 'xyz>rpz'
          [phi, r, z] = cart2pol(obj.x.data, obj.y.data, obj.z.data);
          Ts = TSeries(obj.time, [r, phi, z], 'vec_rpz');
        case 'rpz>xyz'
          [x, y, z] = pol2cart(obj.phi.data, obj.r.data, obj.z.data);
          Ts = TSeries(obj.time, [x, y, z], 'vec_xyz');
        case 'xyz>rtp'
          [phi, lambda, r] = cart2sph(obj.x.data, obj.y.data, obj.z.data);
          theta = pi/2 - lambda;
          Ts = TSeries(obj.time, [r, theta, phi], 'vec_rtp');
        case 'rtp>xyz'
          lambda = pi/2 - obj.theta.data;
          [x, y, z] = sph2cart(obj.phi.data, lambda, obj.r.data);
          Ts = TSeries(obj.time, [x, y, z], 'vec_xyz');
        case 'rtp>rlp'
          lambda = pi/2 - obj.theta.data;
          Ts = TSeries(obj.time, [obj.r.data,lambda,obj.phi.data],'vec_rlp');
        case 'rlp>rtp'
          theta = pi/2 - obj.lambda.data;
          Ts = TSeries(obj.time, [obj.r.data,theta,obj.phi.data],'vec_rtp');
        case 'xy>rp'
          [phi, r] = cart2pol(obj.x.data, obj.y.data);
          Ts = TSeries(obj.time, [r, phi], 'vec_rp');
        case 'rp>xy'
          [x, y] = pol2cart(obj.phi.data, obj.r.data);
          Ts = TSeries(obj.time, [x, y], 'vec_xy');
        otherwise
          errStr='Invalid transformation'; error(errStr);
      end
    end
  end
  
end