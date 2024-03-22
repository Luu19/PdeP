/* Parcial Lógico: Los Magios 2011 */
/*  BASE DE CONOCIMIENTO  */
persona(bart).
persona(larry).
persona(otto).
persona(marge).

%los magios son functores alMando(nombre, antiguedad), novato(nombre) y elElegido(nombre).
persona(alMando(burns,29)).
persona(alMando(clark,20).
persona(novato(lenny)).
persona(novato(carl)).
persona(elElegido(homero)).

% Y contamos con algunos hechos en nuestra base
hijo(homero,abbe).
hijo(bart,homero).
hijo(larry,burns).
salvo(carl,lenny).
salvo(homero,larry).
salvo(otto,burns).

%Los beneficios son funtores confort(descripcion), confort(descripcion, caracteristica),
% dispersion(descripcion), economico(descripcion, monto).
gozaBeneficio(carl, confort(sillon)).
gozaBeneficio(lenny, confort(sillon)).
gozaBeneficio(lenny, confort(estacionamiento, techado)).
gozaBeneficio(carl, confort(estacionamiento, libre)).
gozaBeneficio(clark, confort(viajeSinTráfico)).
gozaBeneficio(clark, dispersion(fiestas)).
gozaBeneficio(burns, dispersion(fiestas)).
gozaBeneficio(lenny, economico(descuento, 500)).

% 1:
% aspiranteMagio(Persona).
aspiranteMagio(Persona) :-
    esDescendienteDeMagio(Persona).

aspiranteMagio(Persona) :-  
    leSalvoLaVidaAUnMagio(Persona).

esDescendienteDeMagio(Persona) :- 
    hijo(Persona, Padre),
    esMagio(Padre).

leSalvoLaVidaAUnMagio(Persona) :-
    salvo(Persona, Otra),
    esMagio(Otra).

esMagio(alMando(_, _)).
esMagio(novato(_)).
esMagio(elElegido(_)).

% 2:
% puedeDarOrdenes(UnaPersona, OtraPersona).
puedeDarOrdenes(elElegido(_), OtraPersona) :- 
    esMagio(OtraPersona).

puedeDarOrdenes(Persona, OtraPersona) :-
    estaAlMando(Persona),
    puedeDarOrdenesSegun(Persona, OtraPersona).

puedeDarOrdenesSegun(alMando(_, _), novato(_)).
puedeDarOrdenesSegun(alMando(_, Numero), alMando(_, OtroNumero)) :-
    Numero > OtroNumero.

% 3: -- PREGUNTAR A FEDE
% sienteEnvidia(Persona, Envidiados).
sienteEnvidia(Persona, Envidiados) :-
    aspiranteMagio(Persona),
    findall(Magio, esMagio(Magio), Envidiados).

sienteEnvidia(Persona, Envidiados) :-
    persona(Persona),
    not(aspiranteMagio(Persona)),
    findall(Aspirante, aspiranteMagio(Aspirante), Envidiados).

sienteEnvidia(Persona, Envidiados) :-
    esNovato(Persona),
    findall(Magio, estaAlMando(Magio), Envidiados).

% 4:
% soloLoGoza(Persona, Beneficio).
soloLoGoza(Persona, Beneficio) :-
    gozaBeneficio(Persona, Beneficio),
    forall((persona(OtraPersona), OtraPersona \= Persona), not(gozaBeneficio(OtraPersona, Beneficio))).

% 6:
% tipoBeneficioMasAprovechado(Beneficio).
tipoBeneficioMasAprovechado(Beneficio) :-
    cantidadUsoBeneficio(Beneficio, CantidadMax),
    forall((cantidadUsoBeneficio(OtroBeneficio, Cantidad), OtroBeneficio \= Beneficio), Cantidad < CantidadMax).

cantidadUsoBeneficio(Beneficio, Cantidad) :-
    gozaBeneficio(_, Beneficio),
    findall(Magio, gozaBeneficio(Magio, Beneficio), Magios),
    length(Magios, Cantidad).
    
