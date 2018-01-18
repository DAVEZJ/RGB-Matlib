function [X_norm, mu, sigma] = featureNormalize(X)%ɢ�ȡ�ÿ�е�ƽ������׼��

mu = mean(X,2); %ÿ�е�ƽ��
X_norm = bsxfun(@minus, X, mu); % ��ƽ��ֵ��ƫ���

% X_norm = X_norm.*X_norm;
% [m,n] = size(X_norm);
% sigma = sqrt((1/n)*sum(X_norm,2));

sigma = std(X_norm);        %��׼�� ;�������ݵķ�ɢ�̶�
X_norm = bsxfun(@rdivide, X_norm, sigma); %��ֵ��һ��
end