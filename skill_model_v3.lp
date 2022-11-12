
% #program skill_model.
skill(NAME) :- complex(NAME).
primitive(NAME) :- characteristic(NAME).
primitive(NAME) :- capacity(NAME).

skill(NAME) :- primitive(NAME).
complex(NAME) :- action(NAME).
complex(NAME) :- perseption(NAME).
complex(NAME) :- behaviour(NAME).

complex(default).
characteristic(default).
capacity(default).
primitive(default).
action(default).
perseption(default).
behaviour(default).

% scenario
% #program unit.
unit(uav).

action(storeData).
parameter(storeData,array(string)).
returnType(storeData,string).

action(loadData).
parameter(loadData,array(string)).
returnType(loadData,string).

action(runBehaviour).
parameter(runBehaviour,array(string)).
returnType(runBehaviour,integer).

perseption(camera_view).
returnType(camera_view,array(int)).

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
valueType(cpu,integer).

capacity(hasStorageAccess).

capacity(canStartBehaviour).

% relationships
has(uav,storeData).
has(uav,loadData).
has(uav,runBehaviour).

has(uav,cpu).
has(uav,capacity).

has(uav,hasStorageAccess).
has(uav,canStartBehaviour).

has(uav,camera_view).
has(uav,run_as_edge).

link(hasStorageAccess, storeData). 
link(hasStorageAccess, loadData).
link(canStartBehaviour, runBehaviour).

% #program task.
task(runAsEdge).
require(runAsEdge,canStartBehaviour).
require(runAsEdge,hasStorageAccess).
require(runAsEdge,cpu).
value(runAsEdge,cpu,5).
valueType(runAsEdge,cpu,integer).
require(runAsEdge,capacity).
provide(runAsEdge,isNavigatorService).

% Matching rules
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL).

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), value(TASK, SKILL, VALUE), valueType(TASK, SKILL,string), characteristic(SKILL), value(SKILL,VALUE), valueType(SKILL,string).

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), value(TASK, SKILL, VALUE_1), valueType(TASK, SKILL,string), characteristic(SKILL), value(SKILL,VALUE_2), valueType(SKILL,integer), VALUE_1 > VALUE_2.

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), parameter(TASK, SKILL ,INPUT), returnType(TASK, SKILL ,OUTPUT), action(SKILL), parameter(SKILL,INPUT), returnType(SKILL,OUTPUT).

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), returnType(TASK, SKILL ,OUTPUT), perseption(SKILL), returnType(SKILL,OUTPUT).

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL),  preCondition(TASK,SKILL,PRE), runtimeCondition(TASK,SKILL,RUNTIME), postCondition(TASK,SKILL,POST), callGraph(TASK,SKILL,CALL_GRAPH), 
                   behaviour(SKILL), preCondition(SKILL,PRE), runtimeCondition(SKILL,RUNTIME), postCondition(SKILL,POST), callGraph(SKILL,CALL_GRAPH).
                   
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
parameter(default, default ,default). 
returnType(default, default ,default).

#show missing/1.