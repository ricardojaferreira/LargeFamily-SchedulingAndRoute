
%Rule
firstAndLastAreHome(Route):-
    element(1,Route,0),
    length(Route,LastElement),
    element(LastElement,Route,0).

%Rule
onlyElementsOfChosenActivitiesOrZero([],_).
onlyElementsOfChosenActivitiesOrZero([A|T],Activities):-
    countOccurrences(A,Activities,Count),
    A#\=0 #=> Count #=1,
    A#=0 #=> Count #=0,
    onlyElementsOfChosenActivitiesOrZero(T,Activities).

%rule
noConsecutiveNodesOrZero([_]).
noConsecutiveNodesOrZero([A,B|T]):-
    (A#\=B) #\/ (A#=0 #/\ B#=0),
    noConsecutiveNodesOrZero([B|T]).

%Rule
rejectThisPath([_],_).
rejectThisPath([A1,B1|T],[A2,B2]):-
    (A1 #= A2) #=> (B1 #\= B2),
    rejectThisPath([B1|T],[A2,B2]).

checkIfChildrenCanWalk(Route,A,[A,B]):-
    rejectThisPath(Route,[A,B]),
    countOccurrences(A,Route,1).

checkIfChildrenCanWalk(Route,B,[0,B]):-
    rejectThisPath(Route,[0,B]),
    countOccurrences(B,Route,0).

checkIfChildrenCanWalk(_,_,[_]).


rejectWalkingPaths(_,_,[]).
rejectWalkingPaths(Route,ChildrenCanWalkActivity,[A|T]):-
    checkIfChildrenCanWalk(Route,ChildrenCanWalkActivity,A),
    % rejectThisPath(Route,A,Bin),
    rejectWalkingPaths(Route,ChildrenCanWalkActivity,T).

%rule
countOccurrences(_,[_],0).
countOccurrences(A,[B|T],Value):-
    countOccurrences(A,T,V1),
    ((A #= B) #/\ (A#\=0)) #<=> R,
    Value #= V1 + R.

% countOccurrences(_,[],V,V).
% countOccurrences(A,[B|T],Aux,Value):-
%     ((A #= B) #/\ (A#\=0)) #<=> R,
%     Aux1 #= Aux +R,
%     countOccurrences(A,T,Aux1,Value).


maximumTwoVisitsOnEachNode([],_,_).
maximumTwoVisitsOnEachNode([A|T],Route,ChildrenCanWalkActivity):-
    countOccurrences(A,Route,Count),
    (A #\= ChildrenCanWalkActivity #/\ A#\=0) #=> Count#=2,
    (A #= ChildrenCanWalkActivity) #=> Count#=<2,
    maximumTwoVisitsOnEachNode(T,Route,ChildrenCanWalkActivity).


%rule
zerosNotAllowedBetweenTwoNumbers([_,_,_,_]).
zerosNotAllowedBetweenTwoNumbers([A,B,C|T]):-
    (A#\=0 #/\ C#\=0) #=> B#\=0,
    zerosNotAllowedBetweenTwoNumbers([B,C|T]).

%rule
getFirstStartTime(StartTimes,Activities,[T|_],[_,R|_],T):-
    element(P,Activities,R),
    element(P,StartTimes,St),
    StPlus #= St + 5,
    StMinus #= St - 5,
    (T#=St #\/ T#=StPlus #\/ T#=StMinus).


implyTravelTime([],_,_,_).
implyTravelTime([[A,B,T]|R],R1,R2,TravelTime):-
    R1#=A #/\ R2#=B #=> TravelTime #= T,
    implyTravelTime(R,R1,R2,TravelTime).

%rule
getSecondStartTime(RoutePaths,StartTimes,Activities,[_,T|_],[_,R1,R2|_],ActualTime,T):-
    element(P,Activities,R2),
    element(P,StartTimes,St),
    StPlus #= St + 5,
    StMinus #= St - 5,
    implyTravelTime(RoutePaths,R1,R2,TravelTime),
    ((T #= ActualTime+TravelTime) #/\
    ((T #= St) #\/ (T #= StPlus) #\/ (T #= StMinus))).


getNextRoutesSequence(_,_,_,_,_,_,_,0).
getNextRoutesSequence(RoutePaths,StartTimes,EndTimes,Activities,[T3|Times],[R1,R2|Routes],ActualTime,Index):-
    Index1 is Index -1,
    element(P,Activities,R2),
    element(P,StartTimes,St),
    element(P,EndTimes,Et),
    StPlus #= St + 5,
    StMinus #= St - 5,
    EtPlus #= Et + 5,
    EtMinus #= Et - 5,
    implyTravelTime(RoutePaths,R1,R2,TravelTime),
    T3 #= ActualTime+TravelTime,
    (T3 #> ActualTime) #=> (
        (T3 #= St) #\/
        (T3 #= StPlus) #\/
        (T3 #= StMinus) #\/
        (T3 #= Et) #\/
        (T3 #= EtPlus) #\/
        (T3 #= EtMinus)
    ),
    getNextRoutesSequence(RoutePaths,StartTimes,EndTimes,Activities,Times,[R2|Routes],T3,Index1).

getNextRoutes(RoutePaths,StartTimes,EndTimes,Activities,[_,_,T3|Times],[_,_,R1,R2|Routes],ActualTime,Index):-
    Index1 is Index -1,
    element(P,Activities,R2),
    element(P,StartTimes,St),
    element(P,EndTimes,Et),
    StPlus #= St + 5,
    StMinus #= St - 5,
    EtPlus #= Et + 5,
    EtMinus #= Et - 5,
    implyTravelTime(RoutePaths,R1,R2,TravelTime),
    T3 #= ActualTime+TravelTime,
    (T3 #> ActualTime) #=> (
        (T3 #= St) #\/
        (T3 #= StPlus) #\/
        (T3 #= StMinus) #\/
        (T3 #= Et) #\/
        (T3 #= EtPlus) #\/
        (T3 #= EtMinus)
    ),
    getNextRoutesSequence(RoutePaths,StartTimes,EndTimes,Activities,Times,[R2|Routes],T3,Index1).


calculateRoute(RoutePaths,ChildrenCanWalkActivity,WalkingPaths,Activities,StartTimes,EndTimes,Route,Times):-
    firstAndLastAreHome(Route),
    noConsecutiveNodesOrZero(Route),
    rejectWalkingPaths(Route,ChildrenCanWalkActivity,WalkingPaths),
    maximumTwoVisitsOnEachNode(Route,Route,ChildrenCanWalkActivity),
    zerosNotAllowedBetweenTwoNumbers(Route),
    getFirstStartTime(StartTimes,Activities,Times,Route,ActualTime),
    getSecondStartTime(RoutePaths,StartTimes,Activities,Times,Route,ActualTime,NewActualTime),
    length(WalkingPaths,L),
    length(Times,Lt),
    Index is Lt-3-L,
    getNextRoutes(RoutePaths,StartTimes,EndTimes,Activities,Times,Route,NewActualTime,Index).
