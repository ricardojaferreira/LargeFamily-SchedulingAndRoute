/*
    1º Todos os filhos diferentes
    2º Todas as actividades diferentes
    3º Cada filho só pode ter uma actividade
    4º O filho só pode ir para a actividade se a idade for adequada
    5º Atribuir filho a actividade conforme preferência

    Actividades não podem começar ao mesmo tempo
    Tempo de inicio em actividades tem que ser igual ao anterior mais o
        tempo de deslocacao, com tolerancia de 5min

    Restrições da deslocação (Ir e Vir):

        (Começa em casa, a hora de saída será o inicio da primeira activida menos o tempo da deslocação menos dropOff).
        1º A actividade seguinte tem que começar depois da anterior mais o tempo de deslocação (+/- 5min opcional)
            + dropOffTime
        2º O tempo para a próxima vai depender do tempo actual.

        2º A primeira a acabar tem que acabar depois da última entrega mais o tempo de deslocação (+5min opcional)
        3º A actividade a acabar seguinte tem que acabar depois da anterior mais o tempo de deslocação (+5min opcional)

        5º A última posição é a casa


*/
:-include('utils/includes.pl').

%ageAndPreferenceRestrictions(_Children,_Activities)
%   _Children: A list with all the Children
%   _Activities: A list with the activities available
%
%   This function adds the restrictions for the minimum age and tries to
%   pair activities with the preference of each sun. This function assumes
%   that the number of children and activities is the same.
%

routeRestrictionsOld([Child|T],Children,Activities):-
        write('.......EnteringRoute.....'),nl,
        write('Children: '),write(Children),nl,
        write('Activities: '),write(Activities),nl,
    element(Position,Children,Child),
    element(Position,Activities,Activity),
    horaInicio(Activity,StartTime),
    dropOffTime(DropOffTime),
    sumMinToTime(StartTime,DropOffTime,NextRouteStartTime),
    routeRestrictions(T,NextRouteStartTime,Activity,Children,Activities).

routeRestrictions([],_,_,_,_). %O tempo de chegada da última tem que respeitar o intervalo
routeRestrictions([Child|T],RouteStartTime,PrevActivity,Children,Activities):-
        write('.......IteractionRoute.....'),nl,
    marginTime(Margin),
    dropOffTime(DropOffTime),
    element(Position,Children,Child),
    element(Position,Activities,Activity),
        write('Child is: '),write(Child),write(' - '),
        write('Activity is: '),write(Activity),nl,
    horaInicio(Activity,StartActivity),
        write('Route Start Time is: '),write(RouteStartTime),write('-'),
        write('Next Activity Starts at: '),write(StartActivity),nl,
    %
    tempoCarro(PrevActivity,Activity,T), %A base de dados liga actividades mas terá que ligar locais
    sumMinToTime(RouteStartTime,T,ArrivalTime),
    sumMinToTime(StartActivity,Margin,TMoreMargin),
    subtractMinToTime(StartActivity,Margin,TLessMargin),
%    sumMinToTime(StartActivity,Margin,StartActMoreMargin),
%    subtractMinToTime(StartActivity,Margin,StartActLessMargin),
        write('Arrival Time: '),write(ArrivalTime),write('-'),
        write('More Margin: '),write(TMoreMargin),write('-'),
        write('Less Margin: '),write(ArrivalTime),nl,
