%% Define times
timesteps = 00200:200:05200;
times = timesteps/50;
ntimes = numel(timesteps);
savedir_root = '/Users/cno062/Research/PIC/df_cold_protons_1/';
data_dir = '/Volumes/Fountain/Data/PIC/df_cold_protons_1/data/';

savedir_root = '/Users/cno062/Research/PIC/df_cold_protons_04/';
data_dir = '/Volumes/Fountain/Data/PIC/df_cold_protons_04/data/';
screensize = get( groot, 'Screensize' );

%% Define xlim zlim, common for all figures, do this below, after having loaded x and z
% xlim = [x(1) x(end)] + [100 -100];
% zlim = [-25 25];
% xlim = [x(1) x(end)];
% zlim = [z(1) z(end)];

%% Quantities to plot or save
% Plots
clear subdirs_all varstrs_all clims_all cylims_all nrows_all plot_structure      
clear doMovie movies
iplot = 0;
imovie = 0;
if 0 % Uti1-Uki1
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'Uti1-Uki1'};
  clims_all{iplot} = [-0.3 0.3];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Uti2-Uki2
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'Uti2-Uki2'};
  clims_all{iplot} = [-0.3 0.3];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ute1-Uke1
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'Ute1-Uke1'};
  clims_all{iplot} = [-0.3 0.3];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ute2-Uke2
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'Ute2-Uke2'};
  clims_all{iplot} = [-0.3 0.3];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % By
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'B.y'};
  clims_all{iplot} = [-0.6 0.6];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Bz
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'B.z'};
  clims_all{iplot} = [-0.6 0.6];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ez
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'E.z'};
  clims_all{iplot} = [-2 2];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ey
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'E.y'};
  clims_all{iplot} = [-0.4 0.4];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % pe1.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'pe1.scalar'};
  clims_all{iplot} = [-0.19 0.19];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % pe2.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'pe2.scalar'};
  clims_all{iplot} = [-0.19 0.19];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % pi1.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'pi1.scalar'};
  clims_all{iplot} = [-0.9 0.9];  
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % pi2.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'pi2.scalar'};
  clims_all{iplot} = [-0.15 0.15];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Te1.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'te1.scalar'};
  clims_all{iplot} = [-0.2 0.2];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Te2.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'te2.scalar'};
  clims_all{iplot} = [-0.1 0.1];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ti1.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'ti1.scalar'};
  clims_all{iplot} = [-0.8 0.8];  
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ti2.scalar
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'ti2.scalar'};
  clims_all{iplot} = [-0.2 0.2];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % angle_ve1ve2
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'angle_ve1ve2'};
  clims_all{iplot} = [0 180];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % angle_vi1ve1
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'angle_vi1ve1'};
  clims_all{iplot} = [0 180];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % angle_vi1ve2
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'angle_vi1ve2'};
  clims_all{iplot} = [0 180];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % angle_vi1vi2
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'angle_vi1vi2'};
  clims_all{iplot} = [0 180];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % angle_vi2ve1
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'angle_vi2ve1'};
  clims_all{iplot} = [0 180];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % angle_vi2ve2
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'angle_vi2ve2'};
  clims_all{iplot} = [0 180];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % jiy
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'ji.y'};
  clims_all{iplot} = [-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % jey
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'je.y'};
  clims_all{iplot} = [-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Jy
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'J.y'};
  clims_all{iplot} = [-2.5 2.5];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % vex
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;
  
  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'ve.x'};
  clims_all{iplot} = [-2 2];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % vix
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;

  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'vi.x'};
  clims_all{iplot} = [-2 2];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % ne
  iplot = iplot + 1;
  doMovie(iplot) = 1; imovie = imovie + 1;

  subdirs_all{iplot} = 'mov';
  varstrs_all{iplot} = {'ne'};
  clims_all{iplot} = [-3 3];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 1; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end

