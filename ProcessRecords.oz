fun {CanonizeTmp Xs}
   Temp
in
   Temp = {Dictionary.new}
   {List.forAll Xs proc {$ X }
		      if {Member {Dictionary.keys Temp} X.1} then raise illegalRecord end
		      else
			 {Dictionary.put Temp X.1 X.2.1}
		      end
		      
		   end }
   {Map {Dictionary.entries Temp} fun {$ X} case X of A#B then [A B] else X end end }
   
end

fun {Canonize ListOfKeyValue}
   SortingPredicate
   SortedKeys
   IsListOfUniques
in
   fun {IsListOfUniques L}
      case L
      of H|T then
	 case T
	 of nil then true
	 [] X|_ then if H==X then false
		     else
			{IsListOfUniques T}
		     end
	 else
	    H \= T
	 end
      else
	 true
      end
   end
   
   
   fun {SortingPredicate A B }
      case A
      of literal(X)
      then
	 case B
	 of literal(Y)
	 then
	    if {IsNumber X} == {IsNumber Y} 
	    then
	       X < Y 
	    else
	       {Not {IsNumber X} } 
	    end
	 end
      end
   end
   fun {SortedKeys}
      Key
   in
      Key = {Map ListOfKeyValue fun{$ X } X.1 end}
      {Sort Key SortingPredicate}
   end
   local SortedKeySet in
      SortedKeySet = {SortedKeys}
      if {IsListOfUniques SortedKeySet} then
	 {Map SortedKeySet fun {$ Key} {Filter ListOfKeyValue fun{$ X} X.1 == Key end }.1 end }
      else
	 raise illegalRecord
	 end
      end
      
   end
end
fun {ListOfFeatures PairList}
   local SomeFunc in
      fun {SomeFunc X}
         case X 
         of nil then nil
         [] literal(Z)|_ then Z
         else 
            raise
               illegalRecord(features:PairList)
            end
         end
      end
      {Map PairList SomeFunc}
   end
end
% fun {PatternMatch MatchTo  MatchWith NewEnv}
%    case MatchTo
%    of literal(_)|X|nil then
%       case MatchWith
%       of literal(_)|Y|nil then
%          case X
%          of ident(Z) then
%            if {IsInEnv Z NewEnv} then
%                {Unify X Y NewEnv}
%            else
%            end 
%          else
%          end
%       else
%          raise
%             notARecordPair
%          end
%       end
%    else
%       raise
%          notARecordPair
%       end
%    end

% end