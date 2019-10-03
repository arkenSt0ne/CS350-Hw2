fun {InitEnv}
   {Dictionary.new}
end
fun {CloneEnv Env}
   {Dictionary.clone Env}
end
fun {GetEnv Env}
   {Dictionary.entries Env} 
end
fun {IsInEnv Key Env}
   {Dictionary.member Env Key}
end
fun {GetFromEnv Key Env}
   {Dictionary.get Env Key}
end
fun {Addjunct Env Key Val}
   {Dictionary.put Env Key Val}
   adjoined
end
