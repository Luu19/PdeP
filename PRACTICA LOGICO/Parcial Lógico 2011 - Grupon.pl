/* Parcial Lógico: Grupón - Cupones de Descuento 2022 */
/* BASE DE CONOCIMIENTO */
usuario(lider,capitalFederal).
usuario(alf,lanus).
usuario(roque,laPlata).
usuario(fede, capitalFederal).

% los functores cupon son de la forma
% cupon(Marca,Producto,PorcentajeDescuento)
cuponVigente(capitalFederal,cupon(elGatoNegro,setDeTe,35)).
cuponVigente(capitalFederal,cupon(lasMedialunasDelAbuelo,panDeQueso,43)).
cuponVigente(capitalFederal,cupon(laMuzzaInspiradora,pizzaYBirraParaDos,80)).
cuponVigente(lanus,cupon(maoriPilates,ochoClasesDePilates,75)).
cuponVigente(lanus,cupon(elTano,parrilladaLibre,65)).
cuponVigente(lanus,cupon(niniaBonita,depilacionDefinitiva,73)).

% El predicado accionDeUsuario registra las acciones que el usuario realiza en el sitio, que pueden ser:
%   ● comprar con un cupón, que se representa con un functor:
%           compraCupon(PorcentajeDescuento,Fecha,Marca)
%   ● recomendar un cupón, representado como:
%           recomiendaCupon(Marca,Fecha,UsuarioRecomendado)
accionDeUsuario(lider,compraCupon(60,"20/12/2010",laGourmet)).
accionDeUsuario(lider,compraCupon(50,"04/05/2011",elGatoNegro)).
accionDeUsuario(alf,compraCupon(74,"03/02/2011",elMundoDelBuceo)).
accionDeUsuario(fede,compraCupon(35,"05/06/2011",elTano)).
accionDeUsuario(fede,recomiendaCupon(elGatoNegro,"04/05/2011",lider)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"13/05/2011",alf)).
accionDeUsuario(alf,recomiendaCupon(cuspide,"13/05/2011",fede)).
accionDeUsuario(fede,recomiendaCupon(cuspide,"13/05/2011",roque)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"24/07/2011",fede)).

% 1:
% ciudadGenerosa(Ciudad).
ciudadGenerosa(Ciudad) :-
    esCiudad(Ciudad), 
    forrall((cuponVigente(Ciudad, Cupon), descuentoCupon(Cupon, Descuento)), Descuento > 60).

esCiudad(Ciudad) :- cuponVigente(Ciudad, _).

descuentoCupon(cupon(_, _, Descuento), Descuento).

% 2:
% puntosGanados(Persona, TotalPuntos).
puntosGanados(Persona, TotalPuntos) :-
    usuario(Persona, _),
    findall(Puntos, ganoPuntos(Persona, Puntos), TodosLosPuntos),
    sumlist(TodosLosPuntos, TotalPuntos).

ganoPuntos(Persona, Puntos) :-
    accionDeUsuario(Persona, Accion),
    ganoPuntosSegun(Accion, Puntos).

ganoPuntosSegun(Accion, 5) :- recomendacionExitosa(Accion).
ganoPuntosSegun(Accion, 10) :- comproCupon(Accion). 
ganoPuntosSegun(Accion, 1) :- not(recomendacionExitosa(Accion)).

comproCupon(compraCupon(_, _, _)). 

recomendacionExitosa(recomiendaCupon(Marca, Fecha, OtraPersona)) :-
    accionDeUsuario(OtraPersona, compraCupon(_, Fecha, Marca)).

% 3:
% promedioDePuntosPorMarca(Marca, Promedio).
promedioDePuntosPorMarca(Marca, Promedio) :-

% 4:
% lePuedeInteresarCupon(Persona, CuponVigente).
lePuedeInteresarCupon(Persona, CuponVigente) :-
    usuario(Persona, Ciudad),
    cuponVigente(Ciudad, CuponVigente),
    requisitosDeInteres(Persona, CuponVigente).

requisitosDeInteres(Persona, cupon(Marca, _, _)) :-
    accionSegunMarca(Marca, Persona).

accionSegunMarca(Marca, Persona) :-
    accionDeUsuario(_, recomiendaCupon(Marca, _, Persona)).

accionSegunMarca(Marca, Persona) :- 
    accionDeUsuario(Persona, compraCupon(_, _, Marca)).

% 5:
% nadieLeDioBola(Usuario).
nadieLeDioBola(Usuario) :-
    usuario(Usuario, _)
    forall(accionDeUsuario(Usuario, Recomedacion), not(recomendacionExitosa(Recomedacion))).

% 6:
% cadenaDeRecomendacionesValida(Marca, Fecha, ListaDeRecomendaciones).
cadenaDeRecomendacionesValida(Marca, Fecha, Recomedaciones) :-
    usuario(Usuario, _),
    findall(Usuario, hizoRecomendacion(Usuario), Usuarios),
    posiblesCadenas(Marca, Fecha, Usuarios, Recomedaciones),
    length(Recomedaciones, Longitud),
    Longitud > 2.

hizoRecomendacion(Usuario) :- accionDeUsuario(Usuario, recomiendaCupon(_, _, _)).

posiblesCadenas(_, _, [], []).
posiblesCadenas(Marca, Fecha, [Usuario | Usuarios], [Usuario | Recomedaciones]) :-
    accionDeUsuario(Usuario, recomiendaCupon(Marca, Fecha, Otro)),
    member(Otro, Usuarios),
    posiblesCadenas(Marca, Fecha, Usuarios, Recomedaciones).

posiblesCadenas(Marca, Fecha, [_ | Usuarios], Recomedaciones) :-
    posiblesCadenas(Marca, Fecha, Usuarios, Recomedaciones).

/*
posiblesCadenas(Marca, Fecha, Usuario, [Usuario | Recomedaciones]) :-
    accionDeUsuario(Usuario, recomiendaCupon(Marca, Fecha, Otro)),
    hizoRecomendacion(Otro),
    posiblesCadenas(Marca, Fecha, Otro, Recomedaciones).

posiblesCadenas(Marca, Fecha, Usuario, [Usuario]) :-
    accionDeUsuario(Usuario, recomiendaCupon(Marca, Fecha, Otro)).
*/