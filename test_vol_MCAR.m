clear
load data_traffic_volume.mat;

Num_sensor = 40;
Num_day = 30;
Data = Data/1000;
maxIter = 200;
epsilon = 1e-5;
rho = 1e-1;
rho1=0.1;%1e-1;
rho2=0.1;%1e-1;
rho3=0.1;%1e-1;
[m,n] = size(Data);
disp('-----------------MCAR---------------------------')
thr = [0.1];
misspatt = 0;
opt_RMSE = +Inf;
tt = 10;
C1= 1;
C2=0.0988;
w1 =0.194;
w2 =0.103;
w3 = 1-w1-w2;
w = [w1 w2 w3];
all_ERR = zeros(tt,5);
for rr = 1:tt
    idx = gen_missing_value_pos(m,n,rr,thr,misspatt);
    Data_mv = Data;
    Data_mv(idx) = NaN;
    Tsr = [];
    T = [];T1 = [];
    for i=1:Num_sensor
        Tsr(:,:,i) = Data_mv((i-1)*Num_day+1:i*Num_day,:)';%96*30*40
        T1(:,:,i) = Data((i-1)*Num_day+1:i*Num_day,:)';%96*30*40
    end
    lamba = C1;
    beta = C1*C2;
    [k,X,V1, U1, errList_H] =TensorLowRankSparse_fast(Tsr,w,rho1,rho2,rho3,lamba,beta,maxIter,epsilon,T1);
    idx1 = find(isnan(Tsr(:)));
    
    [RMSE, MAE, R2, RELErr1, RELErr2] = compute_measure(X(idx1),T1(idx1));
    all_ERR(rr,1) = RMSE;all_ERR(rr,2) = MAE;all_ERR(rr,3) = R2;all_ERR(rr,4) = RELErr1;all_ERR(rr,5) = RELErr2;
end
fprintf(1,'Cur RMSE:%.6f std:%.6f (w1:%.2f w2:%.2f lamda:%0.5f beta:%0.5f)\n',mean(all_ERR(:,1))*1000,std(all_ERR(:,1))*1000,w1,w2,lamba,beta);
