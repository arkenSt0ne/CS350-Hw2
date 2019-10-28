% \insert 'Environment.oz'
%declare
MultiStack = {NewCell nil}
ExecutionCount = {NewCell 0}
% Stack = {NewCell nil}

fun {ValueToPrintable Val}
   case Val
   of pair(env:Env stmt:Stmt) then
      pair(env:{GetEnv Env} stmt:Stmt)
   else
      undefinedValueOnStack
   end
   
end
proc {CreateNewStack Val}
   MultiStack := [Val]|@MultiStack
   {ResetExecutionCount}
   {System.show {Map @MultiStack PrintStackElem}}
end

proc {ResetExecutionCount}
   ExecutionCount := 0
end

proc {IncreaseExecutionCount}
   ExecutionCount := @ExecutionCount+1
end

proc {DeleteCurrThread}
   {ResetExecutionCount}
   MultiStack := @MultiStack.2
end

proc {SuspendCurrThread}
   {ResetExecutionCount}
   MultiStack := {Append @MultiStack.2 [@MultiStack.1]}
end



proc {Push Val}
   MultiStack := (Val|@MultiStack.1) | @MultiStack.2
   % {System.show pushed({ValueToPrintable Val})}
end

fun {IsEmpty}
   if @MultiStack.1==nil then
      {Browser.browse 'Thread Ended Successfully'}
      {System.show 'Thread Ended Successfully'}
      {DeleteCurrThread}
   else skip
   end
   @MultiStack == nil
end

fun {Pop}
   case @MultiStack.1
   of nil then nil
   [] H|T then
      MultiStack := T | @MultiStack.2
      H
   % else
   %    @Stack
   end
end


fun {PrintStackElem Stack}
   local PrintStackAux TempEnv in
      TempEnv = {Dictionary.new}
      proc {PrintStackAux S Level}
         case S
         of nil then skip
         else
            {Dictionary.put TempEnv Level {ValueToPrintable S.1}}
            {PrintStackAux S.2 Level+1}
         end
      end
      {PrintStackAux Stack 0}
      {GetEnv TempEnv}
   end
end
	    
