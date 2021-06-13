function results = solve_inst_partial_lagrangian...
    (benchmark, first_stage_vars, random_vars, params, ...
    v_bounds, rho)

Nb = benchmark.Nb;

Ct = @(p0_delta) max(params.gammaB*p0_delta, ...
    params.gammaS*p0_delta);
Cpv= @(p_inverter, p_load) ...
    params.pi_inverter.'*max(0, p_inverter-p_load);
Cm = @(p_m) params.pm_linear'*p_m + params.pm_quadratic'*p_m.^2;

F       = benchmark.F;
R       = benchmark.R;
X       = benchmark.X;
v_base  = benchmark.v_base;

v_0 =        first_stage_vars.v_0;
p_diesel =   first_stage_vars.p_diesel;
p0_advance = first_stage_vars.p0_advance;

p_load = random_vars.p_load;
q_load = random_vars.q_load;
pinv_available = random_vars.pinv_available;

s2_inverter = params.s2_inverter;
phi_inverter= params.phi_inverter;
S2          = params.S2;
pm_lower    = params.pm_lower;
pm_upper    = params.pm_upper;
pm_diag_phi = params.pm_diag_phi;

v_upper     = v_bounds.v_upper;
v_lower     = v_bounds.v_lower;

cvx_begin %quiet
    cvx_solver sedumi %faster, but less reliable
    variables p(Nb) q(Nb) v(Nb) p_inverter(Nb) q_inverter(Nb) ...
          p_0 p0_delta p_m(Nb) q_m(Nb) P(Nb) Q(Nb) v_penalty(Nb)
    dual variables lambda theta rho sig
      minimize Ct(p0_delta) + Cpv(p_inverter, p_load) ...
          + Cm (p_m) ...
          + rho*(v-v_0*ones(Nb, 1) + (2*R*p + 2*X*q)./v_base
      subject to
      theta: p == p_m + p_inverter - p_load + p_diesel;
             q == q_m + q_inverter - q_load ;
      lambda: p_0 == p0_advance + p0_delta;         %#ok<*EQEFF>
      p_0 >= -sum(p) + (p.'*R*p + q.'*R*q)./v_base; %#ok<*VUNUS>
      0 <= p_inverter;
      p_inverter <= pinv_available;
      q_inverter <= diag(phi_inverter)*p_inverter;
     -q_inverter <= diag(phi_inverter)*p_inverter;
      P == F.'*p;
      Q == F.'*q;
      sig: P.^2 + Q.^2 <= S2; %#ok
      p_inverter.^2 + q_inverter.^2 <= s2_inverter;
      pm_lower <= p_m;
      p_m <= pm_upper;
      q_m  <= pm_diag_phi*p_m;
      -q_m <= pm_diag_phi*p_m;
      v<=v_upper;
      v>=v_lower;
cvx_end

results.optval = cvx_optval;
results.status = cvx_status;
results.p      = p;
results.q      = q;
results.v      = v;
results.p_inverter = p_inverter;
results.q_inverter = q_inverter;
results.p_0     = p_0;
results.p0_delta= p0_delta;
results.p_m     = p_m;
results.q_m     = q_m;
results.S2      = zeros(1, Nb);
results.P       = P;
results.Q       = Q;
for n = 1:Nb,
    results.S2(n) = p.'*F(:,n)*F(:,n)'*p + q.'*F(:,n)*F(:,n)'*q;
end
results.losses  = (p.'*R*p + q.'*R*q)./v_base;
results.lambda  = lambda;%+/-
results.theta   = theta; %+/-
results.rho     = rho;   %+/-
results.sigma   = sig;