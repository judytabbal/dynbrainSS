function [F,delta,gap,psi]=aciValid(Kum,AA)
% [F,delta,gap,psi]=aciValid(Kum,AA)
% P.Comon, version 10 march 1992.
% English comments added in 1994
% aciValid simulates the calculation of ICA of a data matrix with infinite
% integration length. It only needs as inputs the cumulants of sources,
% in a possibly larger number than sensors.
% Kum = standardized cumulants of sources, vector of size P
% A = mixing matrix, of size NxP, N and P can be arbitrarily chosen
% Entries of delta are sorted in decreasing order;
% Columns of F are of unit norm;
% The entry of largest modulus in each column of F is positive real.
% Initial and final values of contrast can be fprinted for checking.
% REFERENCE: P.Comon, "Independent Component Analysis, a new concept?",
% Signal Processing, Elsevier, vol.36, no 3, April 1994, 287-314.
%
[N,P]=size(AA);Kum=Kum(:);A0=AA(1:N,1:N);
if length(Kum)~=P,error('dimensions de AA et Kum incompatibles');end;
%%%%%% ETAPES 1 & 2: blanchiment et projection %%%%%%
%%% premiere version (standard) %%%
%[QA,RA]=qr(AA');QA=QA(1:P,1:N);RA=RA(1:N,1:N);
%[V,S,U]=svd(RA');s=diag(S);
%tol=max(size(S))*norm(S)*eps;I=find(s>tol);r=length(I);
%s=ones(r,1)./s(I);L=V(:,I)*S(I,I);   % L est Nxr
%A=U(:,I)'*QA';F=L;    % ici A*A'=I et A est rxP, F est Nxr
%%% seconde version (variante avec cholesky) %%%
% [qq,rr]=qr(AA');L=rr';A=qq';F=L;r=N;
%%% troisieme version (a utiliser si "svd would not converge" se repete) %%%
[V,S2]=eig(AA*AA');s2=diag(S2);
[ss,Js]=sort(-s2);ss=sqrt(-ss);Ss=diag(ss); % ss=Ps*sqrt(s2);
E=eye(N);Ps=E(:,Js)';Vs=V*Ps';              % norm(AA*AA'-Vs*diag(ss.*ss)*Vs')=0
tol=max(size(Ss))*norm(Ss)*eps;I=find(ss>tol);r=length(I);
ss=ones(r,1)./ss(I);L=Vs(:,I)*Ss(I,I);      % L est Nxr
A=inv(Ss(I,I))*Vs(:,I)'*AA;F=L;             % ici A*A'=I et A est rxP, F est Nxr
% norm(A*A'-eye(r))  % controle eventuel du blanchiment
% NB: une difference peut exister entre les versions, du a l'indetermination de
%  phase des vecteurs propres, ou a la presence de val propres multiples.
%%%%%% CONTRASTE INITIAL %%%%%%
contraste=Kum'*Kum;
%fprintf('Borne contraste=%g\n',contraste);
  for i=1:r,B(i,1:P)=A(i,:).^4;end;G=B*Kum;contraste=G'*G;
%fprintf('contraste initial=%g\n',contraste);
  if nargout>2,rep=1;psi(rep)=contraste;gap(rep)=ecar2(A0,F);end;
%%%%%% ETAPES 3 & 4 & 5: transformation orthogonale %%%%%%
if N==2,K=1;else,K=1+round(sqrt(N));end; % K=nbre max de balayages
Rot=eye(r);
for k=1:K,                     %%%%%% debut balayages
%fprintf('Balayage n%g\n', k)
Q=eye(r);
  for i=1:r-1,for j= i+1:r,
    Ai=A(i,:);Aj=A(j,:);
    qij=tfuniV(Ai,Aj,Kum);    %%%%%% traitement de la paire
    Qij=eye(r);Qij(i,i)=qij(1,1);Qij(i,j)=qij(1,2);
    Qij(j,i)=qij(2,1);Qij(j,j)=qij(2,2);
    F=F*Qij';A=Qij*A;
    if nargout>2,rep=rep+1;
      for ic=1:r,B(ic,1:P)=A(ic,:).^4;end;
      G=B*Kum;psi(rep)=G'*G;gap(rep)=ecar2(A0,F);
    end;
  end;end;
end;                           %%%%%% fin balayages
%%%%%% CONTRASTE FINAL %%%%%%
  for i=1:r,B(i,1:P)=A(i,:).^4;end;G=B*Kum;contraste=G'*G;
fprintf('contraste final=%g\n',contraste);
%%%%%% ETAPE 6: norme des colonnes %%%%%%
delta=diag(sqrt(sum(F.*conj(F))));
%%%%%% ETAPE 7: classement par ordre descendant %%%%%%
[d,I]=sort(-diag(delta));E=eye(r);P=E(:,I)';delta=P*delta*P';F=F*P';
%%%%%% ETAPE 8: normalisation des colonnes %%%%%%
F=F*inv(delta);
%%%%%% ETAPE 9: phase des colonnes %%%%%%
[y,I]=max(abs(F));
for i=1:r,Lambda(i)=conj(F(I(i),i));end;Lambda=Lambda./abs(Lambda);
F=F*diag(Lambda);