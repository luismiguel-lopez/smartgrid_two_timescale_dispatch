load data_56bus_sce

% duplicamos la red
bus_from2 = [bus_from; bus_from(2:end)+55; 1  ];
bus_to2   = [bus_to;   bus_to(2:end)+55;   57 ];
Nb = 110;
r2 = [r;r];
x2 = [x;x];

benchmark = struct();

benchmark.Nb = Nb;


% generate branch-bus incidence matrix
A_tilde = zeros(Nb, Nb+1);
for i = 1:Nb,
    A_tilde(i, bus_from2(i)) = 1;
    A_tilde(i, bus_to2(i)) = -1;
end

a_0 = A_tilde(:,1);      % branch-substation incidence vector
A   = A_tilde(:, 2:end); % reduced branch-bus incidence matrix

F = inv(A);
benchmark.F = F;

%base values to normalize electric quantities:
benchmark.v_base = 12;    %kV
benchmark.s_base = 1;     %MVA
benchmark.z_base = 12^2;  %ohm

benchmark.R = F*diag(r2)*F.'./benchmark.z_base; %#ok<MINV>
benchmark.X = F*diag(x2)*F.'./benchmark.z_base; %#ok<MINV>

%nominal loads:
nominal_loads = zeros(Nb+1, 1);
nominal_loads(loads_sce(:,1)) = loads_sce(:,2)/2;
nominal_lodas(loads_sce(:,1)+55) = loads_sce(:,2)/2;

