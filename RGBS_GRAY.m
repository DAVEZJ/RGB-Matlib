% close all;clear all;clc;
% 
% %% 处理图片合成RGB图像
% Data_Per1_C1 = [];
% load RGB_I.mat;
% L = 0;
% for ii = 1:16   % 代表第几张图（1-4）
%     for jj = 1:20   %代表第几个人（1-26）
%         for kk = 1:28   %代表光谱（1-33）
%             B = imread(['C:\Users\ZJ_LC\Desktop\Work\CMU_img_60_60_65_spectra\s',...
%                 int2str(kk),'_p',int2str(jj),'_c',int2str(ii),'.jpg']);%S1光谱，第一人的33张图，di
%             Data_Per1_C1(:,kk) = B(:);
%             % 同一光谱的33张图片读取完毕，进行一次RGB转换；
%             if kk == 28
%                 RGB_11 = RGB_Func(Data_Per1_C1, r, g, b, I);
%                 imshow(RGB_11);
%                 imwrite(RGB_11,['C:\Users\ZJ_LC\Desktop\Work\RGB_TU\Data_P',...
%                     num2str(jj),'_C',num2str(ii), '.jpg'])
%             end
%         end
%     end
% end
% %
% clear all;close all;clc;
% % RGB 转 GRAY
% for i = 1:20
%     for j = 1:16
%         RGB_Pic = imread(['C:\Users\ZJ_LC\Desktop\Work\RGB_TU\Data_P',...
%             int2str(i),'_C',int2str(j),'.jpg']);
%         GRAY_11 = rgb2gray(RGB_Pic);
%         imshow(GRAY_11)
%         imwrite(GRAY_11,['C:\Users\ZJ_LC\Desktop\Work\GRAY_TU\GRAY_P',...
%             num2str(i),'_C',num2str(j), '.jpg']);
%     end
% end
% %
% clear all;close all;clc;
% % 2D 图片白化重组
% for i = 1:20
%     for j = 1:16
%         X = imread(['C:\Users\ZJ_LC\Desktop\Work\GRAY_TU\GRAY_P',...
%             int2str(i),'_C',int2str(j),'.jpg']);
%         imshow(X)
%         [m, n] = size(X);
%         Y = X';
%         u = mean(Y,2);
%         k=10;
%         Yh = bsxfun(@minus, double(Y), u);
%         [U,S,V] = svd(Yh');
%         Xv = sqrt(n)*U(:,1:k)*V(:,1:k)';
%         imshow(Xv)
%         imwrite(Xv,['C:\Users\ZJ_LC\Desktop\Work\TWR_TU\TWR_P',...
%             num2str(i),'_C',num2str(j), '.jpg']);
%     end
% end

%%
clear all;close all;clc;
%% TWR_KNN识别
Dist = [];Tab = [];
TrainSetFace = [];TestSetFace = [];
% 选取每人的前两张图片作为训练样本
K = 60;
Dimen = 60;
for i = 1:20
    for j = 1:8
        Oil_face = double(imread(['C:\Users\ZJ_LC\Desktop\Work\TWR_TU\TWR_P'...
            num2str(i),'_C',num2str(j),'.jpg']));
        Oil_face = imresize(mapminmax(Oil_face,0,1),[Dimen,Dimen],'nearest');
        r = (i-1) * 8 + j;
        TrainSetFace(:,r) = Oil_face(:);
    end
end
[Train_X_norm, Train_mu, Train_sigma] = featureNormalize(TrainSetFace');
[U, S, V] = pca(Train_X_norm);
Z=projectData(Train_X_norm,U,K);
X_pca=recoverData(Z,U,K);    %TWR+PCA后图片
imshow(reshape(X_pca(1,:)',Dimen,Dimen))


r = 0;
for i = 1:20
    for j =9:16
        Test_face = double(imread(['C:\Users\ZJ_LC\Desktop\Work\TWR_TU\TWR_P'...
            num2str(i),'_C',num2str(j),'.jpg']));
        Test_face = imresize(mapminmax(Test_face,0,1),[Dimen,Dimen],'nearest');
        r = (i-1) * 8 + (j-8);
        TestSetFace(:,r) = Test_face(:);
        
        if rem(r,2) ~= 0
            Tab(1,r) = i; 
        else
            Tab(1,r) = Tab(1,r-1);
        end
        
        for k =1:160
            Diff = [Test_face(:)';TrainSetFace(:,k)'];
            Dist(1,k) = pdist(Diff,'euclidean');
            [DX, RN] = sort(Dist);
            Tab_Test_1(1,k) = ceil(RN(1,k)/2);
            %TestResult(1,k) = Tab_Test_1(1,1);
        end
        Tab_Test(1,r) = Tab_Test_1(1,1);
%         if Tab_Test_1(1,1) == Tab_Test_1(1,2)
%             Tab_Test(1,r) = Tab_Test_1(1,1);
%         elseif Tab_Test_1(1,1) == Tab_Test_1(1,3)
%             Tab_Test(1,r) = Tab_Test_1(1,1);
%         elseif Tab_Test_1(1,2) == Tab_Test_1(1,3)
%             Tab_Test(1,r) = Tab_Test_1(1,2);
%         else
%             Tab_Test(1,r) = Tab_Test_1(1,1);
%         end
    end
end
count = 0;
for k =1:160
    if Tab(1,k) == Tab_Test(1,k)
        count = count +1;
    else
        count = count;
    end
end
result = (count/160.0)*100

[Train_X_norm, Train_mu, Train_sigma] = featureNormalize(TestSetFace');
[U, S, V] = pca(Train_X_norm);
Z=projectData(Train_X_norm,U,K);
X_pca1=recoverData(Z,U,K);    %TWR+PCA后图片
imshow(reshape(X_pca(1,:)',Dimen,Dimen))

mdl = ClassificationKNN.fit(X_pca,Tab','NumNeighbors',1);
predict_label  =  predict(mdl, X_pca1);
accura   = length(find(predict_label == Tab'))/length(Tab')*100


