% TRABAJO PRACTICO : Potencial Rebelde

%% PUNTO 1 : Personas
/* BASE DE CONOCIMIENTO */
trabajaEn(bakunin, aviacionMilitar).
esBuenoEn(bakunin, conduciendoAutos).
historialCriminal(bakunin, roboDeAeronaves).
historialCriminal(bakunin, fraude).
historialCriminal(bakunin, tenenciaDeCafeina).

trabajaEn(ravachol, inteligenciaMilitar).
leGusta(ravachol, juegosDeAzar).
leGusta(ravachol, ajedrez).
leGusta(ravachol, tiroAlBlanco).
esBuenoEn(ravachol, tiroAlBlanco).
historialCriminal(ravachol, falsificacionDeVacunas).
historialCriminal(ravachol, fraude).

leGusta(rosaDubovsky, mirarPeppaPig).
leGusta(rosaDubovsky, construirPuentes).
leGusta(rosaDubovsky, fisicaCuantica).
esBuenoEn(rosaDubovsky, construyendoPuentes).
esBuenoEn(rosaDubovsky, mirarPeppaPig).

trabajaEn(emmaGoldman, profesoraDeJudo).
trabajaEn(emmaGoldman, cineasta).
leGusta(emmaGoldman, LeGusta) :-
    leGusta(elisaBachofen, LeGusta).
esBuenoEn(emmaGoldman, EsBuena) :-
    esBuenoEn(judithButler, EsBuena).

trabajaEn(judithButler, profesoraDeJudo).
trabajaEn(judithButler, inteligenciaMilitar).
leGusta(judithButler, judo).
leGusta(judithButler, carrerasDeAutomovilismo).
esBuenoEn(judithButler, judo).
historialCriminal(judithButler, falsificacionDeCheques).
historialCriminal(judithButler, fraude).

trabajaEn(elisaBachofen, ingenieraMecanica).
leGusta(elisaBachofen, fuego).
leGusta(elisaBachofen, destruccion).
esBuenoEn(elisaBachofen, armarBombas).

leGusta(juanSuriano, judo).
leGusta(juanSuriano, armarBombas).
leGusta(juanSuriano, ringRaje).
esBuenoEn(juanSuriano, judo).
esBuenoEn(juanSuriano, armarBombas).
esBuenoEn(juanSuriano, ringRaje).
historialCriminal(juanSuriano, falsificacionDeDinero).
historialCriminal(juanSuriano, fraude).

personaje(bakunin).
personaje(ravachol).
personaje(rosaDubovsky).
personaje(emmaGoldman).
personaje(judithButler).
personaje(elisaBachofen).
personaje(juanSuriano).
personaje(sebastienFaure).


%% PUNTO 2 : Viviendas
vivienda(Vivienda) :-
    viveEn(Vivienda, _).

vivenEn(laSeverino, [bakunin, elisaBachofen, rosaDubovsky]).
vivenEn(comisaria48, [ravachol]).
vivenEn(casaDePapel, [emmaGoldman, juanSuriano, judithButler]).
vivenEn(casaDelSolNaciente, []).

viveEn(Persona, Vivienda) :-
    viveEn(Vivienda, Habitantes),
    member(Persona, Habitantes).

cuartosDeUnaVivienda(laSeverino, cuartoSecreto(4, 8)).
cuartosDeUnaVivienda(laSeverino, pasadizo).
cuartosDeUnaVivienda(laSeverino, tunel(8, construido)).
cuartosDeUnaVivienda(laSeverino, tunel(5, construido)).
cuartosDeUnaVivienda(laSeverino, tunel(1, enConstruccion)).

cuartosDeUnaVivienda(casaDePapel, pasadizo).
cuartosDeUnaVivienda(casaDePapel, pasadizo).
cuartosDeUnaVivienda(casaDePapel, cuartoSecreto(5, 3)).
cuartosDeUnaVivienda(casaDePapel, cuartoSecreto(4, 7)).
cuartosDeUnaVivienda(casaDePapel, tunel(9, construido)).
cuartosDeUnaVivienda(casaDePapel, tunel(2, construido)).

cuartosDeUnaVivienda(casaDelSolNaciente, pasadizo).


%% PUNTO 3 : Guaridas rebeldes
esGuaridaRebelde(Vivienda) :-
    viveEn(Disidente, Vivienda),
    esPosibleDisidente(Disidente),
    superficieVivienda(Vivienda, Superficie),
    Superficie > 50.

%superficieCuarto(cuarto, metrosCuadrados).
superficieCuarto(cuartoSecreto(Alto, Ancho), Superficie) :-
    Superficie is Alto * Ancho.

