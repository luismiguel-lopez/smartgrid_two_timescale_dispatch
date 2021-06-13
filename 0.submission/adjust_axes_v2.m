% adequate_axes

%figure(21);

subplot(2, 3, 1);
ax = axis;
axis([1 40000 0.97 0.99]);

subplot(2, 3, 2);
axis([1 40000 0 0.3]);

subplot(2, 3, 3);
axis([1 40000 -5 -4.5]);

subplot(2, 3, 4);
axis([1 40000 0 2]);

subplot(2,3, 5);
axis([1 40000 0 0.2]);

for i = 1:6, 
    subplot(2, 3, i);
    grid on
end