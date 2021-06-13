function draw_results_only3(r, numfig)
figure(numfig); clf
nrows = 1;
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
xlim([1 40000]);
ylim([0.97 0.99]);
grid on

subplot(nrows, ncols,2);
y1 = cat(2, first_stage_vars.p_diesel)';
y2 = cat(1, first_stage_vars.p0_advance);
plotyy(1:40000, y1(1:40000, :), 1:40000, y2(1:40000,:));
hold on;
y3 = cat(2, first_stage_out.p_diesel)';
y4 = cat(1, first_stage_out.p0_advance);
[hAx, hLine1, hLine2] = ...
    plotyy(1:40000, y3(1:40000, :), 1:40000, y4(1:40000,:));
hLine1.LineStyle = 'r';
hLine2.LineStyle = 'r';
% yyaxis left
% plot(cat(2, first_stage_vars.p_diesel)'); hold on
% plot(cat(2, first_stage_out.p_diesel)', 'r');
% xlim([1 40000]);
% ylim([0 0.5]);
% yyaxis right
% plot(cat(1, first_stage_vars.p0_advance)); hold on
% plot(cat(1, first_stage_out.p0_advance), 'r');
% ylim([-5 -4.5]);
ylabel (hAx(1), '$p^d$ (MW)', 'interpreter', 'latex')
title ('Diesel generation and injection from main grid', ...
    'interpreter', 'latex')
ylabel (hAx(2), '$p_0^a$ (MW)', 'interpreter', 'latex')
grid on

subplot(nrows, ncols,3);
plot(nu_lower(:, 1:k)'); hold on; 
plot(r.nu_lower_out(:, 1:k)', 'r');
ylabel ('$\nu_{\textrm{lower}}$', 'interpreter', 'latex')
title ('Multiplier: avg. voltage (lower)', 'interpreter', 'latex')
plot(nu_upper(:,1:k)');hold on; 
plot(r.nu_upper_out(:, 1:k)', 'r');
xlabel ('Iteration index', 'interpreter', 'latex')
ylabel ('$\nu_{\textrm{upper}}$', 'interpreter', 'latex')
title ('Multiplier: avg. voltage (upper)',...
    'interpreter', 'latex')
grid on

