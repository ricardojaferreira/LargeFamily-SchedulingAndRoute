continue.
ifThen(Condition,Then,_Else):-
    Condition,!,Then.
ifThen(_Condition,_Then,Else):-
    Else.


showMinAges([]).
showMinAges([[A-M]|T]):-
    activity(A,Activity),
    write(Activity),write(' - '),write(M),nl,
    showMinAges(T).

showActivities([],[]).
showActivities([C|Childs],[A|Activities]):-
    children(C,Name),
    ageChildren(C,Age),
    activity(A,Activity),
    write(Name),write(' tem '),write(Age),write(' anos e vai praticar '),write(Activity),write('.'),nl,
    showActivities(Childs,Activities).

getChildrenActivity(C,[C|_],[A|_],A).
getChildrenActivity(C,[_Cid|T],[_Aid|T],Act):-
    getChildrenActivity(C,T,T,Act).

showOnFoot(C,A,B):-
    children(C,Name),
    activity(A,Activity1),
    activity(B,Activity2),
    write(Name),write(' vai a pe da actividade '),write(Activity1),
    write(' para a actividade '),write(Activity2),nl.

showFootRoutes(_,_,[],_).
showFootRoutes(Children,Activity,[C|T],[[A,B]|R]):-
    getChildrenActivity(C,Children,Activity,Act),
    ifThen(Act=:=A,showOnFoot(C,A,B),continue),
    showFootRoutes(Children,Activity,T,R).

showCarPlan(A,T):-
    activity(A,Activity),
    write('Chegar ao '),write(Activity),write(' as: '),write(T),nl.

showCarRoutes2(_,[]).
showCarRoutes2([A|Routes],[T|Times]):-
    ifThen(A=:=0,continue,showCarPlan(A,T)),
    showCarRoutes2(Routes,Times).

showCarRoutes([_,A|Routes],Times):-
    showCarRoutes2([A|Routes],Times).

showRouteOnly(Route):-
    activity(Route,Activity),
    write(Activity),write(',').

showOnlyRoutes2([_]):-
    write('casa]'),nl,
    write('-**-'),nl.
showOnlyRoutes2([Route|Routes]):-
    ifThen(Route=:=0,write('esperar,'),showRouteOnly(Route)),
    showOnlyRoutes2(Routes).

showOnlyRoutes([_,Route|Routes]):-
    write('Rota: [casa,'),
    showOnlyRoutes2([Route|Routes]).

display(Children,Activity,ChildrenCanWalk,WalkingPaths,Route,Times,Flag,SumResult,SumResultMax):-
    write('---------------------------------------'),nl,
    write('Planeamento de Actividades Familiares'),nl,
    write('----------------------------------------'),nl,
    findall([Act-MinAge],activityMinimumAge(Act,MinAge),MinAgeActivities),
    write('*Idade Minima Actividades*'),nl,
    showMinAges(MinAgeActivities),nl,
    write('*Actividades de cada filho*'),nl,
    showActivities(Children,Activity),nl,
    write('*Deslocacoes a pe*'),nl,
    showFootRoutes(Children,Activity,ChildrenCanWalk,WalkingPaths),nl,
    write('*Deslocacoes de carro*'),nl,
    showOnlyRoutes(Route),
    showCarRoutes(Route,Times),nl,
    write('*Indicador de qualidade*'),nl,
    write('Resultado Algoritmo: '),write(Flag),nl,
    write('Resultado escolhas filhos: '),write(SumResult),write('/'),write(SumResultMax),nl.
