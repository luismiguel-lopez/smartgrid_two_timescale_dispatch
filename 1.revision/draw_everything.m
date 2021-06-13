function draw_everything(filename, draw_convergence,...
    draw_evaluation)
close all
load(filename)
if draw_convergence,
    draw_results(results, 1)
    draw_voltages(results, v_bounds_loose, v_bounds_tight, ...
        5000,2, 3, 4)
    draw_avg_v(results, 5, 6, 1000, v_bounds_tight)
end
if draw_evaluation,
   draw_results(results_optimal, 7);
   title 'Net cost: Optimal'
   draw_results(results_naive, 8);
   title 'Net cost: Naive'
   draw_voltages(results_optimal, v_bounds_loose,...
       v_bounds_tight, 5000, 9, 10, 11);
   draw_voltages(results_naive, v_bounds_loose, ...
       v_bounds_tight, 5000, 12, 13, 14);
   draw_avg_v(results_optimal, 15, 16, 1000, v_bounds_tight)
   draw_avg_v(results_naive, 17, 18, 1000, v_bounds_tight)
end