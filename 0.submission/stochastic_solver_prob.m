function results = stochastic_solver_prob...
    (benchmark, first_stage_initial, nu_initial, random_vars,...
    params, v_bounds_tight, v_bounds_loose, v0_bounds, ...
    hyp, debug_modes)

% initialize the first-stage variables
first_stage_vars = first_stage_initial;

n_iterations = hyp.n_iterations;

switch hyp.stepsize_mode,
    case 'constant',
        stepsize = ones(1, n_iterations);
    case 'O(1/sqrt(k))'
        stepsize= sqrt(1./(1:n_iterations));
end
eps_p0 = hyp.epsilon0_p0;
eps_v0 = hyp.epsilon0_v0;
eps_pd = hyp.epsilon0_pd;

nu = zeros(1, n_iterations);
nu(1) = nu_initial;
indicator_loose = zeros(1, n_iterations);

pd_lower = params.pd_lower;
pd_upper = params.pd_upper;

C_diesel  = @(x) params.pd_linear'*x + params.pd_quadratic'*x.^2;
dCdp_diesel= @(x) params.pd_linear + 2*params.pd_quadratic.*x;
c = 1000;
cost = zeros(1, n_iterations);

nu_ul = zeros(1, benchmark.Nb);

for k = 1:n_iterations,
    my_random_vars = struct();
    my_random_vars.p_load = random_vars.p_load(:, k);
    my_random_vars.q_load = random_vars.q_load(:, k);
    my_random_vars.pinv_available = ...
        random_vars.pinv_available(:, k);
    % Solve the instantaneous dispatch:
    inst_r_loose(k) = solve_instantaneous(benchmark, ...
        first_stage_vars(k), my_random_vars, params, ...
        v_bounds_loose, c, 0, nu_ul', nu_ul', nu_ul', hyp.precision);
    switch inst_r_loose(k).status,
        case 'Solved'
            execute_step = 1;
        case 'Inaccurate/Solved'
            execute_step = 1;        
        otherwise
            execute_step = 0;
    end
    if execute_step,
        if all(inst_r_loose(k).v<=v_bounds_tight.v_upper) &&...
           all(inst_r_loose(k).v>=v_bounds_tight.v_lower),
            inst_r_tight(k) = inst_r_loose(k);
            inst_results(k) = inst_r_loose(k);
            indicator_loose(k) = 0;
        else
            inst_r_tight(k) = solve_instantaneous(benchmark, ...
                first_stage_vars(k), my_random_vars, params, ...
                v_bounds_tight, c, 0, nu_ul', nu_ul', nu_ul', hyp.precision);    
            if inst_r_tight(k).optval < ...
                    inst_r_loose(k).optval+nu(k),
                indicator_loose(k) = 0;
                inst_results(k) = inst_r_tight(k);
            else
                indicator_loose(k) = 1;
                inst_results(k) = inst_r_loose(k);
            end
        end
        %dual update:
        nu(k+1) = max(0, nu(k) + hyp.mu0*stepsize(k)*...
            (indicator_loose(k)-params.alpha)); 
        %primal updates:
        next_v_0 =max(v0_bounds.v_lower,min(v0_bounds.v_upper,...
            first_stage_vars(k).v_0 + eps_v0*stepsize(k)*...
            sum(inst_results(k).rho) ));
        next_p_diesel = max(pd_lower, min(pd_upper, ...
            first_stage_vars(k).p_diesel - eps_pd*stepsize(k)*...
            (dCdp_diesel(first_stage_vars(k).p_diesel) - ...
            inst_results(k).theta) ));
        next_p0_a=first_stage_vars(k).p0_advance-eps_p0*...
            stepsize(k)*(params.beta-inst_results(k).lambda);
        % keeping track of the net cost:
        cost(k) = inst_results(k).optval + params.beta*...
            first_stage_vars(k).p0_advance + C_diesel(...
            first_stage_vars(k).p_diesel);
    else %in case the loose optimization is not feasible:
        nu(k+1) = nu(k);
        next_v_0 = first_stage_vars(k).v_0;
        next_p_diesel = first_stage_vars(k).p_diesel;
        next_p0_a = first_stage_vars(k).p0_advance;
        cost(k) = Inf;
        indicator_loose(k) = 1;
        beep
        display 'loose -> infeasible'
    end
    first_stage_vars(k+1).v_0 = next_v_0;
    first_stage_vars(k+1).p_diesel = next_p_diesel;
    first_stage_vars(k+1).p0_advance = next_p0_a;
    % sliding averages:
    k_init = ceil(hyp.r*k);
    first_stage_out(k).v_0 = stepsize(k_init:k)*...
        cat(1, first_stage_vars(k_init:k).v_0)./...
        sum(stepsize(k_init:k));
    first_stage_out(k).p_diesel = (stepsize(k_init:k)*...
        cat(2, first_stage_vars(k_init:k).p_diesel)'./...
        sum(stepsize(k_init:k))).';
    first_stage_out(k).p0_advance = stepsize(k_init:k)*...
        cat(1, first_stage_vars(k_init:k).p0_advance)./...
        sum(stepsize(k_init:k));
    my_indices = find(isfinite(cost(k_init:k)));
    avg_cost(k) = stepsize(my_indices)*...
        cost(my_indices)'./sum(stepsize(my_indices));
    nu_out(k) = stepsize(k_init:k)*nu(k_init:k)'./....
        sum(stepsize(k_init:k));
    if hyp.evaluate_output, 
        real_r_loose(k) = solve_instantaneous(benchmark, ...
            first_stage_out(k), my_random_vars, params, ...
            v_bounds_loose, c, 0, nu_ul, nu_ul);
        if isequal(real_r_loose(k).status, 'Solved'),
            if all(real_r_loose(k).v<=v_bounds_tight.v_upper) &&...
               all(real_r_loose(k).v>=v_bounds_tight.v_lower),
                real_r_tight(k) = real_r_loose(k);
                real_results(k) = real_r_loose(k);
                real_ind_loose(k) = 0;
            else
                real_r_tight(k) = solve_instantaneous(benchmark, ...
                    first_stage_out(k), my_random_vars, params, ...
                    v_bounds_tight, c, 0, nu_ul, nu_ul);     
                if real_r_tight(k).optval < ...
                        real_r_loose(k).optval+nu_out(k),
                    real_ind_loose(k) = 0;
                    real_results(k) = real_r_tight(k);
                else
                    real_ind_loose(k) = 1;
                    real_results(k) = real_r_loose(k);
                end
            end
            real_cost(k) = real_results(k).optval + params.beta*...
                first_stage_out(k).p0_advance + C_diesel(...
                first_stage_out(k).p_diesel);
        else
            real_cost(k) = Inf;
            real_ind_loose(k) = 1;
        end
    end
    %%
    if isfield(debug_modes, 'plot'), 
        figure(debug_modes.plot); clf;
        nrows = 2;
        ncols = 3;
        subplot(nrows, ncols, 1);
        plot(cat(1, first_stage_vars.v_0)); hold on
        plot(cat(1, first_stage_out.v_0), 'r');
        ylabel v_0^2(pu)
        subplot(nrows, ncols,2);
        plot(cat(2, first_stage_vars.p_diesel)'); hold on
        plot(cat(2, first_stage_out.p_diesel)', 'r');
        ylabel 'p_{diesel} (MW)'
        subplot(nrows, ncols,3);
        plot(cat(1, first_stage_vars.p0_advance)); hold on
        plot(cat(1, first_stage_out.p0_advance), 'r');
        ylabel 'p_0^a (MW)'
        subplot(nrows, ncols,4);
        stem(nu); hold on
        plot(nu_out, 'rs');
        ylabel \nu
        subplot(nrows, ncols, 5);
        plot(cost); hold on
        plot(avg_cost,'g');
        if hyp.evaluate_output, 
            plot(real_cost, 'r');
            plot(cumsum(real_cost)./...
                 (1:k), 'c');
        end
        subplot(nrows, ncols, 6);
        plot(cumsum(indicator_loose(1:k))./(1:k)); hold on;
        plot([1, k], ones(1, 2)*params.alpha, 'r--');
        drawnow;
    end
end

results = struct();
results.first_stage_out     = first_stage_out;
results.first_stage_vars    = first_stage_vars;
results.inst_results        = inst_results;
results.indicator_loose     = indicator_loose;
results.cost                = cost;
results.avg_cost            = avg_cost;
results.nu                  = nu;
results.nu_out              = nu_out;
if hyp.evaluate_output,
    results.real_results    = real_results;
    results.real_cost       = real_cost;
end