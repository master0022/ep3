defmodule Automata do

  def next_states(transitions,input) do
    #Filter to get only transitions where the input is equal to the input received
    possible_transitions = Enum.filter(transitions,fn x ->Enum.fetch(x,0)=={:ok,input} end)
    #For each transition, extract the next state
    next_transitions = Enum.map(possible_transitions,
    fn trans ->
      {:ok,ele} = Enum.fetch(trans,1)
      ele
    end)
    #If there are no next states, return :none
    case length(next_transitions) do
      0 -> :none
      _ -> next_transitions
    end
  end

  def automata_simulation(automata,inputlist,input_idx\\1) do

    case Enum.fetch(inputlist,input_idx) do
      # It's assumed the first and last input to be "",
      # If we reach the end, check if the automata is in an accepting state
      {:ok,""} -> Enum.member?(automata.accept_states, automata.state)
      {:ok,input} ->
        transitions = automata.transitions[automata.state]

        case next_states(transitions,input) do
          # If there are no next states, reject input
          :none -> false
          #Run the simulation of an automata in the next state, with the rest of the input
          next_states ->
            #Checks if at least one of the "automatas running the next states" have reached an Accepting State in the end.
            Enum.any?( Enum.map(next_states,fn state -> automata_simulation(%{automata | state: state}, inputlist, input_idx+1) end ))


        end
    end
  end

  def parse(input) do
    #Returns a list of characters.
    #Example "abcdefg" -> ["","a","b","c","d","e","f","g",""]
    input_list = String.split(input,"")
  end

  def recursive_has_duplicates(transitions,index\\0) do
    case Enum.fetch(transitions,index) do
      {:ok,row} ->
        [head|[tail]] = Tuple.to_list(row)
        states = Enum.map( tail,fn x ->
          {:ok,state} = Enum.fetch(x,0)
         state end)
         (Enum.uniq(states) != states) or recursive_has_duplicates(transitions,index+1)
      :error -> false
    end
  end

  def simulate_DFA(automata,input_list) do
    #Check in transitions table, if there is an input that transitions to more than one state
    case recursive_has_duplicates(automata.transitions) do
      true -> :invalid_transitions
      false ->automata_simulation(automata,input_list)
    end


  end

end
