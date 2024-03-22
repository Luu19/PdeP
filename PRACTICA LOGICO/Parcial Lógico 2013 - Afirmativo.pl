/* Parcial Logico: Afirmativo 2013 */
/* BASE DE CONOCIMIENTO */
% tarea(agente, tarea, ubicacion)
% tareas:
% ingerir(descripcion, tamaño, cantidad)
% apresar(malviviente, recompensa)
% asuntosInternos(agenteInvestigado)
% vigilar(listaDeNegocios)
tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles).
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales]),laBoca).

% Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).

% 1:
agente(A) :- tarea(A, _, _).
tieneTareaEn(Agente, Ubicacion) :- tarea(Agente, _, Ubicacion).
vigila(Lugar, Agente) :-
    tarea(Agente, vigilar(Lugares), _),
    member(Lugar, Lugares).

% frecuenta(Agente, Ubicacion).    
frecuenta(Agente, buenosAires) :- agente(Agente).
frecuenta(vega, quilmes).
frecuenta(Agente, Ubicacion) :- tieneTareaEn(Agente, Ubicacion).
frecuenta(Agente, marDelPlata) :- 
    vigila(negocioDeAlfajores, Agente).

% 2:
% lugarInaccesible(Lugar).
lugarInaccesible(Ubicacion) :- 
    ubicacion(Ubicacion),
    not(frecuenta(_, Ubicacion)).

% 3:
% afincado(Agente).
afincado(Agente) :-
    agente(Agente),
    tieneTareaEn(Agente, Ubicacion)
    not(cambiaDeUbicacion(Agente, Ubicacion)).

/*
ubicacion(Ubicacion)
forall(tarea(Agente, Tarea, _), tarea(Agente, Tarea, Ubicacion)).
*/

cambiaDeUbicacion(Agente, Ubicacion) :-
    tieneTareaEn(Agente, OtraUbicacion),
    Ubicacion \= OtraUbicacion.
    
% 4:
% cadenaDeMando(CadenaDeMandoLista). PREGUNTAR A FEDE!!
cadenaDeMando(CadenaDeMando) :-
    forall(consecutivos(Agente1, Agente2, CadenaDeMando), jefe(Agente1, Agente2)).

consecutivos(Primero, Segundo, Lista) :-
    nth1(PosPrimero, Primero, Lista),
    PosSegundo is PosPrimero + 1,
    nth1(PosSegundo, Segundo, Lista).

% 5:
% agentePremiado(Agente).
agentePremiado(Agente) :-
    agente(Agente),
    puntajeAgente(Agente, MejorPuntaje)
    forall((puntajeAgente(OtroAgente, OtroPuntaje), OtroAgente \= Agente), OtroPuntaje < MejorPuntaje).

puntajeAgente(Agente, Puntaje) :-
    agente(Agente),
    findall(PuntosPorTarea, puntosDeTarea(Agente, PuntosPorTarea), Puntos),
    sumlist(Puntos, Puntaje).

puntosDeTarea(Agente, Puntos) :-
    tarea(Agente, Tarea, _),
    puntosSegun(Tarea, Puntos).

puntosSegun(apresar(_, Puntos), Puntos).

puntosSegun(vigilar(Lugares), Puntos) :- 
    length(Lugares, Largo), Puntos is Largo * 5.

puntosSegun(ingerir(_, Tamaño, Cantidad), Puntos) :- 
    Puntos is - 10 * (Tamaño * Cantidad).

puntosSegun(asuntosInternos(AgenteInvestigado), Puntos) :- 
    puntajeAgente(AgenteInvestigado, OtrosPuntos),
    Puntos is 2 * OtrosPuntos.