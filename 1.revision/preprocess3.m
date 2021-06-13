load case123

Nb = 122;
benchmark = struct();
benchmark.Nb = Nb;

bus_from = lines(:,1);
bus_to = lines(:,2);
r = lines(:,3);
x = lines(:,4);

loads_123 = -Pnet;
ql_123 = -Qnet;

% generate branch-bus incidence matrix
A_tilde = zeros(Nb, Nb+1);
for i = 1:Nb,
    A_tilde(i, bus_from(i)) = 1;
    A_tilde(i, bus_to(i)) = -1;
end

a_0 = A_tilde(:,1);      % branch-substation incidence vector
A   = A_tilde(:, 2:end); % reduced branch-bus incidence matrix

F = inv(A);
benchmark.F = F;

%base values to normalize electric quantities:
benchmark.v_base = 1;    %kV
benchmark.s_base = 1;     %MVA
benchmark.z_base = 1;  %ohm

benchmark.R = F*diag(r)*F.'./benchmark.z_base; %#ok<MINV>
benchmark.X = F*diag(x)*F.'./benchmark.z_base; %#ok<MINV>

%nominal loads:
nominal_loads = loads_123(1:end);

buses_smallp = find(dist(nominal_loads, 0.0667)<0.05)-1;
buses_pd = buses_smallp(mod(1:size(buses_smallp),2)==1);

buses_pv = buses_smallp(end-(0:2:6));

