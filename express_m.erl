-module(express_m).
-import(liquidity_m,[getLiquidity/3]).
-import(independ_m,[getInd/2]).
-import(buisactiv_m,[getPow/3]).
%-import(erlang,[float_to_list/2,list_to_float/1]).
-import(lists,[reverse/1]).

-define(TEST_BALANCE,[{b1100,9520057},{b1170,0},{b1200,33259218},{b1210,14908391},{b1240,13116299},{b1250,341884},{b1260,59618},{b1300,29597109},{b1500,11941119},{b1530,0},{b1540,30963},{b1600,41779275}]).


-define(cr,16.5).
-define(ir,17).
-define(pow,15).
-define(pows,13.5).
-define(zero,0).
startAnalyse(Balance)->Res=roundRatio(
	[ {ar,getLiquidity(ar,false,?TEST_BALANCE)},
	  {qr,getLiquidity(qr,false,?TEST_BALANCE)},
	  {cr,getLiquidity(cr,false,?TEST_BALANCE)},
	  {ir,getInd(false,?TEST_BALANCE)},
	  {pow,getPow(false,?TEST_BALANCE,pow)},
	  {pows,getPow(false,?TEST_BALANCE,pows)}]),
	Rules = fillRules(),
	Summa = getSumm(runExpress(Res,Rules)),
	getDecision(Summa).


roundRatio(List)->roundRatio(List,[]).

roundRatio([],Acc)->reverse(Acc);
roundRatio([{Tag,R}|T],Acc)->roundRatio(T, [ {Tag, list_to_float(float_to_list(R,[{decimals,2}]))}|Acc]).
% Corteg(ratio,max,min,h,bal)
fillRules() ->
   [{ar,20,0.5,0.1,0.1,4},
	{qr,18,1.5,1,0.1,3},
	{cr,16.5,2,1,0.1,1.5},
	{ir,17,0.6,0.4,0.01,0.8},
	{pow,15,0.5,0.1,0.1,3},
	{pows,13.5,1,0.5,0.1,2.5}].

runExpress(List, Rules)->runExpress(List,Rules,[]).

runExpress([],[],Sum)->reverse(Sum);
runExpress([H|T],[H1|T1],Sum) ->runExpress(T,T1,[countBal(H,H1)|Sum]).

countBal(Elem,Rules)->
	{Tag,Val} = Elem,
	case Rules of
		{Tag2,Base,Max,Min,H,Bal} when Tag =:=Tag2, Val < Max, Val > Min ->Base - ((Max-Val)/H*Bal);%/H*Bal;
		{Tag2,Base,Max,Min,H,Bal} when Tag =:=Tag2,Val >= Max-> Base;
		{Tag2,Base,Max,Min,H,Bal} when Tag =:=Tag2,Val =< Min-> ?zero	
	end.

getSumm(List)-> getSumm(List,0).
getSumm([],Acc)->Acc;
getSumm([H|T],Acc)->getSumm(T,Acc+H).

getDecision(Summ)->
	case Summ of
		Value when Value >=94 -> 'Exellent';
		Value when Value >=65, Value <93 -> 'Good';
		Value when Value >=52, Value <65 -> 'Average';
		Value when Value >=21, Value <52 -> 'Satisfactory';
		Value when Value >=0,  Value  <21 -> 'Critical'
	end.