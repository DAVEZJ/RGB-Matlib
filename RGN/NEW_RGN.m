clear all;close all;clc;
mmm = 2;
CEIL = [];Accra = [];
while (mmm~=1)
    mmm = mmm-1
   

%%
K = 10;
Tab = [];TrainSetFace = [];TestSetFace = [];
Dimen = 60;
% Array_ = randperm(16);%随机生成1~16的数；
Array_ = [15,2,16,6,13,12,8,1,10,7,5,11,4,3,14,9];
%Array_ = [1,6,8,4,5,2,14,16,9,10,11,12,3,7,13,15];
CEIL(mmm,:) = Array_(1,:);
for i = 1:20
    for j = 1:8
        Oil_face = double(imread(['C:\Users\ZJ_LC\Desktop\Work\TWR_TU\TWR_P'...
            num2str(i),'_C',num2str(Array_(j)),'.jpg']));
        %Oil_face = imresize(mapminmax(Oil_face,0,1),[Dimen,Dimen],'nearest');
        Oil_face = imresize(Oil_face,[Dimen,Dimen],'nearest');
        [Train_X_norm, Train_mu, Train_sigma] = featureNormalize(Oil_face);
        [U, S, V] = pca(Train_X_norm);
        Z=projectData(Train_X_norm,U,K);
        Train_pca=recoverData(Z,U,K); 
        r = (i-1) * 8 + j;
        TrainSetFace(:,r) = Oil_face(:);
        Train_pca1(:,r) = Train_pca(:);
    end
end
%% 多余变量还原：
i = 0;j = 0;r = 0;
for i = 1:20
    for j = 9:16
        Oil_face = double(imread(['C:\Users\ZJ_LC\Desktop\Work\TWR_TU\TWR_P'...
            num2str(i),'_C',num2str(Array_(j)),'.jpg']));
        %Oil_face = imresize(mapminmax(Oil_face,0,1),[Dimen,Dimen],'nearest');
        Oil_face = imresize(Oil_face,[Dimen,Dimen],'nearest');
        [Test_X_norm, Test_mu, Test_sigma] = featureNormalize(Oil_face);
        [U, S, V] = pca(Test_X_norm);
        Z=projectData(Test_X_norm,U,K);
        Test_pca=recoverData(Z,U,K);    %TWR+PCA后图片
        
        r = (i-1) * 8 + (j-8);
        TestSetFace(:,r) = Oil_face(:);
        Test_pca1(:,r) = Test_pca(:);
        if rem(r,2) ~= 0
            Tab(1,r) = i; 
        else
            Tab(1,r) = Tab(1,r-1);
        end
    end
end

%% 清除多余变量 
clear i j U  V Z K r Test_mu Train_mu Test_sigma Train_sigma Test_X_norm Train_X_norm
%% KNN
% TWR
mdl = ClassificationKNN.fit(TrainSetFace',Tab','NumNeighbors',1);
predict_label  =  predict(mdl, TestSetFace');
accura1   = length(find(predict_label == Tab'))/length(Tab')*100

% TWR+PCA
mdl = ClassificationKNN.fit(Train_pca1',Tab','NumNeighbors',1);
predict_label  =  predict(mdl, Test_pca1');
accura   = length(find(predict_label == Tab'))/length(Tab')*100

Accra(1,mmm)=accura1;
Accra(2,mmm)=accura;
end