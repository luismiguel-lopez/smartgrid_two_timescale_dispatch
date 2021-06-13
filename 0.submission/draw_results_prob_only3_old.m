function fh = draw_results_prob_only3(r, numfig)
fh = figure(numfig); clf
set(fh, ...
    'InvertHardcopy','off',...
    'Color',[1 1 1]);
nrows = 1;
ncols = 3;

myfontsize = 15;

first_stage_vars = r.first_stage_vars;
first_stage_out  = r.first_stage_out;
cost = r.cost;
avg_cost = r.avg_cost;
k = length(r.cost);

subplot(nrows, ncols, 1);
plot(sqrt(cat(1, first_stage_vars.v_0))); hold on
plot(sqrt(cat(1, first_stage_out.v_0)), 'r');
ylabel ('$V_0$ (pu)', 'interpreter', 'latex', 'FontSize', myfontsize);
title ('Voltage magnitude at substation',...
    'interpreter', 'latex', 'FontSize', myfontsize);
subplot(nrows, ncols,2);
plot(cat(2, first_stage_vars.p_diesel)'); hold on
plot(cat(2, first_stage_out.p_diesel)', 'r');
ylabel ('$p^{d}$ (MW)' , 'interpreter', 'latex', 'FontSize', myfontsize);
title ('Diesel generation', 'interpreter', 'latex', ...
    'FontSize', myfontsize);
plot(cat(1, first_stage_vars.p0_advance)); hold on
plot(cat(1, first_stage_out.p0_advance), 'r');
title ('Injection from main grid', 'interpreter', 'latex', ...
    'FontSize', myfontsize);
ylabel ('$p_0^a$ (MW)' , 'interpreter', 'latex', ...
    'FontSize', myfontsize);
subplot(nrows, ncols,3);
plot(r.nu(:, 1:k)'); hold on; 
plot(r.nu_out(:, 1:k)', 'r');
ylabel ('Lagrange multiplier $\nu$', 'interpreter', 'latex', ...
    'FontSize', myfontsize);
title ('Multiplier: probability', ...
    'interpreter', 'latex', 'FontSize', myfontsize);

plot(cumsum(r.indicator_loose(1:k))./(1:k)); hold on;
plot([1, k], ones(1, 2)*r.alpha, 'r--');
ylabel(['$Pr\{\mathbf{v} ', ...
    '\notin \mathcal{V}_{\textrm{tight}}\;\;\}$' ]...
            , 'interpreter', 'latex', 'FontSize', myfontsize);
title ('Probability of under-/over-voltages'...
            ,'interpreter', 'latex', 'FontSize', myfontsize)
xlabel('Iteration index', 'interpreter', 'latex', 'FontSize', myfontsize)
        
for i = 1:3, 
    subplot(nrows, ncols, i);
    grid on
end

%adjust_axes_v2