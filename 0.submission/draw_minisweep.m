pv_penetration = zeros(2, 1);
load 'evaluation-18-A_r-2016 225217.mat'
pv_penetration(1) = sum(nominal_pv)*(1-prop_p_avail/2)/...
    (sum(nominal_loads)*tnomi_p_load);
eff_naive(1) = results_naive.avg_cost(end);
eff_optimal(1) = results_optimal.avg_cost(end);
pollution_naive(1) = ...
    0.883*sum(results_naive.first_stage_out(end).p_diesel)+...
    0.689*results_naive.first_stage_out(end).p0_advance;
pollution_optimal(1) = ...
    0.883*sum(results_optimal.first_stage_out(end).p_diesel)+...
    0.689*results_optimal.first_stage_out(end).p0_advance;
load 'evaluation-19-A_r-2016 040037.mat'
pv_penetration(2) = sum(nominal_pv)*(1-prop_p_avail/2)/...
    (sum(nominal_loads)*tnomi_p_load);
eff_naive(2) = results_naive.avg_cost(end);
eff_optimal(2) = results_optimal.avg_cost(end);
pollution_naive(2) = ...
    0.883*sum(results_naive.first_stage_out(end).p_diesel)+...
    0.689*results_naive.first_stage_out(end).p0_advance;
pollution_optimal(2) = ...
    0.883*sum(results_optimal.first_stage_out(end).p_diesel)+...
    0.689*results_optimal.first_stage_out(end).p0_advance;
%%
figure();
subplot(1,2,1);
plot(pv_penetration, 1000*[eff_naive; eff_optimal]');
xlabel ('PV penetration index', 'interpreter', 'latex');
ylabel('Net cost (\$/h)', 'interpreter', 'latex');
legend('Naive', '2-stage Optimal')
title 'Net cost'

subplot(1,2,2);
plot(pv_penetration, [pollution_naive; pollution_optimal]');
xlabel ('PV penetration index', 'interpreter', 'latex');
ylabel('$CO_2$ emissions (ton/h)', 'interpreter', 'latex');
legend('Naive', '2-stage Optimal')
title ('Estimated $CO_2$ emssions', 'interpreter', 'latex');