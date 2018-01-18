function [X_norm, mu, sigma] = featureNormalize(X)%散度、每列的平均、标准差

mu = mean(X,2); %每列的平均
X_norm = bsxfun(@minus, X, mu); % 与平均值的偏离度

% X_norm = X_norm.*X_norm;
% [m,n] = size(X_norm);
% sigma = sqrt((1/n)*sum(X_norm,2));

sigma = std(X_norm);        %标准差 ;描述数据的分散程度
X_norm = bsxfun(@rdivide, X_norm, sigma); %均值归一化
end