/*
    1º Todos os filhos diferentes
    2º Todas as actividades diferentes
    3º Cada filho só pode ter uma actividade
    4º O filho só pode ir para a actividade se a idade for adequada
    5º Atribuir filho a actividade conforme preferência

    Actividades não podem começar ao mesmo tempo
    Tempo de inicio em actividades tem que ser igual ao anterior mais o
        tempo de deslocacao, com tolerancia de 5min

    Restrições da deslocação:

        1º A actividade seguinte tem que começar depois da anterior mais o tempo de deslocação (+ 5min opcional)
        2º A primeira a acabar tem que acabar depois da última entrega mais o tempo de deslocação (+5min opcional)
        3º A actividade a acabar seguinte tem que acabar depois da anterior mais o tempo de deslocação (+5min opcional)

*/
:-include('utils/includes.pl').

ageRestriction([],[],_,_,_).
ageRestriction([C|T],[A|R],Position,ListC,ListA):-
    children(C,_,Age),
    preference(C,A),
    idadeMinimaActividade(A,MinAge),
    Age #>= MinAge,
    P is Position +1,
    element(Position,ListC,C),
    element(Position,ListA,A),
    ageRestriction(T,R,P,ListC,ListA).


%Predicado para verificar se o número de filhos e de actividades é diferente
% Mais filhos do que actividades
% Mais actividade do que filhos
% Número de filhos e de actividades igual
getScheduleAndRoute:-
    findall(IdChildren,children(IdChildren,_NameC,_Age),RChildren), %Get all childrens (useful to escalate)
    findall(IdActividade,actividade(IdActividade,_NameA),RActivities), %Get all activities (useful to escalate)
    %Generate Array of Children Id's
    length(RChildren,NumberOfChildren),
    length(Children,NumberOfChildren),
    %Generate Array of Activities Id's
    length(RActivities,NumberOfActivities),
    length(Activities,NumberOfActivities),
    domain(Children,1,NumberOfChildren),
    domain(Activities,1,NumberOfActivities),
    all_distinct(Children),
    all_distinct(Activities), %pode haver mais do que um filho na mesma actividade
    %restrictions 4 and 5
    ageRestriction(Children, Activities, 1, Children, Activities),

    append(Children,Activities,MyVars),
    labeling([],MyVars),
    write('Vars: ' + MyVars),nl.

scheduleRestrictions([_]).

scheduleRestrictions([H1,H2|T]):-
    write('.......Iteraction.....'),nl,
    horaInicio(H1,I1),
    write('Hora Inicio de: '),write(H1),write('::'),write(I1),write('-'),
    horaInicio(H2,I2),
    write('Hora Chegada de: '),write(H2),write('::'),write(I2),write('-'),
    tempoCarro(H1,H2,T1),
    write('Tempo Carro: '),write(T1),write('-'),
    sumMinToTime(I1,T1,RouteTime), %Em falta os 5min de desvio
    write('Tempo do Caminho: '),write(RouteTime),write('-'),
    I2 #>= RouteTime,
    write('I2 > TempHora '),write(I2),write('>'),write(RouteTime),write('-'),
    write('Remaining: '),write([H2|T]),nl,
    scheduleRestrictions([H2|T]).

%scheduleRestrictionsBack([H1|T],LastDrop):-


orderActivitiesByRoute:-
    findall(IdActividade,actividade(IdActividade,_NameA),RActivities),
    length(RActivities,NumberOfActivities),
    length(GOActivities,NumberOfActivities),
    length(BACKActivities,NumberOfActivities),
    domain(GOActivities,1,NumberOfActivities),
    domain(BACKActivities,1,NumberOfActivities),
    all_distinct(GOActivities),
    all_distinct(BACKActivities),
    element(NumberOfActivities,GOActivities,LastDrop),
    element(1,BACKActivities,LastDrop),
    scheduleRestrictions(GOActivities),
%    scheduleRestrictionsBack(BackActivities,LastDrop),
%    append(GOActivities,BackActivities,MySchedule),
    write('GoActivities Before Labeling: '),write(GOActivities),
    labeling([],GOActivities),
    write(GOActivities).
%    write(BackActivities),nl.


% consult('src/Solver.pl').
% consult('Solver.pl').
% getScheduleAndRoute(F).
% getScheduleAndRoute.