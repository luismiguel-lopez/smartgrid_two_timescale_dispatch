load data_56bus_sce

benchmark = struct();

Nb = 55;
benchmark.Nb = Nb;

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
benchmark.v_base = 12;    %kV
benchmark.s_base = 1;     %MVA
benchmark.z_base = 12^2;  %ohm

benchmark.R = F*diag(r)*F.'./benchmark.z_base; %#ok<MINV>
benchmark.X = F*diag(x)*F.'./benchmark.z_base; %#ok<MINV>

%nominal loads:
nominal_loads = zeros(Nb+1, 1);
nominal_loads(loads_sce(:,1)) = loads_sce(:,2);

buses_pd = [10, 18, 21, 30, 36, 43, 51, 55];
buses_pv = [44 50];

ql_123 = zeros(1, Nb+1)';