% evaluate results.

n_rlze = 30; %number of simulated time steps

rng(hyp.seed+1);
random_vars2 = struct();
random_vars2.p_load = ...
    tnomi_p_load*nominal_loads(2:end)*ones(1, n_rlze) ...
    + stdev_p_load*diag(nominal_loads(2:end))*randn(Nb, n_rlze);
random_vars2.q_load = ...
    stdev_q_load*diag(nominal_loads(2:end))*randn(Nb, n_rlze);
random_vars2.pinv_available = ...
    diag(nominal_pv)*(1-prop_p_avail*rand(Nb, n_rlze));

rng(hyp.seed+2);
random_vars3 = struct();
random_vars3.p_load = ...
    tnomi_p_load*nominal_loads(2:end)*ones(1, n_rlze) ...
    + stdev_p_load*diag(nominal_loads(2:end))*randn(Nb, n_rlze);
random_vars3.q_load = ...
    stdev_q_load*diag(nominal_loads(2:end))*randn(Nb, n_rlze);
random_vars3.pinv_available = ...
    diag(nominal_pv)*(1-prop_p_avail*rand(Nb, n_rlze));

hyp_eval = struct();
hyp_eval.n_iterations = n_rlze; 
hyp_eval.epsilon0_p0 = 0;
hyp_eval.epsilon0_v0 = 0;
hyp_eval.epsilon0_pd = 0;
hyp_eval.mu0 = hyp.mu0/10;
hyp_eval.evaluate_output = 0;
hyp_eval.stepsize_mode = 'constant';
hyp_eval.precision = 'low';
hyp_eval.r = 0.0001;

nu_initial = results.nu_out(end);
results_naive = stochastic_solver_prob(benchmark, ...
    first_stage_initial, nu_initial, ...
    random_vars2, params, v_bounds_tight, v_bounds_loose, ...
        v0_bounds, hyp_eval, struct('plot', 1));
    %%
results_optimal = stochastic_solver_prob(benchmark, ...
    results.first_stage_out(end), nu_initial, random_vars3, params, v_bounds_tight, ...
    v_bounds_loose, v0_bounds, hyp_eval, struct('plot', 2));

filename = ['evaluation-' datestr(now)];
filename(16)='_';
filename(filename==':') = [];
save(filename)
display(['Saved ' filename]);
beep

%%
figure(3);
plot(results_naive.avg_cost);
hold on
plot(results_optimal.avg_cost, 'g');

wsize = 1000;
figure(4); clf
plot(filter(ones(1, wsize), 1, results_naive.cost)./...
    min(wsize, 1:n_rlze));
hold on
plot(filter(ones(1, wsize), 1, results_optimal.cost)./...
    min(wsize, 1:n_rlze), 'g');