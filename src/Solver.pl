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
    length(RoutePaths,NumberOfPossiblePaths),
    NumberOfPaths is NumberOfChildren*2,
    VoidNumber is NumberOfPossiblePaths+1,
    length(Route,NumberOfPaths),
    length(StartTimes,NumberOfActivities),
    length(EndTimes,NumberOfActivities),
    length(ExcludingRoutes,NumberOfPossiblePaths),
    domain(ExcludingRoutes,0,VoidNumber),
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
    Count in 0..NumberOfPossiblePaths,
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
    all_distinct(StartTimes),
    all_distinct(EndTimes),
    %Prepare Results
    linkIndexesAndValues(AgeAux,Children,Ages),
    linkIndexesAndValues(MinAgeAux,Activities,MinAges),
    linkIndexesAndValues(StartTimesAux,Activities,StartTimes),
    linkIndexesAndValues(EndTimesAux,Activities,EndTimes),
    %Restrictions
    ageAndPreferenceRestrictions(Children,Activities,Ages,MinAges),
    evaluatePreferences(Children,Activities,Preferences,ListOfPreferences),
    sumAirVariable(ListOfPreferences,SumResult),
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
    labeling([maximize(SumResult),maximize(Count)],[SumResult,Count|CARE]),
        write('SumResult: '),write(SumResult),nl,
        write('Count: '),write(Count),nl,
        write('Children: '),write(Children),nl,
        write('Activities: '),write(Activities),nl,
        write('Route: '),write(Route),nl,
        write('ChildrenCanWalk: '),write(ChildrenCanWalk),nl,
        write('WalkingPaths: '),write(ExcludingRoutes),nl,
        write(RoutePaths).