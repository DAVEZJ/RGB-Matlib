function RGB_11 = RGB_Func(Data_Per1_C1, r, g, b, I)
Dimen = 60;
SetData = Data_Per1_C1';% �����ݱ�Ϊ 33 * 65536��
% ��ʼ������
X = [];Y = [];Z = [];
R1 = [];G1 = [];B1 = [];
R = [];G = [];B = [];
RGB_11 = [];

Row_ = 1;Line_ = 26;% Row_:Line_ ѡȡ�����ά�ȣ�

% ȷ����ʽ
gI = g(Row_:Line_,:) .* I(Row_:Line_,:);
k = 100 / sum(gI);% ����ϵ��
X = k * sum(bsxfun(@times, r(Row_:Line_,:) .* I(Row_:Line_,:) , SetData(Row_:Line_,:)))';
Y = k * sum(bsxfun(@times, g(Row_:Line_,:) .* I(Row_:Line_,:) , SetData(Row_:Line_,:)))';
Z = k * sum(bsxfun(@times, b(Row_:Line_,:) .* I(Row_:Line_,:) , SetData(Row_:Line_,:)))';

XYZ = [X,Y,Z];
[rgb] = xyz2rgb(XYZ);% ����RGB
                
R1 = rgb(:, 1);G1=rgb(:, 2);B1 = rgb(:, 3);
R = reshape(R1,Dimen,Dimen);G = reshape(G1,Dimen,Dimen);B = reshape(B1,Dimen,Dimen);  % �ع� R��G��B 
                
RGB_11 = uint8(cat(3,R,G,B));% ��R��G��B�ϳ�Ϊ��ά����,��תΪ����
end