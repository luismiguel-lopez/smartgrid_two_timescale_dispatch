% load test_batch_30abr/t_avg_optimal_extreme_03-May-2016_142130.mat
% v2_o = cat(2, results.inst_results.v);
% load test_batch_30abr/t_avg_approximate_extreme_03-May-2016_143903.mat
% v2_n = cat(2, results.inst_results.v);
% save finaldata_myavgvoltages v2_o v2_n
load finaldata_myavgvoltages
%%
figure(7); clf
stem(mean(sqrt(v2_o')), 'basevalue', 1)
hold on
stem(mean(sqrt(v2_n')), 'rs', 'basevalue', 1)
xlim([0.5, 55.5])
orange = [1, 0.4, 0];
plot([0 56], [1.01 1.01], '--', 'Color', orange)
plot([0 56], [0.99, 0.99], '--', 'Color', orange)
plot([0 56], [1 1], '--g')
title ('Average voltage magnitudes', 'interpreter', 'latex')
xlabel('Bus index $n$', 'interpreter', 'latex')
legend({'Optimal scheme', 'Approximate scheme $\;\;\;\;$'}, ...
'location', 'southeast', 'interpreter', 'latex')
ylabel('Voltage magnitude (V)', 'interpreter', 'latex')
