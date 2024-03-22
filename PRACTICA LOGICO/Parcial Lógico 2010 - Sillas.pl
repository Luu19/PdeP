/* Parcial Lógico: El Juego de las Sillas 2010 */
/* BASE DE CONOCIMIENTO */
% de cada persona se conocen sus amigos.
amigo(juan, alberto).
amigo(juan, pedro).
amigo(pedro,mirta).
amigo(alberto, tomas).
amigo(tomas,mirta).

% ...y sus enemigos.
enemigo(mirta,ana).
enemigo(juan,nestor).
enemigo(juan,mirta).

% Para cada fiesta tenemos las mesas conformadas
% Para modelar una mesa vamos a usar un functor que tiene número de mesa y una lista de comensales.
mesaArmada(navidad2010,mesa(1,[juan,mirta,ana,nestor])).
mesaArmada(navidad2010,mesa(5,[andres,german,ludmila,elias])).
mesaArmada(navidad2010,mesa(8,[nestor,pedro])).

% 1:
% se modela el predicado persona teniendo en cuenta que la relacion enemigo y amigo no es simetrica.
persona(Persona) :- amigo(Persona, _).
persona(Persona) :- enemigo(Persona, _).

% estaSentadaEn(Persona, Mesa).
estaSentadaEn(Persona, Mesa) :-
    persona(Persona),
    comensalesDeUnaMesa(Mesa, Comensales),
    member(Persona, Comensales).

comensalesDeUnaMesa(mesa(_, Comensales), Comensales).
mesa(mesa(_, _)).

% 2:
% sePuedeSentar(Persona, Mesa).
sePuedeSentar(Persona, Mesa) :-
    persona(Persona),
    mesa(Mesa),
    hayAmigoEnLaMesa(Persona, Mesa),
    not(hayEnemigosEnLaMesa(Persona, Mesa)).

hayAmigoEnLaMesa(Persona, Mesa) :-
    amigo(Persona, Amigo),
    estaSentadaEn(Amigo, Mesa).

hayEnemigoEnLaMesa(Persona, Mesa) :-
    enemigo(Persona, Enemigo),
    estaSentadaEn(Enemigo, Mesa).

% 3:
% mesaDeCumpleañero(Cumpleañero, SuMesa).
mesaDeCumpleañero(Persona, MesaDeCumpleañero) :-
    numeroMesa(1, MesaDeCumpleañero),
    mesa(Mesa),

    forall(amigo(Persona, Amigo), estaSentadaEn(Amigo, Mesa)),

    comensalesDeUnaMesa(Mesa, Comensales),
    comensalesDeUnaMesa(MesaDeCumpleañero, Comensales1),

    append([Persona], Comensales, Comensales1).

numeroMesa(Numero, mesa(Numero, _)).

% 4:
% incompatible(Persona, OtraPersona).
incompatible(Persona, OtraPersona) :- 
    amigo(Persona, AmigoDeUno),
    enemigo(OtraPersona, AmigoDeUno).


% 5:
% laPeorOpcion(Persona, Mesa).
laPeorOpcion(Persona, Mesa) :-
    persona(Persona),
    mesa(Mesa),
    forall(estaSentadaEn(Alguien, Mesa), enemigo(Alguien, Persona)).

% 6:
% mesasPlanificadas(Fiesta, MesasPlanificadas).
mesasPlanificadas(Fiesta, MesasPlanificadas) :-
    findall(Mesa, mesa(Mesa), Mesas),
    planificadas(Fiesta, Mesas, MesasPlanificadas).

planificadas(_, [], []).
planificadas(Fiesta, [Mesa | Mesas], [Mesa | Planificadas]) :-
    mesaArmada(Fiesta, Mesa),
    planificadas(Fiesta, Mesas, Planificadas).

planificadas(Fiesta, [_,| Mesas], Planificadas) :-
    planificadas(Fiesta, Mesas, Planificadas).

% 7:
% esViable(ListaDeMesas).
esViable(Mesas) :-
    numerosDeMesaCorrectos(Mesas),
    hayCuatroEnCadaMesa(Mesas),
    noHayEnemigosEnLasMesas(Mesas),
    length(Mesas, Numero),
    Numero \= 0.

hayCuatroEnCadaMesa(Mesas) :-
    forall(member(Mesa, Mesas), cantidadComensales(Mesa, 4)).

cantidadComensales(mesa(_, Comensales), Cuantos) :- length(Comensales, Cuantos).

noHayEnemigosEnLasMesas(Mesas) :-
    forall(member(Mesa, Mesas), not(hayEnemigosEnLaMesa(Mesa))).

numerosDeMesaCorrectos(Mesas) :-
    length(Mesas, Total),
    forall(member(Mesa, Mesas), (numeroMesa(Numero, Mesa), between(1, Total, Numero))).

hayEnemigosEnLaMesa(Mesa) :-
    estaSentadaEn(Persona, Mesa),
    estaSentadaEn(OtraPersona, Mesa),
    enemigos(Persona, OtraPersona),
    Persona \= OtraPersona.

