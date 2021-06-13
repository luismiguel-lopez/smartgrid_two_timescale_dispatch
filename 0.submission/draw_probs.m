function draw_probs(results, v_bounds_tight, fn1, fn2, fn3)

v2 = cat(2, results.inst_results.v);
n = length(results.inst_results);

my_markersize = 7;

figure(fn1);  clf
stem(mean(v2>v_bounds_tight.v_upper*ones(1, n), 2))
ylabel('Pr$\{V_b > 1.02\}$', 'interpreter', 'latex')
title 'Estimated over-voltage probabilities'
xlabel ('Bus index $b$', 'interpreter', 'latex')

figure(fn2);  clf
stem(mean(v2<v_bounds_tight.v_lower*ones(1, n), 2))
ylabel('Pr$\{V_b < 0.98\}$', 'interpreter', 'latex')
title 'Estimated under-voltage probabilities'
xlabel ('Bus index $b$', 'interpreter', 'latex')

h = figure(fn3); clf
pr1 = mean(v2>v_bounds_tight.v_upper*ones(1, n), 2);
s1 = find(pr1>0);
stem(s1, pr1(s1), '^', 'Color', [0.6, 0.0,  0.4], ...
    'MarkerFaceColor', [0.6, 0, 0.4], 'MarkerSize', my_markersize);
hold on
pr2 = mean(v2<v_bounds_tight.v_lower*ones(1, n), 2);
s2 = find(pr2>0);
stem(s2 ,pr2(s2), 'v', 'Color', [0.0, 0.25, 1  ], ...
    'MarkerFaceColor', [0.0, 0.25, 1], 'MarkerSize', my_markersize);
xlabel ('Bus index $n$', 'interpreter', 'latex')
legend({'Pr$\{V_n > 1.02\}\;$ ', 'Pr$\{V_n  < 0.98\}\;$ '}, ...
    'interpreter', 'latex', 'location', 'NorthWest');
stem(find(pr1==0 & pr2==0), zeros(1,sum(pr1==0 & pr2==0)),'k'...
    ,'MarkerSize',my_markersize);
%title ('Per-bus under-/over-voltage probability', ...
%    'interpreter', 'latex');
plot([0 length(pr2)+1], [0.05, 0.05], 'r--');
xlim ([0.5, length(pr2)+0.5]);
ylim ([0 0.075])
mysubfigures = get(h, 'Children');
set(mysubfigures, 'YTick',[0, 0.025, 0.05, 0.075])%, ...
%'YTickLabel', {'0', '0.025', 'alpha = 0.05' '0.075'})
text(-6, 0.05, '$\alpha$ = ', 'interpreter', 'latex')
grid on