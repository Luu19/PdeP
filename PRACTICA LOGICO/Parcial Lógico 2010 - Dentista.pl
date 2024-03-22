/* Parcial Lógico: Dentista 2010 */
/* BASE DE CONOCIMIENTO */
/*
Cada PACIENTE puede ser de:
    UNA OBRA SOCIAL -> se representa con el functor pacienteObraSocial(...)
    PARTICULAR -> se representa con el functor pacienteParticular(...)
    OTRA CLÍNICA -> se representa con el functor pacienteClinica(...)
*/
dentista(pereyra). 
dentista(deLeon). 
puedeAtenderA(pereyra, pacienteObraSocial(karlsson, 1231, osde)). 
puedeAtenderA(pereyra, pacienteParticular(rocchio, 24)). 
puedeAtenderA(deLeon, pacienteClinica(dodino, odontoklin)). 

% costo de servicios para cada obra social 
costo(osde, tratamientoConducto, 200). 
costo(omint, tratamientoConducto, 250). 

% costo de servicios por atención particular 
costo(tratamientoConducto, 1200). 
% porcentaje que se cobra a clínicas asociadas
clinica(odontoklin, 80).

% 1:
/* EXTIENDO BASE DE CONOCIMIENTO */
dentista(cureta).
puedeAtenderA(cureta, pacienteClinica(_, sarlanga)).
puedeAtenderA(cureta, pacienteObraSocial(_, Edad)) :- Edad > 60.

dentista(patolinger).
puedeAtenderA(patolinger, Paciente) :- puedeAtenderA(pereyra, Paciente).
puedeAtenderA(patolinger, Paciente) :- not(puedeAtenderA(deLeon, Paciente)).

dentista(saieg).
puedeAtenderA(saieg, Paciente) :- puedeAtenderA(_, Paciente).

% 2:
% precio(Servicio, Precio, Paciente).
precio(Servicio, Precio, PacienteConObraSocial) :-
    obraSocialPaciente(PacienteConObraSocial, ObraSocial),
    costo(ObraSocial, Servicio, Precio).

precio(Servicio, Precio, PacienteParticular) :-
    edadPaciente(PacienteParticular, Edad),
    precioSegunEdadPaciente(Servicio, Precio, Edad).

precioSegunEdadPaciente(Servicio, Precio, Edad) :- 
    Edad > 45,
    costo(Servicio, Costo),
    Precio is Costo + 50.

precioSegunEdadPaciente(Servicio, Precio, Edad) :-
    Edad =< 45,
    costo(Servicio, Precio).

edadPaciente(pacienteParticular(_, Edad), Edad).

precio(Servicio, Precio, PacienteDeClinica) :-
    clinicaPaciente(PacienteDeClinica, Clinica),
    clinica(Clinica, Porcentaje),
    costo(Servicio, Costo),
    Precio is Costo * (0.01 * Porcentaje).

% 3:
/* BASE DE CONOCIMIENTO EXTRA */
% servicioRealizado(fecha, dentista, servicio(servicio, functor paciente)) 
servicioRealizado(fecha(10, 11, 2010), pereyra, servicio(tratamientoConducto, pacienteObraSocial(karlsson, 1231, osde))). 
servicioRealizado(fecha(16, 11, 2010), pereyra, servicio(tratamientoConducto, pacienteClinica(dodino, odontoklin))). 
servicioRealizado(fecha(21, 12, 2010), deLeon, servicio(tratamientoConducto, pacienteObraSocial(karlsson, 1231, osde))). 

% montoFacturacion(Dentista, Mes, Cuanto).
montoFacturacion(Dentista, Mes, Cuanto) :-
    dentista(Dentista),
    mesDeLaFecha(_, Mes),
    findall(Monto, calculoCadaFacturacion(Mes, Dentista, Monto), Montos),
    sumlist(Montos, Cuanto).

mesDeLaFecha(fecha(_, Mes, _), Mes).

calculoCadaFacturacion(Mes, Dentista, Monto) :-
    servicioRealizado(Fecha, Dentista, Servicio),
    mesDeLaFecha(Fecha, Mes),
    servicioHechoA(Servicio, Tipo, Paciente),
    precio(Tipo, Monto, Paciente).

servicioHechoA(servicio(Tipo, Paciente), Tipo, Paciente).

% 4:
% dentistaCool(Dentista).
dentistaCool(Dentista) :-
    dentista(Dentista),
    forall(atendioA(Paciente, Dentista), esInteresante(Paciente)).

atendioA(Paciente, Dentista) :-
    servicioRealizado(_, Dentista, Servicio),
    servicioHechoA(Servicio, _, Paciente).

esInteresante(Paciente) :-
    obraSocialPaciente(Paciente, ObraSocial),
    costo(ObraSocial, tratamientoConducto, Precio),
    Precio > 1000.

esInteresante(pacienteParticular(_, _)).

% 5:
confia(pereyra, deLeon). 
confia(cureta, pereyra).

% atiendeDeUrgencia(Dentista, Paciente).
atiendeDeUrgencia(Dentista, Paciente) :-
    puedeAtenderA(Dentista, Paciente).

atiendeDeUrgencia(Dentista, Paciente) :-
    confia(Dentista, OtroDentista),
    atiendeDeUrgencia(OtroDentista, Paciente).

% 6:
% pacienteAlQueLeVieronLaCara(Paciente).
pacienteAlQueLeVieronLaCara(Paciente) :-
    esPaciente(Paciente),
    leVieronLaCaraSegun(Paciente).

leVieronLaCaraSegun(Paciente) :-
    obraSocialPaciente(Paciente, ObraSocial),
    serviciosCaros(ObraSocial, Servicios),
    forall(servicioHechos(Paciente, Servicio), member(Servicio, Servicios)).

leVieronLaCaraSegun(Paciente) :-
    esParticular(Paciente),
    forall(servicioHechos(Paciente, Servicio), esCaro(Servicio, Paciente)).

esCaro(Servicio, Paciente) :-
    precio(Servicio, Precio, Paciente),
    Precio > 500.

esPaciente(Paciente) :- puedeAtenderA(_, Paciente).
servicioHechos(Paciente, Servicio) :-
    servicioRealizado(_, _, servicio(Servicio, Paciente)).

% 7:
% serviciosMalHechos(Dentista, ServiciosMalHecho).
serviciosMalHechos(Dentista, ServiciosMalHecho) :-
    dentista(Dentista),
    findall(ServicioHecho, serviciosHechosPor(Dentista, ServicioHecho), Servicios),
    posiblesMalHechos(Servicios, ServiciosMalHecho).

serviciosHechosPor(Dentista, hecho(Servicio, Mes)) :-
    servicioRealizado(Fecha, Dentista, servicio(Servicio, _)).
    mesDeLaFecha(Fecha, Mes).

posiblesMalHechos([], []).
posiblesMalHechos([Servicio | Servicios], [Servicio | MalHechos]) :-
    mesYServicio(Servicio, Mes, ServicioMalHecho),
    Siguiente is Mes + 1,
    servicioRealizado(fecha(_, Siguiente, _), _, servicio(ServicioMalHecho, _)),
    posiblesMalHechos(Servicios, MalHechos).
posiblesMalHechos([_ | Servicio], MalHechos) :-
    posiblesMalHechos(Servicio, MalHechos).
