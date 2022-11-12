
% state graph
% Transition diagram based on action language

% Fluent: stand for a status of each action. A negated fluent means that the action has not
%         been completed yet. The positive value states the opposite (obviously)

% Action: is atransition between two states

% State:  contains a list of all actions inside the State Graph. That means, that each state
%         knows which actions must've been completed before this one and which are yet to come.

#program state_graph.
%startstate(NAME).
%transition(STATE1, STATE2).
state(NAME):- startstate(NAME).
fluent(NAME):- state(NAME), not startstate(NAME).

#program unit_bahaviour_state_graph.
startstate(start).
state(s1).
state(s2).
transition(start, s1).
transition(s1, s2).

state(s3).
state(s4).
state(s5).
transition(s2, s3).
transition(s3, s4).
transition(s4, s3).
transition(s3, s5).
transition(s5, s3).

state(s6).
state(s7).
transition(s2, s6).
transition(s6, s7).
transition(s7, s6).

state(s8).
state(s9).
transition(s2, s8).
transition(s8, s9).
transition(s9, s8).


#program skill_model.
skill(NAME) :- complex(NAME).
characteristic(NAME,VALUE) :- characteristic(NAME,VALUE,VALUE_TYPE).
primitive(NAME) :- characteristic(NAME,VALUE).
primitive(NAME) :- capacity(NAME).

skill(NAME) :- primitive(NAME).
complex(NAME) :- action(NAME,INPUT,OUTPUT).
complex(NAME) :- perseption(NAME,OUTPUT).
complex(NAME) :- behaviour(NAME,PRE,RUNTIME,POST).
behaviour(NAME) :- state_graph(NAME,STATE_GRAPH).
behaviour(NAME) :- model(NAME,MODEL).

characteristic(default).
capacity(default).
action(default).
perseption(default).
behaviour(default).

% scenario
#program type_ontology.
listType(list).
type(list,index,primitveType).
type(list,index,listType).
primitveType(string).
primitveType(integer).
primitveType(float).
primitveType(boolean).

#program unit.
unit(skillUnit1).

capacity(canPlayStandardChess).
behaviour(playStandardChess).
has(skillUnit1,playStandardChess).
link(canPlayStandardChess,playStandardChess).

characteristic(languageSupport).
value(languageSupport,"C++").
valueType(languageSupport,string).
has(skillUnit1,languageSupport).

% unit(skillUnit2).
% behaviour(playChineseChess).
% value(languageSupport,"C++").
% valueType(languageSupport,string).

% unit(skillUnit3).
% behaviour(playCheckers).
% value(languageSupport,"C++").
% valueType(languageSupport,string).

#program task.
task(player1).
require(player1,canPlayStandardChess).
require(player1,languageSupport).
value(player1,languageSupport,"C++").
valueType(player1,languageSupport,string).


% scenario
#program unit.

unit(uav).

action(storeData).
parameter(storeData,list).
returnType(storeData,string).

action(loadData).
parameter(loadData,list).
returnType(loadData,string).

action(runBehaviour).
parameter(runBehaviour,list).
returnType(runBehaviour,integer).

perseption(camera_view).
returnType(camera_view,list).

behaviour(run_as_edge).
% preCondition(run_as_edge,"").
% runtimeCondition(run_as_edge,"").
% postCondition(run_as_edge,"").
% callGraph(run_as_edge,"").

characteristic(cpu).
value(cpu,4).
valueType(cpu,integer).

characteristic(capacity).
value(capacity,20).
valueType(capacity,integer).

capacity(hasStorageAccess).

% capacity(canStartBehaviour).

% relationships
has(uav,storeData).
has(uav,loadData).
has(uav,runBehaviour).

has(uav,cpu).
has(uav,capacity).

has(uav,hasStorageAccess).
% has(uav,canStartBehaviour).

has(uav,camera_view).
has(uav,run_as_edge).

