-module(liquidity_m).
% Импорт BIF функций.
-import(lists,[reverse/1,nth/2]).
-import (balance_m,[st/2,foldBalance/2]).
-export([getLiquidity/3]).
% Описание нормативных констант для коэффициентов ликвидности
-define(NORMA_CR,2).
-define(NORMA_QR,1).
-define(NORMA_AR,0.5).
-define(TEST_BALANCE,[{b1170,0},{b1200,33259218},{b1240,13116299},{b1250,341884},{b1260,59618},{b1500,11941119},{b1530,0},{b1540,30963}]).
% Описание статей баланса используемых для расчета коэфф. ликвидности
-define(QR_STATE,[b1240,b1250,b1260,b1500,b1530,b1540]).
-define(AR_STATE,[b1240,b1250,b1500,b1530,b1540]).
-define(CR_STATE,[b1170,b1200,b1500,b1530,b1540]).

stP() -> getLiquidity(ar,true,?TEST_BALANCE).
	

valuateRatio(Term1,Term2)  -> %when is_float(Term1),is_float(Term2)
	Term1/Term2.
			    
getLiquidity(Type,CompareNormal,Balance)->
	case Type of
		ar ->
			StateList = foldBalance(Balance,?AR_STATE),
			Res = getRatio(StateList,'ab_liq'),
			if CompareNormal =:= false -> 
				Res;
				true ->	{"K= ",Res," Difference between normal ", getDif(Res,?NORMA_AR)}
			end;
		cr ->
			StateList = foldBalance(Balance,?CR_STATE),
			Res = getRatio(StateList,'cr_liq'),
			if CompareNormal =:= false -> 
				Res;
				true ->	{"K= ",Res," Difference between normal ",  getDif(Res,?NORMA_CR)}
			end;
		qr ->
			StateList = foldBalance(Balance,?QR_STATE),
			Res = getRatio(StateList,'ft_liq'),
			if CompareNormal =:= false -> 
				Res;
				true ->	{"K= ",Res, " Difference between normal ", getDif(Res,?NORMA_QR)}
			end
	end.

getDif(Value,Normal)->
	Value - Normal.

getRatio(List,Ratio)->
	case Ratio of
		'ab_liq'  ->
			T1 = st(b1240,List) + st(b1250,List),
			T2 = st(b1500,List)-st(b1530,List)-st(b1540,List),
			valuateRatio(T1,T2);
		'cr_liq'  ->
			T1 = st(b1170,List) + st(b1200,List),
			T2 = st(b1500,List)-st(b1530,List)-st(b1540,List),
			valuateRatio(T1,T2);
		'ft_liq'  ->
			T1 = st(b1240,List) + st(b1250,List) + st(b1260,List),
			T2 = st(b1500,List)-st(b1530,List)-st(b1540,List),
			valuateRatio(T1,T2)
	end.


