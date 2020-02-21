function h5write_dists(data_dir,filePath,nSpecies,timestep,iteration)
% H5WRITE_DISTS Write Michael's simulation output distribution data to h5 file.
% H5WRITE_DISTS(dirData,h5filePath,distIndices,nSpecies,dt)
%
% dirData - directory of data
% h5filepath - directory and file name
% distIndices - distribution numbers to resave, if empty [], go through 
%   all in directory and check them against existing ones (if any)
% nSpecies - number of species: required in order to read the data right
% dt - to convert from time to iteration (iteration is used in h5 data structure)

h5exist = 0;
newh5file = 0;
if exist(filePath,'file')
  h5exist = 1;
  disp(sprintf('File %s exists. Loading file to obtain existing distributions.',filePath))
  dist = PICDist(filePath);
  newh5file = 1; % if I want to add some ovearching information later
else
  %H5F.create(filePath); % does not work in older matlab versions
  %h5writeatt(filePath,'/','software','micPIC')
end

% data_dir can both be overarching directory with subdirectories for each
% time (or something else), or the directory for a given time
% first try for data files
fileList = dir([data_dir '*.dat']);
if isempty(fileList)
  warning('No .dat files in ''%s'', please check path.',filePath)
  return
end

% if isempty(fileList)
%   dirList = dir([data_dir '*00*']);
% end
% nDirs = numel(dirList);
% for 

nFiles = numel(fileList);

if newh5file
  id = 0;
else
  ds = dist.twpelim(timestep);
end
for iFile = 1:nFiles
  id = id + 1;
  h5write_dists_single(datFilePath,h5FilePath,nSpecies,iteration)
  
  if h5exist && not(isempty(find(timestep==pic.twpe)))
    disp(sprintf('twpe = %g already exists, skipping.',timestep))
    continue
  end
  txtfile = sprintf('%s/fields-%05.0f.dat',data_dir,timestep); 
  
  h5write_dists_single(datFilePath,h5FilePath,nSpecies,iteration)
  

end
% Embedded function
function h5write_dists_single(datFilePath,h5FilePath,nSpecies,iteration)
  % datFilePath - path to -dat file
  % h5FilePath - path to h5 file
  % 
  distnumber = dists(idist);  
  str_iteration = sprintf('%010.0f',iteration);

  % Read distributions  
  [axes,xlo,xhi,zlo,zhi,ic,fxyz,fxy,fxz,fyz,vxa,vya,vza] = read_distributions(datFilePath,nSpecies);

  % Write data to file
  %for isp = 1:nss
    %dataset_name = ['/data/' str_iteration '/' num2str(distnumber),'/'];
    %h5create(filePath, dataset_name, size(fxyz));
    %h5write(filePath, dataset_name, fxyz);

    dataset_name = ['/data/' str_iteration '/' num2str(distnumber,'%05.0f'),'/fxyz'];
    try
      h5create(filePath, dataset_name, size(fxyz));
    catch
      warning('h5 structure %s already exists',dataset_name)      
    end
    h5write(h5FilePath, dataset_name, fxyz);
    h5writeatt(h5FilePath, dataset_name,'x', [xlo xhi]);
    h5writeatt(h5FilePath, dataset_name,'z', [zlo zhi]);
    h5writeatt(h5FilePath, dataset_name,'ic', ic);
    h5writeatt(h5FilePath, dataset_name,'vxa', vxa);
    h5writeatt(h5FilePath, dataset_name,'vya', vya);
    h5writeatt(h5FilePath, dataset_name,'vza', vza);
    h5writeatt(h5FilePath, dataset_name,'axes', axes);

    h5disp(h5FilePath,dataset_name(1:(end-4)))

end
end