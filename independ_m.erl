-module(independ_m).

-import(lists,[reverse/1]).
-import (balance_m,[st/2,foldBalance/2]).
-export([getInd/2]).
-define(TEST_BALANCE,[{b1300,29597109},{b1600,41779275}]).	
-define(NORMAL_FI,0.5).
-define(FI_STATE,[b1300,b1600]).

stP()->getInd(true,?TEST_BALANCE).


getInd(CompareNormal,Balance)->
	StateList = foldBalance(Balance,?FI_STATE),
	Res = getRatio(StateList),
	if CompareNormal =:= false ->
		Res;
		true-> {"K=", Res," Difference between normal ", Res - ?NORMAL_FI}
	end.

getRatio(List)->
	 st(b1300,List)/st(b1600,List).