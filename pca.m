function [U, S, V] = pca(X)

[m, n] = size(X);

U = zeros(n);
S = zeros(n);
V = zeros(n);
Sigma = 1/m * X'* X;

[U, S, V] = svd(Sigma);%奇异值分解
%[U，S，V] = svd（A）执行矩阵A的奇异值分解，使得Sigma = U * S * V'。
end