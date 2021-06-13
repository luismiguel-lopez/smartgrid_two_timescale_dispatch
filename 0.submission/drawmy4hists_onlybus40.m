% drawmy4hists

clear; 
% load 'evaluation-26-Abr-2016_060457.mat'
% v2_avg = cat(2, results_optimal.inst_results.v);
% load 'evaluation-26-Abr-2016_101635'
% v2_prob = cat(2, results_optimal.inst_results.v);
% save finaldata_4hists v2_avg v2_prob
load finaldata_4hists

bbb = 40;
%%    
bus_high = bbb;
bus_low = 15;

% %%
% h = figure(4); clf
% nbins = 30;
% 
% subplot(2,2,1); grid on
% hist(sqrt(v2_avg(15, :)), nbins);
%     
% axavg15 = axis;
% mysubfigures = get(h, 'Children');
% set(mysubfigures(1), 'XTickLabel', ...
%     {'0.97','0.98','1','1.02','1.03'},...
%     'XTick',[0.97 0.98 1 1.02 1.03])
% mypatches = get(mysubfigures(1), 'Children');
% set(mypatches(1), 'FaceColor', [0.0, 0.25, 1  ])
% legend ('Bus 15', 'location', 'NorthWest')
% %title 'Average constrained voltages'
% 
% subplot(2,2,2); grid on
% hist(sqrt(v2_avg(bus_high, :)), nbins);
% axavg_high = axis;
% mysubfigures = get(h, 'Children');
% set(mysubfigures(1), 'XTickLabel',{'0.97','0.98','1','1,02','1,03'},...
%     'XTick',[0.97 0.98 1 1.02 1.03])
% mypatches = get(mysubfigures(1), 'Children');
% set(mypatches(1), 'FaceColor', [0.6, 0.0,  0.4])
% legend (sprintf('Bus %d', bus_high), 'location', 'NorthWest')
% %title 'Average constrained voltages'
% 
% subplot(2,2,3); grid on
% hist(sqrt(v2_prob(15, :)), nbins);
% axprob15 = axis;
% mysubfigures = get(h, 'Children');
% set(mysubfigures(1), 'XTickLabel', ...
%     {'0.97','0.98','1','1.02','1.03'},...
%     'XTick',[0.97 0.98 1 1.02 1.03])
% mypatches = get(mysubfigures(1), 'Children');
% set(mypatches(1), 'FaceColor', [0.0, 0.25, 1  ])
% %title 'Probability constrained voltages'
% 
% subplot(2,2,4); grid on
% hist(sqrt(v2_prob(bus_high, :)), nbins);
% axprob_high = axis;
% mysubfigures = get(h, 'Children');
% set(mysubfigures(1), 'XTickLabel',{'0.97','0.98','1','1.02','1.03'},...
%     'XTick',[0.97 0.98 1 1.02 1.03])
% mypatches = get(mysubfigures(1), 'Children');
% set(mypatches(1), 'FaceColor', [0.6, 0.0,  0.4])
% %title 'Probability constrained voltages'
% 
% axavg15(1:2) = [min(axavg15(1), axprob15(1)),...
%     max(axavg15(2), axprob15(2))];
% axprob15(1:2) = axavg15(1:2);
% 
% axavg_high(1:2) = [min(axavg_high(1), axprob_high(1)),...
%     max(axavg_high(2), axprob_high(2))];
% axprob_high(1:2) = axavg_high(1:2);
% 
% subplot(2,2,1); hold on
% axavg15(1) = 0.965;
% axis(axavg15);
% plot([0.97, 0.97], axavg15(3:4), 'r--')
% plot([0.98, 0.98], axavg15(3:4), '--', 'Color', [1, 0.4, 0])
% ylabel 'Absolute Frequency'
% grid on
% 
% subplot(2,2,2); hold on
% axis(axavg_high);
% plot([0.97, 0.97], axavg_high(3:4), 'r--')
% plot([0.98, 0.98], axavg_high(3:4), '--', 'Color', [1, 0.4, 0])
% plot([1.02, 1.02], axavg_high(3:4), '--', 'Color', [1, 0.4, 0])
% plot([1.03, 1.03], axavg_high(3:4), 'r--')
% grid on
% 
% subplot(2,2,3); hold on
% axis(axavg15);
% plot([0.97, 0.97], axavg15(3:4), 'r--')
% plot([0.98, 0.98], axavg15(3:4), '--', 'Color', [1, 0.4, 0])
% ylabel 'Absolute Frequency';
% xlabel 'Voltage magnitude (V)'
% grid on
% 
% subplot(2,2,4); hold on
% axis(axavg_high);
% plot([0.97, 0.97], axavg_high(3:4), 'r--')
% plot([0.98, 0.98], axavg_high(3:4), '--', 'Color', [1, 0.4, 0])
% plot([1.02, 1.02], axavg_high(3:4), '--', 'Color', [1, 0.4, 0])
% plot([1.03, 1.03], axavg_high(3:4), 'r--')
% xlabel 'Voltage magnitude (V)'
% grid on

