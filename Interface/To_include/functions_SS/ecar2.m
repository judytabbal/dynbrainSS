function e=ecar2(A,B)
% e=ecar2(A,B)
%  Comon, version 24 may 1991
%  English comments added in 1994
%  Measures the gap between two matrices, up to a Diag*Permutation:
%  Gap is null iff:
%  B=A*D*P, or B=A*P*D, or A=B*D*P, or A=B*P*D,
%  where   D regular diagonal  and P permutation
[m,n]=size(A);[p,q]=size(B);
if(m~=n|p~=q),error('les matrices doivent etre carrees'),end;
if(m~=p),error('les matrices n<ont pas la meme taille'),end;
%normalisation des colonnes
AA=A.*conj(A);A=A./(ones(n,1)*sqrt(sum(AA)));
BB=B.*conj(B);B=B./(ones(n,1)*sqrt(sum(BB)));
M=inv(A)*B;
%gap
MM=M.*conj(M);
h1=sum(abs(M))-1;h2=sum(MM)-1;v1=sum(abs(M'))-1;v2=sum(MM')-1;
e=h1*h1'+v1*v1'+sum(abs(h2))+sum(abs(v2));