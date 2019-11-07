% \insert 'Environment.oz'
%declare
MultiStack = {NewCell nil}
ExecutionCount = {NewCell 0}
SuspendCount = {NewCell 0}
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

proc {ResetSuspendCount}
   SuspendCount := 0
end

proc {IncreaseSuspendCount}
   SuspendCount := @SuspendCount+1
   {System.show 'Thread Suspended'}
end
proc {RemNil}
   case @MultiStack
   of nil then skip
   [] H|T then if H == nil then MultiStack = @MultiStack.2
                           {RemNil}
               else
                        skip
               end
   end
end
proc {DeleteCurrThread}
   {ResetExecutionCount}
   if @MultiStack==nil then skip
   else
      if @MultiStack.1==nil then MultiStack := @MultiStack.2 {DeleteCurrThread}
      else skip
      end
   end
   {System.show deletingthread(@MultiStack)}
end

proc {SuspendCurrThread}
   {ResetExecutionCount}
   MultiStack := {Append @MultiStack.2 [@MultiStack.1]}
   {System.show multistack(@MultiStack)}
   {System.show 'Thread Suspended'}
end



proc {Push Val}
   MultiStack := (Val|@MultiStack.1) | @MultiStack.2
   % {System.show pushed({ValueToPrintable Val})}
end

fun {IsEmpty}
   if @MultiStack==nil then 1==1
   else
      if @MultiStack.1==nil then
         {Browser.browse 'Thread Ended Successfully'}
         {System.show 'Thread Ended Successfully'}
         {DeleteCurrThread}
      else skip
      end
      @MultiStack == nil
   end
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
	    