%    (StartActivity #= ArrivalTime) #\/ (StartActMoreMargin #= TMoreMargin) #\/ (StartActLessMargin #= TLessMargin),
%    getNextStartTime(A,B,C,TChegada,TMoreMargin,TLessMargin,NextStartTime),


    (StartActivity #>= TLessMargin) #/\ (StartActivity #=< TMoreMargin),
    sumMinToTime(ArrivalTime,DropOffTime,NextStartTime),
        write('Next Start Time: '),write(NextStartTime),write('---------'),nl,
    routeRestrictions(T,NextStartTime,Activity,Children,Activities).

%%%%%%%%%%%%%%%%%%%

ageAndPreferenceRestrictions([],_,_,_).
ageAndPreferenceRestrictions([A|T],Activities,Ages,MinAges):-
    element(P,Activities,A),
    element(P,Ages,A1),
    element(P,MinAges,M1),
    A1 #>= M1,
    ageAndPreferenceRestrictions(T,Activities,Ages,MinAges).

%%%%%%%%%%%%%%%%%%%%%

evaluatePreferences(_,[],_Pref).
evaluatePreferences([C,A],[[Cid,Aid,Weight]|T],Pref):-
    (C#=Cid #/\ A#=Aid) #=> (Pref #= Weight),
    evaluatePreferences([C,A],T,Pref).

evaluatePreferences([],[],_,ListOfPreferences,ListOfPreferences).
evaluatePreferences([C|CR],[A|AR],Preferences,SumAux,ListOfPreferences):-
    evaluatePreferences([C,A],Preferences,Pref),
    append([Pref],SumAux,Aux),
    evaluatePreferences(CR,AR,Preferences,Aux,ListOfPreferences).

evaluatePreferences(Children,Activities,Preferences,ListOfPreferences):-
    evaluatePreferences(Children,Activities,Preferences,[],ListOfPreferences).


%Predicado para verificar se o número de filhos e de actividades é diferente
% Mais filhos do que actividades
% Mais actividade do que filhos
% Número de filhos e de actividades igual
getScheduleAndRoute:-
    %Prepare Variables
    findall(IdChildren,children(IdChildren,_Age),IdChildrenAux),
    findall(IdActividade,activity(IdActividade,_NameA),IdActivitiesAux),
    findall(Age,ageChildren(_,Age),AgeAux),
    findall(MinAge,activityMinimumAge(_,MinAge),MinAgeAux),
    findall([C,A,V],preference(C,A,V),Preferences),

    %%%Route
    findall(StartTime,startTime(_,StartTime),StartTimes),
    findall(Duration,duration(_,Duration),Durations),


    length(IdChildrenAux,NumberOfChildren),
    length(IdActivitiesAux,NumberOfActivities),
    %Generate Arrays of Variables for labeling
    length(Children,NumberOfChildren),
    length(Activities,NumberOfActivities),
    length(Ages,NumberOfChildren),
    length(MinAges,NumberOfActivities),
    %Route




    domain(Children,1,NumberOfChildren),
    domain(Activities,1,NumberOfActivities),
    getGlobalCardinalityDomain(AgeAux,AgeDomain),
    getGlobalCardinalityDomain(MinAgeAux,MinAgeDomain),
    global_cardinality(Ages,AgeDomain),
    global_cardinality(MinAges,MinAgeDomain),
    maxActivityWeight(Max),
    minActivityWeight(Min),
    SumResultMax is Max * NumberOfChildren,
    SumResultMin is Min * NumberOfChildren,
    SumResult in SumResultMin..SumResultMax,

    %%%Route
    Route

    all_distinct(Children),
    all_distinct(Activities),
    %All ages are diferent (evolve that?)
    all_distinct(Ages),
    all_distinct(MinAges),
    %Prepare Results
    linkIndexesAndValues(AgeAux,Children,Ages),
    linkIndexesAndValues(MinAgeAux,Activities,MinAges),
    ageAndPreferenceRestrictions(Children,Activities,Ages,MinAges),
    evaluatePreferences(Children,Activities,Preferences,ListOfPreferences),
    sumAirVariable(ListOfPreferences,SumResult),
    append(Children,Activities,CA),
%    append(CA,Ages,CAG),
%    append(CAG,MinAges,Vars),
    write('Vars Before: '),write(CA),nl,
    write('SumResult: '),write(SumResult),nl,
    labeling([maximize(SumResult)],[SumResult|CA]),
    write('Childs: '),write(Children),nl,
    write('Activities: '),write(Activities),nl,
    write('SumResult: '),write(SumResult),nl.
%    write('Ages: '),write(Ages),nl,
%    write('MinAges: '),write(MinAges).


%%%%%%%%%%%%%%%%%%%%%%%%%%

getScheduleAndRouteOld:-
    %generate Domains
    findall(IdChildren,children(IdChildren,_NameC,_Age),RChildren), %Get all childrens (useful to escalate)
    findall(IdActividade,actividade(IdActividade,_NameA),RActivities), %Get all activities (useful to escalate)
        write('Childrens: '),write(RChildren),nl,
        write('Activities: '),write(RActivities),nl,
        read(_),
    %Generate Array of Children Id's
    length(RChildren,NumberOfChildren), %same_length
    length(Children,NumberOfChildren),
    %Generate Array of Activities Id's
    length(RActivities,NumberOfActivities),
    length(Activities,NumberOfActivities),
    %Generate Array of Routes
    NumberOfNodes is NumberOfChildren*2, %DropOff and PickUp for each child
    length(GoActivities,NumberOfNodes),

    findall(Age,ageChildren(_,Age),A),
    same_length(Ages,A),
    ageDomain(Ages,A),
        write('Instance Ages: '),write(A),nl,
        write('No Instance Ages: '),write(Ages),nl,
        read(_),
    findall(MinAge,activityMinimumAge(_,MinAge),M),
    same_length(MinAges,M),
    ageDomain(MinAges,M),
       write('Instance MinAges: '),write(M),nl,
       write('No Instance MinAges: '),write(MinAges),nl,
       read(_),
    all_distinct(Ages),
    all_distinct(MinAges),
    %Domains
    domain(Children,1,NumberOfChildren),
    domain(Activities,1,NumberOfActivities),
    domain(GoActivities,0,NumberOfChildren),
    all_distinct(Children),
    all_distinct(Activities), %pode haver mais do que um filho na mesma actividade
    %restrictions 4 and 5
        write('Childrens: '),write(Children),nl,
        write('Activities: '),write(Activities),nl,
        read(_),
    ageAndPreferenceRestrictions(Children,Activities,Preference),
%    routeRestrictions(GoActivities,Children,Activities),

    append(Children,Activities,Aux),
    append(Aux,GoActivities,MyVars),
    write(MyVars),nl,
    labeling([maximize(Preference)],MyVars),
    write('Children: '),write(Children),nl,
    write('Weight: '),write(Preference),nl,
    write('Activities: '),write(Activities),nl,
    write('Go Route: '),write(GoActivities),nl.