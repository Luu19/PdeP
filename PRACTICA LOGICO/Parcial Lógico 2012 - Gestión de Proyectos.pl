/* Parcial Lógico : Gestión de Proyectos 2012 */
/*  BASE DE CONOCIMIENTO  */
proyecto(saeta, tarea(planificacion, 3, [])).
proyecto(saeta, tarea(encuesta, 5, [planificacion])).
proyecto(saeta, tarea(analisis, 5, [encuesta])).
proyecto(saeta, tarea(limpieza, 3, [planificacion])).
proyecto(saeta, tarea(diseño, 6, [analisis])).
proyecto(saeta, tarea(construccion, 5, [diseño, limpieza])).
proyecto(saeta, tarea(ejecucion, 4, [construccion])).
proyecto(saeta, tareaOpcional(presentacion, 4, 10)).

% tarea(nombre, duracion, tareasAnterioresRequeridas)
% tareaOpcional(nombre, cantidadPersonas, duracion)

% 1:
% sonConsecutivas(Tarea, OtraTarea).
sonConsecutivas(Tarea, OtraTarea) :-
    nombreTarea(Tarea, NombreTarea),
    nombreTarea(OtraTarea, NombreOtraTarea),
    esAnterior(NombreTarea, NombreOtraTarea).

esAnterior(TareaAnterior, Tarea) :- proyecto(_, tarea(Tarea, _, [TareaAnterior])).
esAnterior(TareaAnterior, Tarea) :- proyecto(_, tarea(Tarea, _, [_ | TareaAnterior])).

tareaDeProyecto(Proyecto, Tarea) :-
    proyecto(Proyecto, Tarea).

nombreTarea(tarea(Nombre, _, _), Nombre).
% 2:
% tareaPesada(Tarea).
tareaPesada(Tarea) :-
    esPesadaSegun(Tarea).

esPesadaSegun(tarea(_, _, [Tarea | _])).
esPesadaSegun(tareaOpcional(_, 1, _)).
esPesadaSegun(tarea(_, Duracion, _)) :-
     Duracion > 5.

% 3:
% tipoTarea(Tarea, Tipo).
% final -> no tiene tareas siguientes
% inicial -> no tiene tareas anteriores 
% intermedia -> no es final ni es inicial
tipoTarea(Tarea, Tipo) :-
    esTarea(Tarea),
    tipoTareaSegun(Tarea, Tipo).

tipoTareaSegun(tarea(_, _, []), inicial).
tipoTareaSegun(Tarea, final) :-
    nombreTarea(Tarea, Nombre),
    forall((tarea(OtraTarea, _, Anteriores), OtraTarea \= Nombre), not(member(Nombre, Anteriores))).

tipoTarea(Tarea, intermedia) :-
    not(esTarea(Tarea, inicial)),
    not(esTarea(Tarea, final)).

esTarea(Tarea) :- proyecto(_, Tarea).

% 4:
% caminoEntreTareas(Tarea, OtraTarea, Camino).
caminoEntreTareas(Tarea, OtraTarea, Camino) :-
    proyecto(Proyecto, Tarea),
    proyecto(Proyecto, OtraTarea),

% 5:
% esCaminoPesado(Camino).
esCaminoPesado(Camino) :-
    caminoEntreTareas(_, _, Camino),
    todasSonTareasPesadas(Camino),
    duracionCamino(Camino, Duracion).
    Duracion > 100.

todasSonTareasPesadas(Camino) :-
    forall(member(Tarea, Camino), tareaPesada(Tarea)).

duracionCamino(Camino, Duracion) :-
    findall(DuracionTarea, duracionTareaCamino(Camino, DuracionTarea), Duraciones),
    sumlist(Duraciones, Duracion).

duracionTareaCamino(Camino, DuracionTarea) :-
    member(Tarea, Camino),
    duracionTarea(Tarea, DuracionTarea).

duracionTarea(tarea(_, Duracion, _), Duracion).

% 6:
% cantidadTareasAnteriores(Tarea, Cantidad).
cantidadTareasAnteriores(Tarea, 1) :-
    tareaAnterior(Tarea, TareaAnterior).

cantidadTareasAnteriores(Tarea, Cantidad) :-
    sonConsecutivas(OtraTarea, Tarea),
    cantidadTareasAnteriores()