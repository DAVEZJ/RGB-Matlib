clear all;close all;clc;
%%
K = 10;
Tab = [];TrainSetFace = [];TestSetFace = [];
Dimen = 64;
for i = 1:26
    for j = 1:2
        Oil_face = double(imread(['C:\Users\ZJ_LC\Desktop\Mission_This_week\GRB_GRY\Repair_RGB\TWR_TU\TWR_P'...
            num2str(i),'_C',num2str(j),'.jpg']));
        %Oil_face = imresize(mapminmax(Oil_face,0,1),[Dimen,Dimen],'nearest');
        Oil_face = imresize(Oil_face,[Dimen,Dimen],'nearest');
        r = (i-1) * 2 + j;
        TrainSetFace(:,r) = Oil_face(:);
    end
end
%% 多余变量还原：
i = 0;j = 0;r = 0;
for i = 1:26
    for j = 3:4
        Oil_face = double(imread(['C:\Users\ZJ_LC\Desktop\Mission_This_week\GRB_GRY\Repair_RGB\TWR_TU\TWR_P'...
            num2str(i),'_C',num2str(j),'.jpg']));
        %Oil_face = imresize(mapminmax(Oil_face,0,1),[Dimen,Dimen],'nearest');
        Oil_face = imresize(Oil_face,[Dimen,Dimen],'nearest');
        r = (i-1) * 2 + (j-2);
        TestSetFace(:,r) = Oil_face(:);
                if rem(r,2) ~= 0
            Tab(1,r) = i; 
        else
            Tab(1,r) = Tab(1,r-1);
        end
    end
end
%% PCA

% Train
[Train_X_norm, Train_mu, Train_sigma] = featureNormalize(TrainSetFace');
[U, S, V] = pca(Train_X_norm);
Z=projectData(Train_X_norm,U,K);
Train_pca=recoverData(Z,U,K);    %TWR+PCA后图片
imshow(reshape(Train_pca(1,:)',Dimen,Dimen))

%Test
[Test_X_norm, Test_mu, Test_sigma] = featureNormalize(TestSetFace');
[U, S, V] = pca(Test_X_norm);
Z=projectData(Test_X_norm,U,K);
Test_pca=recoverData(Z,U,K);    %TWR+PCA后图片
imshow(reshape(Test_pca(1,:)',Dimen,Dimen))

%% 清除多余变量 
clear i j U V Z K r Test_mu Train_mu Test_sigma Train_sigma Test_X_norm Train_X_norm
%% KNN
% TWR
mdl = ClassificationKNN.fit(TrainSetFace',Tab','NumNeighbors',1);
predict_label  =  predict(mdl, TestSetFace');
accura   = length(find(predict_label == Tab'))/length(Tab')*100

% TWR+PCA
mdl = ClassificationKNN.fit(Train_pca,Tab','NumNeighbors',1);
predict_label  =  predict(mdl, Test_pca);
accura   = length(find(predict_label == Tab'))/length(Tab')*100
