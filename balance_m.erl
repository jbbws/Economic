-module(balance_m).
-import(lists,[reverse/1]).
-export([foldBalance/2,st/2]).

foldBalance(List,RequestState)  ->foldBalance(List,RequestState,[]).	
foldBalance(_,[],Res)           ->reverse(Res);
foldBalance([H1|T1],[H2|T2],Res)-> 
	case H1 of 
		{H2,Value} -> foldBalance(T1,T2,[{H2,Value}|Res]);
		_		   -> foldBalance(T1,[H2|T2],Res)
	end.

st(Num,[])->nil;
st(Num,[H|T])->
	case H of
		{Num,Value} -> Value;
		_			->st(Num,T)
	end.
