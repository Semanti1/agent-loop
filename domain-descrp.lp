%Define the types, should parameterize like step..
robot(pioneer). xpos(0). xpos(1). xpos(2). xpos(3). ypos(0). ypos(1). ypos(2). ypos(3).
dir(0). dir(1). dir(2). dir(3).

%Define the steps 
#const n=curr_step+50 .
step(0..n).
%#const curr_step=0. 


%Define the fluents
fluent(inertial, at(ROBOT, POSX, POSY, DIR)) :- robot(ROBOT), xpos(POSX), ypos(POSY), dir(DIR).
fluent(inertial, blocked(POSX, POSY)) :- xpos(POSX), ypos(POSY).
fluent(inertial, uneqx(X1,X2)):- xpos(X1),xpos(X2).
fluent(inertial, uneqy(Y1,Y2)):- ypos(Y1),ypos(Y2).
fluent(inertial, uneqd(D1,D2)):- dir(D1),dir(D2).
%fluent(inertial, expl(A,I)):- action(exogenous,A), step(I).

%Define the Action
%action(moveTo(FARMER, ITEM, POS)) :- farmer(FARMER), item(ITEM), pos(POS).
action(agent,rotateRight(ROBOT)) :- robot(ROBOT) .
action(agent,rotateLeft(ROBOT)) :- robot(ROBOT).
action(agent,moveForward(ROBOT)) :- robot(ROBOT).

%#domain action(A).
%action(T,rotateRight(ROBOT)):-action(T,rotateRight(ROBOT)),actionType(agent).
%action(T,rotateLeft(ROBOT)):-action(T,rotateLeft(ROBOT)),actionType(agent).
%action(T,moveForward(ROBOT)):-action(T,moveForward(ROBOT)),actionType(agent).


%action ( dropped(X,Y) ) :- action ( exogenous , dropped(X,Y) ).
% diff between agent nd exo
action (exogenous, dropped(X,Y) ) :- xpos(X), ypos(Y).
%action (T, dropped(X,Y) ) :- action ( T , dropped(X,Y) ),actionType(exogenous) .

%Encode the causal laws

holds(at(ROBOT, X, Y, 0), S+1) :- occurs(rotateRight(ROBOT), S), holds(at(ROBOT, X, Y, 3), S), robot(ROBOT), xpos(X), ypos(Y).
holds(at(ROBOT, X, Y, 1), S+1) :- occurs(rotateRight(ROBOT), S), holds(at(ROBOT, X, Y, 0), S), robot(ROBOT), xpos(X), ypos(Y).
holds(at(ROBOT, X, Y, 2), S+1) :- occurs(rotateRight(ROBOT), S), holds(at(ROBOT, X, Y, 1), S), robot(ROBOT), xpos(X), ypos(Y).
holds(at(ROBOT, X, Y, 3), S+1) :-  occurs(rotateRight(ROBOT), S), holds(at(ROBOT, X, Y, 2), S), robot(ROBOT), xpos(X), ypos(Y).

holds(at(ROBOT, X, Y, 0), S+1) :- occurs(rotateLeft(ROBOT), S), holds(at(ROBOT, X, Y, 1), S), robot(ROBOT), xpos(X), ypos(Y).
holds(at(ROBOT, X, Y, 1), S+1) :- occurs(rotateLeft(ROBOT), S), holds(at(ROBOT, X, Y, 2), S), robot(ROBOT), xpos(X), ypos(Y).
holds(at(ROBOT, X, Y, 2), S+1) :- occurs(rotateLeft(ROBOT), S), holds(at(ROBOT, X, Y, 3), S), robot(ROBOT), xpos(X), ypos(Y).
holds(at(ROBOT, X, Y, 3), S+1) :- occurs(rotateLeft(ROBOT), S), holds(at(ROBOT, X, Y, 0), S), robot(ROBOT), xpos(X), ypos(Y).