if 0 % Ut
  iplot = iplot + 1;
  doMovie(iplot) = 0;

  subdirs_all{iplot} = 'Ut';
  varstrs_all{iplot} = {'Uti1','Ute1','Uti2','Ute2'};
  clims_all{iplot} = 1*[-1 1];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 2; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Uk
  iplot = iplot + 1;
  doMovie(iplot) = 0;

  subdirs_all{iplot} = 'Uk';
  varstrs_all{iplot} = {'Uki1','Uke1','Uki2','Uke2'};
  clims_all{iplot} = 1*[-1 1];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 2; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ut-Uk
  iplot = iplot + 1;
  doMovie(iplot) = 0;

  subdirs_all{iplot} = 'Ut-Uk';
  varstrs_all{iplot} = {'Uti1-Uki1','Uke1-Ute1','Uki2-Uti2','Uke2-Ute2'};
  clims_all{iplot} = 0.3*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 2; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Ut-Uk, 'Uke2-Ute2+0.02'
  iplot = iplot + 1;
  doMovie(iplot) = 0;

  subdirs_all{iplot} = 'Ut-Uk_';
  varstrs_all{iplot} = {'Uti1-Uki1','Uke1-Ute1','Uki2-Uti2','Uke2-Ute2+0.02'};
  clims_all{iplot} = 1*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 2; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % vex, vepar
  iplot = iplot + 1;

  subdirs_all{iplot} = 'vex_vepar';
  varstrs_all{iplot} = {'ve1.x','ve2.x','ve1.par','ve2.par'};
  clims_all{iplot} = [-3 3];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 2; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % vix, vipar
  iplot = iplot + 1;

  subdirs_all{iplot} = 'vix_vipar';
  varstrs_all{iplot} = {'vi1.x','vi2.x','vi1.par','vi2.par'};
  clims_all{iplot} = 0.5*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 2; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % vex vey vez
  iplot = iplot + 1;

  subdirs_all{iplot} = 've_xyz';
  varstrs_all{iplot} = {'ve1.x','ve2.x','ve1.y','ve2.y','ve1.z','ve2.z'};
  clims_all{iplot} = [-3 3];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % vix viy viz
  iplot = iplot + 1;

  subdirs_all{iplot} = 'vi_xyz';
  varstrs_all{iplot} = {'vi1.x','vi2.x','vi1.y','vi2.y','vi1.z','vi2.z'};
  clims_all{iplot} = 0.5*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end  
