filepath = '~/dev/EECS/399/dcachecsv.dat';
origData = csvread(filepath);

% TODO: decide if this is valid cutoff
% determine cutoff point for number of accesses
z = origData(:,3);
maxAccesses = max(z);
cutoff = 0.05 * maxAccesses;

% find unique values for instruction count and addresses
x = origData(:,1);
y = origData(:,2);
xVals = unique(x);
yVals = unique(y);

mappedData = origData;
% replace x values in data with corresponding index in xVals
for n = 1:size(xVals,1)
   mappedData(mappedData(:,1) == xVals(n),1) = n; 
end

% replace y values in data with corresponding index in yVals
for n = 1:size(yVals,1)
   mappedData(mappedData(:,2) == yVals(n),2) = n; 
end

% create matrix containing only # of accesses
heatMatrix = accumarray(mappedData(:,[2 1]), mappedData(:,3));

% remove rows where none of accesses meet or exceed cutoff
iRemove = all((heatMatrix(:,:) < cutoff),2);
heatMatrix(iRemove,:) = [];
yVals(iRemove,:) = [];

% print heatmap in color
colormap('parula');
imagesc(heatMatrix);
colorbar;
xlabel('instruction count'); 
ylabel('address');
set(gca,'Xtick',1:size(xVals),'XTickLabel',xVals);
% translate y value to hex
yHex = dec2hex(yVals);
set(gca,'Ytick',1:size(yVals),'YTickLabel',yHex);
