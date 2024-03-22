/* Parcial Logico : Nailed It */
/* BASE DE CONOCIMIENTO */
ingrediente(cupcake, harina(165, reposteria)).
ingrediente(cupcake, mantequilla(sinSal, 165)).
ingrediente(cupcake, azucar(165)).
ingrediente(cupcake, leche).
ingrediente(cupcake, huevos(3)).

participante(juan).
participante(susana).

suministro(juan, harina(200, reposteria)).
suministro(juan, mantequilla(conSal, 200)).
suministro(juan, azucar(1000)).
suministro(juan, leche).
suministro(juan, huevos(12)).

% 1:
% a:
suministro(Participante, manteca) :- participante(Participante).

% b - i:
hizo(juan, cupcake).
hizo(juan, torta).

% b - ii:
hizo(susana, muffins).

% 2:
% supongo que Ingrediente es un functor
% tieneSuficiente(Participante, Ingrediente).
tieneSuficiente(Participante, Ingrediente) :-
    tipoIngrediente(Ingrediente, Tipo),
    cantidadPosee(Participante, Tipo, CantidadIngrediente),
    cantidadDeIngrediente(Ingrediente, Cantidad),
    CantidadIngrediente >= Cantidad.


tipoIngrediente(harina(_, _), harina).
tipoIngrediente(mantequilla(_, _), mantequilla).
tipoIngrediente(huevos(_), huevos).
tipoIngrediente(leche, leche).
tipoIngrediente(azucar(_), azucar).
tipoIngrediente(manteca, manteca).

cantidadPosee(Participante, Tipo, CantidadIngrediente) :-
    participante(Participante),
    suministro(Participante, Ingrediente),
    tipoIngrediente(Ingrediente, Tipo),
    cantidadDeIngrediente(Ingrediente, CantidadIngrediente).

cantidadDeIngrediente(harina(Cantidad, _), Cantidad).
cantidadDeIngrediente(mantequilla(_, Cantidad), Cantidad).
cantidadDeIngrediente(huevos(Cantidad), Cantidad).
cantidadDeIngrediente(azucar(Cantidad), Cantidad).

% 3:
% puedeHacerReceta(Participante, Receta).
puedeHacerReceta(Participante, Receta) :-
    participante(Participante),
    esReceta(Receta),
    forall(ingrediente(Receta, Ingrediente), tieneSuficiente(Participante, Ingrediente)),
    suministro(Participante, manteca).

esReceta(R) :- ingrediente(R, _).

% 4:
% esDesafio(Participante, Receta).
esDesafio(Participante, Receta) :-
    participante(Participante),
    esReceta(Receta),
    forall( (recetaSimilar(Receta, OtraReceta), Receta \= OtraReceta), not(hizo(Participante, OtraReceta)) ).

recetaSimilar(Receta, Similar) :-
    esReceta(Receta),
    esReceta(Similar),
    Receta \= Similar,
    findall(Ingrediente, ingredienteSimilarEnComun(Receta, Similar, Ingrediente), Ingredientes),
    length(Ingredientes, Cantidad),
    Cantidad >= 3.

ingredienteSimilarEnComun(Receta, OtraReceta, IngredienteSimilar) :-
    nombreIngredienteReceta(Receta, NombreIngrediente),
    nombreIngredienteReceta(OtraReceta, NombreIngrediente),
    requisitosDeIngredienteSimilar(NombreIngrediente, IngredienteSimilar).

requisitosDeIngredienteSimilar(NombreIngrediente, IngredienteSimilar) :-
    tipoIngrediente(IngredienteSimilar, NombreIngredienteSimilar),
    ingredienteSimilar(NombreIngrediente, NombreIngredienteSimilar).

requisitosDeIngredienteSimilar(_, IngredienteSimilar) :-
    findall(NombreIngrediente, (nombreIngredienteReceta(_, NombreIngrediente), Nombres),
    tipoIngrediente(IngredienteSimilar, Nombre),
    member(Nombre, Nombres).

nombreIngredienteReceta(Receta, NombreIngrediente) :-
    ingrediente(Receta, Ingrediente),
    tipoIngrediente(Ingrediente, NombreIngrediente).

% 5:
/*
a: Debería agregar tipoIngrediente y cantidadIngrediente solamente.
b: el concepto que ayuda a que la modificacion tenga menor impacto es el concepto de polimorfismo.
*/

% 6:
% felicidadDada(Participante, Felicidad).
felicidadDada(Participante, Felicidad) :-
    esReceta(Receta),
    felicidadReceta(Receta, FelicidadDeReceta),
    extra(Participante, Receta, FelicidadDeReceta, Felicidad).

felicidadReceta(Receta, FelicidadDeReceta) :-
    findall(Gramos, gramosDeCadaIngrediente(Receta, Gramos), ListaDeGramos),
    sumlist(ListaDeGramos, FelicidadDeReceta).

extra(Participante, Receta, FelicidadDeReceta, Felicidad) :-
    hizo(Participante, Receta),
    Felicidad is FelicidadDeReceta + 100.

extra(Participante, Receta, Felicidad, Felicidad) :-
    participante(Participante),
    esReceta(Receta),
    not(hizo(Participante, Receta)).

gramosDeCadaIngrediente(Receta, Gramos) :-
    ingrediente(Receta, Ingrediente),
    gramosSegun(Ingrediente, Gramos).

gramosSegun(Ingrediente, Gramos) :-
    tipoIngrediente(Ingrediente, Tipo), Tipo \= huevos, Tipo \= leche,
    cantidadDeIngrediente(Ingrediente, Gramos).

gramosSegun(Ingrediente, 0) :-
    esHuevoOLeche(Ingrediente).

esHuevoOLeche(huevos(_)).
esHuevoOLeche(leche).

% 7:
% esRemotamenteParecida(Receta, OtraReceta).
esRemotamenteParecida(Receta, OtraReceta) :-
    recetaSimilar(Receta, OtraReceta).

esRemotamenteParecida(Receta, OtraReceta) :- % PREGUNTAR A FEDE
    doble(0, Uno),
    recetaSimilar(Receta, Otra),
    esRemotamenteParecida(Otra, OtraReceta),
    Contador is Uno + 1,
    Contador =< 7,
    doble(Contador, Uno),.

doble(N, N).