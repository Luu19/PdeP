/* Parcial Logico: Tokyo 2020 - 2021 */
/* BASE DE CONOCIMIENTO */
/* 
De los ATLETAS se conoce:
    NOMBRE 
    EDAD
    PAIS QUE REPRESENTA

De las DISCIPLINAS se conoce:
    EQUIPO O INDIVIDUAL
    En caso de ser individual se sabe QUIEN COMPITE

De las MEDALLAS se conoce:
    MATERIAL
    QUIEN O QUIENES GANAN
    EN QUE DISCIPLINA

De los EVENTOS se conoce:
    DISCIPLINA 
    RONDA
    PARTICIPANTES
*/
% 1:
%% MODELADO DE INFORMACIÓN:
%% atleta(Nombre, Edad, PaisQueRepresenta).
atleta(juanPerez, 28, argentina).

%% disciplina(Nombre).
disciplina(voleyMasculino).
disciplina(carrera100MetrosLlanos).

%% competencia(Nombre, Categoria).
competencia(voleyMasculino, equipo(argentina)).
competencia(carrera400MetrosConVallasFemenino, individual(dalilahMuhammad)).

%% medalla(Material, Disciplina, Premiado/s).
medalla(bronce, voleyMasculino, equipo(argentina)).

%% evento(Disciplina, Ronda, Participante/s).
evento(hockeyFemenino, final, equipo(argentina)).
evento(hockeyFemenino, final, equipo(paisesBajos)).

%2:
% vinoAPasear(Atleta).
vinoAPasear(Atleta) :-
    atleta(Atleta, _, _),
    not(compiteEn(Atleta, _)).

% compiteEn(Atleta, Disciplina).
compiteEn(Atleta, Disciplina) :-
    competencia(Disciplina, individual(Atleta)).

% 3:
% medallasDelPais(Medalla, Disciplina, Pais).
medallasDelPais(Medalla, Disciplina, Pais) :-
    ganoMedallaInd(Pais, Medalla, Disciplina).

medallasDelPais(Medalla, Disciplina, Pais) :-
    ganoMedallaEquipo(Pais, Medalla, Disciplina).

%%
ganoMedallaEquipo(Pais, Medalla, Disciplina) :-
    medalla(Medalla, Disciplina, equipo(Pais)).

ganoMedallaInd(Pais, Medalla, Disciplina) :-
    atleta(Atleta, _, Pais),
    medalla(Medalla, Disciplina, individual(Atleta)).

% 4:
% participoEn(Ronda, Disciplina, Atleta).
participoEn(Ronda, Disciplina, Atleta) :-
    atleta(Atleta, _, Pais),
    participoComo(Disciplina, Atleta, Pais, Ronda).

participoComo(Disciplina, _, Pais, Ronda) :-
    evento(Disciplina, Ronda, equipo(Pais)).

participoComo(Disciplina, Atleta, _, Ronda) :-
    evento(Disciplina, Ronda, individual(Atleta)).

% 5:
%% dominio(Pais, Disciplina).
pais(P) :- atleta(_, _, P).

dominio(Pais, Disciplina) :-
    pais(Pais),
    disciplina(Disciplina),
    forall(medalla(Medalla, Disciplina, _), ganoMedallaInd(Pais, Medalla, Disciplina)).

% 6:
%% medallaRapida(Disciplina).
medallaRapida(Disciplina) :-
    disciplina(Disciplina),
    evento(Disciplina, Ronda, _),
    not(hayOtraRonda(Disciplina, Ronda)).

hayOtraRonda(Disciplina, Ronda) :-
    evento(Disciplina, Ronda2, _),
    Ronda \= Ronda2.

% 7:
% noEsElFuerte(Pais, Disciplina).
noEsElFuerte(Pais, Disciplina) :-
    pais(Pais),
    disciplina(Disciplina),
    noFueMuyLejos(Pais, Disciplina).

noFueMuyLejos(Pais, Disciplina) :-
    not(participoComo(Disciplina, _, Pais, _)).

noFueMuyLejos(Pais, Disciplina) :-
    forall(participoEnRonda(Pais, Disciplina, Ronda), rondaInicial(Tipo, Ronda)).
    

participoEnRonda(Pais, Disciplina, Ronda) :-
    formaDeParticipar(Forma, Pais),
    evento(Disciplina, Ronda, Forma).

formaDeParticipar(equipo(Pais), Pais).
formaDeParticipar(individual(Atleta), Pais) :- atleta(Atleta, _, Pais).

rondaInicial(equipo(_), faseDeGrupos).
rondaInicial(individual(_), ronda1).

% 8:
% medallasEfectivas(Pais, TotalMedallas).
medallasEfectivas(Pais, TotalMedallas) :-
    pais(Pais),
    findall(Valor, valorMedallaGanada(Pais, Valor), Valores),
    sumlist(Valores, TotalMedallas).

valorMedallaGanada(Pais, Valor) :-
    medallasDelPais(Medalla, _, Pais),
    valorMedalla(Medalla, Valor).

valorMedalla(oro, 3).
valorMedalla(placa, 2).
valorMedalla(bronce, 1).

% 9:
% laEspecialidad(Atleta).
esAtleta(A) :- atleta(A, _, _).

laEspecialidad(Atleta) :-
    esAtleta(Atleta),
    not(vinoAPasear(Atleta)),
    forall(participoEn(Disciplina, _, Atleta), soloGanoOroOPlata(Disciplina, Atleta)).

soloGanoOroOPlata(Disciplina, Atleta) :-
    medalla(Medalla, Disciplina, individual(Atleta)),
    esOroOPlata(Medalla).

esOroOPlata(oro).
esOroOPlata(plata).
