% initial conditions
n0 = 1;
L0 = 1;
nL = 0.2;
LL = 1.5;
n_harris = @(n0,L,z) n0*cosh(z/L).^(-2);
n_lobe = @(n0,L,z) nL - n_harris(n0,L,z);
n_lobe1 = @(n0,L,z) 0.5*nL*(1+tanh((z-1*L)/L*2));
n_lobe2 = @(n0,L,z) 0.5*nL*(1+tanh((-z-1*L)/L*2));

z = linspace(-10,10,100);
plot(z,n_harris(n0,L0,z),z,n_lobe1(n0,LL,z),z,n_lobe2(n0,LL,z),z,n_harris(n0,LL,z)+n_lobe1(n0,LL,z)+n_lobe2(n0,LL,z))