link(hasStorageAccess, storeData). 
link(hasStorageAccess, loadData).
% link(canStartBehaviour, runBehaviour).

#program task.
task(runAsEdge).
require(runAsEdge,canStartBehaviour).
require(runAsEdge,hasStorageAccess).

require(runAsEdge,cpu).
value(runAsEdge,cpu, 5).
valueType(runAsEdge,cpu,integer).

require(runAsEdge,capacity).
value(runAsEdge,capacity, 25).
valueType(runAsEdge,capacity,integer).

require(runAsEdge,postion).
value(runAsEdge,postion, "WH 1").
valueType(runAsEdge,postion,string).

provide(runAsEdge,isNavigatorService).

% Matching rules
#program matching_rules.
% capacity
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL).
% characteristic
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL), value(TASK, SKILL, VALUE), valueType(TASK, SKILL,string), characteristic(SKILL), value(SKILL,VALUE), valueType(SKILL,string).
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), value(TASK, SKILL, VALUE_1), valueType(TASK, SKILL, integer), characteristic(SKILL), value(SKILL,VALUE_2), valueType(SKILL,integer), VALUE_1 > VALUE_2.
% action
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL), parameter(TASK, SKILL ,INPUT), returnType(TASK, SKILL,OUTPUT), action(SKILL), parameter(SKILL,INPUT), returnType(SKILL,OUTPUT).
% perseption
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL), returnType(TASK, SKILL ,OUTPUT), perseption(SKILL), returnType(SKILL,OUTPUT).
% behaviour
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL),  preCondition(TASK,SKILL,PRE), runtimeCondition(TASK,SKILL,RUNTIME), postCondition(TASK,SKILL,POST), callGraph(TASK,SKILL,CALL_GRAPH), 
                  behaviour(SKILL), preCondition(SKILL,PRE), runtimeCondition(SKILL,RUNTIME), postCondition(SKILL,POST), callGraph(SKILL,CALL_GRAPH).

% missing(SKILL,SKILTYPE) :- 
                   
preCondition(default,default). 
runtimeCondition(default,default). 
postCondition(default,default). 
callGraph(default,default).
parameter(default,default). 
returnType(default,default).

preCondition(default,default,default). 
runtimeCondition(default,default,default). 
postCondition(default,default,default). 
callGraph(default,default,default).
parameter(default,default,default). 
returnType(default,default,default).

#script (lua)

clingo = require("clingo")

function main(prg)
    prg.configuration.solve.models = 0
    prg.enable_enumeration_assumption = true
    prg:ground({{"unit",{}}})
    prg:ground({{"task",{}}})
    prg:ground({{"skill_model",{}}})
    prg:ground({{"type_ontology",{}}})
    -- prg:solve()
    prg:ground({{"matching_rules",{}}})
    -- prg:solve()
    prg:ground({{"unit_bahaviour_state_graph",{}}})
    prg:ground({{"state_graph",{}}})
    
    local it = prg:solve{yield=true}
    local ret, err = pcall(function()
        for m in it:iter() do
            print("Answer(unit):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "unit" then
                    print(elem)
                end
            end
            print("Answer(has):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "has" then
                    print(elem)
                end
            end
            print("Answer(task):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "task" then
                    print(elem)
                end
            end
            print("Answer(require):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "require" then
                    print(elem)
                end
            end
            print("Answer(complex):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "complex" then
                    print(elem)
                end
            end
            print("Answer(primitive):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "primitive" then
                    print(elem)
                end
            end
            print("Answer(missing):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "missing" then
                    print(elem)
                end
            end
            print("Answer(state):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "state" then
                    print(elem)
                end
            end
            print("Answer(transition):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "transition" then
                    print(elem)
                end
            end
            print("Answer(fluent):")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "fluent" then
                    print(elem)
                end
            end
        end
       local res = it:get()
       print (res)
    end)
    it:close()
end

#end.

% #show missing/1.
% #show skill/1.
% #show primitive/1.
% #show complex/1.