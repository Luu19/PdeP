/* Práctica Lógico: Festivales de Rock */
/* BASE DE CONOCIMIENTO */
% festival(NombreDelFestival, Bandas, Lugar).
festival(lollapalooza, [gunsAndRoses, theStrokes, littoNebbia], hipódromoSanIsidro).

% lugar(nombre, capacidad, precioBase).
lugar(hipódromoSanIsidro, 85000, 3000).

% banda(nombre, nacionalidad, popularidad).
banda(gunsAndRoses, eeuu, 69420).

% entradaVendida(NombreDelFestival, TipoDeEntrada).
% Los tipos de entrada pueden ser alguno de los siguientes:
% - campo
% - plateaNumerada(Fila)
% - plateaGeneral(Zona).
entradaVendida(lollapalooza, campo).
entradaVendida(lollapalooza, plateaNumerada(1)).
entradaVendida(lollapalooza, plateaGeneral(zona2)).

% plusZona(Lugar, Zona, Recargo)
plusZona(hipódromoSanIsidro, zona1, 1500).

% 1:
% itinerante(Festival).
itinerante(Festival) :-
    festival(Festival, Bandas, Lugar),
    festival(Festival, Bandas, OtroLugar),
    Lugar \= OtroLugar.

% 2:
% careta(Festival).
careta(Festival) :-
    esFestival(Festival),
    not(tieneCampo(Festival)).

careta(personalFest).

tieneCampo(Festival) :- 
    entradaVendida(Festival, campo).

% 3:
% nacAndPop(Festival).
nacAndPop(Festival) :-
    festival(Festival, Bandas, _),
    not(careta(Festival)),
    forall(member(Banda, Bandas), (esArgentina(Banda), muyPopular(Banda))).

esArgentina(Banda) :- banda(Banda, argentina, _).
muyPopular(Banda) :- banda(Banda, _, Popularidad), Popularidad > 1000.

% 4:
% sobrevendido(Festival).
sobrevendido(Festival) :-
    festival(Festival, _, Lugar),
    cantidadEntradasVendidas(Festival, Cantidad),
    lugar(Lugar, Capacidad, _),
    Cantidad > Capacidad.

cantidadEntradasVendidas(Festival, Cantidad) :-
    esFestival(Festival),
    findall(Entrada, entradaVendida(Festival, Entrada), Entradas),
    length(Entradas, Cantidad).

% 5:
% recaudacionTotal(Festival, TotalRecaudado).
recaudacionTotal(Festival, TotalRecaudado) :-
    esFestival(Festival),
    findall(PrecioEntrada, precioPorEntradaVendida(Festival, PrecioEntrada), Precios),
    sumlist(Precios, TotalRecaudado).

precioPorEntradaVendida(Festival, PrecioEntrada) :-
    entradaVendida(Festival, Entrada),
    precioEntrada(Festival, Entrada, Precio).

precioEntrada(Festival, campo, Precio) :-
    precioBase(Festival, Precio).

precioEntrada(Festival, plateaGeneral(Zona), Precio) :-
    precioBase(Festival, PrecioBase),
    plus(Festival, Zona, Plus),
    Precio is PrecioBase + Plus.

precioEntrada(Festival, plateaNumerada(Numero), Precio) :-
    precioBase(Festival, PrecioBase),
    precioSegunFila(Numero, PrecioBase, Precio).

precioSegunFila(Numero, PrecioBase, Precio) :-
    Numero > 10,
    Precio is PrecioBase * 3.

precioSegunFila(Numero, PrecioBase, Precio) :-
    between(0, 10, Numero),
    Precio is PrecioBase * 10.

precioBase(Festival, PrecioBase) :- 
    lugarFestival(Festival, Lugar),
    lugar(Lugar, _, PrecioBase).

plus(Festival, Zona, Plus) :-
    lugarFestival(Festival, Lugar),
    plusZona(Lugar, Zona, Plus).

lugarFestival(Festival, Lugar) :- festival(Festival, _, Lugar).

% delMismoPalo(UnaBanda, OtraBanda).
delMismoPalo(UnaBanda, OtraBanda) :-
    tocaronJuntas(UnaBanda, OtraBanda).

delMismoPalo(UnaBanda, OtraBanda) :-
    tocaronJuntas(UnaBanda, UnaBandaMas),
    delMismoPalo(UnaBandaMas, OtraBanda),
    esMasPopular(UnaBandaMas, UnaBanda).

tocaronJuntas(UnaBanda, OtraBanda) :-
    bandasDeUnFestival(_, Bandas),
    member(UnaBanda, Bandas),
    member(OtraBanda, Bandas),
    UnaBanda \= OtraBanda.

bandasDeUnFestival(F, Bs) :- festival(F, Bs, _).

esMasPopular(BandaPopular, BandaNoTanPopular) :-
    popularidadBanda(BandaPopular, Popular),
    popularidadBanda(BandaNoTanPopular, Popular2),
    Popular > Popular2.

popularidadBanda(B, P) :- banda(B, _, P).