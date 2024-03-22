/* Parcial Lógico: Vocaloid 2017 */
/* BASE DE CONOCIMIENTO */
/*
De cada VOCALOID / CANTANTE se conoce:
    NOMBRE
    CANCION QUE SABE CANTAR

De cada CANCION se conoce:
    NOMBRE
    DURACION EN MINUTOS
*/

cantante(megurineLuka).
cantante(hatsuneMiku).
cantante(gumi).
cantante(seeU).
cantante(kaito).

sabeCantar(megurineLuka, cancion(nightFever, 4)).
sabeCantar(megurineLuka, cancion(foreverYoung, 5)).
sabeCantar(hatsuneMiku, cancion(tellYourWorld, 4)).
sabeCantar(gumi, cancion(foreverYoung, 4)).
sabeCantar(gumi, cancion(tellYourWorld, 5)).
sabeCantar(seeU, cancion(novemberRain, 6)).
sabeCantar(seeU, cancion(nightFever, 5)).

% 1:
% esNovedoso(Cantante).
esNovedoso(Cantante) :-
    sabeDosCanciones(Cantante),
    duracionDeCanciones(Cantante, Duracion),
    between(0, 15, Duracion).

% Predicados Auxiliares
% sabeDosCanciones(Vocaloid / Cantante).
sabeDosCanciones(Cantante) :-
    sabeCantar(Cantante, Cancion),
    sabeCantar(Cantante, OtraCancion),
    Cancion \= OtraCancion.

% duracionDeCanciones(Cantante, DuracionDeTodasLasCancionesQueSabe).
duracionDeCanciones(Cantante, Duracion) :-
    cantante(Cantante),
    findall(DuracionCancion, duracionDeCadaCancion(Cantante, DuracionCancion), Total),
    sumlist(Total, Duracion).

% duracionDeCadaCancion(Cantante, DuracionDeCadaCancionQueSabe).
duracionDeCadaCancion(Cantante, Duracion) :- 
    sabeCantar(Cantante, Cancion),
    duracionDeCancion(Cancion, Duracion).

% duracionDeCancion(Cancion, SuDuracion).
duracionDeCancion(cancion(_, Duracion), Duracion).

% 2:
% esAcelerado(Cantante).
esAcelerado(Vocaloid) :-
    vocaloid(Vocaloid, Lista),
    %%member(Cancion, Lista),
    forall((member(Cancion, Lista), cancion(Cancion, Duracion)), Duracion < 4).

% vocaloid(nombreVocaloid, cancion).
vocaloid(megurineLuka, [nightFever1, foreverYoung1]).
vocaloid(hatsuneMiku, [tellYourWorld1]).
vocaloid(gumi, [foreverYoung2, tellYourWorld2]).
vocaloid(seeU, [novemberRain, nightFever2]).

cancion(nightFever1, 2).
cancion(foreverYoung1, 6).
% 4 y 5
cancion(tellYourWorld1, 4).

cancion(foreverYoung2, 4).
cancion(tellYourWorld2, 5).

cancion(novemberRain, 6).
cancion(nightFever2, 5).


/*% SIN FORALL
esAcelerado(Cantante) :- 
    cantante(Cantante),
    not((duracionDeCadaCancion(Cantante, Duracion), Duracion > 4)).

% CON FORALL
esAcelerado2(Cantante) :-
    cantante(Cantante),
    forall(duracionDeCadaCancion(Cantante, Duracion), Duracion < 4).
*/
/* BASE DE CONOCIMIENTO EXTRA */
/*
De cada CONCIERTO se sabe:
    NOMBRE
    LUGAR DONDE SE HACE
    CANTIDAD DE FAMA
    TIPO DE CONCIERTO
        -> GIGANTE:
            Se sabe cantidad minima de canciones que tienen que saber y la duracion 
            de todas las canciones debe ser mayor a una cantidad dada.
        -> MEDIANO:
            Se pide que la duracion total de canciones sea menor a una cantidad dada.
        -> PEQUEÑO:
            Alguna de las canciones debe durar mas de una cantidad dada.  
*/

