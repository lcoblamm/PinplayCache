% file name and path to dcache csv output
filename = 'bzip2_2_r9';
filedir = '~/dev/EECS/399/results/spec_30m';
% cutoff point based on number of accese  for which addresses to include data
% e.g. a cutoff of 0.01 means that any addresses that had less than 1% of
% the overall maximum number of accesses across all intervals are thrown out
cutoffPoint = 0.01;

% generate full file names for input and output files
csvname = strcat('dcachecsv_', filename, '.out');
csvfile = fullfile(filedir, 'csv', csvname);
figname = strcat(filename, '.png');
figfile = fullfile(filedir, 'figure', figname);

% read csv file in as is
origData = csvread(csvfile);

% pull top row off for instruction intervals
xVals = origData(1,1:end - 2)';

% pull first column off for addresses
yVals = origData(2:end,1);

% trim matrix data (take off address, instruction intervals, and final
% column)
heatMatrix = origData(2:end,2:end - 1);

% determine cutoff point for number of accesses
maxAccesses = max(heatMatrix(:));
cutoff = cutoffPoint * maxAccesses;

% remove rows where none of accesses meet or exceed cutoff
iRemove = all((heatMatrix(:,:) < cutoff),2);
heatMatrix(iRemove,:) = [];
yVals(iRemove,:) = [];

% print heatmap in color with labeled x and y values
colormap('parula');
clims = [0 maxAccesses];
imagesc(heatMatrix, clims);
colorbar;
xlabel('instruction count'); 
ylabel('address');
set(gca,'Xtick',1:size(xVals),'XTickLabel',xVals);
% translate y value (addresses) to hex
yHex = dec2hex(yVals);
set(gca,'Ytick',1:size(yVals),'YTickLabel',yHex);

% save figure
saveas(gcf, figfile);
