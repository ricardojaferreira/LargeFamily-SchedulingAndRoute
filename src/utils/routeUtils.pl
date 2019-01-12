getRejectedRoutes(RejectedRoutes):-
    findall([A,B,Time],travelByCar(A,B,Time),RoutePaths),
    computeRejectedRoutes(RoutePaths,[],RejectedRoutes).

computeRejectedRoutes([[A,B,Time]|T],RejectedRoutesAux,RejectedRoutes):-
    startTime(A,StimeA),
    startTime(B,StimeB),
    marginTime(Margin),
    sumMinToTime(StimeA,Margin,ArrivalToB),
    StimeB =:= ArrivalToB,
    computeRejectedRoutes(T,RejectedRoutesAux,RejectedRoutes).

computeRejectedRoutes([A,B,Time|T],RejectedRoutesAux,RejectedRoutes):-
    startTime(A,StimeA),
    startTime(B,StimeB),
    marginTime(Margin),
    dropOffTime(DropOffTime),
    TotMargin is Margin + DropOffTime,
    sumMinToTime(StimeA,TotMargin,ArrivalToB),
    StimeB =< ArrivalToB,
    computeRejectedRoutes(T,RejectedRoutesAux,RejectedRoutes).
