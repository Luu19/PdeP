/* Parcial Lógico: Ayudantes 2011 */
/* BASE DE CONOCIMIENTO */
% Las tareas son functores de la forma
% corregirTp(fechaEnQueElGrupoEntrego, grupo, paradigma) 
% robarseBorrador(diaDeLaClase, horario)
% prepararParcial(paradigma).
tarea(vero, corregirTp(190, losMagiosDeTempeley, funcional)).
tarea(hernan, corregirTp(181, analiaAnalia, objetos)).
tarea(hernan, robarseBorrador(197, turnoMañana)).
tarea(hernan, prepararParcial(objetos)).
tarea(alf, prepararParcial(funcional)).
tarea(nitu, corregirTp(190, analiaAnalia, funcional)).
tarea(ignacio, corregirTp(186, laTerceraEsLaVencida, logico)).
tarea(clara, robarseBorrador(197, turnoNoche)).
tarea(hugo, corregirTp(10, laTerceraEsLaVencida, objetos)). 
tarea(hugo, robarseBorrador(11, turnoNoche)).

% Estos grupos están en problemas
noCazaUna(loMagiosDeTempeley).
noCazaUna(losExDePepita).

% El 1 es el primero de enero, el 32 es el 1 de febrero, etc
diaDelAnioActual(192).

% 1:
% a-
% esDificil(Tarea).
esDificil(corregirTp(_, Grupo, _)) :- noCazaUna(Grupo).
esDificil(corregirTp(_, _, objetos)).
esDificil(prepararParcial(_)).
esDificil(robarseBorrador(_, turnoNoche)).

% b- 
% estaAtrasada(Ayudante, TareaDelAyudante).
estaAtrasada(Ayudante, Tarea) :-
    tarea(Ayudante, Tarea),
    diasDeAtraso(Tarea, Dias),
    Dias > 3.

diasDeAtraso(Tarea, Dias) :-
    diaDelAnioActual(DiaHoy),
    fechaVencimientoTarea(Tarea, FechaVencimiento),
    Dias is  DiaHoy - FechaVencimiento.

fechaVencimientoTarea(robarseBorrador(Fecha, _), Fecha).
fechaVencimientoTarea(corregirTp(FechaEntrega, _, _), Fecha) :- Fecha is FechaEntrega + 4. 

% c-
esGrupo(Grupo) :- tarea(_, corregirTp(_, Grupo, _)).

corrigeTp(Ayudante, Grupo) :-
    tarea(Ayudante, corregirTp(_, Grupo, _)).

% verdugos(Grupo, ListaDeAyudantes).
verdugos(Grupo, Ayudantes) :-
    esGrupo(Grupo),
    forall(member(Ayudante, Ayudantes), corrigeTp(Ayudante, Grupo)).

%%
verdugos(Grupo, Ayudantes) :-
    esGrupo(Grupo),
    findall(Ayudante, corrigeTp(Ayudante, Grupo), Ayudantes).

% 2:
/* BASE DE CONOCIMIENTO EXTRA */
laburaEnProyectoEnLLamas(alf).
laburaEnProyectoEnLLamas(hugo).

cursa(nitu, [ operativos, diseño, analisisMatematico2 ]).
cursa(clara, [ sintaxis, operativos ]).
cursa(ignacio, [ tacs, administracionDeRecursos ] ).

tienePareja(nitu).
tienePareja(alf).

ayudante(P) :- tarea(P, _).

% a-
% tieneProblemitas(Persona).
tieneProblemitas(Persona) :-
    ayudante(Persona),
    tieneProblemasSegun(Persona).

tieneProblemasSegun(Persona) :- tienePareja(Persona).
tieneProblemasSegun(Persona) :- laburaEnProyectoEnLLamas(Persona).
tieneProblemasSegun(Persona) :- cursa(Persona, Materias), member(operativos, Materias).

% b-
% alHorno(Persona).
alHorno(Persona) :- 
    ayudante(Persona),
    tieneProblemitas(Persona),
    estaAtrasada(Persona, _),
    tieneTodasTareasDificiles(Persona).

tieneTodasTareasDificiles(Persona) :-
    ayudante(Persona),
    forall(tarea(Persona, Tarea), esDificil(Tarea)).

% 3:
/*
3.a Se tiene la siguiente consulta: 
?- tareaAtrasada(franco, prepararParcial(logico)). 
● ¿Cual es su valor de verdad?
    - Su valor de verdad es FALSE, ya que no se contempla la tarea de preparar final para el predicado
    tareaAtrasada.
● ¿Con qué concepto está relacionado?
    - Está relacionado el concepto de Principio de Universo Cerrado.

3.b ¿Dónde se utilizó el polimorfismo? ¿Para qué fue util? 
    - Se utilizó polimofismo en el puto 2a. Fue útil para no realizar varias declaraciones de la regla y,
    por lo tanto, evitar la repetición de lógica.

*/