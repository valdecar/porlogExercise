%show and/or inside predicate
f(X,Y):-
	X>Y,print(conclution0);
	X=Y,print(conclution1);
	X<Y,print(conclution2).

myLength(0,[]).
myLength(N,[X|ListTail]):-
	myLength(N1,ListTail),N is N1+1.
%use like
%?-myReverse(0,[1,2,3],L)
%[3,2,1|_G123]
myReverse(N,[],ListOut):-
	print(ListOut).
myReverse(N,[X|ListTail],ListOut):-
	N1 is N+1,
	myReverse(N1,ListTail,[X|ListOut]).

%use like
%?-changeElemOfList(1,5,[1,2,3],L).
%L = [1, 5, 3].
changeElemOfList(ElemNumber,ElemNewValue,ListOld,ListNew):-
	nth0(ElemNumber,ListOld,_,ListTmp),
	nth0(ElemNumber,ListNew,ElemNewValue,ListTmp).

%change at one element with index ElemNumper
changeElemOfListAt1(ElemNumber,ListOld,ListNew):-
	nth0(ElemNumber,ListOld,ElemOldValue,ListTmp),
	ElemNewValue is ElemOldValue+1,
	nth0(ElemNumber,ListNew,ElemNewValue,ListTmp).
%change at N element with index ElemNumper
changeElemOfListAtN(ElemNumber,N,ListOld,ListNew):-
	nth0(ElemNumber,ListOld,ElemOldValue,ListTmp),
	ElemNewValue is ElemOldValue+N,
	nth0(ElemNumber,ListNew,ElemNewValue,ListTmp).
%use like
%?-factorial(5,N).
%N=120
factorial(0,N):-
	N=1.
factorial(K,N):-
	K>0,
	K1 is K-1,
	factorial(K1,N1),
	N is N1*K.
%use like
%binom(10,2,B).
%B=45
binom(N,K,B):-
	N>=K,
	factorial(N,N1),
	NKTmp is N-K,
	factorial(NKTmp,NK1),
	factorial(K,K1),
	B is N1/(NK1*K1).
%init T=1
%find Ck: binom(Ck,K,Xk)
%use like
%?-inverseBinom(Ck,2,45,1).
%Ck = 10
inverseBinom(Ck,K,Xk,T):-
	T=<Xk,
	binom(T,K,B),
	B=Xk,
	Ck is T.
inverseBinom(Ck,K,Xk,T):-
	T=<Xk,
	T1 is T+1,
	inverseBinom(Ck,K,Xk,T1).

%find  C1,...,Ck : binom(C1,1)=X1,...,binom(Ck,k)=Xk
%init K=1
%use like
%seqBinoms(1,[6,45],L).
%L=[6,10]
seqBinoms(K,[],ListOut):-
	append([],[],ListOut).
seqBinoms(K,[Xk|ListTail],ListOut):-
	inverseBinom(Ck,K,Xk,1),%find Ck: binom(Ck,K,Xk)
	K1 is K+1,
	seqBinoms(K1,ListTail,ListOut1),
	append([Ck],ListOut1,ListOut).%ListOut=ListOut1.append(Ck)

%find [c_1,..,c_n|binom(c_1,1)+..+binom(c_n,n)=X]
%K going throut dimention List
%T up value of some element List[i]
%init K=0,T=1,List=[0,0,0]
%use like
%?-binomNumericalSystem(15,[0,0],0,1).
%[9,4]
%meens that 15=binom(9,1)+binom(9,2)
binomNumericalSystem(X,List,K,T):-
	%c_1+..+c_n=X
	sum_list(List,S),
	S=X,
	%permutation(List,ListPerm),
	seqBinoms(1,List,ListBinoms),
	print(ListBinoms).
%change c_1,..,c_n one by one.
binomNumericalSystem(X,List,K,T):-
	sum_list(List,S),
	S<X,
	length(List,N),
	K<N,
	changeElemOfListAt1(K,List,NewList),
	Knew is K+1,
	binomNumericalSystem(X,NewList,Knew,T);
	sum_list(List,S),
	S<X,
	length(List,N),
	%second round
	K>=N,
	Knew is 0,
	binomNumericalSystem(X,List,Knew,T).
%change T and up c_K at T
binomNumericalSystem(X,List,K,T):-
	T=<X,
	sum_list(List,S),
	S<X,
	changeElemOfListAtN(K,T,List,NewList),
	Tnew is T+1,
	binomNumericalSystem(X,NewList,K,T).