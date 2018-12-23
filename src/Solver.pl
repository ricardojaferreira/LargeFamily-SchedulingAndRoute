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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getWalkingPaths([],WalkingPaths,_,WalkingPaths).
getWalkingPaths([[A,B,T]|R],Aux,WalkingTime,WalkingPaths):-
    T =< WalkingTime,
    append([[A,B]],Aux,Aux1),
    getWalkingPaths(R,Aux1,WalkingTime,WalkingPaths).

getWalkingPaths([[_,_,_]|R],Aux,WalkingTime,WalkingPaths):-
    getWalkingPaths(R,Aux,WalkingTime,WalkingPaths).

getWalkingPaths(WalkingTime,WalkingPaths):-
    findall([A,B,Time],travelByFoot(A,B,Time),FootPaths),
    getWalkingPaths(FootPaths,[],WalkingTime,WalkingPaths).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getPathTimes(_,_,[],_TravelTime).
getPathTimes(PosA,PosB,[[A,B,Time]|T],TravelTime):-
    (PosA#=A #/\ PosB#=B) #=> (TravelTime #= Time),
    getPathTimes(PosA,PosB,T,TravelTime).

getFootTravelTimes(PosA,PosB,TravelTime):-
    findall([A,B,Time],travelByFoot(A,B,Time),FootPaths),
    getPathTimes(PosA,PosB,FootPaths,TravelTime).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%getChildrenThatCanWalk([],_,_,_,_).
%getChildrenThatCanWalk([A|T],Children,Ages,WalkingAge,ChildrenCanWalk):-
%    element(Pos,Children,A),
%    element(Pos,Ages,Age),
%    (Age#>=WalkingAge) #<=> B,
%    Value #= B*A,
%    element(Pos,ChildrenCanWalk,Value),
%    getChildrenThatCanWalk(T,Children,Ages,WalkingAge,ChildrenCanWalk).
getChildrenThatCanWalk([],_WalkingAge,ChildrenCanWalk,ChildrenCanWalk).
getChildrenThatCanWalk([C|Cr],WalkingAge,ChildrenCanWalkAux,ChildrenCanWalk):-
    ageChildren(C,Age),
    Age >= WalkingAge,
    append([C],ChildrenCanWalkAux,Aux),
    getChildrenThatCanWalk(Cr,WalkingAge,Aux,ChildrenCanWalk).

getChildrenThatCanWalk([_|Cr],WalkingAge,ChildrenCanWalkAux,ChildrenCanWalk):-
    getChildrenThatCanWalk(Cr,WalkingAge,ChildrenCanWalkAux,ChildrenCanWalk).

getChildrenThatCanWalk(IdChildrenAux,WalkingAge,ChildrenCanWalk):-
    getChildrenThatCanWalk(IdChildrenAux,WalkingAge,[],ChildrenCanWalk).

%%%%%%%%%%%%%%%%%%%%%%%%%%

%populateList(_,Position,Position,_).
%populateList(List,FromPosition,ToPosition,Value):-
%    P #= FromPosition +1,
%    element(P,List,Value),
%    populateList(List,P,ToPosition,Value).



%Predicado para verificar se o número de filhos e de actividades é diferente
% Mais filhos do que actividades
% Mais actividade do que filhos
% Número de filhos e de actividades igual

%At this version, the knowledge base should have consistent data, on a new version is easy to remove activities that
%have times overlaping, which would always be impossible to match and compare the number of remaining activities with the
%number of children to void the knowledge base if it does not have sufficient activities for all children.
getScheduleAndRoute:-
    %Prepare Variables
    findall(IdChildren,children(IdChildren,_Name),IdChildrenAux),
    findall(IdActividade,activity(IdActividade,_NameA),IdActivitiesAux),
    findall(Age,ageChildren(_,Age),AgeAux),
    findall(MinAge,activityMinimumAge(_,MinAge),MinAgeAux),
    findall([C,A,V],preference(C,A,V),Preferences),

    %%%Route
    findall(StartTime,startTime(_,StartTime),StartTimesAux),
    findall(EndTime,endTime(_,EndTime),EndTimesAux),
    minimumAgeForWalking(WalkingAge),
    maxTimeWalking(WalkingTime),
    findall([A,B,Time],travelByCar(A,B,Time),RoutePaths),
    getWalkingPaths(WalkingTime,WalkingPaths),
    getChildrenThatCanWalk(IdChildrenAux,WalkingAge,ChildrenCanWalk),


    length(IdChildrenAux,NumberOfChildren),
    length(IdActivitiesAux,NumberOfActivities),
    %Generate Arrays of Variables for labeling
    length(Children,NumberOfChildren),
    length(Activities,NumberOfActivities),
    length(Ages,NumberOfChildren),
    length(MinAges,NumberOfActivities),
    %Route
    length(RoutePaths,NumberOfPossiblePaths),
    NumberOfPaths is NumberOfChildren*2,
    VoidNumber is NumberOfPossiblePaths+1,
    length(Route,NumberOfPaths),
    length(StartTimes,NumberOfActivities),
    length(EndTimes,NumberOfActivities),
%    length(ChildrenCanWalk,NumberOfChildren),
    length(ExcludingRoutes,NumberOfPossiblePaths),

    domain(ExcludingRoutes,0,VoidNumber),
    %0 is default, no children with id 0
%    domain(ChildrenCanWalk,1,NumberOfChildren),


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
    domain(Route,0,VoidNumber),
    getGlobalCardinalityDomain(StartTimesAux,StartTimeDomain),
    getGlobalCardinalityDomain(EndTimesAux,EndTimeDomain),
    global_cardinality(StartTimes,StartTimeDomain),
    global_cardinality(EndTimes,EndTimeDomain),

    all_distinct(Children),
    all_distinct(Activities),
    %All ages are diferent (evolve that?) (Removing this should be enough)
    all_distinct(Ages),
    all_distinct(MinAges),
    %%%Route
    all_distinct(StartTimes),
    all_distinct(EndTimes),
    %Prepare Results
    linkIndexesAndValues(AgeAux,Children,Ages),
    linkIndexesAndValues(MinAgeAux,Activities,MinAges),
    %%%Route
    linkIndexesAndValues(StartTimesAux,Activities,StartTimes),
    linkIndexesAndValues(EndTimesAux,Activities,EndTimes),
    %Restrictions
    ageAndPreferenceRestrictions(Children,Activities,Ages,MinAges),
    evaluatePreferences(Children,Activities,Preferences,ListOfPreferences),
    sumAirVariable(ListOfPreferences,SumResult),
    %%%Route
    calculateRoute(
        NumberOfActivities,
        VoidNumber,
        Route,
        RoutePaths,
        ChildrenCanWalk,
        WalkingPaths,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        ExcludingRoutes,
        1,
        NumberOfPaths,
        Count
    ),

    append(Children,Activities,CA),
    append(CA,Route,CAR),
    append(CAR,ExcludingRoutes,CARE),
    write('Vars Before: '),write(CARE),nl,
    write('SumResult: '),write(SumResult),nl,
    labeling([maximize(SumResult)],[SumResult|CARE]),
    write('Childs: '),write(Children),nl,
    write('Activities: '),write(Activities),nl,
    write('SumResult: '),write(SumResult),nl,
    write('Route: '),write(Route),nl,
        write('Ages: '),write(Ages),nl,
        write('StartTimes: '),write(StartTimes),nl,
        write('EndTimes: '),write(EndTimes),nl,
        write('ChildrenCanWalk: '),write(ChildrenCanWalk),nl,
        write('WalkingPaths: '),write(WalkingPaths),nl,
        write('ExcludingRoutes: '),write(ExcludingRoutes),nl,
        write(RoutePaths).