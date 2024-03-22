/* Parcial Logico: Papá Noel 2019 */

% creeEnPapaNoel(Persona).
creeEnPapaNoel(Persona) :-
    esNiño(Persona).
creeEnPapaNoel(federico).

esNiño(Persona) :-
    persona(Persona, Edad),
    Edad < 13.

% 1:
% buenaAccion(Accion).
buenaAccion(favor(_)).
buenaAccion(ayuda(_)).
buenaAccion(travesura(Nivel)) :- Nivel =< 3.

% 2:
% sePortoBien(Persona).
sePortoBien(Persona) :-
    esPersona(Persona),
    forall(accion(Persona, Accion), buenaAccion(Accion)).

esPersona(P) :- persona(Persona, _).

% 3:
% malcriador(Padre).
malcriador(Padre) :-
    esPadre(Padre),
    forall(padre(Padre, Hijo), esMalcriado(Hijo)).

esPadre(P) :- padre(P, _).
esMalcriado(Persona) :-
    accion(Persona, Accion),
    not(buenaAccion(Accion)).

esMalcriado(Persona) :- 
    esPersona(Persona),
    not(creeEnPapaNoel(Persona)).

% 4:
% puedeCostear(Padre, Hijo).
puedeCostear(Padre, Hijo) :-
    padre(Padre, Hijo),
    forall(quiere(Hijo, Regalo), puedePagar(Padre, Regalo)).

puedePagar(Padre, Regalo) :-
    precioSegunRegalo(Regalo, Precio),
    presupuesto(Padre, Presupuesto),
    Precio < Presupuesto.

precioSegunRegalo(abrazo, 0).
precioSegunRegalo(juguete(_, Precio), Precio).
precioSegunRegalo(bloques(Piezas), Precio) :- length(Piezas, Total), Precio is Total * 3.

% 
puedeCostear2(Padre, Hijo) :- 
    padre(Padre, Hijo),
    findall(Precio, precioPorRegalo(Hijo, Precio), Precios),
    sumlist(Precios, Total),
    presupuesto(Padre, Presupuesto),
    Total < Presupuesto.

precioPorRegalo(Hijo, Precio) :-
    quiere(Hijo, Regalo),
    precioSegunRegalo(Regalo, Precio).

% 5:
% regaloCandidatoPara(Regalo, Candidato).
regaloCandidatoPara(Regalo, Candidato) :-
    sePortoBien(Candidato),
    padre(Padre, Candidato),
    puedePagar(Padre, Regalo),
    quiere(Candidato, Regalo),
    creeEnPapaNoel(Candidato).

% 6:
% regalosQueRecibe(Persona, Regalos).
regalosQueRecibe(Persona, Regalos) :-
    padre(Padre, Persona),
    recibeRegalosSegun(Padre, Persona, Regalos).

recibeRegalosSegun(Padre, Persona, Regalos) :-
    puedeCostear(Padre, Persona),
    forall(quiere(Persona, Regalo), member(Regalo, Regalos)).
    /*
    findall(Regalo, quiere(Persona, Regalo), Regalos).
    */
recibeRegalosSegun(Padre, Persona, Regalos) :-
    not(puedeCostear(Padre, Persona)),
    regalosSegun(Persona, Regalos).

regalosSegun(Persona, [medias(blancas), medias(grises)]) :- sePortoBien(Persona).
regalosSegun(Persona, [carbon]) :-
    accion(Persona, Accion),
    accion(Persona, OtraAccion),
    Accion \= OtraAccion,
    malaAccion(Accion),
    malaAccion(OtraAccion).

malaAccion(Accion) :-
    accion(_, Accion),
    not(buenaAccion(Accion)).

% 7:
% suggarDaddy(Padre).
suggarDaddy(Padre) :-
    esPadre(Padre),
    forall(padre(Padre, Hijo), quiereRegaloCaroOQueValeLaPena(Hijo)).

quiereRegaloCaroOQueValeLaPena(Hijo) :-
    quiere(Hijo, Regalo),
    caroOValeLaPena(Regalo).

caroOValeLaPena(Regalo) :-  esCaro(Regalo).
caroOValeLaPena(Regalo) :- valeLaPena(Regalo).

esCaro(Regalo) :- 
    precioSegunRegalo(Regalo, Precio),
    Precio > 500.

valeLaPena(juguete(Nombre, _)) :- esBuzzOWoody(Nombre).
valeLaPena(bloques(Piezas)) :- member(cubo, Piezas).

esBuzzOWoody(buzz).
esBuzzOWoody(woody).