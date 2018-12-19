%filho(_id,_nome,_idade)
children(1,peter,15).
children(2,tony,8).
children(3,diana,6).
children(4,felicia,2).

%preference(_IdFilho,_IdActividade)
preference(1,5).
preference(1,2).
preference(1,3).
preference(1,4).
preference(1,1).

preference(2,5).
preference(2,2).
preference(2,1).
preference(2,3).
preference(2,4).

preference(3,3).
preference(3,5).
preference(3,4).
preference(3,2).
preference(3,1).

%Neste caso apenas a primeira opção será válida
%É possível colocar aqui mais limitações (vale a pena?)
preference(4,4).
preference(4,3).
preference(4,1).
preference(4,2).
preference(4,5).


%idade mínima para se deslocar a pé
idadeMinimaAndarAPe(11).

%tempoMáximoAPé(minutos)
tempoMaxAPe(30).