%superficieCuarto(pasadizo, metrosCuadrados).
superficieCuarto(pasadizo, 1).

%superficieCuarto(tunel, metrosCuadrados)
superficieCuarto(tunel(Metros, construido), Superficie) :-
    Superficie is Metros *2.

superficieVivienda(Vivienda, Total) :-
    vivienda(Vivienda),
    findall(Calculo, superficieDeUnCuartoDeUnaVivienda(Vivienda, Calculo), Calculos),
    sumlist(Calculos, Total).

superficieDeUnCuartoDeUnaVivienda(Vivienda, TotalSuperficie) :- 
    cuartosDeUnaVivienda(Vivienda, CuartoEspecial), 
    superficieCuarto(CuartoEspecial, TotalSuperficie).

%% PUNTO 4 : Aqui no hay quien viva
viviendaVacia(Vivienda) :-
    vivenEn(Vivienda, []).

tienenGustoEnComun(Vivienda) :-
    vivienda(Vivienda),
    leGusta(_, Gusto),
    forall(viveEn(Persona, Vivienda), leGusta(Persona, Gusto)).

%% PUNTO 5 : Rebelde
%%esPosibleDisidente(Persona).
esPosibleDisidente(Persona) :-
    personaje(Persona),
    tieneHabilidadTerrorista(Persona),
    gustosRebeldes(Persona),
    registroCriminal(Persona).

%%esHabilidadTerrorista(Habilidad).
esHabilidadTerrorista(tiroAlBlanco).
esHabilidadTerrorista(mirarPeppaPig).
esHabilidadTerrorista(armarBombas).

%%viveConUnCriminal(Persona).
viveConUnCriminal(Persona) :-
    vivenEn(Persona, Vivienda),
    personaje(Persona2),
    Persona2 \= Persona,
    viveEn(Persona2, Vivienda),
    esCriminal(Persona2).

%%esCriminal(Persona).
esCriminal(Persona) :-
    personaje(Persona),
    findall(Crimen, historialCriminal(Persona, Crimen), Crimenes),
    length(Crimenes, Largo),
    Largo > 1.

%%tieneHabilidadTerrorista(Persona).
tieneHabilidadTerrorista(Persona) :-
    esBuenoEn(Persona, Habilidad),
    esHabilidadTerrorista(Habilidad).

%%gustosRebeldes(Persona).
gustosRebeldes(Persona) :-
    personaje(Persona),
    forall(esBuenoEn(Persona, Gusto), leGusta(Persona, Gusto)).

%%registroCriminal(Persona).
registroCriminal(Persona) :-
    esCriminal(Persona).

registroCriminal(Persona) :- 
    viveConUnCriminal(Persona).


%% PUNTO 6 :  Bunkers
% En nuestra solucion actual se deberia agregar el nuevo ambiente, es decir agregar un cuartoDeVivienda(Vivienda, nuevoCuarto(...)), y ademas
% para el predicado superficieVivienda se debe agregar el calculo de la superficie total del ambiente, esto significa agregar un predicado de superficieCuarto(nuevoCuarto(...), Total).

viveEn(laCasaDePatricia, [sebastienFaure]).

cuartosDeUnaVivienda(laCasaDePatricia, pasadizo).
cuartosDeUnaVivienda(laCasaDePatricia, bunker(2,10)).

superficieCuarto(bunker(SuperficieInterna, PerimetroAcceso), Superficie) :-
    Superficie is SuperficieInterna + PerimetroAcceso.

%% PUNTO 7 : Batallon de rebeldes.
batallonDeRebeldes(Batallon) :-
    findall(Personaje, personaje(Personaje), Personajes),
    batallonesPosibles(Personajes, 3, Batallon).

batallonesPosibles(PosiblesMiembros, MinHabilidades, PosibleBatallon) :-
    posiblesMiembros(PosiblesMiembros, PosibleBatallon),
    habilidadesDelBatallon(PosibleBatallon, Total),
    Total > 3.

posiblesMiembros([], []).
posiblesMiembros([Miembro|Batallon], [Miembro|Posible]) :-
    registroCriminal(Miembro), 
    posiblesMiembros(Batallon, Posible).

posiblesMiembros([_|Batallon], PosibleBatallon) :-
    posiblesMiembros(Batallon, PosibleBatallon).

habilidadesDelBatallon([], 0). % se debe contemplar este caso??
habilidadesDelBatallon(PosibleBatallon, Total) :-
    findall(Habilidad, habilidadDeUnMiembro(Habilidad, PosibleBatallon), Habilidades),
    length(Habilidades, Total).

habilidadDeUnMiembro(Habilidad, PosibleBatallon) :-
    member(Persona, PosibleBatallon),
    esBuenoEn(Persona, Habilidad).