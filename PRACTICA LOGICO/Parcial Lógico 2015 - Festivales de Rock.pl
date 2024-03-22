/* Parcial Lógico: Festivales de... rock? */
/* BASE DE CONOCIMIENTO */
anioActual(2015).

%festival(nombre,          lugar,            bandas, precioBase).
%                 lugar(nombre, capacidad).
festival(lulapaluza, lugar(hipodromo,40000), [miranda, paulMasCarne, muse], 500).
festival(mostrosDelRock, lugar(granRex, 10000), [kiss, judasPriest, blackSabbath], 1000).
festival(personalFest, lugar(geba, 5000), [tanBionica, miranda, muse, pharrellWilliams], 300).
festival(cosquinRock, lugar(aerodromo, 2500), [erucaSativa, laRenga], 400).

%banda(nombre, año, nacionalidad, popularidad).
banda(paulMasCarne, 1960, uk, 70).
banda(muse, 1994, uk, 45).
banda(kiss, 1973, us, 63).
banda(erucaSativa, 2007, ar, 60).
banda(judasPriest, 1969, uk, 91).
banda(tanBionica, 2012, ar, 71).
banda(miranda, 2001, ar, 38).
banda(laRenga, 1988, ar, 70).
banda(blackSabbath, 1968, uk, 96).
banda(pharrellWilliams, 2014, us, 85).

%entradasVendidas(nombreDelFestival, tipoDeEntrada, cantidadVendida).
% tipos de entrada: campo, plateaNumerada(numero de fila), plateaGeneral(zona).
entradasVendidas(lulapaluza,campo, 600).
entradasVendidas(lulapaluza,plateaGeneral(zona1), 200).
entradasVendidas(lulapaluza,plateaGeneral(zona2), 300).
entradasVendidas(mostrosDelRock,campo,20000).
entradasVendidas(mostrosDelRock,plateaNumerada(1),40).
entradasVendidas(mostrosDelRock,plateaNumerada(2),0).
% … y asi para todas las filas
entradasVendidas(mostrosDelRock,plateaNumerada(10),25).
entradasVendidas(mostrosDelRock,plateaGeneral(zona1),300).
entradasVendidas(mostrosDelRock,plateaGeneral(zona2),500).

plusZona(hipodromo, zona1, 55).
plusZona(hipodromo, zona2, 20).
plusZona(granRex, zona1, 45).
plusZona(granRex, zona2, 30).
plusZona(aerodromo, zona1, 25).

% 1:
% estaDeModa(Banda).
estaDeModa(Banda) :-
    popularidadBanda(Banda, Popularidad),
    surgioEnLosUltimosAnios(5, Banda),
    Popularidad > 70.

surgioEnLosUltimosCincoAnios(DentroDe, Banda) :-
    banda(Banda, AnioSurgio, _, _),
    anioActual(AnioActual),
    AnioPasado is AnioActual - DentroDe,
    between(AnioPasado, AnioActual, AnioSurgio),

popularidadBanda(Banda, Popularidad) :- banda(Banda, _, _, Popularidad).

% 2:
% esCareta(Festival).
esCareta(Festival) :-
    esFestival(Festival),
    esCaretaPor(Festival).

esFestival(F) :- festival(F, _, _, _).

esCaretaPor(Festival) :- 
    estaDeModa(UnaBanda),
    estaDeModa(OtraBanda),
    UnaBanda \= OtraBanda.
esCaretaPor(Festival) :- not(entradaRazonable(Festival, _)).
esCaretaPor(Festival) :- tocaMiranda(Festival).

tocaMiranda(Festival) :- bandaDelFestival(miranda, Festival).

bandaDelFestival(Banda, Festival) :-
    bandasDelFestival(Festival, Bandas),
    member(Banda, Bandas).

bandasDelFestival(Festival, Bandas) :- festival(Festival, _, Bandas, _).

% 3:
% entradaRazonable(Festival, Entrada).
entradaRazonable(Festival, Entrada) :-
    esEntradaDeFestival(Festival, Entrada),
    requisitosTipoEntrada(Festival, Entrada).

esEntradaDeFestival(Festival, Entrada) :- entradasVendidas(Festival, Entrada, _).

requisitosTipoEntrada(Festival, Entrada) :-
    precioEntrada(Entrada, Festival, Precio),
    requisitosTipoEntrada(Entrada, Precio, Festival).

requisitosTipoEntrada(plateaGeneral(Zona), Precio, Festival) :-
    plus(Festival, Zona, Plus),
    Referencia is Precio * 0.1,
    Plus < Referencia.

