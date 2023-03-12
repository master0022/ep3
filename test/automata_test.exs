defmodule AutomataTest do
  use ExUnit.Case
  doctest Automata

  test "test automata 1 DFA" do

    # O automata 1 e definido com a tabela de transicoes abaixo.
    # E um automata simples, com um estado de rejeicao qR e que comeca no q0
    # Ele aceita strings do tipo (1)(0|1)*(0), ou seja, que comecam com 1 e terminam com 0.

    transitions =  %{
        q0: [ ["0",:qR], ["1",:q1] ],
        q1: [ ["0",:q2], ["1",:q1] ],
        q2: [ ["0",:q2], ["1",:q1] ],
        qR: [ ["0",:qR], ["1",:qR] ]
      }

    #O estado de aceitacao e q2
    accept_states = [:q2]

    automata = %{accept_states: accept_states,transitions: transitions, state: :q0}


    # CASOS DE TESTE
    input1 = "0001011010101110" # FALSE, comeca com 0
    input2 = "0011111111"       # FALSE, comeca com 0
    input3 = "1011111111"       # FALSE, termina com 1
    input4 = "1011111110"       # TRUE, comeca com 1 e termina com 0. Aceito.
    input5 = "0123456789"       # FALSE, inputs nao reconhecidos => rejeitado

    parser = fn (inp) -> Automata.parse(inp) end

    result1 = Automata.simulate_DFA(automata,parser.(input1))
    result2 = Automata.simulate_DFA(automata,parser.(input2))
    result3 = Automata.simulate_DFA(automata,parser.(input3))
    result4 = Automata.simulate_DFA(automata,parser.(input4))
    result5 = Automata.simulate_DFA(automata,parser.(input5))

    assert(result1==false)
    assert(result2==false)
    assert(result3==false)
    assert(result4==true)
    assert(result5==false)
  end

  test "test automata DFA" do
    # Nesse caso vamos apenas testar se a funcao que simula APENAS DFA funciona conforme esperado
    # Essa funcao verifica se a tabela de transicoe corresponde a um DFA ou um NFA, e retorna um error caso seja de um NFA.
    # Caso seja um DFA, essa funcao usa o proprio simulador do NFA, uma vez que todo DFA tambem pode ser simulado por um simulador de NFA.

    # Isso e uma DFA
    transitionsDFA =  %{
      q0: [ ["0",:qR], ["1",:q1] ],
      q1: [ ["0",:q2], ["1",:q1] ],
      q2: [ ["0",:q2], ["1",:q1] ],
      qR: [ ["0",:qR], ["1",:qR] ]
    }

    # Isso nao e uma DFA. Nao ha alteracao nas strings aceitas.
    transitionsNFA =  %{
      q0: [ ["0",:qR], ["1",:q1] ],
      q1: [ ["0",:q2], ["1",:q1],["1",:q0] ],
      q2: [ ["0",:q2], ["1",:q1] ],
      qR: [ ["0",:qR], ["1",:qR] ]
    }

    accept_states = [:q2]

    automataDFA = %{accept_states: accept_states,transitions: transitionsDFA, state: :q0}
    automataNFA = %{accept_states: accept_states,transitions: transitionsNFA, state: :q0}



    input1 = "0001011010101110" # FALSE, pois comeca com 0
    parser = fn (inp) -> Automata.parse(inp) end

    resultDFA = Automata.simulate_DFA(automataDFA,parser.(input1))
    resultNFA = Automata.simulate_DFA(automataNFA,parser.(input1))

    assert resultDFA == false
    assert resultNFA == :invalid_transitions #Correto, o simulador de DFAs lanca esse erro.

  end

  test "test automata 3" do

    # Mais tabelas de transicao para serem testadas.

    # Aceita strings do tipo (a)*(b)*, que tem n (a)s no comeco, e n (b)s no fim.
    transitions =  %{
        q0: [ ["b",:qR], ["a",:q1] ], #Estado Inicial
        q1: [ ["a",:q1], ["b",:q2] ],
        q2: [ ["b",:q2], ["a",:qR] ], #Estado de aceitacao
        qR: [ ] #Estado de rejeicao
      }
    accept_states = [:q2]

    automata = %{accept_states: accept_states,transitions: transitions, state: :q0}


    # CASOS DE TESTE
    input1 = "aaaaabbbbb"         # True
    input2 = "bbbbbaaaaa"         # FALSE
    input3 = "a"                  # FALSE
    input4 = "baaaabbbb"          # FALSE
    input5 = "aaabbbaaabbbb"      # FALSE

    parser = fn (inp) -> Automata.parse(inp) end

    result1 = Automata.automata_simulation(automata,parser.(input1))
    result2 = Automata.automata_simulation(automata,parser.(input2))
    result3 = Automata.automata_simulation(automata,parser.(input3))
    result4 = Automata.automata_simulation(automata,parser.(input4))
    result5 = Automata.automata_simulation(automata,parser.(input5))

    assert(result1==true)
    assert(result2==false)
    assert(result3==false)
    assert(result4==false)
    assert(result5==false)
  end

  test "test automata 4" do

    # Mais tabelas de transicao para serem testadas.

    # Aceita strings do tipo (0|1)*01, ou seja, uma sequencia de 0s e 1s que termina em 01.
    transitions =  %{
        q0: [ ["0",:q0], ["1",:q0], ["0",:q1] ], #Estado Inicial
        q1: [ ["1",:q2] ],
        q2: [ ] #Estado de aceitacao
      }
    accept_states = [:q2]

    automata = %{accept_states: accept_states,transitions: transitions, state: :q0}

    # CASOS DE TESTE
    input1 = "010100101110101"  # True
    input2 = "01"               # True
    input3 = "111110010"        # FALSE, termina em 10
    input4 = "00000011111"      # FALSE, termina em 11
    input5 = "11110000100"      # FALSE, termina em 00

    parser = fn (inp) -> Automata.parse(inp) end

    result1 = Automata.automata_simulation(automata,parser.(input1))
    result2 = Automata.automata_simulation(automata,parser.(input2))
    result3 = Automata.automata_simulation(automata,parser.(input3))
    result4 = Automata.automata_simulation(automata,parser.(input4))
    result5 = Automata.automata_simulation(automata,parser.(input5))

    assert(result1==true)
    assert(result2==true)
    assert(result3==false)
    assert(result4==false)
    assert(result5==false)
  end

  test "test automata 5" do

    # Mais tabelas de transicao para serem testadas.

    # Aceita strings do tipo (0|1)* 1100 (0|1)*, ou seja, uma sequencia de 0s e 1s que possuem 1100 como substring.
    transitions =  %{
        q0: [ ["0",:q0], ["1",:q0], ["1",:q1] ], #Estado Inicial
        q1: [ ["1",:q2] ],
        q2: [ ["0",:q3] ],
        q3: [ ["0",:q4] ],
        q4: [ ["0",:q4], ["1",:q4] ],
      }
    accept_states = [:q4]

    automata = %{accept_states: accept_states,transitions: transitions, state: :q0}

    # CASOS DE TESTE
    input1 = "0101001011100101"  # TRUE, 010100101(1100)101
    input2 = "01"                # FALSE
    input3 = "1111100110"        # TRUE, 111(1100)110
    input4 = "000000111110"      # FALSE
    input5 = "11110000100"       # TRUE, 11(1100)00100

    parser = fn (inp) -> Automata.parse(inp) end

    result1 = Automata.automata_simulation(automata,parser.(input1))
    result2 = Automata.automata_simulation(automata,parser.(input2))
    result3 = Automata.automata_simulation(automata,parser.(input3))
    result4 = Automata.automata_simulation(automata,parser.(input4))
    result5 = Automata.automata_simulation(automata,parser.(input5))

    assert(result1==true)
    assert(result2==false)
    assert(result3==true)
    assert(result4==false)
    assert(result5==true)
  end


end
