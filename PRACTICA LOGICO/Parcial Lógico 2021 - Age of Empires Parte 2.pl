/* Parcial Lógico : Age of Empires 2021 */
/* BASE DE CONOCIMIENTO */
/*
De los JUGADORES se conoce:
    NOMBRE
    RATING
    CIVILIZACION FAV
    -> Se sabe:
        QUÉ UNIDADES y CUÁNTAS
        RECURSOS (Madera, Alimento, Oro)
        EDIFICIOS (+ cuántos tiene)

De las UNIDADES se sabe que:
    SON ALDEANOS O MILITARES
    -> De los MILITARES se sabe:
        TIPO
        CUÁNTOS RECURSOS CUESTA
        CATEGORIA QUE PERTENECE
    -> De los ALDEANOS se sabe:
        TIPO
        CUANTOS RECURSOS PRODUCE x MINUTO
        CATERGORIA = ALDEANO

De los EDIFICIOS se sabe:
    TIPO
    COSTO
*/
% …jugador(Nombre, Rating, Civilizacion).
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).

% …tiene(Nombre, QueTiene).
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(juan, unidad(carreta, 10)).

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).

/*  PREDICADOS  */
ratingJugador(Jugador, SuRating) :- jugador(Jugador, SuRating, _).

esJugador(Jugador) :- jugador(Jugador, _, _).

% 1:
% esUnAfano(Jugador1, Jugador2).
esUnAfano(Jugador, OtroJugador) :-
    ratingJugador(Jugador, Rating),
    ratingJugador(OtroJugador, OtroRating),
    Dif is Rating - OtroRating,
    abs(Dif, Diferencia),
    Diferencia > 500.

% 2:
% esEfectivo(UnidadGanadora, UnidadPerdedora).
% teniendo en cuenta que por "unidad" recibo un functor
esEfectivo(UnidadGanadora, UnidadPerdedora) :-
    tipoUnidad(UnidadGanadora, TipoUnidadGanadora),
    tipoUnidad(UnidadPerdedora, TipoUnidadPerdedora),
    leGanaSegunCategoria(TipoUnidadGanadora, TipoUnidadPerdedora).

tipoUnidad(unidad(Tipo, _), Tipo).

leGanaSegunCategoria(TipoGanador, TipoPerdedor) :-
    esMilitar(TipoGanador), 
    esMilitar(TipoPerdedor),
    TipoGanador \= samurai,
    categoriaMilitar(TipoGanador, CategoriaGanador),
    categoriaMilitar(TipoPerdedor, CategoriaPerdedor),
    leGana(CategoriaGanador, CategoriaPerdedor)

leGanaSegunCategoria(samurai, TipoPerdedor) :-
    categoriaMilitar(TipoPerdedor, unica).

esMilitar(Tipo) :- militar(Tipo, _, _).

categoriaMilitar(Tipo, Categoria) :- 
    militar(Tipo, _, Categoria).

leGana(caballeria, arqueria).
leGana(arqueria, infanteria).
leGana(infanteria, piquero).
leGana(piquero, caballeria).

% 3:
% alarico(Jugador).
alarico(Jugador) :-
    esJugador(Jugador),
    soloTieneUnidades(Jugador, infanteria).

categoriaDeUnidad(Unidad, Categoria) :- 
    tipoUnidad(Unidad, Tipo), 
    categoriaMilitar(Tipo, Categoria).

soloTieneUnidades(Jugador, Categoria) :-
    esJugador(Jugador),
    forall(tiene(Jugador, Unidad), categoriaDeUnidad(Unidad, Categoria)).

% 4:
% leonidas(Jugador).
leonidas(Jugador) :-
    esJugador(Jugador),
    soloTieneUnidades(Jugador, piquero).

% 5:
% nomada(Jugador).
nomada(Jugador) :-
    esJugador(Jugador),
    not(tieneCasa(Jugador)).

tieneCasa(Jugador) :-
    tiene(Jugador, Edificio),
    tipoEdificio(Edificio, casa).

tipoEdificio(edificio(Tipo, _), Tipo).

% 6:
% cuantoCuesta(Unidad/Edificio, Costo).
cuantoCuesta(Unidad, Costo) :-
    tipoUnidad(Unidad, Tipo),
    costoSegun(Tipo, Costo).

cuantoCuesta(edificio(_, Costo), Costo).

costoSegun(Tipo, Costo) :-
    esMilitar(Tipo),
    costoMilitar(Tipo, Costo).

costoSegun(Tipo, costo(0, 50, 0)) :-
    esAldeano(Tipo).

costoSegun(Tipo, costo(100, 0, 50)) :-
    esUrnaOCarreta(Tipo).

esAldeano(Tipo) :- aldeano(Tipo, _).
esUrnaOCarreta(urnaMercante).
esUrnaOCarreta(carreta).
costoMilitar(Tipo, Costo) :- militar(Tipo, Costo, _).

