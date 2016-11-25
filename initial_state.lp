%Initial State
holds(at(pioneer, 0, 0, 1), 0).
%obs(blocked(X, Y),false,0):-xpos(X),ypos(Y),xory(X,Y).
%xory(X,Y):-xpos(X), ypos(Y).
%xory(X, Y):- xpos(X), ypos(Y),
%	 X==0,Y!=0
%	;Y==0,X!=0
%	;X!=0, Y!=0.
obs(blocked(X, Y),false,0):-xpos(X),ypos(Y).



