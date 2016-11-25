success :- goal(S), step(S), S < n.
:-not success. %Failure is not an option

%%Generate the actions

1{occurs(A,S): action(agent,A)}1 :- step(S), not goal(S), S < n, S>=curr_step.

#show occurs/2.

plen(L) :- L=#count { A,I: occurs(A,I),action(agent, A)}.
#minimize { L, plen: plen(L)}.


