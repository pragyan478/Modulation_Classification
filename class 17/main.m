function C = main(X,epsilon,MinPts)


%% Run DBSCAN Clustering Algorithm
[IDX,noise,C]=DBSCAN(X,epsilon,MinPts);


%% Plot Results

 PlotClusterinResult(X, IDX);
title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
