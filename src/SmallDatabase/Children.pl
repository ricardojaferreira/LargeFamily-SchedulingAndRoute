%filho(_id,_nome,_idade)
children(1,peter).
children(2,tony).
children(3,diana).
children(4,felicia).

ageChildren(1,15).
ageChildren(2,8).
ageChildren(3,6).
ageChildren(4,2).

%preference(_IdFilho,_IdActividade,_Ranking)
preference(1,1,10).
preference(1,2,40).
preference(1,3,30).
preference(1,4,20).

preference(2,1,30).
preference(2,2,40).
preference(2,3,20).
preference(2,4,10).

preference(3,1,10).
preference(3,2,20).
preference(3,3,40).
preference(3,4,30).

preference(4,1,20).
preference(4,2,10).
preference(4,3,30).
preference(4,4,40).


%minimumAgeForWalking(_Age)
%   Minimum Age to walk from place to place
minimumAgeForWalking(11).

%maxTimeWalking(minutos)
%   Maximum time walking in minutes
maxTimeWalking(2).
