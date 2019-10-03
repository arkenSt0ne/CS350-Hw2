functor
import
   Browser
   System
define
	\insert 'Environment.oz'
	\insert 'SingleAssignmentStore.oz'
    \insert 'ProcessRecords.oz'
    \insert 'SemanticStack.oz'
    \insert 'FreeVariable.oz'
	\insert 'unify.oz'
	fun {BindFromEnv Env CE}
		fun {$ X Y}
			if {IsInEnv X Env} then
			   {Unify {GetFromEnv X Env} Y CE}
			   unified
			else
				raise 
					variableNotDefined(X)
				end
			end
		end
	end
	proc {BindFuncArgs FormalArgs ActualArgs Env CE}
		if {Length FormalArgs} \= {Length ActualArgs} then
			raise 
				illegalBindingParams(formal:FormalArgs actual:ActualArgs)
			end
		else
			{List.zip ActualArgs FormalArgs {BindFromEnv Env CE}}
		end
	end
	proc {AddIdentsInEnv L Env}
		_=	{
		Map {Flatten L} fun {$ X}
							case X
							of ident(Y) then 
								local Key in
									Key = {AddKeyToSAS}
									{System.show declaring(key:Y)}
									{Addjunct Env Y Key}
								end
							else X
							end
						end 
		}
	end
	SuspendCount = {NewCell 0}
	proc {ExecStack}
		local StackTop Stmt Env in
			if {IsEmpty} then
				{Browser.browse sasViewEnd({PrintableSAS})}
				{Browser.browse 'Execution Ended Successfully'}
			else
				if @SuspendCount == 0 then
					{Browser.browse stackView({PrintStack})}
					{Browser.browse sasView({PrintableSAS})}
					StackTop = {Pop}
					Stmt     = StackTop.stmt
					Env      = StackTop.env
					case Stmt
					of nop then skip
					[] variable|IdentList|NextStmt|nil then
						local NewEnv  in
							NewEnv = {CloneEnv Env}
							{AddIdentsInEnv IdentList NewEnv}
							{Push pair(stmt:NextStmt env:NewEnv)}
						end
					[] bind|Exp1|Exp2|nil then
						case Exp1
						of ident(X) then
								if{IsInEnv X Env} then
									case Exp2
									of ident(Y) then
										if {IsInEnv Y Env} then
											{Unify Exp1 Exp2 Env}
										else
											raise variableNotDeclared73(Y)
											end
										end
									[] procedure|Args|Stmt|nil then
										local CE in
											CE = {GetContextualEnv  Stmt Args Env }
											{Browser.browse contextEnv(ce:{Dictionary.entries CE} stmt:Exp2)}
											{Unify Exp1 procedure(stmt:Exp2 ce:CE) Env}
										end
									else
										{Unify Exp1 Exp2 Env}
									end
								else
									raise variableNotDeclared86(X) end
								end
						[] procedure|_ then
							raise procedureBindingWithNonVar(Exp1)	end
						else
							raise unknown(exp1:Exp1 exp2:Exp2)	end
						end
					[] procedure|ident(X)|Args|Stmt|nil then
						 {Push pair(stmt:  bind|ident(X)|[procedure Args Stmt]|nil env:Env)}
					[] conditional|ident(X)|TrueStmt|FalseStmt|nil then
						local Value in
							if {IsInEnv X Env} then
								Value = {RetrieveFromSAS {GetFromEnv X Env}}
								case Value
								of equivalence(_) then SuspendCount:=@SuspendCount+1 
								[] boolTrue then 
									 {Push pair(stmt:TrueStmt env:{CloneEnv Env})}
								[] boolFalse then
									 {Push pair(stmt:FalseStmt env:{CloneEnv Env})}
								else
									raise illegalBooleanValue(Value) end
								end
							else
								raise variableNotDeclared109(X) end
							end
						end
					[] apply|ident(PName)|ActualArgs|nil then
						local Fvalue Fce in
							 if {IsInEnv PName Env} then
								 Fvalue = {RetrieveFromSAS {GetFromEnv PName Env}}
								 case Fvalue
								 of procedure(stmt:procedure|FormalArgs|ProcStmt|nil ce:CE) then
								 	 if {Length ActualArgs} == {Length FormalArgs} then
									 	 Fce = {CloneEnv CE}
										 {BindFuncArgs FormalArgs ActualArgs Env Fce}
										 {Push pair(stmt:ProcStmt env:Fce)}
										 									 
									 else
									 	raise 
										  argumentNumberMismatch(found:{Length ActualArgs} expected:{Length FormalArgs})
										end 
									 end
								 else 
								 	raise notAValidProcedure(PName) end
								 end
							 else
							 	raise variableNotDefined(PName) end
							 end						
						end
					[] match|ident(X)|record|L|Pairs1|TrueStmt|FalseStmt|nil then
						local NewEnv  ValX InpPair ExpPair in 
							NewEnv = {CloneEnv Env}
							try	
								ValX = {RetrieveFromSAS {GetFromEnv X Env}}
								case ValX
								of equivalence(_) then
									SuspendCount:=@SuspendCount+1
								[] record | !L | PairList|nil then
								   	InpPair = {Canonize Pairs1}
									ExpPair = {Canonize PairList}
									if {Length ExpPair} \= {Length InpPair} then
										raise incompatibleRecordArity end
									else
										if {ListOfFeatures InpPair} \= {ListOfFeatures ExpPair}
										then
											raise 
												incompatibleFeatures 
											end
										else
											skip
											%Something

										end
									end	
								else 
									raise incompatibleRecords end
								end

								{Unify X record|L|Pairs1|nil NewEnv}
								{Push pair(env:NewEnv stmt:TrueStmt)}
							catch X then
								{Push pair(stmt:FalseStmt env:{CloneEnv Env})}
							end
						end
					[] H|T then 
					   if T \=nil then
							{Push pair(stmt:T env:{CloneEnv Env})}
						else
							skip
						end
						{Push pair(stmt:H env:{CloneEnv Env})} 
					else
						skip
					end
					{ExecStack}
				else
					{Browser.browse 'Execution Suspended'}
				end
			end
		end
		
	 	% {Browser.browse 'stackEx'}
	end
	proc {ParseAST AST}
		{Push pair(env:{InitEnv} stmt:AST)}
		{Browser.browse 'Starting Execution'}
		{ExecStack}
	end
	local AST in 
      AST = [variable [ident(f) ident(r) ident(p)] 
	     [procedure ident(p) [ident(x)] 
	      [
	       [bind ident(f) ident(x)] 
	       [bind ident(r) [record literal(rec) [[literal(f1) literal(x1)] [literal(f2) literal(x2)]]]]
	      ]
	     ]
	    ]
      {Browser.browse inputGiven(AST)}
      {ParseAST AST}
   end
end