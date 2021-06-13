clear; close all
%%
preprocess;

buses_pm = [3 4 5 7 14 25 28 32 44 51];
b_pm = false(1, Nb);
b_pm(buses_pm) = 1;

params = struct();
params.pm_lower = zeros(Nb, 1);
params.pm_upper = zeros(Nb, 1);
params.pm_upper(b_pm) = 0.25;
%http://www.powermag.com/microturbine-technology-matures/
microturbine_pf = 0.8;
params.pm_diag_phi = diag(b_pm)*tan(acos(microturbine_pf));
params.S2 = 11*ones(Nb,1);
params.pi_inverter = 0.15*ones(Nb,1);  % typical value
params.pm_linear = 0.25*ones(Nb,1);    % reasonable value 
params.pm_quadratic = 1*ones(Nb,1); % a value such that 
% there is some curvature
% pm_space = linspace(0, 0.2, 100);
% plot(pm_space, mean(params.pm_linear)    * pm_space + ...
%                mean(params.pm_quadratic) * pm_space.^2);
params.beta   = 0.25;
params.gammaB = 0.30;
params.gammaS = 0.20;
%%
v_bounds_tight = struct();
v_bounds_tight.v_upper = 1.02.^2*ones(Nb, 1);
v_bounds_tight.v_lower = 0.98.^2*ones(Nb, 1);

v_bounds_loose = struct();
v_bounds_loose.v_upper = 1.03.^2*ones(Nb, 1);
v_bounds_loose.v_lower = 0.97.^2*ones(Nb, 1);

b_pv = zeros(Nb,1);
b_pv(44) = 1;
nominal_pv = 5*b_pv; %SCE 56 nodes (Gan, Li, Topcu and Low)
params.s2_inverter = 36*b_pv;
inverter_pf = 0.6;
params.phi_inverter = b_pv*tan(acos(inverter_pf));

random_vars_example = struct();
random_vars_example.p_load = 2*nominal_loads(2:end);
random_vars_example.q_load = 0.5*nominal_loads(2:end);
random_vars_example.pinv_available = 0.8*nominal_pv;

first_stage_vars_example = struct();
first_stage_vars_example.p_diesel = zeros(Nb,1);
first_stage_vars_example.v_0 = 1.01.^2;
first_stage_vars_example.p0_advance = 0;

%%
% sweep values for the substation voltage
npoints = 20;
v0s = linspace(0.98.^2, 1.02.^2, npoints);
c = 100;
for i = 1:npoints,
    first_stage_vars_example.v_0 = v0s(i);
    results_tight(i) = solve_instantaneous(...
        benchmark, first_stage_vars_example, ...
        random_vars_example, params, v_bounds_tight, c, 0);
    results_loose(i) = solve_instantaneous(...
        benchmark, first_stage_vars_example, ...
        random_vars_example, params, v_bounds_loose, c, 0);
    value_tight(i) = results_tight(i).optval;
    value_loose(i) = results_loose(i).optval;
    derivative(i) = sum(results_tight(i).rho);
    feasible_tight(i) = max(abs(results_tight(i).rho))<(0.9*c);
    feasible_loose(i) = max(abs(results_loose(i).rho))<(0.9*c);
end
%%
figure(3); clf;
plot(v0s, value_tight, 'b');
hold on
plot(v0s(not(feasible_tight)), ...
    value_tight(not(feasible_tight)), 'xr',...
    'markersize', 14);
plot(v0s, value_loose, 'g');
plot(v0s(not(feasible_tight)), ...
    value_loose(not(feasible_tight)), 'xr',...
    'markersize', 14);
%%
figure(4); clf;
plot(v0s, derivative);
hold on;
stem(v0s(feasible_tight), derivative(feasible_tight), 'r');

figure(5); clf
plot(v0s, value_tight);
ax = axis;
hold on
for i = 1:npoints,
    plot(v0s, derivative(i)*(v0s-v0s(i))+value_tight(i), 'r')
end
axis(ax);

%%
figure(1), clf; 
results = results_tight(i); %last values
plot(results.v, 's')
hold on, 
plot([1 Nb], mean(v_bounds_tight.v_lower)*ones(1, 2), 'r--')
plot([1 Nb], mean(v_bounds_tight.v_upper)*ones(1, 2), 'r--')
figure(2); clf;
stem(results.rho)