% 7:
% produccion(Unidad, ProduccionRecursosXMinuto).
produccion(Unidad, ProduccionRecursosXMinuto) :-
    tipoUnidad(Unidad, Tipo),
    produccionSegun(Tipo, ProduccionRecursosXMinuto).

% produce(Madera, Alimento, Oro)
produccionSegun(keshiks, produce(0, 0, 10)).
produccionSegun(Tipo, produce(0, 0, 32)).
    esUrnaOCarreta(Tipo).

produccionSegun(Tipo, ProduccionRecursosXMinuto) :-
    aldeano(Tipo, ProduccionRecursosXMinuto).

% 8:
% produccionTotal(Jugador, Recurso, ProduccionTotalDeEseRecurso).
produccionTotal(Jugador, Recurso, ProduccionTotal) :-
    esJugador(Jugador),
    esRecurso(Recurso),
    findall(Total, produccionDe(Jugador, Recurso, Total), Totales),
    sumlist(Totales, ProduccionTotal).

produccionDe(Jugador, Recurso, Total) :-
    tiene(Jugador, Unidad),
    cantidadUnidad(Unidad, Cuanto),
    produccion(Unidad, ProduccionRecursosXMinuto),
    produccionSegunRecurso(Recurso, ProduccionRecursosXMinuto, Produce),
    Total is Produce * Cuanto.

produccionSegunRecurso(madera, produce(Total, _, _), Total).
produccionSegunRecurso(alimento, produce(_, Total, _), Total).
produccionSegunRecurso(oro, produce(_, _, Total), Total).

cantidadUnidad(unidad(_, Cuanto), Cuanto).

esRecurso(oro).
esRecurso(alimento).
esRecurso(madera).

% 9:
% estaPeleado(Jugador, OtroJugador).
estaPeleado(Jugador, OtroJugador) :-
    esJugador(Jugador),
    esJugador(OtroJugador),
    not(esUnAfano(Jugador, OtroJugador)),
    not(esUnAfano(OtroJugador, Jugador)),
    cantidadDeUnidades(Jugador, Cantidad),
    cantidadDeUnidades(Jugador, Cantidad),
    calculoDeProduccion(Jugador, CalculoJugador),
    calculoDeProduccion(OtroJugador, CalculoOtroJugador),
    Dif is CalculoJugador - CalculoOtroJugador,
    abs(Dif, Diferencia),
    Diferencia < 100.

calculoDeProduccion(Jugador, CalculoProduccion) :-
    esJugador(Jugador),
    produccionTotal(Jugador, oro, ProduccionOro),
    produccionTotal(Jugador, madera, ProduccionMadera),
    produccionTotal(Jugador, alimento, ProduccionAlimento),
    CalculoProduccion is (ProduccionOro * 5) + (ProduccionAlimento * 2) + (ProduccionMadera * 3).

cantidadDeUnidades(Jugador, Cantidad) :-
    esJugador(Jugador),
    findall(CantidadUnidad, cantidadUnidadJugador(Jugador, CantidadUnidad), Cantidades),
    sumlist(Cantidades, Cantidad).

cantidadUnidadJugador(Jugador, CantidadUnidad) :-
    tiene(Jugador, unidad(_, CantidadUnidad)).

% 10:
% avanzaA(Jugador, Edad).
avanzaA(Jugador, edadMedia) :- esJugador(Jugador).
avanzaA(Jugador, Edad) :-
    esJugador(Jugador),
    puedeAvanzarASegun(Jugador, Edad).

puedeAvanzarASegun(Jugador, edadFeudal) :- 
    cumpleEdificio(Jugador, casa),
    cumpleProduccionAlimento(Jugador, 500).

puedeAvanzarASegun(Jugador, edadDeCastillos) :-
    cumpleEdificio(Jugador, herreria),
    cumpleEdificio(Jugador, EstabloOGaleria),
    cumpleProduccionAlimento(Jugador, 800),
    cumpleProduccionOro(Jugador, 200). /*JUSTO 200*/

puedeAvanzarASegun(Jugador, edadImperial) :-
    cumpleEdificio(Jugador, castillo),
    cumpleEdificio(Jugador, universidad),
    cumpleProduccionAlimento(Jugador, 1000),
    cumpleProduccionOro(Jugador, 800).

cumpleEdificio(Jugador, Tipo) :-
    tiene(Jugador, Edificio),
    tipoEdificio(Edificio, Tipo).

cumpleProduccionAlimento(Jugador, Cuanto) :-
    produccionTotal(Jugador, alimento, Total),
    Total >= Cuanto.

cumpleProduccionOro(Jugador, Cuanto) :- 
    produccionTotal(Jugador, oro, Total),
    Total >= Cuanto.