/* Parcial Lógico: Game Over 2018 */
/* BASE DE CONOCIMIENTO */
/*
De cada JUEGO se conoce:
    NOMBRE
    GENERO

Los GENEROS son:
    -> AVENTURA, tiene un objetivo
    -> INGENIO, tiene nivel de ingenio
    -> ACCION, tiene la plataforma en la que se desarrolla y el numero de jugadores
*/
% 1:
juego(marioBros, aventura(rescatarAPrincesa)).
juego(sonic, aventura(rescatarAnimales)).
juego(tetris, ingenio(200)).
juego(bomberman, ingenio(100)).
juego(bomberman, accion(cuadrilatero, 8)).

% 2:
% juegosMismoGenero(UnJuego, OtroJuego).
juegosMismoGenero(UnJuego, OtroJuego) :-
    generoJuego(UnJuego, Genero),
    generoJuego(OtroJuego, Genero).

generoJuego(NombreJuego, Genero) :-
    juego(NombreJuego, GeneroJuego),
    genero(GeneroJuego, Genero).

genero(aventura(_), aventura).
genero(ingenio(_), ingenio).
genero(accion(_, _), accion).

% 3:
% generoDificil(Genero).
generoDificil(aventura(_)).
generoDificil(ingenio(Nivel)) :- Nivel > 100.
generoDificil(accion(_, Jugadores)) :- between(4, 8, Jugadores).

% 4:
% juegoDificil(Juego).
juegoDificil(Juego) :- 
    esJuego(Juego),
    forall(juego(Juego, Genero), generoDificil(Genero)).

esJuego(J) :- juego(J, _).

% 5:
% juegosPopulares(Juegos).
juegosPopulares(JuegosPopulares) :-
    findall(Juego, esJuego(Juego), Juegos),
    posiblesJuegosPopulares(Juegos, JuegosPopulares).

posiblesJuegosPopulares([], []).
posiblesJuegosPopulares([Juego | Juegos], [Juego | Posibles]) :-
    not(juegoDificil(Juego)),
    posiblesJuegosPopulares(Juegos, Posibles).

posiblesJuegosPopulares([_|Juegos], Posibles) :-
    posiblesJuegosPopulares(Juegos, Posibles).

% 6:
% generoAExpandir(Genero).
% teniendo en cuenta que por GENERO se refiere al NOMBRE DEL GENERO y no al FUNCTOR
generoAExpandir(Genero) :-
    esGenero(Genero),
    cantidadJuegosRegistrados(Genero, CantidadMin),
    forall((cantidadJuegosRegistrados(Otro, Cantidad), Otro \= Genero), CantidadMin < Cantidad).

cantidadJuegosRegistrados(Genero, Cantidad) :-
    esGenero(Genero),
    findall(Juego, generoJuego(Juego, Genero), Juegos),
    length(Juegos, Cantidad).

esGenero(G) :- genero(_, Genero).

/* SUPER MULTIJUGADOR */
/* BASE DE CONOCIMIENTO EXTRA */
personajesSecundarios(sonic, [tails, knuckles]).
personajesSecundarios(marioBros, [luigi, bowser, peach]).
personajesSecundarios(bomberman, [bombermanNegro, regulus, altair, pommy, orion]).
% ...

% 7:
% superMultijugador(Juego).
superMultijugador(Juego) :-
    cantidadDePersonajes(Juego, CantidadMaxima),
    forall((cantidadDePersonajes(Otro, Cantidad), Otro \= Juego), Cantidad < CantidadMaxima).

cantidadDePersonajes(Juego, Cantidad) :-
    personajesSecundarios(Juego, Personajes),
    length(Personajes, CantidadPersonajesSecundarios),
    Cantidad is CantidadPersonajesSecundarios + 1.

/* SUCESOR */
/* BASE DE CONOCIMIENTO EXTRA */
sucesor(marioBros, superMario).
sucesor(superMario, marioNintendo64).
sucesor(marioNintendo64, superMarioGalaxy).

% 8:
% esSaga(UnJuego, OtroJuego).
esSaga(UnJuego, JuegoSaga) :-
    sucesor(JuegoSaga, UnJuego).

esSaga(UnJuego, JuegoSaga) :-
    sucesor(OtroJuego, UnJuego),
    esSaga(OtroJuego, JuegoSaga).

% 9:
/*
Se pueden realizar solo consultas individuales debido a que Juego ni Juegos
no están ligados.
*/