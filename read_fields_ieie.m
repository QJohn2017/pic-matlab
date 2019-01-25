function [time,r,e,b,ni,ne,ve,vi,je,ji,pe,pi,dfac,teti,nnx,nnz,wpewce,mass,it,dt,xmax,zmax,q] = read_fields_ieie(txtfile)
% [time,r,e,b,ni,ne,ve,vi,je,ji,pe,pi,dfac,teti,nnx,nnz,wpewce,mass,it,dt,xmax,zmax,q] = read_fields_ieie(txtfile)
    
%% Read data from fields-_____.dat file
%tic
nss = 4; % Oxygen run has 4 species
[fid, message] = fopen(txtfile,'r','ieee-le');
      if fid < 0
        error('Failed to open file "%s" because "%s"', txtfile, message);
      end
header = fread(fid,1,'integer*8');

it = fread(fid,1,'integer*4');                                % it
dt = fread(fid,1,'real*4');                                   % dt
teti = fread(fid,1,'real*4');                                 % teti
xmax = fread(fid,1,'real*4');                                 % xmax
zmax = fread(fid,1,'real*4');                                 % zmax
nnx = fread(fid,1,'integer*4');                               % nnx
nnz = fread(fid,1,'integer*4');                               % nnz

vxs = zeros(nnx,nnz,nss);
vys = zeros(nnx,nnz,nss);
vzs = zeros(nnx,nnz,nss);

