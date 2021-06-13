clear;
close all;

%% Figures 1 and 2 - convergence of average dispatch

load evaluation-26-Abr-2016_060457
draw_results_only4(results, 111)

% Use profile 'TSG_4_1911'

%% Figure 3 - convergence of probabilistic dispatch

load evaluation-26-Abr-2016_101635
results.alpha = 0.05;
draw_results_prob_only3(results, 12);

% Use profile 'TSG_3_1314'
% Manual tweak: move left and right ylabels in Fig. 3b

%% Figure 4 - over/under voltage probabilities

load evaluation-26-Abr-2016_101635
draw_probs_only1(results,v_bounds_tight, 4);

% Use profile 'TSG_Fig_4'
% Manual tweaks:
%   Resize legend
%   Place alpha under U
%   Move alpha 4 times with the right arrow

%% Figures 5 - histograms

drawmy4hists_onlybus40;

% Use profile 'TSG_hists_20160713'


%% Figure 6 - performance comparison

draw_barplot_tests;

% Use profile 'TSG_4_1911'
% Manual tweaks:
%   Move legend
