clear;
close all;

%% Figure 1/2 - convergence of avg. constrained optimization

load evaluation-26-Abr-2016_060457
%draw_results(results, 1)
%draw_results_only3_simple(results,11)
draw_results_only4(results, 111)

%% Figure 3 - convergence of prob. constrained optimization

load evaluation-26-Abr-2016_101635
results.alpha = 0.05;
%fh = draw_results_prob(results, 2);
draw_results_prob_only3(results, 12);
%hgexport(fh, 'convergence_prob_new');

%% Figure 4 - over/under voltage probabilities

%draw_probs(results, v_bounds_tight, 101, 102, 3);
%close 101 102

load evaluation-26-Abr-2016_101635
draw_probs_only1(results,v_bounds_tight, 4);
%% Figures 5 - histograms

drawmy4hists_onlybus40;

%% Figure 6 - performance comparison

draw_barplot_tests;

%%% Figure 7 - per-bus voltage average magnitudes
%(constraint-violating for the case of the approximate scheme)
%drawmyavgvoltages;
