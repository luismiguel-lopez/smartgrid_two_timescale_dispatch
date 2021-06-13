load test_batch_30abr/table_output.mat
M_prob([3 6 9 12 15]) = M_avg([3 6 9 12 15]);
matrix_average = reshape(M_avg, 3, 5)';
matrix_probab  = reshape(M_prob, 3, 5)';
matrix_combined = reshape(...
    [matrix_average'; matrix_probab'; zeros(3, 5)],...
    3, 15)';
figure(6); clf
  mybarplot(matrix_combined, 6)
  
%%
% figure(109); clf
% matrix_average_forplot = matrix_average([3 1 4 5],:);
% matrix_probab_forplot = matrix_probab([3 1 4 5],:);
% plot(matrix_average_forplot);
% hold on
% plot (matrix_probab_forplot, '--');

MM = reshape(matrix_combined', 9, 5);
MM(end-3:end,:) = [];
idx = [1 4 2 5 3];
MM = MM(idx,:);
mybarplot2(MM', 7);