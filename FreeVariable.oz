%%declare

fun {Diff Xs Ys}
   local Temp in
      Temp = {Dictionary.new}
      _={Map Xs fun{$ X} {Dictionary.put Temp X val } t end }
      _={Map Ys fun{$ Y} {Dictionary.remove Temp Y} t end }
      {Filter {Dictionary.keys Temp} fun{$ X} X\=nil end }
   end
end

fun {SortPredicate X Y}
   X<Y
end

fun {Union Xs Ys}
   local Temp in
      Temp = {Dictionary.new}
      _={Map Xs fun{$ X} {Dictionary.put Temp X val } t end }
      _={Map Ys fun{$ Y} {Dictionary.put Temp Y val } t end }
      {Filter {Dictionary.keys Temp} fun{$ X} X\=nil end }
   end
end



fun {FreeVariables Stmt}
  % {Browse 'Jai Hind Doston'}
   % returns a list of free variables
   % {FreeVariables [Stmt]} = [z y] so on
   case Stmt
   of nil then nil
   [] variable|IdentList|Stmt|nil 
      % Assuming: [variable [ident(x) ident(y)] Stmt]
      then 
      local Fvars Idents in
         Fvars = {FreeVariables Stmt}
         Idents = {Map IdentList fun {$ X} case X of ident(Y) then Y else nil end end}
         {Diff Fvars Idents}
      end
   [] bind|Exp1|Exp2|nil then
      {Union {FreeVariables Exp1} {FreeVariables Exp2}}
      % case Exp1
      % of ident(X) then 
      %    case Exp2
      %    of literal(X) then nil
      %    [] ident(X) then Exp2
      %    [] procedure|IdentList|Stmt|nil then {Diff {FreeVariables Stmt} IdentList}
      %    [] record|literal(Lit)|Pairs|nil then god_save_me

   [] procedure|IdentList|Stmt|nil then 
      local Idents in
         Idents = {Map IdentList fun {$ X} case X of ident(Y) then Y else nil end end}
         {Diff {FreeVariables Stmt} Idents}
      end
   [] record|literal(Lit)|Pairs|nil then { FoldR {Map Pairs fun {$ X} {FreeVariables X.2.1}end } fun{$ X Y} {Union X Y} end nil} %ping me if you understand this
   [] literal(X) then nil
   [] ident(X) then [X]
   [] H|T then {Union {FreeVariables H} {FreeVariables T} }
   else nil
   end
end
/*
local AST in
   AST = [procedure [ident(x)] [[bind ident(x) [procedure [ident(l)] [bind ident(l) ident(f)]]] [ident(q)]]]
   %  AST = [bind ident(x) [record literal(r) [[literal(f1) ident(x1)] [literal(f2) ident(x2)]]]]
   AST = [variable [ident(f)] [procedure ident(p) ]]
   {Browse {FreeVariables AST}}
end
*/
fun {GetContextualEnv Stmt Args E}
   % return a contextual env of Stmt
   local Idents Fvars CE in
      Idents = {Map Args fun {$ X} case X of ident(Y) then Y else nil end end}
      Fvars = {Diff {FreeVariables Stmt} Idents}
      CE = {InitEnv}
      {List.forAll Fvars proc {$ X} {Dictionary.put CE X E.X} end }
      CE
   end
end
