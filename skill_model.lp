
% #program skill_model.
skill(NAME) :- complex(NAME).
characteristic(NAME,VALUE) :- characteristic(NAME,VALUE,VALUE_TYPE).
primitive(NAME) :- characteristic(NAME,VALUE).
primitive(NAME) :- capacity(NAME).

skill(NAME) :- primitive(NAME).
complex(NAME) :- action(NAME,INPUT,OUTPUT).
complex(NAME) :- perseption(NAME,OUTPUT).
complex(NAME) :- behaviour(NAME,PRE,RUNTIME,POST,CALL_GRAPH).

% scenario
% #program unit.
unit(uav).

action(storeData,array(string),string).
action(loadData,array(string),string).
action(runBehaviour,array(string),string).

perseption(camera_view,array(int)).
behaviour(run_as_edge,"","","","").

characteristic(cpu,4,integer).
characteristic(capacity,20,integer).

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
require(runAsEdge,cpu,5,integer).
require(TASK,NAME) :- require(TASK,NAME,VALUE,VALUE_TYPE).
require(runAsEdge,capacity).
provide(runAsEdge,isNavigatorService).

% Matching rules
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), not has(UNIT, SKILL).

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), require(TASK, SKILL,VALUE,string), characteristic(SKILL,VALUE,string).
missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), require(TASK, SKILL,VALUE_1,integer), characteristic(SKILL,VALUE_2,integer), VALUE_1 > VALUE_2.

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), require(TASK, SKILL,INPUT,OUTPUT), action(SKILL,INPUT,OUTPUT).

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL), require(TASK, SKILL,OUTPUT), perseption(SKILL,OUTPUT).

missing(SKILL) :- task(TASK), require(TASK, SKILL), unit(UNIT), has(UNIT, SKILL),  require(TASK,SKILL,PRE,RUNTIME,POST,CALL_GRAPH), behaviour(SKILL,PRE,RUNTIME,POST,CALL_GRAPH).

#show missing/1.


% composite(N) :- N=1..40000 , I=2..N-1 , N\I=0.
% % achieved : composite ( N ) iff N is a composite number
% % from {1 ,... , n }.
% prime(N) :- N=2..40000, not composite(N).
% % achieved : prime ( N ) iff N is a prime number
% % from {1 ,... , n }.

% #show prime/1.