if 0 % ni, ne
  iplot = iplot + 1;

  subdirs_all{iplot} = 'n';
  varstrs_all{iplot} = {'ne1','ne2','ni1','ni2'};
  clims_all{iplot} = [-3 3];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 2; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Pe1 tensor
  iplot = iplot + 1;

  subdirs_all{iplot} = 'pe1_tensor';
  varstrs_all{iplot} = {'pe1.xx','pe1.xy','pe1.yy','pe1.xz','pe1.zz','pe1.yz'};
  clims_all{iplot} = 0.25*[-1 1];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Pi1 tensor
  iplot = iplot + 1;

  subdirs_all{iplot} = 'pi1_tensor';
  varstrs_all{iplot} = {'pi1.xx','pi1.xy','pi1.yy','pi1.xz','pi1.zz','pi1.yz'};
  clims_all{iplot} = 1*[-1 1];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Pe2 tensor
  iplot = iplot + 1;

  subdirs_all{iplot} = 'pe2_tensor';
  varstrs_all{iplot} = {'pe2.xx','pe2.xy','pe2.yy','pe2.xz','pe2.zz','pe2.yz'};
  clims_all{iplot} = 0.25*[-1 1];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % Pi2 tensor
  iplot = iplot + 1;

  subdirs_all{iplot} = 'pi2_tensor';
  varstrs_all{iplot} = {'pi2.xx','pi2.xy','pi2.yy','pi2.xz','pi2.zz','pi2.yz'};
  clims_all{iplot} = 1*[-1 1];        
  cylims_all{iplot} = [0 clims_all{iplot}(2)];
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B forces on hot electrons
  iplot = iplot + 1;

  subdirs_all{iplot} = '-ve1xB_E_sum_xyz';
  varstrs_all{iplot} = {'-ve1xB.x','-ve1xB.y','-ve1xB.z','-E.x','-E.y','-E.z','-ve1xB.x-E.x','-ve1xB.y-E.y','-ve1xB.z-E.z'};
  clims_all{iplot} = [-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B forces on cold electrons
  iplot = iplot + 1;

  subdirs_all{iplot} = '-ve2xB_E_sum_xyz';
  varstrs_all{iplot} = {'-ve2xB.x','-ve2xB.y','-ve2xB.z','-E.x','-E.y','-E.z','-ve2xB.x-E.x','-ve2xB.y-E.y','-ve2xB.z-E.z'};
  clims_all{iplot} = [-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B forces on hot electrons
  iplot = iplot + 1;

  subdirs_all{iplot} = 'vi1xB_E_sum_xyz';
  varstrs_all{iplot} = {'vi1xB.x','vi1xB.y','vi1xB.z','E.x','E.y','E.z','vi1xB.x+E.x','vi1xB.y+E.y','vi1xB.z+E.z'};
  clims_all{iplot} = [-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B forces on cold electrons
  iplot = iplot + 1;

  subdirs_all{iplot} = 'vi2xB_E_sum_xyz';
  varstrs_all{iplot} = {'vi2xB.x','vi2xB.y','vi2xB.z','E.x','E.y','E.z','vi2xB.x+E.x','vi2xB.y+E.y','vi2xB.z+E.z'};
  clims_all{iplot} = [-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B,divP forces on hot electrons
  iplot = iplot + 1;

  subdirs_all{iplot} = 'e1_force_terms';
  varstrs_all{iplot} ={'-ne1.*ve1xB.x','-ne1.*ve1xB.y','-ne1.*ve1xB.z','-ne1.*E.x','-ne1.*E.y','-ne1.*E.z',...
           '-ne1.*(ve1xB.x+E.x)','-ne1.*(ve1xB.y+E.y)','-ne1.*(ve1xB.z+E.z)',...
           '-gradpe1_smooth.x','-gradpe1_smooth.y','-gradpe1_smooth.z',...
           '-ne1.*(ve1xB.x+E.x)-gradpe1_smooth.x','-ne1.*(ve1xB.y+E.y)-gradpe1_smooth.y','-ne1.*(ve1xB.z+E.z)-gradpe1_smooth.z'...
           }; 
  clims_all{iplot} = 0.5*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 5; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B forces on cold electrons
  iplot = iplot + 1;

  subdirs_all{iplot} = 'e2_force_terms';
  varstrs_all{iplot} ={'-ne2.*ve2xB.x','-ne2.*ve2xB.y','-ne2.*ve2xB.z','-ne2.*E.x','-ne2.*E.y','-ne2.*E.z',...
           '-ne2.*(ve2xB.x+E.x)','-ne2.*(ve2xB.y+E.y)','-ne2.*(ve2xB.z+E.z)',...
           '-gradpe2_smooth.x','-gradpe2_smooth.y','-gradpe2_smooth.z',...
           '-ne2.*(ve2xB.x+E.x)-gradpe2_smooth.x','-ne2.*(ve2xB.y+E.y)-gradpe2_smooth.y','-ne2.*(ve2xB.z+E.z)-gradpe2_smooth.z'...
           }; 
  clims_all{iplot} = 0.5*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 5; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B forces on hot ions
  iplot = iplot + 1;

  subdirs_all{iplot} = 'i1_force_terms';
  varstrs_all{iplot} ={'ni1.*vi1xB.x','ni1.*vi1xB.y','ni1.*vi1xB.z','ni1.*E.x','ni1.*E.y','ni1.*E.z',...
           'ni1.*(vi1xB.x+E.x)','ni1.*(vi1xB.y+E.y)','ni1.*(vi1xB.z+E.z)',...
           '-gradpi1_smooth.x','-gradpi1_smooth.y','-gradpi1_smooth.z',...
           'ni1.*(vi1xB.x+E.x)-gradpi1_smooth.x','ni1.*(vi1xB.y+E.y)-gradpi1_smooth.y','ni1.*(vi1xB.z+E.z)-gradpi1_smooth.z'...
           }; 
  clims_all{iplot} = 0.5*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 5; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % E,B forces on cold ions
  iplot = iplot + 1;

  subdirs_all{iplot} = 'i2_force_terms';
  varstrs_all{iplot} ={'ni2.*vi2xB.x','ni2.*vi2xB.y','ni2.*vi2xB.z','ni2.*E.x','ni2.*E.y','ni2.*E.z',...
           'ni2.*(vi2xB.x+E.x)','ni2.*(vi2xB.y+E.y)','ni2.*(vi2xB.z+E.z)',...
           '-gradpi2_smooth.x','-gradpi2_smooth.y','-gradpi2_smooth.z',...
           'ni2.*(vi2xB.x+E.x)-gradpi2_smooth.x','ni2.*(vi2xB.y+E.y)-gradpi2_smooth.y','ni2.*(vi2xB.z+E.z)-gradpi2_smooth.z'...
           }; 
  clims_all{iplot} = 0.5*[-1 1];        
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 5; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end
if 0 % vi1xB.y, vi2xB.y, -vi1xB.y+vi2xB.y (y-forces on cold ions)
  iplot = iplot + 1;

  subdirs_all{iplot} = 'i2_force_terms';
  varstrs_all{iplot} = {'vi1xB.y','vi2xB.y','-vi1xB.y+vi2xB.y','vi1xB.y_zx','vi2xB.y_zx','-vi1xB.y_zx+vi2xB.y_zx','vi1xB.y_xz','vi2xB.y_xz','-vi1xB.y_xz+vi2xB.y_xz'};
  clims_all{iplot} = 0.2*[-1 1];          
  cylims_all{iplot} = clims_all{iplot};
  nrows_all{iplot} = 3; % ncols is calculated from nrows and nvars

  plot_structure.subdir = subdirs_all{iplot};
  plot_structure.varstrs = varstrs_all{iplot};
  plot_structure.clim = clims_all{iplot};
  plot_structure.cylim = cylims_all{iplot};
  plot_structure.nrows = nrows_all{iplot};
  plot_structures_all{iplot} = plot_structure;
end


% Collect everything in cells instead of named variables, the varstrs
% serves as identificator

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time series of scalar quantities %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear varstrs_ts_scalar
varstrs_ts_scalar = {};
% ...
%   'Uke1','Uke2','Uke3','Uke23','Uki1','Uki2','Uki3','Uki23',...
%   'Ute1','Ute2','Ute3','Ute23','Uti1','Uti2','Uti3','Uti23',...
%   'UB.tot','UB.x','UB.y','UB.z',...
%   'U.B_mean','U.B_sum',...
%   'U.Uke1_mean','U.Uke2_mean','U.Uki1_mean','U.Uki2_mean',...
%   'U.Ute1_mean','U.Ute2_mean','U.Uti1_mean','U.Uti2_mean',...
%   'U.Uke1_sum','U.Uke2_sum','U.Uki1_sum','U.Uki2_sum',...
%   'U.Ute1_sum','U.Ute2_sum','U.Uti1_sum','U.Uti2_sum',...
%   'pe1_mean','pe2_mean','pi1_mean','pi2_mean',...              
%   'pe1_std','pe2_std','pi1_std','pi2_std',...
%   'E_mean','E_std'};
nvars_ts_scalar = numel(varstrs_ts_scalar);
cell_ts_scalar = cell(nvars_ts_scalar,1);
% %str_ts_scalar = varstrs_ts_scalar;
% %cellfun(@()sprintf())
% for ivar_ts_scalar = 1:nvars_ts_scalar
%   varstr_ts = varstrs_ts_scalar{ivar_ts_scalar};
%   varstr_ts_adapted = [varstr_ts '_ts'];
%   varstr_ts_adapted(strfind(varstr_ts_adapted,'.')) = '_';
%   varstrs_ts_scalar{ivar_ts_scalar,:} = varstr_ts_adapted;
%   eval([varstr_ts_adapted ' = nan(1,ntimes);']);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time stacked line plots (for example to see how Bz or vx spread out) %%%%
clear varstrs_ts_line_x
zval_collect = [-6:1:6]; % collect for a number of different z's
nz_collect = numel(zval_collect);
varstrs_ts_line_x = {...
  'A',...
  've1.x','ve2.x','ve3.x','ve23.x','vi1.x','vi2.x','vi3.x','vi23.x',...
  'B.y','B.z','E.x','E.y','E.z',...
  ...%'ve.x','ve.x','vi.x','vi.x',...
  've1.y','ve2.y','ve3.y','ve23.y','vi1.y','vi2.y','vi3.y','vi23.y',...
  'ne1','ne2','ne3','ne23','ni1','ni2','ni3','ni23',...
  'J.y',...
  'pe1.scalar','pe2.scalar','pi1.scalar','pi2.scalar',...
  'te1.scalar','te2.scalar','ti1.scalar','ti2.scalar'...
  };
nvars_ts_line_x = numel(varstrs_ts_line_x);
cell_ts_line_x = cell(nvars_ts_line_x,1);
nx = 6400;
for ivar_ts_scalar = 1:nvars_ts_line_x
  %varstr_ts_stacked = varstrs_ts_stacked{ivar_ts_scalar};
  %varstr_ts_stacked_adapted = [varstr_ts_stacked '_ts_stacked'];
  %varstr_ts_stacked_adapted(strfind(varstr_ts_stacked_adapted,'.')) = '_';
  %varstrs_ts_stacked_adapted{ivar_ts_scalar,:} = varstr_ts_stacked_adapted;
  cell_ts_line_x{ivar_ts_scalar} = nan(nx,nz_collect,ntimes);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Movies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frames are captured for plots for which doMovie(iplot) == 1, this is set
% manually above
indMovie = find(doMovie);
nMovies = sum(doMovie);
cell_movies = cell(nMovies,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Time loop
doTs = 1;
doPatch = 0;

tstart = tic;
for itime = 1:ntimes
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
  
  ind_z0 = find_closest_ind(z,zval_collect);
  
  xlim = [-150 150]; [x(1) x(end)];
  zlim = [-15 15];   [z(1) z(end)];
  
  %% Calculate auxillary quantities
  A = vector_potential(x,z,B.x,B.z); % vector potential
  [saddle_locations,saddle_values] = saddle(A);
  pic_calc_script_nss6  
  
  
  %% Collect time series of scalar quantities
  for ivar_ts_scalar = 1:nvars_ts_scalar
    %%
    %disp([varstrs_ts_scalar{ivar_ts_scalar} '(1,itime) = sum(' varstrs_ts_scalar{ivar_ts_scalar} '(:));']);    
    %eval([varstrs_ts_scalar{ivar_ts_scalar} '(1,itime) = sum(' varstrs_ts{ivar_ts_scalar} '(:));']);    
    tmp_var = eval(varstrs_ts_scalar{ivar_ts_scalar});
    if isa(tmp_var,'struct')
      tmp_var_fields = fields(U);
      for ifield = 1:numel(tmp_var_fields)
        cell_ts_scalar{ivar_ts_scalar}(ifield,itime) = eval(['sum(tmp_var.' tmp_var_fields{ifields} '(:))']);
      end
    else
      cell_ts_scalar{ivar_ts_scalar}(1,itime) = sum(tmp_var(:));
    end
  end
  
  %% Collect stacked time series (lines)
  for ivar_ts_line_x = 1:nvars_ts_line_x
    tmp_var = eval(varstrs_ts_line_x{ivar_ts_line_x});
    cell_ts_line_x{ivar_ts_line_x}(:,:,itime) = tmp_var(:,ind_z0);
    %disp(['cell_ts_line_x (:,:,itime) = ' varstrs_ts_stacked{ivar_ts_scalar} '(:,ind_z0);']);    
    %eval([varstrs_ts_stacked_adapted{ivar_ts_scalar} '(:,:,itime) = ' varstrs_ts_stacked{ivar_ts_scalar} '(:,ind_z0);']);    
%     if ivar_ts_scalar == 15
%       subdir = 'jtot_at_x=0';
%       savedir = [savedir_root,subdir];
%       mkdir(savedir)
%       savestr = sprintf('%s_t%05.0f',subdir,timestep);    
%       figure(33)
%       hca = subplot(2,1,1);
%       plot(hca,x,eval([varstrs_ts_stacked{ivar_ts_scalar} '(:,11);']))      
%       hca.XLabel.String = 'x (di)';
%       hca.YLabel.String = varstrs_ts_stacked_adapted{ivar_ts_scalar};
%       hca.Title.String = [varstrs_ts_stacked_adapted{ivar_ts_scalar} 'at z = 0'];
%       hca = subplot(2,1,2);
%       imagesc(hca,timesteps/wpewce/mass(1),x,squeeze(eval([varstrs_ts_stacked_adapted{ivar_ts_scalar} '(:,11,:)'])))
%       hcb = colorbar('peer',hca);
%       hcb.YLabel.String = varstrs_ts_stacked_adapted{ivar_ts_scalar};
%       hca.XLabel.String = 'time (1/wci)';
%       hca.YLabel.String = 'x (di)';
%       print('-dpng','-r200',[savedir '/' savestr '.png']);      
%     end
  end
  
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
    
  nplots = iplot;
  for iplot = 1:nplots % Plot, adaptive
    %% Save and print info
    % subdirs_all varstrs_all clims_all cylims_all nrows_all plot_structure     
    subdir = subdirs_all{iplot};
    varstrs = varstrs_all{iplot};
    clim = clims_all{iplot};
    cylim = cylims_all{iplot};
    nrows = nrows_all{iplot};
    
    nvars = numel(varstrs);
    npanels = nvars;        
    ncols = ceil(npanels/nrows);
    % set figure position
    screensize = get(groot,'Screensize');
    figure_position(1) = 1;
    figure_position(2) = 1;
    figure_position(3) = screensize(3)/4*ncols;
    figure_position(4) = figure_position(3)*nrows/ncols*0.5;
    
    savedir = [savedir_root,subdir];
    mkdir(savedir)
    savestr = sprintf('%s_t%05.0f',subdir,timestep);            

    % Initialize figure
    fig = figure(102);
    fig.Position = figure_position;

    isub = 1; 
    for ipanel = 1:npanels  
      h(isub) = subplot(nrows,ncols,ipanel); isub = isub + 1;  
    end
    clear hb;

    % Plot part of data    
    ix1 = find(x>xlim(1),1,'first');
    ix2 = find(x<xlim(2),1,'last');
    iz1 = find(z>zlim(1),1,'first');
    iz2 = find(z<zlim(2),1,'last');
    ipx = ix1:2:ix2;
    ipz = iz1:2:iz2;
    
    doA = 1;
    if doA    
      cA = [0.8 0.8 0.8];
      cA = [0.7 0.7 0.7];
      nA = 40;
      nA = [0:-1:min(A(:))];
      ipxA = ix1:10:ix2;
      ipzA = iz1:10:iz2;
    end
    
    
    % Panels
    isub = 1;
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
      if abs(himag.CData(not(isnan(himag.CData)))) % dont do if is zero
        hca.CLim = max(abs(himag.CData(:)))*[-1 1];  
      end
      hcb = colorbar('peer',hca);
      hcb.YLabel.String = varstr;
      hcb.YLim = cylim;
      hb(ivar) = hcb;
      %hcb.YLim = hca.CLim(2)*[-1 1];
      colormap(hca,pic_colors('blue_red'));

      if doA
        hold(hca,'on')
        hcont = contour(hca,x(ipxA),z(ipzA),A(ipxA,ipzA)',nA,'color',cA,'linewidth',0.7);  
        hold(hca,'off')  
      end
    end
    for ipanel = 1:npanels
      h(ipanel).YDir = 'normal';
      h(ipanel).XDir = 'reverse';
      h(ipanel).XLim = xlim;
      h(ipanel).YLim = zlim;
      h(ipanel).CLim = clim;      
    end
    h(1).Title.String = sprintf('time = %g (1/wci) = %g (1/wpe)',time,timestep);

    set(gcf,'color',[1 1 1]);
    
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

disp(sprintf('Total elapsed time is %.0f seconds',toc(tstart)))
end