for is = 1:nss, vxs(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % vxs 
for is = 1:nss, vys(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % vys 
for is = 1:nss, vzs(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % vzs
bx = fread(fid,[nnx nnz],'real*4');                           % bx 
by = fread(fid,[nnx nnz],'real*4');                           % by 
bz = fread(fid,[nnx nnz],'real*4');                           % bz 
ex = fread(fid,[nnx nnz],'real*4');                           % ex 
ey = fread(fid,[nnx nnz],'real*4');                           % ey 
ez = fread(fid,[nnx nnz],'real*4');                           % ez 

dns = zeros(nnx,nnz,nss);
for is = 1:nss, dns(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % dns 
xe = fread(fid,nnx,'real*4');                                 % xe 
ze = fread(fid,nnz,'real*4');                                 % ze 
mass = fread(fid,nss,'real*4');                               % mass 
q = fread(fid,nss,'real*4');                                  % q 
time = fread(fid,1,'real*8');                                 % time 
wpewce = fread(fid,1,'real*4');                               % wpewce 
dfac = fread(fid,nss,'real*4');                               % dfac
pxx = zeros(nnx,nnz,nss);
pyy = zeros(nnx,nnz,nss);
pzz = zeros(nnx,nnz,nss);
pxy = zeros(nnx,nnz,nss);
pxz = zeros(nnx,nnz,nss);
pyz = zeros(nnx,nnz,nss);

for is = 1:nss, pxx(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % pxx 
for is = 1:nss, pyy(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % pyy 
for is = 1:nss, pzz(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % pzz 
for is = 1:nss, pxy(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % pxy 
for is = 1:nss, pxz(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % pxz 
for is = 1:nss, pyz(:,:,is) = fread(fid,[nnx nnz],'real*4'); end  % pyz
remainder = fread(fid); 
%toc

%% Normalize fields, time

xe=xe/sqrt(mass(1));
ze=ze/sqrt(mass(1));
bx=bx*wpewce(1);
by=by*wpewce(1);
bz=bz*wpewce(1);
ex=ex*sqrt(mass(1))*wpewce(1)^2;
ey=ey*sqrt(mass(1))*wpewce(1)^2;
ez=ez*sqrt(mass(1))*wpewce(1)^2;

time = time/wpewce/sqrt(mass(1));

%% Mixed (hydrogen (1-2) oxygen (3-4))
    ion = 1;
    ele = 2;
    
    dni=squeeze(dns(:,:,ion(1)))*dfac(ion(1));
    dne=squeeze(dns(:,:,ele(1)))*dfac(ele(1));
    
    jix=squeeze(vxs(:,:,ion(1)))*dfac(ion(1));
    jiy=squeeze(vys(:,:,ion(1)))*dfac(ion(1));
    jiz=squeeze(vzs(:,:,ion(1)))*dfac(ion(1));
    
   
    
    vix = jix./dni;
    viy = jiy./dni;
    viz = jiz./dni;
    vix(dni < 0.005) = 0;
    viy(dni < 0.005) = 0;
    viz(dni < 0.005) = 0;
    
    jex=squeeze(vxs(:,:,ele(1)))*dfac(ele(1)) ;
    jey=squeeze(vys(:,:,ele(1)))*dfac(ele(1)) ;
    jez=squeeze(vzs(:,:,ele(1)))*dfac(ele(1));
    
    vex = jex./dne;
    vey = jey./dne;
    vez = jez./dne;
    
    vex(dne < 0.005) = 0;
    vey(dne < 0.005) = 0;
    vez(dne < 0.005) = 0;
        
    pxxi=squeeze(pxx(:,:,ion))*dfac(ion);
    pyyi=squeeze(pyy(:,:,ion))*dfac(ion);
    pzzi=squeeze(pzz(:,:,ion))*dfac(ion);
    pxyi=squeeze(pxy(:,:,ion))*dfac(ion);
    pxzi=squeeze(pxz(:,:,ion))*dfac(ion);
    pyzi=squeeze(pyz(:,:,ion))*dfac(ion);
    
    pxzi=mass(ion)*(pxzi-vix.*jiz);
    pxxi=mass(ion)*(pxxi-vix.*jix);
    pxyi=mass(ion)*(pxyi-vix.*jiy);
    pyyi=mass(ion)*(pyyi-viy.*jiy);
    pyzi=mass(ion)*(pyzi-viy.*jiz);
    pzzi=mass(ion)*(pzzi-viz.*jiz);
    
    % Move to right frame
    
%     pxzi=mass(ion)*(pxzi-vix.*jiz-jix.*viz+dni.*vix.*viz);
%     pxxi=mass(ion)*(pxxi-vix.*jix-jix.*vix+dni.*vix.*vix);
%     pxyi=mass(ion)*(pxyi-vix.*jiy-jix.*viy+dni.*vix.*viy);
%     pyyi=mass(ion)*(pyyi-viy.*jiy-jiy.*viy+dni.*viy.*viy);
%     pyzi=mass(ion)*(pyzi-viy.*jiz-jiy.*viz+dni.*viy.*viz);
%     pzzi=mass(ion)*(pzzi-viz.*jiz-jiz.*viz+dni.*viz.*viz);

    
    pxxe=squeeze(pxx(:,:,ele))*dfac(ele);
    pyye=squeeze(pyy(:,:,ele))*dfac(ele);
    pzze=squeeze(pzz(:,:,ele))*dfac(ele);
    pxye=squeeze(pxy(:,:,ele))*dfac(ele);
    pxze=squeeze(pxz(:,:,ele))*dfac(ele);
    pyze=squeeze(pyz(:,:,ele))*dfac(ele);

    pxze=mass(ele)*(pxze-vex.*jez);
    pxxe=mass(ele)*(pxxe-vex.*jex);
    pxye=mass(ele)*(pxye-vex.*jey);
    pyye=mass(ele)*(pyye-vey.*jey);
    pyze=mass(ele)*(pyze-vey.*jez);
    pzze=mass(ele)*(pzze-vez.*jez);
    
%     pxze=mass(ele)*(pxze-vex.*jez-jex.*vez+dne.*vex.*vez);
%     pxxe=mass(ele)*(pxxe-vex.*jex-jex.*vex+dne.*vex.*vex);
%     pxye=mass(ele)*(pxye-vex.*jey-jex.*vey+dne.*vex.*vey);
%     pyye=mass(ele)*(pyye-vey.*jey-jey.*vey+dne.*vey.*vey);
%     pyze=mass(ele)*(pyze-vey.*jez-jey.*vez+dne.*vey.*vez);
%     pzze=mass(ele)*(pzze-vez.*jez-jez.*vez+dne.*vez.*vez);
    
    % I have no idea 
    
     jix=jix*wpewce(1)*sqrt(mass(1));
    jiy=jiy*wpewce(1)*sqrt(mass(1));
    jiz=jiz*wpewce(1)*sqrt(mass(1));
    
    vix = jix./dni;
    viy = jiy./dni;
    viz = jiz./dni;
    vix(dni < 0.005) = 0;
    viy(dni < 0.005) = 0;
    viz(dni < 0.005) = 0;
    
    
     jex=jex*wpewce(1)*sqrt(mass(1));
    jey=jey*wpewce(1)*sqrt(mass(1));
    jez=jez*wpewce(1)*sqrt(mass(1));
    
        vex = jex./dne;
    vey = jey./dne;
    vez = jez./dne;
    
    vex(dne < 0.005) = 0;
    vey(dne < 0.005) = 0;
    vez(dne < 0.005) = 0;
    
    
    pxxi=pxxi*wpewce(1)^2;
    pyyi=pyyi*wpewce(1)^2;
    pzzi=pzzi*wpewce(1)^2;
    pxyi=pxyi*wpewce(1)^2;
    pxzi=pxzi*wpewce(1)^2;
    pyzi=pyzi*wpewce(1)^2;
    
    pxxe=pxxe*wpewce(1)^2;
    pyye=pyye*wpewce(1)^2;
    pzze=pzze*wpewce(1)^2;
    pxye=pxye*wpewce(1)^2;
    pxze=pxze*wpewce(1)^2;
    pyze=pyze*wpewce(1)^2;

%     pi=(pxxi+pyyi+pzzi)/3;
%     pe=(pxxe+pyye+pzze)/3;
%     
%     
%     tmp=(jix.^2+jiy.^2+jiz.^2)/2;
%     eki = tmp./dni;
%     eki(dni < threshold) = 0;
% 
% 
%     tmp=(jex.^2+jey.^2+jez.^2)/2;
% %     dendiv,tmp,dne,eke,threshold
%     eke = tmp./dne;
%     eke(dni < threshold) = 0;
% 
%     tmp=(pxxi+pyyi+pzzi)/3;
% %     dendiv,tmp,dni,ti,threshold
%     ti = tmp./dni;
%     ti(dni < threshold) = 0;
% 
%     tmp=(pxxe+pyye+pzze)/3;
% %     dendiv,tmp,dne,te,threshold
%     te = tmp./dne;
%     te(dni < threshold) = 0;
% 
%      Vixz_o_divergence = 1;
    

%% Mixed (hydrogen (1-2) oxygen (3-4))
    ion = 3;
    ele = 4;
    
    dni_h=squeeze(dns(:,:,ion(1)))*dfac(ion(1));
    dne_h=squeeze(dns(:,:,ele(1)))*dfac(ele(1));
    
    jix_h=squeeze(vxs(:,:,ion(1)))*dfac(ion(1));
    jiy_h=squeeze(vys(:,:,ion(1)))*dfac(ion(1));
    jiz_h=squeeze(vzs(:,:,ion(1)))*dfac(ion(1));
    
    vix_h = jix_h./dni_h;
    viy_h = jiy_h./dni_h;
    viz_h = jiz_h./dni_h;
    vix_h(dni_h < 0.005) = 0;
    viy_h(dni_h < 0.005) = 0;
    viz_h(dni_h < 0.005) = 0;
    
    jex_h=squeeze(vxs(:,:,ele(1)))*dfac(ele(1)) ;
    jey_h=squeeze(vys(:,:,ele(1)))*dfac(ele(1)) ;
    jez_h=squeeze(vzs(:,:,ele(1)))*dfac(ele(1));
    
    vex_h = jex_h./dne_h;
    vey_h = jey_h./dne_h;
    vez_h = jez_h./dne_h;
    
    vex_h(dne_h < 0.005) = 0;
    vey_h(dne_h < 0.005) = 0;
    vez_h(dne_h < 0.005) = 0;
        
    pxxi_h=squeeze(pxx(:,:,ion))*dfac(ion);
    pyyi_h=squeeze(pyy(:,:,ion))*dfac(ion);
    pzzi_h=squeeze(pzz(:,:,ion))*dfac(ion);
    pxyi_h=squeeze(pxy(:,:,ion))*dfac(ion);
    pxzi_h=squeeze(pxz(:,:,ion))*dfac(ion);
    pyzi_h=squeeze(pyz(:,:,ion))*dfac(ion);
    
    pxzi_h=mass(ion)*(pxzi_h-vix_h.*jiz_h);
    pxxi_h=mass(ion)*(pxxi_h-vix_h.*jix_h);
    pxyi_h=mass(ion)*(pxyi_h-vix_h.*jiy_h);
    pyyi_h=mass(ion)*(pyyi_h-viy_h.*jiy_h);
    pyzi_h=mass(ion)*(pyzi_h-viy_h.*jiz_h);
    pzzi_h=mass(ion)*(pzzi_h-viz_h.*jiz_h);
    
    pxxe_h=squeeze(pxx(:,:,ele))*dfac(ele);
    pyye_h=squeeze(pyy(:,:,ele))*dfac(ele);
    pzze_h=squeeze(pzz(:,:,ele))*dfac(ele);
    pxye_h=squeeze(pxy(:,:,ele))*dfac(ele);
    pxze_h=squeeze(pxz(:,:,ele))*dfac(ele);
    pyze_h=squeeze(pyz(:,:,ele))*dfac(ele);

    pxze_h=mass(ele)*(pxze_h-vex_h.*jez_h);
    pxxe_h=mass(ele)*(pxxe_h-vex_h.*jex_h);
    pxye_h=mass(ele)*(pxye_h-vex_h.*jey_h);
    pyye_h=mass(ele)*(pyye_h-vey_h.*jey_h);
    pyze_h=mass(ele)*(pyze_h-vey_h.*jez_h);
    pzze_h=mass(ele)*(pzze_h-vez_h.*jez_h);
    
    
    
     jex_h=jex_h*wpewce(1)*sqrt(mass(1));
    jey_h=jey_h*wpewce(1)*sqrt(mass(1));
    jez_h=jez_h*wpewce(1)*sqrt(mass(1));
    
        vex_h = jex_h./dne_h;
        vey_h = jey_h./dne_h;
        vez_h = jez_h./dne_h;
        vex_h(dne_h == 0) = 0;
        vey_h(dne_h == 0) = 0;
        vez_h(dne_h == 0) = 0;
    
    jix_h=jix_h*wpewce(1)*sqrt(mass(1));
    jiy_h=jiy_h*wpewce(1)*sqrt(mass(1));
    jiz_h=jiz_h*wpewce(1)*sqrt(mass(1));
    
        vix_h = jix_h./dni_h;
        viy_h = jiy_h./dni_h;
        viz_h = jiz_h./dni_h;
        vix_h(dni_h == 0) = 0;
        viy_h(dni_h == 0) = 0;
        viz_h(dni_h == 0) = 0;

    pxxi_h=pxxi_h*wpewce(1)^2;
    pyyi_h=pyyi_h*wpewce(1)^2;
    pzzi_h=pzzi_h*wpewce(1)^2;
    pxyi_h=pxyi_h*wpewce(1)^2;
    pxzi_h=pxzi_h*wpewce(1)^2;
    pyzi_h=pyzi_h*wpewce(1)^2;
    
    pxxe_h=pxxe_h*wpewce(1)^2;
    pyye_h=pyye_h*wpewce(1)^2;
    pzze_h=pzze_h*wpewce(1)^2;
    pxye_h=pxye_h*wpewce(1)^2;
    pxze_h=pxze_h*wpewce(1)^2;
    pyze_h=pyze_h*wpewce(1)^2;

%     pi_h=(pxxi_h+pyyi_h+pzzi_h)/3;
%     pe_h=(pxxe_h+pyye_h+pzze_h)/3;
%     
%     tmp=(jix_h.^2+jiy_h.^2+jiz_h.^2)/2;
%     eki_h = tmp./dni_h;
% %     dendiv,tmp,dni,eki,threshold
%     eki_h(dni_h < threshold) = 0;
% 
% 
%     tmp=(jex_h.^2+jey_h.^2+jez_h.^2)/2;
% %     dendiv,tmp,dne,eke,threshold
%     eke_h = tmp./dne_h;
%     eke_h(dni_h < threshold) = 0;
% 
%     tmp=(pxxi_h+pyyi_h+pzzi_h)/3;
% %     dendiv,tmp,dni,ti,threshold
%     ti_h = tmp./dni_h;
%     ti_h(dni_h < threshold) = 0;
% 
%     tmp=(pxxe_h+pyye_h+pzze_h)/3;
% %     dendiv,tmp,dne,te,threshold
%     te_h = tmp./dne_h;
%     te_h(dni_h < threshold) = 0;

%     Vixz_o_divergence


% %% Proton    
%     ion = 1;
%     ele = 2;
%     
%     dni_p=squeeze(dns(:,:,ion(1)))*dfac(ion(1));
%     dne_p=squeeze(dns(:,:,ele(1)))*dfac(ele(1));
%     
%     jix_p=squeeze(vxs(:,:,ion(1)))*dfac(ion(1));
%     jiy_p=squeeze(vys(:,:,ion(1)))*dfac(ion(1));
%     jiz_p=squeeze(vzs(:,:,ion(1)))*dfac(ion(1));
%      
%     vix_p = jix_p./dni_p;
%     viy_p = jiy_p./dni_p;
%     viz_p = jiz_p./dni_p;
%     
%     jex_p=squeeze(vxs(:,:,ele(1)))*dfac(ele(1)) ;
%     jey_p=squeeze(vys(:,:,ele(1)))*dfac(ele(1)) ;
%     jez_p=squeeze(vzs(:,:,ele(1)))*dfac(ele(1));    
%     
%% Collect data in structures, r, b, e, ni, ne, vi, ve, ji, je, pi, pe
r.units = 'r/di';
r.x = xe;
r.z = ze;

b.units = 'B/B0';
b.x = bx;
b.y = by;
b.z = bz;
b.abs = sqrt(bx.^2 + by.^2 + bz.^2);

e.units = 'E*vA*B0';
e.x = ex;
e.y = ey;
e.z = ez;
e.abs = sqrt(ex.^2 + ey.^2 + ez.^2);
e.par = (ex.*bx + ey.*by + ez.*bz)./b.abs;
e.perp.x = ex - e.par.*bx./b.abs;
e.perp.y = ey - e.par.*by./b.abs;
e.perp.z = ez - e.par.*bz./b.abs;

ni.units = 'ni/n0';
ni.s1 = dni;
ni.s2 = dni_h;

ne.units = 'ne/n0';
ne.s1 = dni;
ne.s2 = dni_h;

ve.units = 've/vA';
ve.x1 = vex;
ve.x2 = vex_h;
ve.y1 = vey;
ve.y2 = vey_h;
ve.z1 = vez;
ve.z2 = vez_h;
ve.par1 = (ve.x1.*bx + ve.y1.*by + ve.z1.*bz)./b.abs;
ve.par2 = (ve.x2.*bx + ve.y2.*by + ve.z2.*bz)./b.abs;

vi.units = 'vi/vA';
vi.x1 = vix;
vi.x2 = vix_h;
vi.y1 = viy;
vi.y2 = viy_h;
vi.z1 = viz;
vi.z2 = viz_h;
vi.par1 = (vi.x1.*bx + vi.y1.*by + vi.z1.*bz)./b.abs;
vi.par2 = (vi.x2.*bx + vi.y2.*by + vi.z2.*bz)./b.abs;

je.units = '';
je.x1 = jex;
je.x2 = jex_h;
je.y1 = jey;
je.y2 = jey_h;
je.z1 = jez;
je.z2 = jez_h;

ji.units = 'vi/vA';
ji.x1 = jix;
ji.x2 = jix_h;
ji.y1 = jiy;
ji.y2 = jiy_h;
ji.z1 = jiz;
ji.z2 = jiz_h;


ve.units = 've/vA';
ve.x1 = vex;
ve.x2 = vex_h;
ve.y1 = vey;
ve.y2 = vey_h;
ve.z1 = vez;
ve.z2 = vez_h;

vi.units = 'vi/vA';
vi.x1 = vix;
vi.x2 = vix_h;
vi.y1 = viy;
vi.y2 = viy_h;
vi.z1 = viz;
vi.z2 = viz_h;

pe.units = '';
pe.xx1 = pxxe;
pe.yy1 = pyye;
pe.zz1 = pzze;
pe.xy1 = pxye;
pe.xz1 = pxze;
pe.yz1 = pyze;
pe.xx2 = pxxe_h;
pe.yy2 = pyye_h;
pe.zz2 = pzze_h;
pe.xy2 = pxye_h;
pe.xz2 = pxze_h;
pe.yz2 = pyze_h;
pe.s1 = (pxxe + pyye + pzze)/3;
pe.s2 = (pxxe_h + pyye_h + pzze_h)/3;

pi.units = '';
pi.xx1 = pxxi;
pi.yy1 = pyyi;
pi.zz1 = pzzi;
pi.xy1 = pxyi;
pi.xz1 = pxzi;
pi.yz1 = pyzi;
pi.xx2 = pxxi_h;
pi.yy2 = pyyi_h;
pi.zz2 = pzzi_h;
pi.xy2 = pxyi_h;
pi.xz2 = pxzi_h;
pi.yz2 = pyzi_h;
pi.s1 = (pxxi + pyyi + pzzi)/3;
pi.s2 = (pxxi_h + pyyi_h + pzzi_h)/3;