% 1:
% concierto(Nombre, Lugar, FamaQueOtorga, Tipo).
concierto(mikuEpo, eeuu, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

% 2:
% puedeParticipar(Cantante, Concierto).
puedeParticipar(Cantante, Concierto) :-
    Cantante \= hatsuneMiku,
    cantante(Cantante),
    tipoDeConcierto(Concierto, Tipo),
    cumpleRequisitosSegunTipo(Cantante, Tipo).

puedeParticipar(hatsuneMiku, Concierto) :- concierto(Concierto, _, _, _).

cumpleRequisitosSegunTipo(Cantante, gigante(CantidadMinima, DuracionTotal)) :-
    cantidadCancionesQueSabe(Cantante, Cantidad),
    duracionDeCanciones(Cantante, Duracion),
    Cantidad >= CantidadMinima,
    Duracion > DuracionTotal.

cumpleRequisitosSegunTipo(Cantante, mediano(CantidadMaxima)) :-
    duracionDeCanciones(Cantante, Duracion),
    CantidadMaxima > Duracion.

cumpleRequisitosSegunTipo(Cantante, pequenio(DuracionMinima)) :-
    duracionDeCadaCancion(Cantante, Duracion),
    Duracion > DuracionMinima.

tipoDeConcierto(Concierto, Tipo) :- concierto(Concierto, _, _, Tipo).
cantidadCancionesQueSabe(Cantante, Cantidad) :-
    cantante(Cantante),
    findall(Cancion, sabeCantar(Cantante, Cancion), Canciones),
    length(Canciones, Cantidad).

cantidadDeCanciones(Vocaloid,Cantidad):-
    cantante(Vocaloid),
    findall(Cancion,sabeCantar(Vocaloid, cancion(Cancion,_)),Canciones),
    length(Canciones, Cantidad).
    

cantidadDeCancionesMaxima(Vocaloid,Maximo):-
    cantidadDeCanciones(Vocaloid,CantidadCanciones),
    CantidadCanciones =< Maximo.

cantidadDeCancionesMinima(Vocaloid,Minimo):-
    cantidadDeCanciones(Vocaloid,CantidadCanciones),
    CantidadCanciones >= Minimo.


% 3:
% masFamoso(Cantante).
masFamoso(Cantante) :-
    nivelDeFama(Cantante, NivelMaximo),
    forall((nivelDeFama(OtroCantante, Nivel), OtroCantante \= Cantante), Nivel < NivelMaximo).

nivelDeFama(Cantante, Nivel) :-
    cantidadCancionesQueSabe(Cantante, Cantidad),
    famaTotal(Cantante, FamaTotal),
    Nivel is Cantidad *  FamaTotal.

famaTotal(Cantante, FamaTotal) :-
    cantante(Cantante),
    findall(FamaOtorgada, famaOtorgadaPorConcierto(Cantante, FamaOtorgada), Total),
    sumlist(Total, FamaTotal).

famaOtorgadaPorConcierto(Cantante, FamaOtorgada) :-
    puedeParticipar(Cantante, Concierto),
    concierto(Concierto, _, FamaOtorgada, _).

% 4:
/* BASE DE CONOCIMIENTO EXTRA */
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).

% esElUnico(Cantante).
esElUnico(Cantante) :-
    puedeParticipar(Cantante, Concierto),
    forall(conocido(Cantante, _), not(puedeParticipar(_, Concierto))).
/*
esElUnico2(Cantante) :- 
    puedeParticipar(Cantante, Concierto),
    not((conocido(Cantante, Concierto), puedeParticipar(Conocido, Concierto))).

conocido(Uno, Otro) :- conoce(Uno, Otro).
conocido(Uno, Otro) :-
    conoce(Uno, OtroMas),
    conocido(OtroMas, Otro).
*/
% 5:
/*
En el caso que aparezca un nuevo tipo de concierto, se debe agregar a nuestra
base de conocimiento y, para que nuestra solucion siga funcionando, se debe
agregar el predicado cumpleRequisitosSegunTipo con el cuerpo correspondiente
al predicado. Ejemplo:
    % BASE DE CONOCIMIENTO
    concierto(nombre, pais, 1000, grande(.. requisitos ..)).
    ...

cumpleRequisitosSegunTipo(Cantante, grande(.. requisitos ..)) :-
    % cuerpo del predicado
*/