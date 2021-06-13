function fh = draw_results_prob_only3(r, numfig)
% figure(numfig);
% clf
% % fh = figure(numfig); clf
% % set(fh, ...
% %     'InvertHardcopy','off',...
% %     'Color',[1 1 1]);
% nrows = 1;
% ncols = 3;

myfontsize = 15;

first_stage_vars = r.first_stage_vars;
first_stage_out  = r.first_stage_out;
cost = r.cost;
avg_cost = r.avg_cost;
k = length(r.cost);

%subplot(nrows, ncols,1);
figure(numfig); clf
plot(cat(2, first_stage_vars.p_diesel)'); hold on
plot(cat(2, first_stage_out.p_diesel)', 'k');
ylabel ('$p^{d}$ (MW)' , 'interpreter', 'latex')
%, 'FontSize', myfontsize);
%title ('Diesel generation', 'interpreter', 'latex')%, ...
   % 'FontSize', myfontsize);
xlim([1, 40000])
ylim([0, 0.3]);
xlabel 'Iteration index' interpreter latex
grid on

figure(numfig+1); clf
[hAx, hLine1, hLine2] = plotyy(...
       1:40001, sqrt(cat(1, first_stage_vars.v_0)), ...
       1:40001, cat(1, first_stage_vars.p0_advance)); hold on
ylabel (hAx(1), 'Substation voltage [pu]', 'interpreter', 'latex')
ylabel (hAx(2), '$p_0^a$ [MW]', 'interpreter', 'latex')
xlim(hAx(1),[1, 40000])
xlim(hAx(2),[1, 40000])
my_ylim_1 = [0.97, 1.00];
my_ylim_2 = [-5.6, -4.4];
ylim(hAx(1), my_ylim_1);
ylim(hAx(2), my_ylim_2);
[hAxr, hLiner1, hLiner2] = plotyy(...
      1:40000, sqrt(cat(1, first_stage_out.v_0)), ... 
      1:40000, cat(1, first_stage_out.p0_advance));
  set(hLiner1, 'color', 'black');
  set(hLiner2, 'color', 'black');
xlim(hAxr(1),[1, 40000])
xlim(hAxr(2),[1, 40000])
ylim(hAxr(1), my_ylim_1);
ylim(hAxr(2), my_ylim_2);
%xlabel ('Iteration index', 'interpreter', 'latex')
xlabel 'Iteration index' interpreter latex
for victim = [hAxr(2), hAx(2)],
    set(victim, 'YTickMode', 'manual', ...
    'YTick', linspace(-5.6, -4.4, 7), ...
    'YTickLabel', ...
    {'-5.6', '-5.4', '-5.2', '', '-4.8', '-4.6', '-4.4'});
end
grid on

% plot(sqrt(cat(1, first_stage_vars.v_0))); hold on
% plot(sqrt(cat(1, first_stage_out.v_0)), 'r');
% ylabel ('$V_0$ (pu)', 'interpreter', 'latex', 'FontSize', myfontsize);
% title ('Voltage magnitude at substation',...
%     'interpreter', 'latex', 'FontSize', myfontsize);
% plot(cat(1, first_stage_vars.p0_advance)); hold on
% plot(cat(1, first_stage_out.p0_advance), 'r');
% title ('Injection from main grid', 'interpreter', 'latex', ...
%     'FontSize', myfontsize);
% ylabel ('$p_0^a$ (MW)' , 'interpreter', 'latex', ...
%     'FontSize', myfontsize);

%subplot(nrows, ncols,3);
figure(numfig+2); clf
[hAx, hLine1, hLine2] = plotyy(...
       1:k, cumsum(r.indicator_loose(1:k))./(1:k), ...
       1:k, r.nu(:, 1:k)'); hold on
ylabel (hAx(1), ['$Pr\{\mathbf{v} '...
    '\notin \mathcal{V}_{\textrm{A}}\;\;\}$'], ...
    'interpreter', 'latex')
ylabel (hAx(2), '$\nu$', ...
    'interpreter', 'latex')
xlim(hAx(1),[1, 40000])
xlim(hAx(2),[1, 40000])
my_ylim_1 = [0 0.2];
my_ylim_2 = [0 2];
ylim(hAx(1), my_ylim_1);
ylim(hAx(2), my_ylim_2);

[hAxr, hLine1r, hLine2r] = plotyy(...
    [1, k], ones(1, 2)*r.alpha, ...
    1:k, r.nu_out(:, 1:k)');
xlim(hAxr(1),[1, 40000])
xlim(hAxr(2),[1, 40000])
ylim(hAxr(1), my_ylim_1);
ylim(hAxr(2), my_ylim_2);
set(hLine1r, 'color', 'black');
set(hLine2r, 'color', 'black');
set(hLine1r, 'linestyle', '--');
xlabel 'Iteration index' interpreter latex
set(hAxr(2), 'YTickMode', 'auto')
set(hAx(2), 'YTickMode', 'auto')

grid on 
end
function cond_title (b, str)
    if b,
        title(str)
    end
end