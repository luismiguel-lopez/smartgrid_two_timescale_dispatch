function draw_results_only4(r, numfig)
first_stage_vars = r.first_stage_vars;
first_stage_out  = r.first_stage_out;
nu_lower = r.nu_lower;
nu_upper = r.nu_upper;
cost = r.cost;
avg_cost = r.avg_cost;
k = length(r.cost);

n_iter = size(r.cost, 2);

figure(numfig); clf
plot(cat(2, first_stage_vars.p_diesel)'); hold on
plot(cat(2, first_stage_out.p_diesel)', 'k');
xlabel ('Iteration index', 'interpreter', 'latex')
ylabel ('$p^d$ [MW]', 'interpreter', 'latex')
%title ('Diesel generation', 'interpreter', 'latex')
xlim([1, n_iter])
ylim([0.2, 0.25]);
grid on

figure(numfig+1); clf
[hAx, hLine1, hLine2] = plotyy(...
       1:(n_iter+1), sqrt(cat(1, first_stage_vars.v_0)), ...
       1:(n_iter+1), cat(1, first_stage_vars.p0_advance)); hold on
[hAxr, hLiner1, hLiner2] = plotyy(...
       1:n_iter, sqrt(cat(1, first_stage_out.v_0)), ... 
       1:n_iter, cat(1, first_stage_out.p0_advance));
   set(hLiner1, 'color', 'black');
   set(hLiner2, 'color', 'black');
ylabel (hAx(1), 'Substation voltage [pu]', ...
    'interpreter', 'latex')
ylabel (hAx(2), '$p_0^a$ [MW]', 'interpreter', 'latex')
limits_v0 = [0.99, 1.01];
limits_p0 = [-2.7, -1.3];
xlim(hAx(1),[1, n_iter])
xlim(hAx(2),[1, n_iter])
xlim(hAxr(1),[1, n_iter])
xlim(hAxr(2),[1, n_iter])
ylim(hAx(1), limits_v0);
ylim(hAx(2), limits_p0);
ylim(hAxr(1), limits_v0);
ylim(hAxr(2), limits_p0);
%title ('Voltage magnitude at substation','interpreter', 'latex')
% title ('Injection from main grid', 'interpreter', 'latex')
% ylabel ('$p_0^a$ (MW)', 'interpreter', 'latex')
set(hAx(1), 'YTickMode', 'auto');
set(hAx(2), 'YTickMode', 'auto');
xlabel ('Iteration index', 'interpreter', 'latex')
grid on

figure(numfig+2); clf 
plot(nu_lower(:, 1:k)'); hold on; 
plot(r.nu_lower_out(:, 1:k)', 'k');
xlabel ('Iteration index', 'interpreter', 'latex')
ylabel ('$\underline{\mathbf{\nu}}$', 'interpreter', 'latex')
%_{\textrm{lower}}
%title ('Multiplier: avg. voltage (lower)','interpreter','latex')
grid on

figure(numfig+3); clf
plot(nu_upper(:,1:k)');hold on; 
plot(r.nu_upper_out(:, 1:k)', 'k');
xlabel ('Iteration index', 'interpreter', 'latex')
ylabel ('$\overline{\mathbf{\nu}}$', 'interpreter', 'latex')
%$\nu_{\textrm{upper}}$
%title ('Multiplier: avg. voltage (upper)','interpreter','latex')
grid on

end
function cond_title (b, str)
    if b,
        title(str)
    end
end