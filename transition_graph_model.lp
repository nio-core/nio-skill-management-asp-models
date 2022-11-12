#const n = 5.
step(0..n).

% #program unit_bahaviour_state_graph.
entry(start).
vertex(s0).
vertex(s1).
vertex(s2).
vertex(s3).
vertex(s4).
vertex(s5).
edge(s0, s1).
edge(s1, s2).
edge(s2, s3).
edge(s3, s4).
edge(s4, s5).

-fluent(NAME,0) :- vertex(NAME).
state(s0,0).
state(TARGET,I+1) :- edge(SOURCE,TARGET), state(SOURCE,I), step(I). 

state(s0, -fluent(NAME), 0) :- -fluent(NAME,0).
state(TARGET, fluent(SOURCE),I+1) :- edge(SOURCE,TARGET), state(SOURCE,I), state(TARGET,I+1), step(I).
state(TARGET, fluent(NAME),I+1) :- edge(SOURCE,TARGET), state(SOURCE,I),state(SOURCE, fluent(NAME),I), state(TARGET,I+1), step(I).
state(TARGET, -fluent(NAME),I) :- not state(TARGET, fluent(NAME),I), state(TARGET,I), -fluent(NAME,0), step(I).


% occurs(s0,0).
% occurs(s1, 1).
% occurs(s2, 2).
% state(NAME) :- entry(NAME).

% % fluent(NAME,0) :- entry(NAME).
% -fluent(NAME,0) :- state(NAME).
% fluent(inertial, NAME) :- state(NAME), not startstate(NAME).

% fluent(NAME,I + 1) :- fluent(NAME,I), occurs(NAME, I), I < n.

% action(NAME) :- state(NAME).

% holds(NAME,0) :- fluent(NAME,0).
% -holds(NAME,0) :- fluent(inertial, NAME), not fluent(NAME,0).

% % holds(NAME,I+1) :-   fluent(inertial, NAME),   holds(NAME ,I),  not -holds(NAME,I+1), step(I).
% % -holds(NAME,I+1) :-  fluent(inertial, NAME),  -holds(NAME ,I),  not  holds(NAME,I+1), step(I).

% occurs(NAME) :- state(NAME). 
% % -occurs(NAME,I) :- not occurs(NAME,I), step(I).
% % -occurs(NAME,I) :- not occurs(NAME,I), action(NAME), step(I).

% #show holds/2.
% #show -holds/2.
% #show fluent/2.
% #show -fluent/2.
% #show occurs/2.
% #show -occurs/2.
% #show action/1.
% #show state/2.
#show state/3.

% #program unit_bahaviour_state_graph.
% _n_startstate(start).
% _n_state(s4).
% _n_state(s2).
% _n_state(s3).
% _n_transition(start, s4).
% _n_transition(s4, s3).
% _n_transition(s3, s2).
% _n_state(NAME):- _n_startstate(NAME).
% _n_fluent(NAME,0):- _n_startstate(NAME).
% _n_fluent(inertial, NAME):- _n_state(NAME), not _n_startstate(NAME).
% _n_action(NAME):- state(NAME).

% #program transition_diagram_graph_gen.

% #program change_pattern.
% removeF(F) :- fluent(inertial,F), not _n_fluent(inertial,F).
% addF(F) :- not fluent(inertial,F), _n_fluent(inertial,F).
% removeA(A) :- action(A), not _n_action(A).
% addA(A) :- not action(A), _n_action(A).

% unchangedF(F) :- not addF(F), not removeF(F), fluent(inertial, F).
% unchangedA(A) :- not addA(A), not removeA(A), action(A).

% rename(A, B) :- removeA(A), addA(B), action(A), _n_action(B),
%                 occurs(A,X), _n_occurs(B,X), step(X),
%                 action(C), occurs(C, X-1), _n_occurs(C, X-1), A != C, B != C,
%                 action(D), occurs(D, X+1), _n_occurs(D, X+1), A != D, B != D.

% edge(A, B)   :- fluent(inertial,A), fluent(inertial,B), step(T),
%                 holds(A,T), -holds(B,T), holds(A,T+1), holds(B,T+1),
%                 -holds(A,T-1), -holds(B,T-1).

% #script (lua)

% clingo = require("clingo")

% function main(prg)
%     prg.configuration.solve.models = 0
%     prg.enable_enumeration_assumption = true

%     prg:ground({{"unit_bahaviour_state_graph",{}}})
%     prg:ground({{"transition_diagram_graph_gen",{}}})
%     prg:ground({{"change_pattern",{}}})
    
%     local it = prg:solve{yield=true}
%     local ret, err = pcall(function()
%         for m in it:iter() do
%             print("=========================================================================")
%             print("Answer(holds):")
%             for _, elem in pairs(m:symbols{shown=true}) do
%                 if tostring(elem):match "holds" then
%                     print(elem)
%                 end
%             end
%             print("Answer(occurs):")
%             for _, elem in pairs(m:symbols{shown=true}) do
%                 if tostring(elem):match "occurs" then
%                     print(elem)
%                 end
%             end
%             print("Answer(add):")
%             for _, elem in pairs(m:symbols{shown=true}) do
%                 if tostring(elem):match "add" then
%                     print(elem)
%                 end
%             end
%             print("Answer(remove):")
%             for _, elem in pairs(m:symbols{shown=true}) do
%                 if tostring(elem):match "remove" then
%                     print(elem)
%                 end
%             end
%         end
%        local res = it:get()
%        print("=========================================================================")
%        print (res)
%     end)
%     it:close()
% end

% #end.


