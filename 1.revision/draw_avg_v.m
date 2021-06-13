function draw_avg_v(results, fn1, fn2, wsize, v_bounds_tight)

figure(fn1); clf;
buses_u = results.nu_upper(:,end)>...
    (max(results.nu_upper(:,end))./10);
% detect the bus that has the highest multiplier associated to
% the constraint of upper average voltage
v1 = sqrt(cat(2, results.inst_results.v));
nan_indices = any(isnan(v1));
if sum(nan_indices)>0,
    warning(['there are %d instants where the '...
        'optimization failed'], sum(nan_indices))
    v1 = v1(:, not(nan_indices));
end
n_rlz = size(v1, 2);

my_subfunction(buses_u, v1, n_rlz, v_bounds_tight.v_upper, wsize);
grid on;
xlabel 'Time step index'
ylabel(('v (P.u.)'));


if fn1 == fn2, 
    hold on; 
    axis([1 size(results.nu_upper,2), 0.96, 1.04]);
else
    figure(fn2); clf; 
end

buses_l = results.nu_lower(:,end)>...
    (max(results.nu_lower(:,end))./10);

my_subfunction(buses_l, v1, n_rlz, v_bounds_tight.v_lower, wsize);
grid on;
xlabel 'Time step index'
ylabel(('v (P.u.)'));

end
function my_subfunction(the_buses, v1, n_rlz, ...
    v_limit, wsize)
plot(filter(ones(wsize, 1), 1, v1(the_buses,:)')./ ...
    (ones(sum(the_buses), 1)*min(1:size(v1, 2),wsize))');
hold on; plot([1 n_rlz], sqrt([mean(v_limit); ...
    mean(v_limit)]), 'y--')
end