%%

nbars_high = 60;
h1 = figure(5); clf
%subplot(2,1,1);
[~, edges] = hist(sqrt(v2_avg(15, :)), nbars_high);
width15 = mean(diff(edges));
[~, edges] = hist(sqrt(v2_avg(bus_high, :)), nbars_high);
width_high = mean(diff(edges));
hist(sqrt(v2_avg(15, :)), ceil(nbars_high*width15/width_high)); 
hold on
hist(sqrt(v2_avg(bus_high, :)), nbars_high);
mysubfigures = get(h1, 'Children');%%%%
set(mysubfigures(1), 'XTickLabel',{'0.97','0.98','1','1.02','1.03'},...
    'XTick',[0.97 0.98 1 1.02 1.03], ...
      'YTick', linspace(0, 3000, 6), ...
      'YTickLabel',{'0', '0.1', '0.2', '0.3', '0.4', '0.5'});
%     'YTick', [0, 900, 1800, 2700, 3600, 4500]
%     'YTickLabel',{'0', '0.15', '0.3', '0.45', '0.6', '0.75'});

mypatches = get(get(h1, 'Children'), 'Children');
set(mypatches(1), 'FaceColor', [0.6, 0.0,  0.4])
set(mypatches(2), 'FaceColor', [0.0, 0.25, 1  ])
legend({'Bus 15', sprintf('Bus %d', bus_high)},...
    'location', 'North')
ax = [0.965 1.035 0 3000];
axis(ax)
plot([0.97, 0.97], ax(3:4), 'r--')
plot([0.98, 0.98], ax(3:4), '--', 'Color', [1, 0.4, 0])
plot([1.02, 1.02], ax(3:4), '--', 'Color', [1, 0.4, 0])
plot([1.03, 1.03], ax(3:4), 'r--')
ylabel ('Relative Frequency', 'interpreter', 'latex');
%xlabel 'Voltage magnitude (V)'
%title('(a) Average-constrained voltages','interpreter','latex');
grid on

nbars_high_prob = 25;
h2 = figure(6); clf
%subplot(2, 1, 2);
[~, edges] = hist(sqrt(v2_prob(15, :)), nbars_high_prob);
width15 = mean(diff(edges));
[~, edges] = hist(sqrt(v2_prob(bus_high, :)), nbars_high_prob);
width_high = mean(diff(edges));
hist(sqrt(v2_prob(15, :)), ceil(nbars_high_prob*width15/width_high)); 
hold on
hist(sqrt(v2_prob(bus_high, :)), nbars_high_prob);
mysubfigures = get(h2, 'Children'); %%%%
set(mysubfigures(1), 'XTickLabel',{'0.97','0.98','1','1.02','1.03'},...
    'XTick',[0.97 0.98 1 1.02 1.03], ...
    'YTick', linspace(0, 3000, 6), ...
    'YTickLabel',{'0', '0.1', '0.2', '0.3', '0.4', '0.5'});
mypatches = get(mysubfigures(1), 'Children');
set(mypatches(1), 'FaceColor', [0.6, 0.0,  0.4])
set(mypatches(2), 'FaceColor', [0.0, 0.25, 1  ])
%legend('Bus 15', sprintf('Bus %d', bushigh))
% ax = axis;
% ax(1:2) = [0.965 1.035];
ax = [0.965 1.035 0 3000];
axis(ax)
plot([0.97, 0.97], ax(3:4), 'r--')
plot([0.98, 0.98], ax(3:4), '--', 'Color', [1, 0.4, 0])
plot([1.02, 1.02], ax(3:4), '--', 'Color', [1, 0.4, 0])
plot([1.03, 1.03], ax(3:4), 'r--')
ylabel ('Relative Frequency', 'interpreter', 'latex')
xlabel ('Voltage magnitude [pu]', 'interpreter', 'latex');
%title ('(b) Probability-constrained voltages', 'interpreter', ...
%    'latex');
grid on

%saveas (h, sprintf('histogram_bus%d.png', bus_high))
