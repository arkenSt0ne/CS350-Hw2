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
					[] variable|Next then
						local NewEnv IdentList NextStmt in
							IdentList = Next.1
							NextStmt = Next.2
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
											raise variableNotDeclared59(Y)
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
									raise variableNotDeclared72(X) end
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
								of equivalence(_) then 
									SuspendCount:=@SuspendCount+1 
									raise 
										unBoundVariable(X)
									end
								[] boolTrue then 
									 {Push pair(stmt:TrueStmt env:{CloneEnv Env})}
								[] boolFalse then
									 {Push pair(stmt:FalseStmt env:{CloneEnv Env})}
								else
									raise illegalBooleanValue(Value) end
								end
							else
								raise variableNotDeclared99(X) end
							end
						end
					[] apply|ident(PName)|ActualArgs|nil then
						local Fvalue Fce  in
							 if {IsInEnv PName Env} then
								 Fvalue = {RetrieveFromSAS {GetFromEnv PName Env}}
								 case Fvalue
								 of procedure(stmt:procedure|FormalArgs|ProcStmt|nil ce:CE) then
								 	 if {Length ActualArgs} == {Length FormalArgs} then
									 	Fce = {CloneEnv CE}
										{
											 List.forAll FormalArgs proc {$ X}
											 							local Key in 
																			case X
																			of ident(Y) then
																				Key ={AddKeyToSAS}
																				{System.show declaring(key:Y)}
																				_={Addjunct Fce Y Key}
																			else 
																				skip
																			end
																		end
											 						end
										}
										_= {List.zip ActualArgs FormalArgs proc{$ X Y }
										 										{Unify X Y Fce}
										 									end
										}
										{System.show procedureCallSuccess(pname:PName)}
										{Push pair(env:Fce stmt:ProcStmt)}
										
									 else
									 	raise 
										  argumentNumberMismatch(found:{Length ActualArgs} expected:{Length FormalArgs})
										end 
									 end
								 [] equivalence(_) then
								 	 SuspendCount := @SuspendCount+1
									 raise
									 	unBoundVariable(PName)
									 end	
								 else 
								 	raise typeError(PName) end
								 end
							 else
							 	raise variableNotDefined(PName) end
							 end						
						end

					[] match|ident(X)|record|L|Pairs1|TrueStmt|FalseStmt|nil then
					% here assumed <p> will always be a proper record (i.e not a literal)
						{System.show caseStmt(ident:X l:L pairs1:Pairs1 truestmt:TrueStmt falsestmt:FalseStmt)}
						local NewEnv  ValX InpPair ExpPair in 
							NewEnv = {CloneEnv Env}
							% try	
								ValX = {RetrieveFromSAS {GetFromEnv X Env}}
								case ValX
								of equivalence(_) then
									% X is unbounded
									SuspendCount:=@SuspendCount+1
									raise unBoundVariable(X) end
								[] record | !L | PairList|nil then
								   	InpPair = {Canonize Pairs1}
									ExpPair = {Canonize PairList}
									% InpPair = Pairs1
									% ExpPair = PairList
									if {Length ExpPair} \= {Length InpPair} then
										{Push pair(stmt:FalseStmt env:{CloneEnv Env})}
									else
										if {ListOfFeatures InpPair} \= {ListOfFeatures ExpPair}
										then
											{Push pair(stmt:FalseStmt env:{CloneEnv Env})}
										else
											% all good, add new variables to environment, if any
											_ = {
												Map InpPair 
													fun {$ X}
														case X.2.1
														of ident(Y) then
															local Key in
																Key = {AddKeyToSAS}
																{System.show declaring(key:Y)}
																{Addjunct NewEnv Y Key}
															end
														else nil %do nothing, Unify will take care below
														end
													end
											}
											{Unify ValX record|L|Pairs1|nil NewEnv}
											{Push pair(env:NewEnv stmt:TrueStmt)}
										end
									end	
								else 
									{Push pair(stmt:FalseStmt env:{CloneEnv Env})}
								end

								% {Unify X record|L|Pairs1|nil NewEnv}
								% {Push pair(env:NewEnv stmt:TrueStmt)}
							% catch X then
								% {Push pair(stmt:FalseStmt env:{CloneEnv Env})}
							% end
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
    %   AST = [variable [ident(f) ident(r) ident(p)] 
	%      [procedure ident(p) [ident(x)] 
	%       [
	%        [bind ident(f) ident(x)] 
	%        [bind ident(r) [record literal(rec) [[literal(f1) literal(x1)] [literal(f2) literal(x2)]]]]
	%       ]
	%      ]
	%     ]
		AST = [variable [ident(x) ident(a) ident(b)]
			[bind ident(x) [record literal(lit) [[literal(f1) ident(a)] [literal(f2) literal(v2)]]] ]
			[match ident(x) record literal(lit) [[literal(f1) ident(y)] [literal(f2) ident(z)]] [bind ident(a) ident(x)] [bind ident(b) ident(x)] ]
			nop
		]
			
		% AST = [match ident(x) record literal(lit) [[f1 v1] [f2 v2]] nop nop]
      {Browser.browse inputGiven(AST)}
      {ParseAST AST}
   end
end