holds(at(ROBOT, X-1, Y, 0), S+1) :- occurs(moveForward(ROBOT), S),  holds(at(ROBOT, X, Y, 0), S), not holds(blocked(X-1, Y), S), robot(ROBOT), xpos(X), ypos(Y), step(S). 
holds(at(ROBOT, X, Y+1, 1), S+1) :- occurs(moveForward(ROBOT), S),  holds(at(ROBOT, X, Y, 1), S), not holds(blocked(X, Y+1), S), robot(ROBOT), xpos(X), ypos(Y), step(S).  
holds(at(ROBOT, X+1, Y, 2), S+1) :- occurs(moveForward(ROBOT), S),  holds(at(ROBOT, X, Y, 2), S), not holds(blocked(X+1, Y), S), robot(ROBOT), xpos(X), ypos(Y), step(S).  
holds(at(ROBOT, X, Y-1, 3), S+1) :- occurs(moveForward(ROBOT), S),  holds(at(ROBOT, X, Y, 3), S), not holds(blocked(X, Y-1), S), robot(ROBOT), xpos(X), ypos(Y), step(S).  
-
holds(uneqx(X1,X2), S+1) :- occurs(A,S),xpos(X1),xpos(X2),X1!=X2, step(S).
holds(uneqy(Y1,Y2), S+1) :- occurs(A,S), ypos(Y1),ypos(Y2),Y1!=Y2, step(S).
holds(uneqd(D1,D2), S+1) :- occurs(A,S), dir(D1), dir(D2), D1!=D2, step(S).
%observations
%holds(blocked(X, Y), S+1) :- obs(blocked(X, Y), true, S), step(S) .
%holds(blocked(X, Y), S) :- holds(at(ROBOT, X, Y, D), S), step(S), robot(ROBOT), xpos(X), ypos(Y), dir(D). 
%holds(blocked(X,Y), S) :- occurs(dropped(X,Y),S),holds(at(ROBOT, A, B, D), S),robot(ROBOT), xpos(X), ypos(Y), dir(D), xpos(A), ypos(B), step(S), holds(uneqx(X,A),S), holds(uneqy(Y,B),S), X!=0.
 
%holds(blocked(X,Y), S) :- occurs(dropped(X,Y),S),holds(at(ROBOT, A, B, D), S),robot(ROBOT), xpos(X), ypos(Y), dir(D), xpos(A), ypos(B), step(S), holds(uneqx(X,A),S),-holds(uneqy(Y,B),S).

%holds(blocked(X,Y), S) :- occurs(dropped(X,Y),S),holds(at(ROBOT, A, B, D), S),robot(ROBOT), xpos(X), ypos(Y), dir(D), xpos(A), ypos(B), step(S), -holds(uneqx(X,A),S), holds(uneqy(Y,B),S). 

%holds(blocked(X,Y), S) :- occurs(dropped(X,Y),S),holds(at(ROBOT, A, B, D), S),robot(ROBOT), xpos(X), ypos(Y), dir(D), xpos(A), ypos(B), step(S), -holds(uneqx(X,A),S),-holds(uneqy(Y,B),S).                          
%not holds(blocked(X,Y), S),
      % occurs(dropped(X,Y),S-1):-obs(blocked(X, Y), true, S), step(S) .

holds(blocked(X,Y), S+1) :- occurs(dropped(X,Y),S),xpos(X), ypos(Y), step(S).
:- occurs(dropped(X,Y),S), holds(at(ROBOT, X, Y, D), S), xpos(X), ypos(Y), step(S), dir(D).
:- occurs(dropped(X,Y),S), holds(blocked(X,Y), S), xpos(X), ypos(Y), step(S).

% Encode inertia
holds(F, S+1) :- step(S), fluent(inertial, F), holds(F, S), not -holds(F, S+1).
-holds(F, S+1) :- step(S), fluent(inertial, F), -holds(F, S), not holds(F, S+1).

%Encode cwa for defined fluents, we don't have defined fluents but good practice
-holds(F, S) :- step(S), fluent(defined, F), not holds(F, S).

%% CWA for Actions :
-occurs(A, S ) :- not occurs(A, S ), action(A), step(S).

%% Full Awareness Axiom :
holds(F , 0) | -holds(F , 0) :- fluent(inertial , F) .

%% Take what actually happened into account :
occurs (A, S ) :- hpd (A, S ), step(S).
%occurs(dropped(X,Y),S+1):- -holds(blocked(X,Y),S), xpos(X), ypos(Y),step(S). 
%% Reality Check :
fluent(F) :- fluent(inertial,F).
fluent(F) :- fluent(defined,F).
 :- obs( F , true , S ) , -holds( F , S ), fluent(inertial , F).
 :- obs( F , false , S ) , holds( F , S ), fluent(inertial , F).


