/*  Parcial Logico : Las casas de Hogwarts 2020 */
/*  BASE DE CONOCIMIENTO    */
mago(harry).
mago(draco).
mago(hermione).

casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).
casa(gryffindor).

% tipoSangre(Mago, SuTipoDeSangre).
tipoSangre(harry, mestiza).
tipoSangre(draco, pura).
tipoSangre(hermione, impura).

% personalidad(Mago, CaracteristicaDeSuPersonalidad).
personalidad(harry, coraje).
personalidad(harry, amistoso).
personalidad(harry, orgullo).
personalidad(harry, inteligencia).

personalidad(draco, inteligencia).
personalidad(draco, orgullo).

personalidad(hermione, inteligencia).
personalidad(hermione, orgulloso).
personalidad(hermione, responsabilidad).

% noQuiereIr(Mago, CasaQueOdiariaIr).
noQuiereIr(harry, slytherin).
noQuiereIr(draco, hufflepuff).

% esImportante(Casa, CaracteristicaImportante).
esImportante(gryffindor, coraje).

esImportante(slytherin, orgullo).
esImportante(slytherin, inteligencia).

esImportante(ravenclaw, inteligencia).
esImportante(ravenclaw, responsabilidad).

esImportante(hufflepuff, amistoso).

    %%% PARTE 1 %%%
% 1:
% permiteEntrar(Casa, Mago).
permiteEntrar(Casa, Mago) :-
    casa(casa),
    mago(mago),
    casa \= slytherin.

permiteEntrar(slytherin, Mago) :-
    tipoSangre(Mago, pura).

% 2:
% tieneCaracterApropiado(Mago, Casa).
tieneCaracterApropiado(Mago, Casa) :-
    mago(Mago),
    casa(Casa),
    forall(esImportante(Casa, Caracteristica), personalidad(Mago, Caracteristica)).

% 3:
% podriaQuedarSeleccionado(Casa, Mago).
podriaQuedarSeleccionado(Casa, Mago) :-
    tieneCaracterApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(noQuiereIr(Mago, Casa)),
    Mago  \= hermione.

podriaQuedarSeleccionado(hermione, gryffindor).

% 4:
% cadenaDeAmistades(ListaDeMagos).
cadenaDeAmistades(Magos) :-
    sonTodosAmistosos(Magos),
    cadenaDeCasas(Magos).

sonTodosAmistosos(Magos) :-
    forall(member(Mago, Magos), personalidad(Mago, amistoso)).

cadenaDeCasas(Magos) :-
    forall(consecutivos(Mago1, Mago2, Magos), quedanEnLaMismaCasa(Mago1, Mago2)).

consecutivos(Mago1, Mago2, Magos) :-
    nth1(Anterior, Magos, Mago1),
    Siguiente Anterior + 1,
    nth1(Siguiente, Magos, Mago2).

quedanEnLaMismaCasa(Mago1, Mago2) :-
    podriaQuedarSeleccionado(Casa, Mago1),
    podriaQuedarSeleccionado(Casa, Mago2).

    %%% PARTE 2 %%%
/*  BASE DE CONOCIMIENTO EXTRA  */
/*
Se sabe que:
    Malas Acciones 
        -> ANDAR FUERA DE NOCHE --> RESTA 50 ptos
        -> IR A LUGAR PROHIBIDO --> RESTA XX ptos
            -> BOSQUE 50 ptos
            -> SECCION RESTRINGIDA DE LA BIBLIOTECA 10 ptos
            -> 3ER PISO 75 ptos

    Buenas Acciones
        RECONOCIDAS x PROFESORES Y PREFECTOS DEPENDE DE C/ ACCION
*/
% esDe(Mago, CasaEnLaQueQuedo).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

lugarProhibido(bosque).
lugarProhibido(seccionRestringida).
lugarProhibido(tercerPiso).

% malaAccion(Accion).
malaAccion(andarFueraDeCama).

malaAccion(visitar(Lugar)) :-
    lugarProhibido(Lugar).

restaAccionMala(visitar(bosque), 50).
restaAccionMala(visitar(seccionRestringida), 10).
restaAccionMala(visitar(tercerPiso), 75).
restaAccionMala(andarFueraDeCama, 50).

% hizo(Mago, Accion).
hizo(harry, andarFueraDeCama).
hizo(hermione, visitar(tercerPiso)).
hizo(hermione, visitar(seccionRestringida)).
hizo(harry, visitar(bosque)).
hizo(harry, visitar(tercerPiso)).
hizo(draco, visitar(mazmorras)).
hizo(ron, buenaAccion(ganarAjedrez, 50)).
hizo(hermione, buenaAccion(salvarAmigos, 50)).
hizo(harry, buenaAccion(ganarAVoldemort, 60)).

% 1:
% a:
% esBuenAlumno(Mago).
esBuenAlumno(Mago) :-
    mago(Mago),
    hizoAlgunaAccion(Mago),
    forall(hizo(Mago, Accion), not(restaPuntos(Accion, _))).

hizoAlgunaAccion(Mago) :- hizo(Mago, _).

% restaPuntos(Accion, PuntosARestar).
restaPuntos(Accion, Puntos) :-
    restaAccionMala(Accion, PuntosQueResta),
    Puntos is -1 * PuntosQueResta.

% b:
% esRecurrente(Accion).
esRecurrente(Accion) :-
    hizo(Mago, Accion),
    hizo(OtroMago, Accion),
    Mago \= OtroMago.

% 2:
puntajeTotal(Casa, PuntajeTotal) :-
    casa(Casa),
    findall(PuntosMiembro, puntajeDeMiembroCasa(Casa, PuntosMiembro), Puntos),
    sumlist(Puntos, PuntajeTotal).

puntajeDeMiembroCasa(Casa, Puntos) :- 
    esDe(Mago, Casa),
    findall(Puntaje, puntosAccion(Mago, Puntaje), Puntajes),
    sumlist(Puntajes, Puntos).

puntosAccion(Mago, Puntos) :-
    hizo(Mago, Accion),
    puntosSegunAccion(Accion, Puntos).

puntosSegunAccion(buenaAccion(_, Puntos), Puntos).
puntosSegunAccion(Accion, Puntos) :-
    malaAccion(Accion),
    restaPuntos(Accion, Puntos).

% 3:
% casaGanadora(Casa).
casaGanadora(Casa) :-
    casa(Casa),
    puntajeTotal(Casa, PuntajeMaximo),
    forall((puntajeTotal(OtraCasa, OtroPuntaje), OtraCasa \= Casa), OtroPuntaje < PuntajeMaximo).

% 4:
% responde(Pregunta, Dificultad, Profesor).
hizo(hermione, responde(dondeViveBezoar, 20, snape)).

puntosSegunAccion(responde(_, Puntos, Profesor), Puntos) :- Profesor \= snape.
puntosSegunAccion(responde(_, Dificultad, snape), Puntos) :- Puntos is Dificultad / 2.