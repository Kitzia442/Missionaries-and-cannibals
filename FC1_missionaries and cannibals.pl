% Define the initial state of the problem. The boat is initially on the left side of the river,
% and there are 3 missionaries and 3 cannibals on that side.
initial(estado(3,3,1)).

% Define the goal state of the problem. All missionaries and cannibals are on the right side of the river.
goal(estado(0,0,0)).

% A state is dangerous if there are more cannibals than missionaries on either side of the river.
danger(estado(NM,NC,_)) :- (NM < NC), (NM =\= 0).  % If there are more cannibals than missionaries on the left side.
danger(estado(NM,NC,_)) :- (NM > NC), (NM =\= 3).  % If there are more cannibals than missionaries on the right side.

% Each movement indicates how to change from one state to another.
% Movements are included to move missionaries and cannibals to the left or right side of the river,
% considering the constraints of the problem.

% Movements for one missionary to the right, one missionary to the left, one cannibal to the right, and one cannibal to the left.
% Additionally, there are movements for two missionaries and two cannibals.
% Movements for one missionary and one cannibal together in the boat are also included.
movement(estado(NM,NC,1),estado(NNM,NC,0),oneMissionaryRight):- NNM is NM - 1, \+ danger(estado(NNM,NC,0)), NM > 0.
movement(estado(NM,NC,0),estado(NNM,NC,1),oneMissionaryLeft):- NNM is NM + 1, \+ danger(estado(NNM,NC,1)), NM < 3.
movement(estado(NM,NC,1),estado(NM,NNC,0),oneCannibalRight):- NNC is NC - 1, \+ danger(estado(NM,NNC,0)), NC > 0.
movement(estado(NM,NC,0),estado(NM,NNC,1),oneCannibalLeft):- NNC is NC + 1, \+ danger(estado(NM,NNC,1)), NC < 3.
movement(estado(NM,NC,1),estado(NNM,NC,0),twoMissionariesRight):- NNM is NM - 2, \+ danger(estado(NNM,NC,0)), NM > 1.
movement(estado(NM,NC,0),estado(NNM,NC,1),twoMissionariesLeft):- NNM is NM + 2, \+ danger(estado(NNM,NC,1)), NM < 2.
movement(estado(NM,NC,1),estado(NM,NNC,0),twoCannibalsRight):- NNC is NC - 2, \+ danger(estado(NM,NNC,1)), NC > 1.
movement(estado(NM,NC,0),estado(NM,NNC,1),twoCannibalsLeft):- NNC is NC + 2, \+ danger(estado(NM,NNC,1)), NC < 2.
movement(estado(NM,NC,0),estado(NNM,NNC,1),oneMissionaryOneCannibalLeft):- NNM is NM + 1, NNC is NC + 1, \+ danger(estado(NNM,NNC,1)), NM < 3, NC < 3.
movement(estado(NM,NC,1),estado(NNM,NNC,0),oneMissionaryOneCannibalRight):- NNM is NM - 1, NNC is NC - 1, \+ danger(estado(NNM,NNC,0)), NM > 0, NC > 0.

% Recursion: Here, the predicate is defined to determine if a final state can be reached from an initial state,
% avoiding dangerous states and avoiding cycles.
can(State, State,_, []).

can(StateX,StateY,Visited, [Operator|Operators]) :- 
    movement(StateX, Statei, Operator),  % Attempt to apply a movement from the current state.
    \+ member(Statei, Visited),  % Verify that the new state has not been visited previously.
    can(Statei,StateY, [Statei|Visited], Operators).  % Continue the search from the new state.

% Find a sequence of movements that leads from the initial state to the goal state.
query :- 
    initial(InitialState),  % Initial state.
    goal(GoalState),  % Goal state.
    can(InitialState, GoalState, [InitialState], Path),  % Find a solution avoiding previously visited states.
    write('SOLUTION FOUND without repetition of states: '), nl, write(Path).  % Print the found solution.
