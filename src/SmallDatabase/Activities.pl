
%actividade(_Id, _Nome);
actividade(1,futebol).
actividade(2,krav_maga).
actividade(3,piano).
actividade(4,canto).
%actividade(5,badmington).

%local(_id, _NomeLocal)
local(1,casa).
local(2,campo_de_futebol).
local(3,escola_de_artes_marciais).
local(4,escola_de_musica).
local(5,casa_da_musica).

%idTipoActividade(_Id, _Nome);
idTipoActividade(1, desporto).
idTipoActividade(2, musica).

%idadeMinimaActividade(_Id, _IdadeMinima);
idadeMinimaActividade(1,6).
idadeMinimaActividade(2,11).
idadeMinimaActividade(3,6).
idadeMinimaActividade(4,0).
idadeMinimaActividade(5,3).

%tipoActividade(_Id, _IdTipo);
tipoActividade(1, 1).
tipoActividade(2, 1).
tipoActividade(3, 2).
tipoActividade(4, 2).
tipoActividade(5, 1).

%horaInicio(_Id,_Hora HH:mm (24h))
horaInicio(1,1700).
horaInicio(2,1628).
horaInicio(3,1655).
horaInicio(4,1610).

%duracao(_Id,_TempoMinutos)
duracaoActividade(1,120).
duracaoActividade(2,90).
duracaoActividade(3,90).
duracaoActividade(4,30).

%%% Localizações
% 1, Casa
% 2, Campo de futebol (Futebol)
% 3, Escola de artes marciais (Krav Maga
% 4, Escola de Música (Piano)
% 5, Casa da Música (Canto)
% Carro anda a 50km/h a pé 5km/h

%tempoCarro(_De,_Para,_TempoMinutos)
tempoCarro(1,2,12).
tempoCarro(1,3,18).
tempoCarro(1,4,6).
tempoCarro(1,5,14).

tempoCarro(2,1,12).
tempoCarro(2,3,6).
tempoCarro(2,4,13).
tempoCarro(2,5,7).

tempoCarro(3,1,18).
tempoCarro(3,2,6).
tempoCarro(3,4,12).
tempoCarro(3,5,1).

tempoCarro(4,1,6).
tempoCarro(4,2,13).
tempoCarro(4,3,12).
tempoCarro(4,5,7).

tempoCarro(5,1,14).
tempoCarro(5,2,7).
tempoCarro(5,3,1).
tempoCarro(5,4,7).

%tempoAPe(_De,_Para,_TempoMinutos)
tempoAPe(1,2,120).
tempoAPe(1,3,180).
tempoAPe(1,4,60).
tempoAPe(1,5,144).

tempoAPe(2,1,120).
tempoAPe(2,3,60).
tempoAPe(2,4,132).
tempoAPe(2,5,72).


tempoAPe(3,1,180).
tempoAPe(3,2,60).
tempoAPe(3,4,120).
tempoAPe(3,5,12).

tempoAPe(4,1,60).
tempoAPe(4,2,132).
tempoAPe(4,3,120).
tempoAPe(4,5,72).

tempoAPe(5,1,144).
tempoAPe(5,2,72).
tempoAPe(5,3,12).
tempoAPe(5,4,72).

%margemTempo(_Minutos).
%Tempo de margem para chegar a cada local (mais ou menos da hora de fim ou inicio)
margemTempo(5).
