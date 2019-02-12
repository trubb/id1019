defmodule Meta do

    # Environment module
    # performs operations on a passed environment
    defmodule Env do
        # return empty list
        # an empty environment
        def new() do
            []
        end

        # return an environment where the binding of the
        # variable _id_ to the structure _str_ has been
        # added to the environment _env_
        def add( id, structure, environment ) do
            [ { id, structure } | environment ]
        end

        # return {id, structure} if the variable _id_ was bound
        # else return _:nil_
        def lookup( _id, [] ) do
            :nil
        end
        def lookup( id, [ {id, structure} | _environmenttail ]) do
            {id, structure}
        end
        def lookup( id, [ {_,_} | environmenttail ]) do
            lookup( id, environmenttail )
        end

        # returns an enviroment where all bindings for variables
        # in the list _ids_ have been removed
        def remove( ids, environment ) do
            remove( ids, environment, [])
        end
        def remove( [], environment, clearenvironment ) do
            clearenvironment ++ environment
        end
        def remove( [_hids | tids], [], clearenvironment ) do
            remove( tids, clearenvironment, [] )
        end
        def remove( [hids | tids], [hids | environmenttail], clearenvironment ) do
            remove( tids, clearenvironment ++ environmenttail, [] )
        end
        def remove( [hids | tids], [henv | tenv], clearenvironment ) do
            remove( [hids | tids], tenv, [henv | clearenvironment] )
        end

    end # end of module Env

    # Evaluation module
    # performs evaluations and other actions on a passed sequence
    defmodule Eager do
        # takes an expression and an environment
        # returns either _:ok, str_ if all is well,
        # or :error if the expression cant be evaluated
        def eval_expr( {:atm, id}, _ ) do
            {:ok, id}
        end

        def eval_expr( {:var, id}, environment ) do
            case Env.lookup( id, environment ) do
                nil ->
                    :error
                {_, structure} ->
                    { :ok, structure }
            end
        end

        def eval_expr( {:cons, head, tail}, environment ) do
            case eval_expr( head, environment ) do
                :error ->
                    :error
                {:ok, structure } ->
                    case eval_expr( tail, environment ) do
                    :error ->
                        :error
                    {:ok, tailstructure} ->
                        { :ok, {structure, tailstructure } }
                end
            end
        end

        # match a _ which is a :ignore atom
        def eval_match( :ignore, _, env ) do
            {:ok, env}
        end
        # match an atom :a, it's always the atom :a
        def eval_match( {:atm, id}, id, env ) do
            {:ok, env}
        end
        # match a variable, check if present in the environment
        # if it isn't, add it to the environment
        # if it is present, return the environment
        def eval_match( {:var, id}, struct, env ) do
            case Env.lookup( id, env ) do
                :nil ->
                    {:ok, Env.add( id, struct, env )}
                {^id, ^struct} ->
                    {:ok, env}
                {_,_} ->
                    :fail
            end
        end
        # match a cons cell (a list)
        # if it dont match it dont work
        # if we get an updated environment back then we
        # try to match in that environment and so on
        def eval_match( {:cons, hpat, tpat}, { hdat, tdat}, env ) do
            case eval_match( hpat, hdat, env ) do
                :fail ->
                    :fail
                {:ok, updatedenv} ->
                    eval_match( tpat, tdat, updatedenv )
            end
        end

        # returns a list of variables extracted from a passed pattern
        def extract_vars( {:var, v} ) do
            [{:var, v}]
        end
        def extract_vars( {:cons, left, right} ) do
            extract_vars( left ) ++ extract_vars( right )
        end
        def extract_vars( _ ) do
            []
        end

        # helper for evaluating a sequence
        # takes a sequence and returns either
        # {:ok, structure}, or
        # :error
        def eval( sequence ) do
            eval_seq( sequence, [] )
        end

        # evaluates a sequence passed in list form
        # takes the expression-list, and an environment
        # returns an evaluation of the expression
        # based on the environment
        def eval_seq( [expression], environment ) do
            eval_expr( expression, environment )
        end

        # evaluates a sequence expressed as a list containing
        # a pattern matching expression, and one or more normal expression
        # evaluation starts with an empty environment
        # which is extended as we execute the evaluation process
        def eval_seq( [{:match, pattern, expression} | sequencet], environment ) do
            case eval_expr( expression, environment ) do
                :error ->
                    :error
                { :ok, structure } ->
                    vars = extract_vars( pattern )
                    environment = Env.remove( vars, environment )

                case eval_match( pattern, structure, environment ) do
                    :fail ->
                        :error
                    {:ok, environment} ->
                        eval_seq( sequencet, environment )
                end
            end
        end

    end # end of module Eager

end # end of module Meta
