% \insert 'Environment.oz'
%declare
Stack = {NewCell nil}
proc {ResetStack}
   Stack:=nil
end
fun {ValueToPrintable Val}
   case Val
   of pair(env:Env stmt:Stmt) then
      pair(env:{GetEnv Env} stmt:Stmt)
   else
      undefinedValueOnStack
   end
   
end
proc {Push Val}
   Stack := stack(top:Val prev:@Stack)
   % {System.show pushed({ValueToPrintable Val})}
end

fun {IsEmpty}
    @Stack == nil 
end
fun {Pop}
   case @Stack
   of nil then nil
   [] stack(top:H prev:T) then
      Stack := T
      H
   else
      @Stack
   end
end

fun {PrintStack}
   local PrintStackAux TempEnv in
      TempEnv = {Dictionary.new}
      proc {PrintStackAux S Level}
	 case S
	 of nil then skip
	 else
	    {Dictionary.put TempEnv Level {ValueToPrintable S.top}}
	    {PrintStackAux S.prev Level+1}
	 end
      end
      {PrintStackAux @Stack 0}
      {GetEnv TempEnv}
   end
end

	    
