% adequate_axes

figure(1);

subplot(2, 3, 1);
ax = axis;
axis([1 40000 0.97 0.99]);

subplot(2, 3, 2);
axis([1 40000 0 0.25]);

subplot(2, 3, 3);
axis([1 40000 -5 -4.5]);

for i = 1:6, 
    subplot(2, 3, i);
    grid on
end