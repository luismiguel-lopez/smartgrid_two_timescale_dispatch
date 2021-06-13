function draw2hists(results, fn, bus1, bus2)
v2 = cat(2, results.inst_results.v);
figure(fn);

subplot(2, 1, 1);
hist(sqrt(v2(bus1,:)), 50); 
xlabel(sprintf('v_{%d} (pu)', bus1));
ylabel 'Absolute Frequency'

subplot(2, 1, 2);
hist(sqrt(v2(bus2,:)), 50); 
xlabel(sprintf('v_{%d} (pu)', bus2));
ylabel 'Absolute Frequency'
