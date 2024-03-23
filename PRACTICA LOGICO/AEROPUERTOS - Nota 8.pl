/* Primer Parcial Lógico: Aerolineas Prolog 2022 */

% 1:
/* BASE DE CONOCIMIENTO */
% ciudad(Ciudad, Pais).
ciudad(buenosAires, argentina).
ciudad(saoPablo, brasil).
ciudad(santiagoDeChile, chile).
ciudad(palawan, filipinas).
ciudad(paris, francia).
ciudad(chicago, eeuu).

% aeropuerto(Codigo, Ciudad).
aeropuerto(aep, buenosAires).
aeropuerto(eze, buenosAires).
aeropuerto(gru, saoPablo).
aeropuerto(scl, santiagoDeChile).

/*
De cada CIUDAD se sabe:
    -> TIPO
        -Paradisiaca
        -De negocios
        -Importancia cultural, se conocen los lugares emblematicos a visitar
*/
% tipoCiudad(Ciudad, Tipo).
tipoCiudad(palawan, paradisiaca).
tipoCiudad(chicago, negocios).
tipoCiudad(paris, importanciaCultural([torreEiffel, arcoDelTriunfo, museoLouvre, catedralDeNotreDame])).
tipoCiudad(buenosAires, importanciaCultural([obelisco, congreso, cabildo])).

% costoDeRutaCon(Aerolinea, Desde, Hasta, Costo).
costoDeRutaCon(aerolineaProlog, ruta(aep, gru), 75000).
costoDeRutaCon(aerolineaProlog, ruta(gru, scl), 65000).
% ...

aerolinea(aerolineaProlog).

% 2:
% esDeCabotaje(Aerolinea)
esDeCabotaje(Aerolinea) :-
    vuelo(Aerolinea, Ruta),
    esDentroDelPais(Ruta).

vuelo(Aerolinea, Ruta) :-
        costoDeRutaCon(Aerolinea, Ruta, _).

esDentroDelPais(ruta(Desde, Hasta)) :-
    aeropuerto(Desde, Ciudad),
    aeropuerto(Hasta, OtraCiudad),
    ciudad(Ciudad, Pais),
    ciudad(OtraCiudad, Pais).

% soloViajeDeIdaA(CiudadDestino).
soloViajeDeIdaA(CiudadDestino) :-
    aeropuerto(Aeropuerto, CiudadDestino),
    not(viajaDeVuelta(_, Aeropuerto)).

viajaDeVuelta(Aerolinea, Aeropuerto) :-
        vuelo(Aerolinea, Ruta),
        parteDesde(Ruta, Aeropuerto).

parteDesde(ruta(Desde, _), Desde).
lugarDestino(ruta(_, Hasta), Hasta).

% rutaDirecta(ruta(Desde, Hasta)).
rutaDirecta(Ruta) :-
        vuelo(_, Ruta).

rutaDirecta(Ruta) :- 
    parteDesde(Ruta, Lugar1),
    lugarDestino(Ruta, Lugar2),
    /*           -           */
    vuelo(Aerolinea, UnaRuta),
    parteDesde(UnaRuta, Lugar1),
    lugarDestino(UnaRuta, Escala),
    Escala \= Lugar2,
    vuelo(Aerolinea, OtraRuta),
    parteDesde(OtraRuta, Escala),
    lugarDestino(OtraRuta, Lugar2).

/* BASE DE CONOCIMIENTO PERSONAS */
% persona(eduardo, Dinero, Millas).
persona(eduardo, 50000, 750).

% estaEn(Persona, DondeSeEncuentra).
estaEn(eduardo, buenosAires).
%...

% puedeViajar(Persona, Desde, Hasta).
puedeViajar(Persona, CiudadDesde, CiudadHasta) :- 
        rutaDesdeHasta(CiudadDesde, CiudadHasta, Ruta),
        puedeViajarSegun(Persona, Ruta).

puedeViajarSegun(Persona, Ruta) :-
        tieneDineroNecesario(Persona, Desde, Hasta).

tieneDineroNecesario(Persona, Ruta) :- 
        persona(Persona, Dinero, _),
        costoDeUnaRuta(Ruta, Costo), % teniendo en cuenta que elige vuelo directo sin escalas
        Dinero >= Costo.

puedeViajarSegun(Persona, Ruta) :-
        tieneSuficientesMillas(Persona, Ruta).

tieneSuficientesMillas(Persona, Ruta) :-
        persona(Persona, _, Millas),
        costoMillasSegunVuelo(Ruta, Millas).

costoMillasSegunVuelo(Ruta, Millas) :- 
    costoDeMillasDeVuelo(Ruta, Costo),
    Millas >= Costo.

costoDeMillasDeVuelo(Ruta, 500) :-
    rutaDeCabotaje(Ruta).

costoDeMillasDeVuelo(Ruta, Costo) :-
        costoDeUnaRuta(Ruta, Costo),
        not(rutaDeCabotaje(Ruta)),
        Costo is (0.2 * Costo).

rutaDeCabotaje(Ruta) :- 
    vuelo(Aerolinea, Ruta),
    esDeCabotaje(Aerolinea).

costoDeUnaRuta(Ruta, Costo) :- costoDeRutaCon(_, Ruta, Costo).
rutaDesdeHasta(CiudadDesde, CiudadHasta, ruta(AeropuertoDesde, AeropuertoHasta)) :-
    aeropuerto(AeropuertoDesde, CiudadDesde),
    aeropuerto(AeropuertoHasta, CiudadHasta).

% quiereViajar(Persona, Ciudad).
quiereViajar(Persona, Ciudad) :-
        ciudad(Ciudad, _),
        esPersona(Persona),
        seQuiereViajarSegun(Persona, Ciudad).

seQuiereViajarSegun(Persona, Ciudad) :-
        persona(Persona, Dinero, Millas),
        ciudad(Ciudad, Pais),
        Pais \= qatar,
        seQuiereViajarA(Ciudad),
        Dinero > 5000,
        Millas > 100000.

seQuiereViajarSegun(_, Ciudad) :- 
    esDeQatar(Ciudad).

seQuiereViajarA(Ciudad) :-
    tipo(Ciudad, paradisiaca).

seQuiereViajarA(Ciudad) :-
    tipo(Ciudad, importanciaCultural(Lugares)),
    length(Lugares, Cantidad),
    Cantidad >= 4.

esPersona(Persona) :- persona(Persona, _, _).
esDeQatar(Ciudad) :- ciudad(Ciudad, qatar).

% tieneQueAhorrarUnPoco(Persona, Ciudad).
tieneQueAhorrarUnPoco(Persona, Ciudad) :-
        estaEn(Persona, CiudadDondeEsta),
        rutaQueQuiereHacer(Persona, CiudadDondeEsta, Ciudad, Ruta),
        costoDeUnaRuta(Ruta, CostoMinimo),
        forall(
            (rutaQueQuiereHacer(Persona, CiudadDondeEsta, OtraCiudad, OtraRuta),
            costoDeUnaRuta(OtraRuta, Costo), OtraCiudad \= Ciudad),
                CostoMinimo < Costo).

rutaQueQuiereHacer(Persona, CiudadDesde, CiudadHasta, Ruta) :-
        quiereViajar(Persona, CiudadHasta),
        rutaDesdeHasta(CiudadDesde, CiudadHasta, Ruta).