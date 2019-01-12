%Restrictions
%1
firstValueMustBeSmallerThan([A|_],NumberOfActivities):-
    A #=< NumberOfActivities #/\ A #>= 1.
%2
restrictFollowingPaths([],_PathId).
restrictFollowingPaths([A|T],PathId):-
    A #> PathId,
    restrictFollowingPaths(T,PathId).

otherPathsMustBeHigherRestriction([_|T],PathId):-
    restrictFollowingPaths(T,PathId).
%3
pathNotPossibleRestriction([],_).
pathNotPossibleRestriction([A|T],Value):-
    A #\= Value,
    pathNotPossibleRestriction(T,Value).

%4
noTwoConsecutiveRoutesWithSameId([_]).
noTwoConsecutiveRoutesWithSameId([A,B|T]):-
    (A #\= B) #\/ (A#=0 #/\ B#=0),
    noTwoConsecutiveRoutesWithSameId([B|T]).

%5
otherPathsMustBeSmallerRestriction([_],_Value).
otherPathsMustBeSmallerRestriction([A|T],Value):-
    A #< Value,
    otherPathsMustBeSmallerRestriction(T,Value).

%6
travelRestrictions(Route,PathId,[P1,P2,Time],Activities,StartTimes,EndTimes,VoidNumber):-
    % write('ENTERING: '),nl.

    element(Pos2,Activities,P2),
    element(Pos2,StartTimes,StartTime2),
    element(Pos2,EndTimes,EndTime2),
    marginTime(Margin),
    MarginTime is Time + Margin,
    startTime(P1,StartTime1),
    endTime(P1,EndTime1),
    sumMinToTime(StartTime1,MarginTime,ArrivalTime2),
    subtractMinToTime(StartTime1,MarginTime,ArrivalTime3),
    sumMinToTime(EndTime1,MarginTime,ArrivalTime4),
    subtractMinToTime(EndTime1,MarginTime,ArrivalTime5),

    ((StartTime2 #>= ArrivalTime3 #/\ StartTime2 #=< ArrivalTime2) #\/
    (StartTime2 #>= ArrivalTime5 #/\ StartTime2 #=< ArrivalTime4) #\/
    (EndTime2 #>= ArrivalTime3 #/\ EndTime2 #=< ArrivalTime2)  #\/
    (EndTime2 #>= ArrivalTime5 #/\ EndTime2 #=< ArrivalTime4)
    ) #=> (Value #= VoidNumber),

    ((StartTime2 #=< ArrivalTime3 #/\ EndTime2 #=< ArrivalTime3) #\/
    (StartTime2 #=< ArrivalTime3 #/\ EndTime2 #>= ArrivalTime2) #\/
    (StartTime2 #=< ArrivalTime3 #/\ EndTime2 #=< ArrivalTime5) #\/
    (StartTime2 #=< ArrivalTime3 #/\ EndTime2 #>= ArrivalTime4) #\/
    (StartTime2 #>= ArrivalTime2 #/\ EndTime2 #=< ArrivalTime3) #\/
    (StartTime2 #>= ArrivalTime2 #/\ EndTime2 #>= ArrivalTime2) #\/
    (StartTime2 #>= ArrivalTime2 #/\ EndTime2 #=< ArrivalTime5) #\/
    (StartTime2 #>= ArrivalTime2 #/\ EndTime2 #>= ArrivalTime4) #\/
    (StartTime2 #>= ArrivalTime4 #/\ EndTime2 #=< ArrivalTime3) #\/
    (StartTime2 #>= ArrivalTime4 #/\ EndTime2 #>= ArrivalTime2) #\/
    (StartTime2 #>= ArrivalTime4 #/\ EndTime2 #=< ArrivalTime5) #\/
    (StartTime2 #>= ArrivalTime4 #/\ EndTime2 #>= ArrivalTime4) #\/
    (StartTime2 #=< ArrivalTime5 #/\ EndTime2 #=< ArrivalTime3) #\/
    (StartTime2 #=< ArrivalTime5 #/\ EndTime2 #>= ArrivalTime2) #\/
    (StartTime2 #=< ArrivalTime5 #/\ EndTime2 #=< ArrivalTime5) #\/
    (StartTime2 #=< ArrivalTime5 #/\ EndTime2 #>= ArrivalTime4)
    ) #=> (Value #=> PathId),

    pathNotPossibleRestriction(Route,Value).

%%%%%%%%%%%%%%

checkIfItsAWalkingRoute(_,[],0).
checkIfItsAWalkingRoute(Route,[Route|_T],1).
checkIfItsAWalkingRoute(Route,[_WalkingRoute|T],Result):-
    checkIfItsAWalkingRoute(Route,T,Result).


checkWalkPathForChild(_,[],_,_,_,_,_,_,_,_,NPosition,NPosition,NCount,NCount).
checkWalkPathForChild(
    Route,
    [Id|T],
    PathId,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    VoidValue,
    [0,P2],
    ExcludingRoutes,
    ExcludingActualPosition,
    NewExcludingPosition,
    CountAux,
    NewCount
):-
    element(Pos,Children,Id),
    element(Pos,Activities,Activity),
    (Activity#=P2) #=> (Value#=PathId #/\ C #= CountAux+1),
    (Activity#\=P2) #=> (Value#=VoidValue #/\ C #= CountAux),
    P #= ExcludingActualPosition + 1,
    element(P,ExcludingRoutes,Value),
    pathNotPossibleRestriction(Route,Value),
    checkWalkPathForChild(
        Route,
        T,
        PathId,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        VoidValue,
        [0,P2],
        ExcludingRoutes,
        P,
        NewExcludingPosition,
        C,
        NewCount
    ).

checkWalkPathForChild(
    Route,
    [Id|T],
    PathId,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    VoidValue,
    [P1,0],
    ExcludingRoutes,
    ExcludingActualPosition,
    NewExcludingPosition,
    CountAux,
    NewCount
):-
    element(Pos,Children,Id),
    element(Pos,Activities,Activity),
    (Activity#=P1) #=> (Value#=PathId #/\ C #= CountAux+1),
    (Activity#\=P1) #=> (Value#=VoidValue #/\ C #= CountAux),
    P #= ExcludingActualPosition + 1,
    element(P,ExcludingRoutes,Value),
    pathNotPossibleRestriction(Route,Value),
    checkWalkPathForChild(
        Route,
        T,
        PathId,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        VoidValue,
        [P1,0],
        ExcludingRoutes,
        P,
        NewExcludingPosition,
        C,
        NewCount
    ).

checkWalkPathForChild(
    Route,
    [Id|T],
    PathId,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    VoidValue,
    [P1,P2],
    ExcludingRoutes,
    ExcludingActualPosition,
    NewExcludingPosition,
    CountAux,
    NewCount
):-
    element(Pos1,Children,Id),
    element(Pos1,Activities,Activity),
    (Activity#=P1) #<=> B1,
    element(Pos2,Activities,P2),
    element(Pos2,StartTimes,StartTime2),
    element(Pos2,EndTimes,EndTime2),
    endTime(P1,EndTime),
    travelByFoot(P1,P2,TravelTime),
    sumMinToTime(EndTime,TravelTime,EndRouteTime),
    ((StartTime2 #= EndRouteTime) #\/ (EndTime2 #= EndRouteTime)) #<=> B2,
    Result #= B1 + B2,
    (Result #= 2) #=> (Value #= PathId #/\ C #= CountAux+1),
    (Result #\= 2) #=> (Value #= VoidValue #/\ C #= CountAux),
    P #= ExcludingActualPosition + 1,
    element(P,ExcludingRoutes,Value),
    pathNotPossibleRestriction(Route,Value),
    checkWalkPathForChild(
        Route,
        T,
        PathId,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        VoidValue,
        [0,P2],
        ExcludingRoutes,
        P,
        NewExcludingPosition,
        C,
        NewCount
    ).


%%%%%%%%%%%%%%%%%%%%%%

calculateRoute(_,_,[],_,_,_,_,_,_,_,_,RP,RP,EP,EP,Count,Count).
%calculateRoute(_,_,_,_,_,_,_,_,RP,RP,EP,EP,Count,Count).
%StartRoute
calculateRoute(
    VoidNumber,
    Route,
    [[0,P2,_Time]|T],
    ChildrenCanWalk,
    WalkingPaths,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    ExcludingRoutes,
    PathId,
    RouteActualPosition,
    RoutePosition,
    ExcludingActualPosition,
    ExcludingPosition,
    CountAux,
    Count
):-
    checkIfItsAWalkingRoute([0,P2],WalkingPaths,Result),
    Result =:= 0,
%    NewRoutePosition #= RouteActualPosition + 1,
%    element(NewRoutePosition,Route,PathId),
%    otherPathsMustBeHigherRestriction(Route,PathId),
    NewPathId is PathId+1,
    write(NewPathId),nl,
    calculateRoute(
        VoidNumber,
        Route,
        T,
        ChildrenCanWalk,
        WalkingPaths,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        ExcludingRoutes,
        NewPathId,
        RouteActualPosition,
        RoutePosition,
        ExcludingActualPosition,
        ExcludingPosition,
        CountAux,
        Count
    ).

calculateRoute(
    VoidNumber,
    Route,
    [[0,P2,_Time]|T],
    ChildrenCanWalk,
    WalkingPaths,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    ExcludingRoutes,
    PathId,
    RouteActualPosition,
    RoutePosition,
    ExcludingActualPosition,
    ExcludingPosition,
    CountAux,
    Count
):-
    % write('Hello'),nl.
    checkIfItsAWalkingRoute([0,P2],WalkingPaths,Result),
    Result =:= 1,
    checkWalkPathForChild(
        Route,
        ChildrenCanWalk,
        PathId,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        VoidNumber,
        [0,P2],
        ExcludingRoutes,
        ExcludingActualPosition,
        NewExcludingPosition,
        CountAux,
        NewCount
    ),
%    otherPathsMustBeHigherRestriction(Route,PathId),
    NewPathId is PathId+1,
    calculateRoute(
        VoidNumber,
        Route,
        T,
        ChildrenCanWalk,
        WalkingPaths,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        ExcludingRoutes,
        NewPathId,
        RouteActualPosition,
        RoutePosition,
        NewExcludingPosition,
        ExcludingPosition,
        NewCount,
        Count
    ).

%Last Route
calculateRoute(
    VoidNumber,
    Route,
    [[P1,0,_Time]|T],
    ChildrenCanWalk,
    WalkingPaths,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    ExcludingRoutes,
    PathId,
    RouteActualPosition,
    RoutePosition,
    ExcludingActualPosition,
    ExcludingPosition,
    CountAux,
    Count
):-
    checkIfItsAWalkingRoute([P1,0],WalkingPaths,Result),
    Result =:= 0,
   element(RouteActualPosition,Route,PathId),
   NewRoutePosition #= RouteActualPosition + 1,
   otherPathsMustBeSmallerRestriction(Route,PathId),
    NewPathId is PathId+1,
    calculateRoute(
        VoidNumber,
        Route,
        T,
        ChildrenCanWalk,
        WalkingPaths,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        ExcludingRoutes,
        NewPathId,
        NewRoutePosition,
        RoutePosition,
        ExcludingActualPosition,
        ExcludingPosition,
        CountAux,
        Count
    ).

calculateRoute(
    VoidNumber,
    Route,
    [[P1,0,_Time]|T],
    ChildrenCanWalk,
    WalkingPaths,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    ExcludingRoutes,
    PathId,
    RouteActualPosition,
    RoutePosition,
    ExcludingActualPosition,
    ExcludingPosition,
    CountAux,
    Count
):-
    checkIfItsAWalkingRoute([P1,0],WalkingPaths,Result),
    Result =:= 1,
    checkWalkPathForChild(
        Route,
        ChildrenCanWalk,
        PathId,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        VoidNumber,
        [P1,0],
        ExcludingRoutes,
        ExcludingActualPosition,
        NewExcludingPosition,
        CountAux,
        NewCount
    ),
%    element(RouteActualPosition,Route,PathId),
%    NewRoutePosition #= RouteActualPosition + 1,
%    otherPathsMustBeSmallerRestriction(Route,PathId),
    NewPathId is PathId+1,
    calculateRoute(
        VoidNumber,
        Route,
        T,
        ChildrenCanWalk,
        WalkingPaths,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        ExcludingRoutes,
        NewPathId,
        RouteActualPosition,
        RoutePosition,
        NewExcludingPosition,
        ExcludingPosition,
        NewCount,
        Count
    ).


calculateRoute(
    VoidNumber,
    Route,
    [[P1,P2,Time]|T],
    ChildrenCanWalk,
    WalkingPaths,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    ExcludingRoutes,
    NewPathId,
    RouteActualPosition,
    RoutePosition,
    ExcludingActualPosition,
    ExcludingPosition,
    NewCount,
    Count
):-
    checkIfItsAWalkingRoute([P1,P2],WalkingPaths,Result),
    Result =:= 0,
    travelRestrictions(
        Route,
        PathId,
        [P1,P2,Time],
        Activities,
        StartTimes,
        EndTimes,
        VoidNumber
    ),
    NewPathId is PathId+1,
    calculateRoute(
        VoidNumber,
        Route,
        T,
        ChildrenCanWalk,
        WalkingPaths,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        ExcludingRoutes,
        NewPathId,
        RouteActualPosition,
        RoutePosition,
        ExcludingActualPosition,
        ExcludingPosition,
        NewCount,
        Count
    ).

calculateRoute(
    VoidNumber,
    Route,
    [[P1,P2,Time]|T],
    ChildrenCanWalk,
    WalkingPaths,
    Children,
    Activities,
    StartTimes,
    EndTimes,
    ExcludingRoutes,
    NewPathId,
    RouteActualPosition,
    RoutePosition,
    ExcludingActualPosition,
    ExcludingPosition,
    CountAux,
    Count
):-
    checkIfItsAWalkingRoute([P1,P2],WalkingPaths,Result),
    Result =:= 1,
    travelRestrictions(
        Route,
        PathId,
        [P1,P2,Time],
        Activities,
        StartTimes,
        EndTimes,
        VoidNumber
    ),
    checkWalkPathForChild(
        Route,
        ChildrenCanWalk,
        PathId,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        VoidNumber,
        [P1,P2],
        ExcludingRoutes,
        ExcludingActualPosition,
        NewExcludingPosition,
        CountAux,
        NewCount
    ),
    NewPathId is PathId+1,
    calculateRoute(
        VoidNumber,
        Route,
        T,
        ChildrenCanWalk,
        WalkingPaths,
        Children,
        Activities,
        StartTimes,
        EndTimes,
        ExcludingRoutes,
        NewPathId,
        RouteActualPosition,
        RoutePosition,
        NewExcludingPosition,
        ExcludingPosition,
        NewCount,
        Count
    ).

%ENTRY POINT
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
    RoutePosition,
    ExclusionPosition,
    Count
):-
    firstValueMustBeSmallerThan(Route,NumberOfActivities),
    otherPathsMustBeHigherRestriction(Route,NumberOfActivities),
    noTwoConsecutiveRoutesWithSameId(Route),
    calculateRoute(
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
        0,
        RoutePosition,
        0,
        ExclusionPosition,
        0,
        Count
    ).
