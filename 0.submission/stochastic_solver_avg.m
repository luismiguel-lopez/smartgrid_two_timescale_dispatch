function results = stochastic_solver_avg...
    (benchmark, first_stage_initial, nu_lower_initial, ...
    nu_upper_initial, random_vars,...
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

nu_lower = zeros(size(nu_lower_initial, 1), n_iterations);
nu_lower(:,1) = nu_lower_initial;
nu_upper = zeros(size(nu_lower_initial, 1), n_iterations);
nu_upper(:,1) = nu_upper_initial;
nu_var = zeros(size(nu_lower_initial, 1), 1);

C_diesel  = @(x) params.pd_linear'*x + params.pd_quadratic'*x.^2;
dCdp_diesel= @(x) params.pd_linear + 2*params.pd_quadratic.*x;
c = 1000;
cost = zeros(1, n_iterations);

for k = 1:n_iterations,
    my_random_vars = struct();
    my_random_vars.p_load = random_vars.p_load(:, k);
    my_random_vars.q_load = random_vars.q_load(:, k);
    my_random_vars.pinv_available = ...
        random_vars.pinv_available(:, k);
    % Solve the instantaneous dispatch:
    inst_results(k) = solve_instantaneous(benchmark, ...
        first_stage_vars(k), my_random_vars, params, ...
        v_bounds_loose, c, 0, ...
        nu_lower(:,k), nu_upper(:,k), nu_var, hyp.precision);
    switch inst_results(k).status,
        case 'Solved'
            execute_step = 1;
        case 'Inaccurate/Solved'
            execute_step = 1;        
        otherwise
            execute_step = 0;
    end
    if execute_step,
        % dual update:
        nu_upper(:, k+1) = max(0, nu_upper(:,k) + ...
            hyp.mu0*stepsize(k)*...
            (inst_results(k).v  -v_bounds_tight.v_upper));
        nu_lower(:, k+1) = max(0, nu_lower(:,k) + ...
            hyp.mu0*stepsize(k)*...
            (-inst_results(k).v +v_bounds_tight.v_lower));
        % primal updates:
        next_v_0 =max(v0_bounds.v_lower,min(v0_bounds.v_upper,...
            first_stage_vars(k).v_0 + eps_v0*stepsize(k)*...
            sum(inst_results(k).rho) ));
        next_p_diesel = max(params.pd_lower, min(...
            params.pd_upper, first_stage_vars(k).p_diesel - ...
            eps_pd*stepsize(k)*...
            (dCdp_diesel(first_stage_vars(k).p_diesel) - ...
            inst_results(k).theta) ));
        next_p0_a=first_stage_vars(k).p0_advance-eps_p0*...
            stepsize(k)*(params.beta-inst_results(k).lambda);
        % keeping track of the net cost:
        cost(k) = inst_results(k).optval + params.beta*...
            first_stage_vars(k).p0_advance + C_diesel(...
            first_stage_vars(k).p_diesel);
    else % in case the problem is not feasible  
         % or the optimization fails
        nu_upper(:, k+1) = nu_upper(:, k);
        nu_lower(:, k+1) = nu_lower(:, k);
        next_v_0        = first_stage_vars(k).v_0;
        next_p_diesel   = first_stage_vars(k).p_diesel;
        next_p0_a       = first_stage_vars(k).p0_advance;
        cost(k) = Inf;
        beep
        display 'infeasible/failed'
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
    my_indices = intersect(find(isfinite(cost)),k_init:k);
    avg_cost(k) = stepsize(my_indices)*...
        cost(my_indices)'./sum(stepsize(my_indices));
    nu_lower_out(:, k) = stepsize(k_init:k)* ...
        nu_lower(:, k_init:k)'./sum(stepsize(k_init:k));
    nu_upper_out(:, k) = stepsize(k_init:k)* ...
        nu_upper(:, k_init:k)'./sum(stepsize(k_init:k));

    if hyp.evaluate_output, 
        % evaluate the performance of the output variables
        real_results(k) = solve_instantaneous(benchmark, ...
            first_stage_out(k), my_random_vars, params, ...
            v_bounds_loose, c, 0, nu_lower(k,:), nu_upper(k,:));
        switch real_r_loose(k).status,
            case 'Solved',              was_solved = 1;
            case 'Inaccurate/Solved',   was_solved = 1;
            otherwise,                  was_solved = 0;
        end
        if was_solved,
            real_cost(k) = real_results(k).optval ...
                + params.beta*first_stage_out(k).p0_advance ...
                + C_diesel(first_stage_out(k).p_diesel);
        else
            real_cost(k) = Inf;
            beep
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
        plot(nu_lower(:, 1:k)'); 
        hold on; plot(nu_lower_out(:, 1:k)', 'r');
        ylabel '\nu lower'
        subplot(nrows, ncols, 5);
        plot(nu_upper(:,1:k)');
        hold on; plot(nu_upper_out(:, 1:k)', 'r');
        ylabel '\nu upper'
        subplot(nrows, ncols, 6);
        plot(cost); hold on
        plot(avg_cost,'g');
        if hyp.evaluate_output, 
            plot(real_cost, 'r');
            plot(cumsum(real_cost)./...
                 (1:k), 'c');
        end
%         subplot(nrows, ncols, 6);
%         plot(cumsum(indicator_loose(1:k))./(1:k)); hold on;
%         plot([1, k], ones(1, 2)*params.alpha, 'r--');
        drawnow;
    end
end

results = struct();
results.first_stage_out     = first_stage_out;
results.first_stage_vars    = first_stage_vars;
results.inst_results        = inst_results;
%results.indicator_loose     = indicator_loose;
results.cost                = cost;
results.avg_cost            = avg_cost;
results.nu_upper            = nu_upper;
results.nu_lower            = nu_lower;
results.nu_upper_out        = nu_upper_out;
results.nu_lower_out        = nu_lower_out;
if hyp.evaluate_output,
    results.real_results    = real_results;
    results.real_cost       = real_cost;
end