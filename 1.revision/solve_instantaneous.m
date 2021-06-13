function results = solve_instantaneous...
    (benchmark, first_stage_vars, random_vars, params, ...
    v_loose, c, nu, nu_avg_upper, nu_avg_lower, nu_var, ...
    precision)  %#ok<*INUSL>
%#ok<*INUSD>

Nb      = benchmark.Nb;
F       = benchmark.F;
R       = benchmark.R;
X       = benchmark.X;

Ct = @(p0_delta) max(params.gammaB*p0_delta, ...
    params.gammaS*p0_delta); %#ok<*NASGU>
Cpv= @(p_inverter, p_load) ...
    params.pi_inverter.'*max(0, p_inverter-p_load);
Cm = @(p_m) params.pm_linear'*p_m + params.pm_quadratic'*p_m.^2;

v_0         = first_stage_vars.v_0;
p_diesel    = first_stage_vars.p_diesel;
p0_advance  = first_stage_vars.p0_advance;

p_load          = random_vars.p_load;
q_load          = random_vars.q_load;
pinv_available  = random_vars.pinv_available;

s2_inverter  = params.s2_inverter;
phi_inverter = params.phi_inverter;
S2           = params.S2;
pm_lower     = params.pm_lower;
pm_upper     = params.pm_upper;
pm_diag_phi  = params.pm_diag_phi;

norm_factor = benchmark.v_base.^2./benchmark.z_base;

cvx_begin %quiet
cvx_precision(precision)
    cvx_solver sedumi %faster, but less reliable
    variables p(Nb) q(Nb) v(Nb) p_pv(Nb) q_pv(Nb) ...
          p_0 p0_delta p_m(Nb) q_m(Nb) P(Nb) Q(Nb) v_penalty(Nb)
    dual variables lambda theta rho sig
      minimize Ct(p0_delta) + Cpv(p_pv, p_load) ...
          + Cm (p_m) + sum(v_penalty) + ...
          transpose(-nu_avg_upper+ nu_avg_lower)*v + ...
          transpose(nu_var)*(v - 1).^2;
      subject to
      theta: p_m + p_pv - p_load + p_diesel == p;
             q == q_m + q_pv - q_load ;
      lambda:  p0_advance + p0_delta == p_0;        %#ok<*EQEFF>
      p_0 >= -sum(p) + (p.'*R*p + q.'*R*q)./norm_factor; 
      0 <= p_pv; %#ok<*VUNUS>
      p_pv <= pinv_available;
      q_pv <= diag(phi_inverter)*p_pv;
     -q_pv <= diag(phi_inverter)*p_pv;
      P == F.'*p;
      Q == F.'*q;
      sig: P.^2 + Q.^2 <= S2; %#ok
      p_pv.^2 + q_pv.^2 <= s2_inverter;
      pm_lower <= p_m;
      p_m <= pm_upper;
      q_m  <= pm_diag_phi*p_m;
      -q_m <= pm_diag_phi*p_m;
      rho: v_0*ones(Nb, 1) == v - (2*R*p + 2*X*q)./norm_factor;
      v_penalty >= 0;
      v_penalty >= c*(v-v_loose.v_upper)+nu;
      v_penalty >= c*(v_loose.v_lower-v)+nu;
cvx_end

results.optval  = Ct(p0_delta) + Cpv(p_pv, p_load) ...
          + Cm (p_m);
results.status  = cvx_status;
results.p       = p;
results.q       = q;
results.v       = v;
results.p_pv    = p_pv;
results.q_pv    = q_pv;
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
results.losses  = (p.'*R*p + q.'*R*q)./norm_factor;
results.lambda  = lambda;%+/-
results.theta   = theta; %+/-
results.rho     = rho;   %+/-
results.sigma   = sig;