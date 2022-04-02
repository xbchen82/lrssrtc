function idx = gen_missing_value_pos(M,N,rr,miss_rate,wgh)
rand('state',rr);
max_miss_len = 10;

if wgh == 0
    % MCR
    A = rand(M,N);
    idx = find(A > 1-miss_rate);
elseif wgh == 1
    missNum1 = ceil(miss_rate*M*N);
    D = zeros(M,N);
    % MR
    flag = 1;
    a = [-1 -1 -1];
    while flag == 1
        a1 = fix(1+(M-1)*rand);
        a2 = fix(1+(N-1)*rand);
        L = min(max_miss_len,N-a2);
        c = fix(1+(L-1)*rand);
        c = min(c,missNum1-length(find(isnan(D))));
        a3 = a2+c-1;
        id = find(a(:,1)==a1);
        fl = 1;
        for i=1:length(id)
            fl = a(id(i),2)>a3 || a(id(i),3)<a2;
            if fl == 0
                break;
            end
        end
        if fl == 1
            a = [a;[a1 a2 a3]];
            D(a1,a2:a3) = NaN;
        end
        if length(find(isnan(D)))>=missNum1
            flag = 0;
            idx = find(isnan(D));
        end
    end
else
    missNum1 = ceil(wgh*miss_rate*M*N);
    missNum2 = ceil(miss_rate*M*N)-missNum1;
    D = zeros(M,N);
    % MR
    flag = 1;
    a = [-1 -1 -1];
    while flag == 1
        a1 = fix(1+(M-1)*rand);
        a2 = fix(1+(N-1)*rand);
        L = min(max_miss_len,N-a2);
        c = fix(1+(L-1)*rand);
        c = min(c,missNum1-length(find(isnan(D))));
        a3 = a2+c-1;
        id = find(a(:,1)==a1);
        fl = 1;
        for i=1:length(id)
            fl = a(id(i),2)>a3 || a(id(i),3)<a2;
            if fl == 0
                break;
            end
        end
        if fl == 1
            a = [a;[a1 a2 a3]];
            D(a1,a2:a3) = NaN;
        end
        if length(find(isnan(D)))>=missNum1
            flag = 0;
            idx1 = find(isnan(D));
        end
    end
    id = find(~isnan(D));
    id = id(randperm(length(id)));
    idx2 = id(1:missNum2);
    idx = [idx1;idx2];
end

% remove the condition where entir row is NaN
B = ones(M,N);
B(idx) = NaN;
C = isnan(B);
tmp = find(sum(C,2)==N);
if ~isempty(tmp)
    B(tmp,1) = 1;
    idx = find(isnan(B)==1);
else
    return;
end
