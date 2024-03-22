/* Parcial Lógico: Comunicados 4.0 2010 */
/* BASE DE CONOCIMIENTO */
capacidad(handset(nokia,6102),smtp). 
capacidad(handset(nokia,6102),ssl). 
capacidad(handset(samsung,d830),imap). 
capacidad(handset(samsung,d830),smtp). 
capacidad(handset(sonyericsson,k700c),pop3). 

% dominio(elDominio,protocolo,incomingServer(server,port,autenticacion), 
% outgoingServer(server,port, protocolo envío, protocolo autenticación)). 
dominio(gmail,pop3,incomingServer('pop.gmail.com',995,ssl),outgoingServer('smtp.gmail.com',587,smtp,ssl)). 
dominio(yahoo,imap,incomingServer('imap.mail.yahoo.com',143,none),outgoingServer('smtp.mail.yahoo.com',25,smtp,none)). 
dominio(msn,pop3,incomingServer('pop3.live.com',1000,ssl),outgoingServer('smtp.live.com',25,smtp,tls)). 

% 1:
% dominioPretencioso(Dominio).
dominioPretencioso(Dominio) :-
    servidorEntrante(Dominio, ServidorEntrante),
    servidorSaliente(Dominio, ServidorSaliente),
    puerto(ServidorEntrante, PuertoEntrante),
    puerto(ServidorSaliente, PuertoSaliente),
    multiplos(PuertoEntrante, PuertoSaliente).

multiplos(A, B) :- rem(A, B, 0).
multiplos(A, B) :- rem(B, A, 0).

servidorEntrante(Dominio, Servidor) :-
    dominio(Dominio, _, Servidor, _).

servidorSaliente(Dominio, Servidor) :-
    dominio(Dominio, _, _, Servidor).

puerto(incomingServer(_, Puerto, _), Puerto).
puerto(outgoingServer(_, Puerto, _, _), Puerto).

% 2:
% requerimiento(Dominio, Requerimiento).
requerimiento(Dominio, Requerimiento) :-
    dominio(Dominio, Requerimiento, _, _).

requerimiento(Dominio, Requerimiento) :-
    servidorEntrante(Dominio, Servidor),
    requerimientoServidor(Servidor, Requerimiento).

requerimiento(Dominio, Requerimiento) :-
    servidorSaliente(Dominio, Servidor),
    requerimientoServidor(Servidor, Requerimiento).

requerimientoServidor(incomingServer(_, _, Requerimiento), Requerimiento).
requerimientoServidor(outgoingServer(_, _, Requerimiento, _), Requerimiento).

% 3:
% satisface(Headset, Requerimiento).
satisface(Headset, Requerimiento) :-
    capacidad(Headset, Requerimiento).

satisface(headset(iphone, _), Requerimiento) :-
    capacidad(_, Requerimiento).

satisface(headset(nokia, Modelo), pop3) :- Modelo > 1000.
satisface(Headset, none) :- capacidad(Headset, _).

% 4:
% puedeSerConfigurado(Headset, Dominio).
puedeSerConfigurado(Headset, Dominio) :-
    dominio(Dominio, _, _).
    capacidad(Headset, _),
    forall(requerimiento(Dominio, Requerimiento), satisface(Headset, Requerimiento)).

% 5:
% sonZonasDesmilitarizada(Dominios).
sonZonasDesmilitarizada(Dominios) :-
    findall(Dominio, esDominio(Dominio), Posibles),
    posiblesDominios(Posibles, Dominios).

posiblesDominios([], []).
posiblesDominios([Dominio | Dominios], [Dominio | Posibles]) :-
    servidorEntrante(Dominio, ServidorEntrante),
    servidorSaliente(Dominio, ServidorSaliente),
    not(tieneAutenticacion(ServidorEntrante, _)),
    not(tieneAutenticacion(ServidorSaliente, _)),
    posiblesDominios(Dominios, Posibles).

posiblesDominios([_| Dominios], Posibles) :-
    posiblesDominios(Dominio, Posibles).

tieneAutenticacion(incomingServer(_, _, Autenticacion), Autenticacion).
tieneAutenticacion(outgoingServer(_, _, _, Autenticacion), Autenticacion).

% 6:
% noHayConQueDarle(Headset).
noHayConQueDarle(Headset) :-
    capacidad(Headset, _),
    forall(dominio(Dominio, _, _), puedeSerConfigurado(Headset, Dominio)).

%% ...

% 8:
% mejorPensarEnJubilarlo(Headset).
mejorPensarEnJubilarlo(Headset) :-
    capacidad(Headset, _),
    not(puedeSerConfigurado(Headset, _)).

mejorPensarEnJubilarlo(Headset) :-
    loTienen(Headset, 13).

loTienen(Headset, Cantidad) :-
    capacidad(Headset, _),
    findall(Persona, tiene(Persona, Headset), Personas),
    length(Persona, Cantidad).