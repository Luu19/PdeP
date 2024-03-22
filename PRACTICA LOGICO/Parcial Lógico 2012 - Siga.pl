/* Parcial Lógico : SIGADEP 2012 */
/* BASE DE CONOCIMIENTO */
%Días de cursadas (toda materia que se dicte ofrece al menos una opción horaria)
opcionHoraria(paradigmas, lunes).
opcionHoraria(paradigmas, martes).
opcionHoraria(paradigmas, sabados).
opcionHoraria(algebra, lunes).

%Correlatividades
correlativa(paradigmas, algoritmos).
correlativa(paradigmas, algebra).
correlativa(analisis2, analisis1).

%cursada(persona,materia,evaluaciones)
cursada(maria,algoritmos,[parcial(5),parcial(7),tp(mundial,bien)]).
cursada(maria,algebra,[parcial(5),parcial(8),tp(geometria,excelente)]).
cursada(maria,analisis1,[parcial(9),parcial(4),tp(gauss,bien), tp(limite,mal)]).
cursada(wilfredo,paradigmas,[parcial(7),parcial(7),parcial(7),tp(objetos,excelente),tp(logico,excelente),tp(funcional,excelente)]).
cursada(wilfredo,analisis2,[parcial(8),parcial(10)]).

% 1:
% notaFinal(ListaDeEvaluciones, NotaFinal).
    % excelente -> 10
    % bien -> 7
    % mal -> 2
evaluaciones(E) :- cursada(_, _, Evaluciones).

notaFinal(Evaluciones, NotaFinal) :-
    evaluaciones(E),
    findall(Nota, notaDeCadaEvalucion(Evaluciones, Nota), Notas),
    sumlist(Notas, NotaFinal).

notaDeCadaEvalucion(Evaluciones, Nota) :-
    member(Evalucion, Evaluciones),
    notaSegunEvaluacion(Evalucion, Nota).

notaDeCadaEvalucion(parcial(Nota), Nota).
notaDeCadaEvalucion(tp(_, Tipo), Nota) :- tipoNotaTp(Tipo, Nota).

tipoNotaTp(excelente, 10).
tipoNotaTp(bien, 7).
tipoNotaTp(mal, 2).

% 2:
% aprobo(Persona, Materia).
aprobo(Persona, Materia) :-
    cursada(Persona, Materia, Evaluciones),
    notaFinal(Evaluciones, NotaFinal),
    NotaFinal > 4,
    tieneTodoAprobado(Evaluciones).

tieneTodoAprobado(Evaluciones) :-
    evaluaciones(Evaluciones),
    forall(notaDeCadaEvalucion(Evaluciones, Nota), Nota > 4).

% 3:
% puedeCursar(Persona, MateriaQuePuedeCursar).
puedeCursar(Persona, Materia) :-
    esAlumno(Persona),
    esMateria(Materia),
    not(aprobo(Persona, Materia)),
    puedeCursarSegun(Persona, Materia).

puedeCursarSegun(Persona, Materia) :- 
    forall(correlativa(Materia, Correlativa), aprobo(Persona, Correlativa)).

puedeCursarSegun(_, Materia) :- not(correlativa(Materia, _)).

esAlumno(P) :- cursada(P, _, _).
esMateria(M) :- cursada(_, M, _).

% 4:
% opcionesDeCursada(Alumno, OpcionDeCursada).
opcionesDeCursada(Persona, Opciones) :- 
    esAlumno(Persona),
    findall(Materia, puedeCursar(Persona, Materia), Materias),
    esPosibleOpcion(Materias, Opciones).

esPosibleOpcion([Materia|Materias], [Opcion|Opciones]) :-
    opcionHoraria(Materia, Horario),
    esOpcion(Materia, Horario, Opcion),
    esPosibleOpcion(Materias, Opciones).

esPosibleOpcion([_|Materias], Opciones) :-
    esPosibleOpcion(Materias, Opciones).

esOpcion(Materia, Horario, opcion(Materia, Horario)).

% 5:
% a-
% sinSuperposiciones(ListaDeOpciones, Cursada).
sinSuperposiciones(Opciones, Cursada) :-
    