function [X] = Unfold( X, dim, i )
X = reshape(shiftdim(X,i-1), dim(i), []);%�����ƶ�i_1λ reshape96*30*40