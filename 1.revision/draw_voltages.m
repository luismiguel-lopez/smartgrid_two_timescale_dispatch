function draw_voltages(results, v_bounds_loose, ...
    v_bounds_tight, n_rlz, fn1, fn2, fn3)

fs = [fn1 fn2];
figure(fn3); clf

for n = 1:2,
    
    f = fs(n);

    figure(f); clf;
    v1 = sqrt(cat(2, results.inst_results.v));

    % detect which buses have over/undervoltage risk:
    if f == fn1,
        [~, bru] = max(results.nu_lower(:,end));
        % bru = "Bus with highest Risk of Undervoltage"
        bus = bru;
    else
        [~, bro] = max(results.nu_upper(:,end));
        % bru = "Bus with highest Risk of Overvoltage"
        bus = bro;
    end

    plot(v1(bus,:))
    hold on; plot(1:n_rlz, ones(1, n_rlz), 'g--')
    hold on; plot(1:n_rlz, sqrt([v_bounds_tight.v_lower(bus); ...
        v_bounds_tight.v_upper(bus)])*ones(1, n_rlz), 'y--')
    hold on; plot(1:n_rlz, sqrt([v_bounds_loose.v_lower(bus); ...
        v_bounds_loose.v_upper(bus)])*ones(1, n_rlz), 'r--')

    grid on
    axis([1 n_rlz 0.96 1.04]) 
    %TODO: adapt the v limits of the graph
    xlabel 'Time step index'
    ylabel(sprintf('v_{%d} (P.u.)', bus));
    
    figure(fn3);
    subplot(2, 1, n);
    hist(v1(bus,:), 40);
    xlabel(sprintf('v_{%d} (P.u.)', bus))
    ylabel 'Absolute frequency'
end
