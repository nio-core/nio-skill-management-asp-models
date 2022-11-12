
#program type_ontology.
listType(list).
type(list,index,primitveType).
type(list,index,listType).
primitveType(string).
primitveType(integer).
primitveType(float).
primitveType(boolean).

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
preCondition(run_as_edge,"").
runtimeCondition(run_as_edge,"").
postCondition(run_as_edge,"").
callGraph(run_as_edge,"").

characteristic(cpu).
value(cpu,4).
valueType(cpu,integer).

characteristic(capacity).
value(capacity,20).
valueType(capacity,integer).

characteristic(postion).
value(postion,"WH 1").
valueType(postion,string).

capacity(hasStorageAccess).

capacity(canStartBehaviour).

% relationships
has(uav,storeData).
has(uav,loadData).
has(uav,runBehaviour).

has(uav,cpu).
has(uav,capacity).
has(uav,postion).

has(uav,hasStorageAccess).
has(uav,canStartBehaviour).

has(uav,camera_view).
has(uav,run_as_edge).

link(hasStorageAccess, storeData). 
link(hasStorageAccess, loadData).
link(canStartBehaviour, runBehaviour).

% TEST
%capacity(runBehaviour).


#program task.
task(runAsEdge).
require(runAsEdge,canStartBehaviour).
require(runAsEdge,hasStorageAccess).

require(runAsEdge,cpu).
value(runAsEdge,cpu, 3).
valueType(runAsEdge,cpu,integer).

require(runAsEdge,capacity).
value(runAsEdge,capacity, 4).
valueType(runAsEdge,capacity,integer).

require(runAsEdge,postion).
value(runAsEdge,postion, "WH 1").
valueType(runAsEdge,postion,string).

provide(runAsEdge,isNavigatorService).

% TEST
%require(runAsEdge,test).

#program skill_model.
skill(NAME) :-     primitive(NAME),      not complex(NAME).
primitive(NAME) :- characteristic(NAME), not capacity(NAME).
primitive(NAME) :- capacity(NAME),       not characteristic(NAME).

skill(NAME) :-   complex(NAME),    not primitive(NAME).
complex(NAME) :- action(NAME),     not perseption(NAME),  not behaviour(NAME).
complex(NAME) :- perseption(NAME), not action(NAME),      not behaviour(NAME).
complex(NAME) :- behaviour(NAME),  not action(NAME),      not perseption(NAME).

characteristic(default).
capacity(default).
action(default).
perseption(default).
behaviour(default).

#program inconsistancy.
inconsistancy(capacity(NAME)) :- capacity(NAME), not skill(NAME), NAME != default.
inconsistancy(characteristic(NAME)) :- characteristic(NAME), not skill(NAME), NAME != default.
inconsistancy(action(NAME)) :- action(NAME), not skill(NAME), NAME != default.
inconsistancy(perseption(NAME)) :- perseption(NAME), not skill(NAME), NAME != default.
inconsistancy(behaviour(NAME)) :- behaviour(NAME), not skill(NAME), NAME != default.
%:- inconsistancy(NAME).

% Matching rules
#program matching_rules.
% capacity
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL).
% characteristic
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), value(TASK, SKILL, VALUE_1), valueType(TASK, SKILL,string), characteristic(SKILL), value(SKILL,VALUE_2), valueType(SKILL,string), VALUE_1 != VALUE_2.

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), value(TASK, SKILL, VALUE_1), valueType(TASK, SKILL, integer), characteristic(SKILL), value(SKILL,VALUE_2), valueType(SKILL,integer), VALUE_1 > VALUE_2.
% action
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL), parameter(TASK, SKILL ,INPUT), returnType(TASK, SKILL,OUTPUT), action(SKILL), parameter(SKILL,INPUT), returnType(SKILL,OUTPUT).
% perseption
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL), returnType(TASK, SKILL ,OUTPUT), perseption(SKILL), returnType(SKILL,OUTPUT).
% behaviour
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL),  preCondition(TASK,SKILL,PRE), runtimeCondition(TASK,SKILL,RUNTIME), postCondition(TASK,SKILL,POST), callGraph(TASK,SKILL,CALL_GRAPH), 
                  behaviour(SKILL), preCondition(SKILL,PRE), runtimeCondition(SKILL,RUNTIME), postCondition(SKILL,POST), callGraph(SKILL,CALL_GRAPH).

matching_successful() :- not missing(_). 
matching_not_successful() :- missing(_). 
                   
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
    prg:ground({{"inconsistancy",{}}})
    -- prg:solve()
    prg:ground({{"matching_rules",{}}})
    -- prg:solve()
    local it = prg:solve{yield=true}
    local ret, err = pcall(function()
        for m in it:iter() do
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "unit" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "has" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "task" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "require" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "complex" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "primitive" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "missing" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "inconsistancy" then
                    print(elem)
                end
            end
            print("Answer:")
            for _, elem in pairs(m:symbols{shown=true}) do
                if tostring(elem):match "matching_" then
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