requisitosTipoEntrada(campo, Precio, Festival) :-
    popularidadFestival(Festival, Popularidad),
    Precio < Popularidad.

requisitosTipoEntrada(plateaNumerada(Numero), Precio, Festival) :-
    not(todasEstanDeModa(Festival)),
    Precio =< 750.

requisitosTipoEntrada(plateaNumerada(Numero), Precio, Festival) :-
    capacidadLugar(Festival, CapacidadLugar),
    popularidadFestival(Festival, Popularidad),
    Referencia is CapacidadLugar / Popularidad,
    Referencia < Precio.

precioEntrada(plateaGeneral(Zona), Festival, Precio) :-
    precioBaseFestival(Festival, PrecioBase),
    plus(Festival, Zona, Plus),
    Precio is PrecioBase + Plus.

precioEntrada(campo, Festival, Precio) :-
    precioBaseFestival(Festival, Precio).

precioEntrada(plateaNumerada(Numero), Festival, Precio) :-
    precioBaseFestival(Festival, PrecioBase),
    Precio is (PrecioBase + 200) / Numero.

capacidadLugar(Festival, CapacidadLugar) :-
    lugarFestival(Festival, Lugar),
    capacidadLugar(Lugar, CapacidadLugar).

popularidadFestival(Festival, Popularidad) :-
    esFestival(Festival),
    findall(PopularidadBanda, popularidadDeCadaBanda(Festival, PopularidadBanda), Total),
    sumlist(Total, Popularidad).

popularidadDeCadaBanda(Festival, PopularidadBanda) :-
    bandaDelFestival(Banda, Festival),
    pupularidadBanda(Banda, Popularidad).

plus(Festival, Zona, Plus) :-
    lugarFestival(Festival, Lugar),
    nombreLugarFestival(Lugar, Nombre),
    plusZona(Nombre, Zona, Plus).

todasEstanDeModa(Festival) :-
    esFestival(Festival),
    forall(bandaDelFestival(Banda, Festival), estaDeModa(Banda)).

lugarFestival(Festival, Lugar) :- festival(Festival, Lugar, _, _).
nombreLugarFestival(lugar(Nombre, _), Nombre).
precioBaseFestival(Festival, PrecioBase) :- festival(Festival, _, _, PrecioBase).

% 4:
% nacanpop(Festival).
nacanpop(Festival) :-
    esFestival(Festival),
    participanTodasBandasNacionales(Festival),
    entradaRazonable(Festival, _).

participanTodasBandasNacionales(Festival) :-
    esFestival(Festival),
    forall(bandaDelFestival(Banda, Festival), esNacional(Banda)).

esNacional(Banda) :-
    nacionalidadBanda(Banda, ar).

nacionalidadBanda(Banda) :- banda(_, _, ar, _).

% 5:
% recaudacion(Festival, Recaudacion).
recaudacion(Festival, Recaudacion) :-
    esFestival(Festival),
    findall(MontoPorTipo, montoPorTipoDeEntrada(Festival, MontoPorTipo), Montos),
    sumlist(Montos, Recaudacion).

montoPorTipoDeEntrada(Festival, MontoPorTipo) :-
    entradasVendidas(Festival, Entrada, Cantidad),
    precioEntrada(Entrada, Festival, Precio),
    MontoPorTipo is Precio * Cantidad.

% 6:
% estaBienPlaneado(Festival).
estaBienPlaneado(Festival) :-
    bandasDelFestival(Festival, Bandas)
    crecePupularidadDeBandas(Bandas),
    ultimaBandaEsLegendaria(Bandas).

ultimaBandaEsLegendaria(Bandas) :-
    tail(Bandas, Ultima),
    esLegendaria(Ultima).

esLegendaria(Banda) :-
    banda(Banda, Anio, _, _),
    not(esNacional(Banda)),
    esLaMasPopular(Banda),
    between(0, 1979, Anio).

esLaMasPopular(Banda) :-
    popularidadBanda(Banda, PopularidadMaxima),
    forall((popularidadBandaDeModa(OtraBanda, Popularidad), OtraBanda \= Banda), Popularidad < PopularidadMaxima).

popularidadBandaDeModa(Banda, Popularidad) :-
    estaDeModa(Banda),
    popularidadBanda(Banda, Popularidad).

tail(Lista, Ultimo) :-
    reverse(Lista, ListaInvertida),
    head(ListaInvertida, Ultimo).

head([X | Ls], X).
