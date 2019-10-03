% declare
TemporaryCount = {NewCell  ~1}
SAS = {Dictionary.new}
fun {AddKeyToSAS}
   TemporaryCount := @TemporaryCount+1
   {Dictionary.put SAS @TemporaryCount equivalence(@TemporaryCount)}
   @TemporaryCount
end
fun {RetrieveFromSAS A}
   local Val in
      Val = {Dictionary.get SAS A}
      case Val
      of key(X) then {RetrieveFromSAS X}
      [] equivalence(X) then equivalence(X)
      else
	 Val
      end
   end
end
proc {BindRefToKeyInSAS KeyX KeyY} % both X and Y are keys in SAS and they need to merged in the SAS
   {Dictionary.put SAS KeyX key(KeyY)}
end

proc {BindValueToKeyInSAS Key Y } % X : key and Y : a value
   local Value in
      Value = {RetrieveFromSAS Key}
      case Value
      of equivalence(X) then {Dictionary.put SAS X Y}
      else
	 raise alreadyAssigned(Key Y Value)
	 end
      end
   end
end
fun {PrintableSAS}
   local ExpandProcs in 
      fun {ExpandProcs X}
         case X 
         of A#procedure(ce:CE stmt:Stmt ) then A#procedure(ce:{Dictionary.entries CE} stmt:Stmt)
         else X
         end
      end
      _={Map {Dictionary.entries SAS} ExpandProcs}
   end
end
