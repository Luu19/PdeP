/* Parcial Lógico: Café Veloz 2011 */
/* BASE DE CONOCIMIENTO */
% jugadores conocidos 
jugador(maradona). 
jugador(chamot). 
jugador(balbo). 
jugador(caniggia). 
jugador(passarella). 
jugador(pedemonti). 
jugador(basualdo).

% relaciona lo que toma cada jugador 
tomo(maradona, sustancia(efedrina)). 
tomo(maradona, compuesto(cafeVeloz)). 
tomo(caniggia, producto(cocacola, 2)). 
tomo(chamot, compuesto(cafeVeloz)). 
tomo(balbo, producto(gatoreit, 2)). 

% relaciona la máxima cantidad de un producto que 1 jugador puede ingerir 
maximo(cocacola, 3). 
maximo(gatoreit, 1). 
maximo(naranju, 5).

% relaciona las sustancias que tiene un compuesto 
composicion(cafeVeloz, [efedrina, ajipupa, extasis, whisky, cafe]). 

% sustancias prohibidas por la asociación 
sustanciaProhibida(efedrina). 
sustanciaProhibida(cocaina). 

% 1:
% a-
tomo(passarella, Algo) :- 
    tomo(_, Algo),
    not(tomo(maradona, Algo)).

% b-
tomo(pedemonti, Algo) :- tomo(pedemonti, Algo).
tomo(pedemonti, Algo) :- tomo(maradona, Algo).

% c-
tomo(basualdo, Algo) :-
    tomo(_, Algo),
    Algo \= cocacola.

% 2:
% puedeSerSuspendido(Jugador).
puedeSerSuspendido(Jugador) :-
    tomo(Jugador, LoQueTomo),
    requisitosDeSuspensionSegun(LoQueTomo).

requisitosDeSuspensionSegun(sustancia(Sustancia)) :- sustanciaProhibida(Sustancia).

requisitosDeSuspensionSegun(producto(Producto, Cantidad)) :-
    maximo(Producto, Maximo),
    Cantidad > Maximo.

requisitosDeSuspensionSegun(compuesto(Compuesto)) :- 
    composicion(Compuesto, Ingredientes),
    member(Contiene, Ingredientes),
    sustanciaProhibida(Contiene).

% 3:
/* BASE DE CONOCIMIENTO EXTRA */
amigo(maradona, caniggia). 
amigo(caniggia, balbo).
amigo(balbo, chamot). 
amigo(balbo, pedemonti).

% malaInfluencia(Jugador, OtroJugador).
malaInfluencia(Jugador, OtroJugador) :-
    puedeSerSuspendido(Jugador),
    puedeSerSuspendido(OtroJugador),
    seConocen(Jugador, OtroJugador).

% teniendo en cuenta que la relacion de amistad no es simétrica el predicado sería:
seConocen(Jugador, OtroJugador) :-
    amigo(Jugador, OtroJugador).

seConocen(Jugador, OtroJugador) :-
    amigo(Jugador, UnJugador),
    seConocen(UnJugador, OtroJugador).

% 4:
/* BASE DE CONOCIMIENTO EXTRA */
atiende(cahe, maradona). 
atiende(cahe, chamot). 
atiende(cahe, balbo). 
atiende(zin, caniggia). 
atiende(cureta, pedemonti). 
atiende(cureta, basualdo). 

% chanta(Medico).
chanta(Medico) :-
    atiende(Medico, _),
    forall(atiende(Medico, Jugador), puedeSerSuspendido(Jugador)).

% 5:
/* BASE DE CONOCIMIENTO EXTRA */
nivelFalopez(efedrina, 10). 
nivelFalopez(cocaina, 100). 
nivelFalopez(extasis, 120). 
nivelFalopez(omeprazol, 5).

% cuantaFalopaTiene(Jugador, Cuanto).
cuantaFalopaTiene(Jugador, Cuanto) :-
    jugador(Jugador),
    findall(NivelAlteracion, calculoNivel(Jugador, NivelAlteracion), Niveles),
    sumlist(Niveles, Cuanto).

calculoNivel(Jugador, Nivel) :-
    tomo(Jugador, Algo),
    nivelSegunLoQueTomo(Algo, Nivel).

nivelSegunLoQueTomo(sustancia(Sustancia), Nivel) :- nivelFalopez(Sustancia, Nivel).
nivelSegunLoQueTomo(producto(_, _), 0).
nivelSegunLoQueTomo(compuesto(Compuesto), Nivel) :-
    composicion(Compuesto, Ingredientes),
    findall(NivelDeSustancia, nivelDeCadaSustancia(Ingredientes, NivelDeSustancia), Niveles),
    sumlist(Niveles, Nivel).

nivelDeCadaSustancia(Ingredientes, Nivel) :-
    member(Sustancia, Ingredientes),
    sustanciaProhibida(Sustancia), 
    nivelFalopez(Sustancia, Nivel).

% 6:
% medicoConProblemas(Medico).
medicoConProblemas(Medico) :-
    atiende(Medico, _),
    findall(Jugador, atiendeJugadorConflictivo(Medico, Jugador), Jugadores),
    length(Jugadores, Cuantos),
    Cuantos > 3.

atiendeJugadorConflictivo(Medico, Jugador) :- 
    atiende(Medico, Jugador),
    esConflictivo(Jugador).

esConflictivo(Jugador) :- puedeSerSuspendido(Jugador).
esConflictivo(Jugador) :- seConocen(Jugador, maradona).
esConflictivo(Jugador) :- seConocen(maradona, Jugador).

% 7:
% programaTVFantinesco(Jugadores).
programaTVFantinesco(Suspendidos) :-
    findall(Jugador, jugador(Jugador), Jugadores),
    posiblesJugadores(Jugadores, Suspendidos).

posiblesJugadores([], []).
posiblesJugadores([Jugador | Jugadores], [Jugador | Suspendidos]) :-
    puedeSerSuspendido(Jugador),
    posiblesJugadores(Jugador, Suspendidos).

posiblesJugadores([_ | Jugadores], Suspendidos) :-
    posiblesJugadores(Jugadores, Suspendidos).

