/* Parcial Lógico: La Cárcel 2017 */
/* BASE DE CONOCIMIENTO */
/*
De los GUARDIAS se conoce:
    NOMBRE

De los PRISIONEROS se conoce:
    NOMBRE
    CRIMENES 
        -> homicidio(VICTIMA)
        -> narcotrafico(LISTA DE DROGAS)
        -> robo(SUMA DE DINERO)
*/
% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).

% prisionero(Nombre, Crimen)
prisionero(piper, narcotráfico([metanfetaminas])).
prisionero(alex, narcotráfico([heroína])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(2500)).
prisionero(dayanara, narcotráfico[heroína, opio])).
prisionero(dayanara, narcotráfico([metanfetaminas])).

% 1:
% controla(Controlador, Controlado)
controla(piper, alex).
controla(bennett, dayanara).
controla(Guardia, Otro):- 
    prisionero(Otro,_), 
    guardia(Guardia),
    not(controla(Otro, Guardia)).

% 2:
% conflictoDeIntereses(Persona, OtraPersona).
conflictoDeIntereses(Persona, OtraPersona) :-
    controla(Persona, Tercero),
    controla(OtraPersona, Tercero),
    not(controla(Persona, OtraPersona)),
    not(controla(OtraPersona, Persona)),
    Persona \= OtraPersona.

% 3:
% peligroso(Preso).
peligroso(Preso) :-
    esPreso(Preso),
    forall(prisionero(Preso, Crimen), esGrave(Crimen)).

esGrave(homicidio(_)).
esGrave(narcotrafico(Drogas)) :- esGraveSegun(Drogas).

esGraveSegun(Drogas) :- member(metanfetaminas, Drogas).
esGraveSegun(Drogas) :- length(Drogas, Cantidad), Cantidad >= 5.

esPreso(P) :- prisionero(P, _).

% 4:
% ladronDeGuanteBlanco(Prisionero).
ladronDeGuanteBlanco(Preso) :-
    esPreso(Preso),
    forall(prisionero(Preso, Crimen), crimenDeGuanteBlanco(Crimen)).

crimenDeGuanteBlanco(robo(Monto)) :- Monto > 100000.

% 5:
% condena(Preso, Condena).
condena(Preso, Condena) :-
    esPreso(Preso),
    findall(Anios, aniosDeCondenaPorCrimen(Preso, Anios), TotalAnios),
    sumlist(TotalAnios, Condena).

aniosDeCondenaPorCrimen(Preso, Anios) :-
    prisionero(Preso, Crimen),
    condenaSegunCrimen(Crimen, Anios).

condenaSegunCrimen(robo(Monto), Anios) :- Anios is Monto / 10000.
condenaSegunCrimen(narcotrafico(Drogas), Anios) :- length(Drogas, Cantidad), Anios is Cantidad * 2.
condenaSegunCrimen(homicidio(Quien), 9) :- guardia(Quien).
condenaSegunCrimen(homicidio(Quien), 7) :- not(guardia(Quien)).

% 6:
% capoDiTutiLiCapi(Capo).
capoDiTutiLiCapi(Capo) :- 
    esPreso(Capo),
    nadieLoControla(Capo),
    controlaATodos(Capo).

nadieLoControla(Capo) :- 
    not(controla(_, Capo)).

controlaATodos(Capo) :-
    forall(persona(Persona), controlaCapo(Capo, Persona)).

persona(P) :- guardia(P).
persona(P) :- esPreso(P).

controlaCapo(Capo, Persona) :- 
    controla(Capo, Persona).

controlaCapo(Capo, Persona) :- 
    controla(Capo, OtraPersona),
    controlaCapo(OtraPersona, Persona).