-module (buisactiv_m).

-import (lists, [reverse/1]).
-import (balance_m,[st/2,foldBalance/2]).
-export ([getPow/3]).
-define(TEST_BALANCE,[{b1100,9520057},{b1200,32259218},{b1210,14908391},{b1300,29597109}]).

-define(NORMAL_POW,0.1).
-define(NORMAL_POWS,0.8).

-define(POW_STATE,[b1100,b1200,b1300]).
-define(POWS_STATE,[b1100,b1210,b1300]).

getPow(CompareNormal,Balance,TypeR) ->
	case TypeR of
		pow ->
			StateList = foldBalance(Balance,?POW_STATE),
			Res = getRatio(StateList);
		pows->
			StateList = foldBalance(Balance,?POWS_STATE),
			Res = getRatioS(StateList)
	end,
	if CompareNormal =:= false ->
		Res;
		true-> {"K=", Res," Difference between normal ", 
			case TypeR of
				pow ->(Res - ?NORMAL_POW);
				pows->(Res - ?NORMAL_POWS)
			end}
	end.

	
getRatio(List)->
	(st(b1300,List) - st(b1100,List))/st(b1200,List).

getRatioS(List)->
	(st(b1300,List) - st(b1100,List))/st(b1210,List).