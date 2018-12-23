
%The maximum and minimum values for the preferences for each activity
%The step is 10
maxActivityWeight(40).
minActivityWeight(10).


%activityTypeId(_Id, _Nome);
activityTypeId(1, sports).
activityTypeId(2, music).

%activity(_Id, _Nome);
activity(1,futebol).
activity(2,krav_maga).
activity(3,piano).
activity(4,canto).

%activityType(_Id, _IdTipo);
activityType(1, 1).
activityType(2, 1).
activityType(3, 2).
activityType(4, 2).

%location(_id, _LocationName)
location(0,casa).
location(1,campo_de_futebol).
location(2,escola_de_artes_marciais).
location(3,conservatorio).
location(4,escola_de_musica).

%activityMinimumAge(_Id, _MinimumAge);
activityMinimumAge(1,6).
activityMinimumAge(2,11).
activityMinimumAge(3,3).
activityMinimumAge(4,0).

%startTime(_Id,_Hour HH:mm (24h))
startTime(1,1700).
startTime(2,1645).
startTime(3,1610).
startTime(4,1628).

%endTime(_Id,_Hour HH:mm (24h))
endTime(1,1900).
endTime(2,1815).
endTime(3,1740).
endTime(4,1827).

%duration(_Id,_TimeInMinutes)
duration(1,120).
duration(2,90).
duration(3,90).
duration(4,30).

% Carro anda a 50km/h a pé 5km/h
%travelByCar(_Fom,_To,_TimeInMinutes)
travelByCar(0,1,0).
travelByCar(0,2,0).
travelByCar(0,3,0).
travelByCar(0,4,0).

travelByCar(1,2,6).
travelByCar(1,3,13).
travelByCar(1,4,7).

travelByCar(2,1,6).
travelByCar(2,3,12).
travelByCar(2,4,1).

travelByCar(3,1,13).
travelByCar(3,2,12).
travelByCar(3,4,7).

travelByCar(4,1,7).
travelByCar(4,2,1).
travelByCar(4,3,7).

travelByCar(1,0,0).
travelByCar(2,0,0).
travelByCar(3,0,0).
travelByCar(4,0,0).

%travelByFoot(_From,_To,_TimeInMinutes)
travelByFoot(0,1,120).
travelByFoot(0,2,10).
travelByFoot(0,3,60).
travelByFoot(0,4,144).

travelByFoot(1,0,120).
travelByFoot(1,2,60).
travelByFoot(1,3,132).
travelByFoot(1,4,72).

travelByFoot(2,0,10).
travelByFoot(2,1,60).
travelByFoot(2,3,120).
travelByFoot(2,4,12).

travelByFoot(3,0,60).
travelByFoot(3,1,132).
travelByFoot(3,2,120).
travelByFoot(3,4,72).

travelByFoot(4,0,144).
travelByFoot(4,1,72).
travelByFoot(4,2,12).
travelByFoot(4,3,72).

%marginTime(_TimeInMinutes).
%Tempo de margem para chegar a cada local (mais ou menos da hora de fim ou inicio)
marginTime(5).
dropOffTime(1).
