function draw_results(r, numfig)
figure(numfig); clf
nrows = 2;
ncols = 3;

first_stage_vars = r.first_stage_vars;
first_stage_out  = r.first_stage_out;
nu_lower = r.nu_lower;
nu_upper = r.nu_upper;
cost = r.cost;
avg_cost = r.avg_cost;
k = length(r.cost);

subplot(nrows, ncols, 1);
plot(sqrt(cat(1, first_stage_vars.v_0))); hold on
plot(sqrt(cat(1, first_stage_out.v_0)), 'r');
ylabel ('$V_0$ (pu)', 'interpreter', 'latex')
title ('Voltage magnitude at substation', 'interpreter', 'latex')
subplot(nrows, ncols,2);
plot(cat(2, first_stage_vars.p_diesel)'); hold on
plot(cat(2, first_stage_out.p_diesel)', 'r');
ylabel ('$p^d$ (MW)', 'interpreter', 'latex')
title ('Diesel generation', 'interpreter', 'latex')
subplot(nrows, ncols,3);
plot(cat(1, first_stage_vars.p0_advance)); hold on
plot(cat(1, first_stage_out.p0_advance), 'r');
title ('Injection from main grid', 'interpreter', 'latex')
ylabel ('$p_0^a$ (MW)', 'interpreter', 'latex')
subplot(nrows, ncols,4);
plot(nu_lower(:, 1:k)'); hold on; 
plot(r.nu_lower_out(:, 1:k)', 'r');
ylabel ('$\nu_{\textrm{lower}}$', 'interpreter', 'latex')
title ('Multiplier: avg. voltage (lower)', 'interpreter', 'latex')
subplot(nrows, ncols, 5);
plot(nu_upper(:,1:k)');hold on; 
plot(r.nu_upper_out(:, 1:k)', 'r');
xlabel ('Iteration index', 'interpreter', 'latex')
ylabel ('$\nu_{\textrm{upper}}$', 'interpreter', 'latex')
title ('Multiplier: avg. voltage (upper)',...
    'interpreter', 'latex')
subplot(nrows, ncols, 6);
plot(cost); hold on
plot(avg_cost,'g');
title ('Expected operation cost', 'interpreter', 'latex')
ylabel ('Cost (\$/h)', 'interpreter', 'latex')

adjust_axes