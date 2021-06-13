function [first_stage_vars, dual_vars, timing_struc] = ...
    solve_average(benchmark, params, random_vars_mean, v_bounds)

Nb      = benchmark.Nb;
F       = benchmark.F;
R       = benchmark.R;
X       = benchmark.X;
v_base  = benchmark.v_base;

Cd = @(x) params.pd_linear'*x + params.pd_quadratic'*x.^2; 
Cpv= @(p_inverter, p_load) ... 
    params.pi_inverter.'*max(0, p_inverter-p_load); %#ok<*NASGU>
p_load_avg = random_vars_mean.p_load;
q_load_avg = random_vars_mean.q_load;
pinv_available_avg = random_vars_mean.pinv_available;

cvx_begin
cvx_solver sedumi
variables p(Nb) q(Nb) p_0 P(Nb) Q(Nb) p_diesel(Nb) v(Nb) v_0 ...
    p_pv(Nb) q_pv(Nb)
dual variables dual_upper dual_lower dual_v
minimize params.beta*p_0 + Cd(p_diesel) + Cpv(p_pv, p_load_avg)
subject to
    p_pv - p_load_avg + p_diesel == p; %#ok<*EQEFF>
    q_pv - q_load_avg == q;                %#ok<*VUNUS>
    p_0 >= -sum(p) + (p.'*R*p + q.'*R*q)./v_base;
    p_diesel >= params.pd_lower;
    p_diesel <= params.pd_upper;
    0 <= p_pv;
    p_pv <= pinv_available_avg;
    q_pv <= diag(params.phi_inverter)*p_pv;
   -q_pv <= diag(params.phi_inverter)*p_pv;
    P == F.'*p;
    Q == F.'*q;
    P.^2 + Q.^2 <= params.S2;
    p_pv.^2 + q_pv.^2 <= params.s2_inverter;
    dual_v: v_0*ones(Nb, 1) == v - (2*R*p + 2*X*q)./v_base;
    dual_upper: v <= v_bounds.v_upper;
    dual_lower: v >= v_bounds.v_lower;
cvx_end

%%
first_stage_vars.p0_advance = p_0;
first_stage_vars.p_diesel = p_diesel;
first_stage_vars.v_0 = v_0;

dual_vars.upper = dual_upper;
dual_vars.lower = dual_lower;
dual_vars.v     = dual_v;