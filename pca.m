function [U, S, V] = pca(X)

[m, n] = size(X);

U = zeros(n);
S = zeros(n);
V = zeros(n);
Sigma = 1/m * X'* X;

[U, S, V] = svd(Sigma);%����ֵ�ֽ�
%[U��S��V] = svd��A��ִ�о���A������ֵ�ֽ⣬ʹ��Sigma = U * S * V'��
end