close all;clear all;clc;

%% 载入原始频谱数据rgb,I
RGB_Data1 = load('C:\Users\ZJ_LC\Desktop\Work\ciexyz64.txt');
I2 = load('C:\Users\ZJ_LC\Desktop\Work\Illuminantd65.txt');
%% 读取频谱信息
RGB_Data = [];Illuminantd65_Int = [];r =[];g = [];b=[];I = [];
j = 1;m =1;
Min_ = 450;Max_ = 700;% 波长范围；

for i = 1:95
    if RGB_Data1(i,1)>=Min_ && RGB_Data1(i,1) <= Max_
        if rem(RGB_Data1(i,1),10) == 0
            RGB_Data(j,:) = RGB_Data1(i,:); 
            j = j + 1;
        else 
            j = j;
        end
    end
    
end

for i = 1:531
    if I2(i,1)>=Min_ && I2(i,1) <= Max_
        if rem(I2(i,1),10) == 0
            Illuminantd65_Int(m,:) = I2(i,:);
            m = m + 1;
        else
            m = m;
        end
    end
    
end
r = RGB_Data(:,2);g = RGB_Data(:,3);b = RGB_Data(:,4);
I = Illuminantd65_Int(:,2);
clear i j m RGB_Data1 I2;
save('C:\Users\ZJ_LC\Desktop\Work\RGB_I.mat')
pause;

% close all;clear all;clc;
% %% 处理图片
% Data_Per1_C1 = []; 
% for i = 1:33
%     B = imread(['C:\Users\ZJ_LC\Desktop\Mission_This_week\GRB_GRY\img_conduct_detection\s',int2str(i),'_p8_c1','.jpg']);
% %   B1 = reshape(B,256*256,1);
% %   r = (i-1) * 33 + j;
%     Data_Per1_C1(:,i) = B(:);
% end
% 
% clear i B;
% % 存储地址
% save('C:\Users\ZJ_LC\Desktop\Mission_This_week\GRB_GRY\Data_Per1_C1.mat')
% pause;

% close all;clear all;clc;
% %% 载入数据：
% load C:\Users\ZJ_LC\Desktop\Mission_This_week\GRB_GRY\Data_Per1_C1.mat 
% load RGB_I.mat
% 
% SetData = Data_Per1_C1';
% X = [];Y = [];Z = [];
% R1 = [];G1 = [];B1 = [];
% R = [];G = [];B = [];
% RGB_11 = [];
% % rI = r .* I; gI = g .* I; bI = b .* I;
% % X = sum( rI*Data_Per1_C1);
% gI = g .* I;
% k = 100 / sum(gI);
% X = k * sum(bsxfun(@times, r .* I , SetData))';
% Y = k * sum(bsxfun(@times, g .* I , SetData))';
% Z = k * sum(bsxfun(@times, b .* I , SetData))';
% 
% XYZ = [X,Y,Z];
% [rgb] = xyz2rgb(XYZ);
% %  BB = [3.2406 -1.5372  -0.4986;...
% %       -0.9689  1.8758  0.0415;...
% %       0.0557 -0.2040   1.0570];
% %  RGB1 = BB * XYZ;
% %  RGB = sum(RGB1)/3;
% %  imshow(reshape(RGB',256,256))
% %   
% R1 = rgb(:, 1);G1=rgb(:, 2);B1 = rgb(:, 3);
% R = reshape(R1,256,256);G = reshape(G1,256,256);B = reshape(B1,256,256);   
% % for i = 1:3 
% % RGB_11(:,:,1) = R;
% % RGB_11(:,:,2) = G;
% % RGB_11(:,:,3) = B;
% RGB_11 = uint8(cat(3,R,G,B));
% RGB_11 = uint8(RGB_11);
% imshow(RGB_11);
% imwrite(RGB_11,['loli_zip_' ,num2str(1) ,'.jpg'])