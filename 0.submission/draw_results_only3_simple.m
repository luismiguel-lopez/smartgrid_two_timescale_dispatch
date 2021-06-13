function draw_results_only3_simple(r, numfig)
figure(numfig); clf
nrows = 1;
ncols = 3;

colorful = 0;
if colorful == 1,
    style_sliding = 'r';
else
    style_sliding = 'k';
end
first_stage_vars = r.first_stage_vars;
first_stage_out  = r.first_stage_out;
nu_lower = r.nu_lower;
nu_upper = r.nu_upper;
cost = r.cost;
avg_cost = r.avg_cost;
k = length(r.cost);

subplot(nrows, ncols, 1);
plot(sqrt(cat(1, first_stage_vars.v_0)), ...
    'Color', [0.7,0.7,0.7]); hold on
plot(sqrt(cat(1, first_stage_out.v_0)), style_sliding);
ylabel ('$V_0$ (pu)', 'interpreter', 'latex')
title ('Voltage magnitude at substation', 'interpreter', 'latex')
xlim([1 40000]);
ylim([0.97 0.99]);
grid on
legend('Iterates', 'Sliding Average')

subplot(nrows, ncols,2);
plot(cat(2, first_stage_vars.p_diesel)', ...
    'Color', [0.7,0.7,0.7]); hold on
plot(cat(2, first_stage_out.p_diesel)', style_sliding);
xlim([1 40000]);
ylim([0 0.3])
ylabel ('$p^d$ (MW)', 'interpreter', 'latex')
title ('Diesel generation', ...
    'interpreter', 'latex')
ylabel ('$p_0^a$ (MW)', 'interpreter', 'latex')
grid on

subplot(nrows, ncols,3);
plot(nu_lower(:, 1:k)',...
    'Color', [0.7,0.7,0.7]); hold on; 
plot(r.nu_lower_out(:, 1:k)', style_sliding);
ylabel ('$\nu_{\textrm{lower}}$', 'interpreter', 'latex')
title ('Multiplier: avg. voltage (lower)', 'interpreter', 'latex')
text(32500, 10.5, 'Bus 2');
text(32500, 5.5, 'Bus 15');
grid on