%-holds(at(ROBOT,X1, Y1, D),S) :- holds( at (ROBOT,X2, Y2, D),S), xpos(X1), ypos(Y1),xpos(X2), ypos(Y2),dir(D), robot(ROBOT),step(S),holds(uneqx(X1,X2),S),holds(uneqy(Y1,Y2),S).
%-holds(at(ROBOT,X1, Y1, D),S) :- holds( at (ROBOT,X2, Y2, D),S), xpos(X1), ypos(Y1),xpos(X2), ypos(Y2),dir(D), robot(ROBOT),step(S),holds(uneqx(X1,X2),S),-holds(uneqy(Y1,Y2),S).
%-holds(at(ROBOT,X1, Y1, D),S) :- holds( at (ROBOT,X2, Y2, D),S), xpos(X1), ypos(Y1),xpos(X2), ypos(Y2),dir(D), robot(ROBOT),step(S),-holds(uneqx(X1,X2),S),holds(uneqy(Y1,Y2),S).
%-holds(at(ROBOT,X1, Y1, D1),S):- holds( at (ROBOT,X2, Y2, D2),S), xpos(X1), ypos(Y1),xpos(X2), ypos(Y2),dir(D1),dir(D2), robot(ROBOT),step(S),-holds(uneqx(X1,X2),S),-holds(uneqy(Y1,Y2),S),holds(uneqd(D1,D2),S).

same_loc(X,Y,D,X,Y,D) :- xpos(X), ypos(Y), dir(D).
diff_loc(X1,Y1,D1,X2,Y2,D2) :- 
	xpos(X1), ypos(Y1), dir(D1),
	xpos(X2), ypos(Y2), dir(D2),
	not same_loc(X1,Y1,D1,X2,Y2,D2).
-holds(at(ROBOT,X1,Y1,D1),S) :-
	robot(ROBOT), step(S),
	xpos(X1), ypos(Y1), dir(D1),
	xpos(X2), ypos(Y2), dir(D2),
	holds(at(ROBOT,X2, Y2, D2),S),
	diff_loc(X1,Y1,D1,X2,Y2,D2).

%-holds(at(ROBOT, X, Y, 0), S) :- holds(blocked( X1, Y1), S), robot(ROBOT), xpos(X1), ypos(Y1),xpos(X), ypos(Y), step(S), holds(uneqx(X1,X),S),holds(uneqy(Y1,Y),S).
%-holds(at(ROBOT, X, Y, 1), S) :- holds(blocked( X2, Y2), S), robot(ROBOT), xpos(X2), ypos(Y2),xpos(X), ypos(Y), step(S), holds(uneqx(X2,X),S),holds(uneqy(Y2,Y),S).
%-holds(at(ROBOT, X, Y, 2), S) :- holds(blocked( X3, Y3), S), robot(ROBOT), xpos(X3), ypos(Y3),xpos(X), ypos(Y), step(S), holds(uneqx(X3,X),S),holds(uneqy(Y3,Y),S).
%-holds(at(ROBOT, X, Y, 3), S) :- holds(blocked( X4, Y4), S), robot(ROBOT), xpos(X4), ypos(Y4),xpos(X), ypos(Y), step(S), holds(uneqx(X4,X),S),holds(uneqy(Y4,Y),S).

-holds(at(ROBOT, X, Y,D ), S) :- holds(blocked( X, Y), S), robot(ROBOT), xpos(X), ypos(Y), step(S), dir(D).
-holds(blocked( X, Y), S)     :-holds(at(ROBOT, X, Y,D ), S). 
%-holds(at(ROBOT, X, Y,D ), S) :- holds(blocked( X1, Y1), S), robot(ROBOT), xpos(X1), ypos(Y1),xpos(X), ypos(Y), step(S), holds(uneqx(X1,X),S),-holds(uneqy(Y1,Y),S), dir(D).
%-holds(at(ROBOT, X, Y,D ), S) :- holds(blocked( X1, Y1), S), robot(ROBOT), xpos(X1), ypos(Y1),xpos(X), ypos(Y), step(S), -holds(uneqx(X1,X),S),holds(uneqy(Y1,Y),S), dir(D).
%-holds(at(ROBOT, X, Y,D1 ), S) :- holds(blocked( X1, Y1), S), robot(ROBOT), xpos(X1), ypos(Y1),xpos(X), ypos(Y), step(S), holds(uneqx(X1,X),S),holds(uneqy(Y1,Y),S), dir(D).
