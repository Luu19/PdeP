/*  Parcial Logico : Delivery de Comidas 2012   */
/*  BASE DE CONOCIMIENTO  */
%composicion(plato, [ingrediente])
composicion(platoPrincipal(milanesa),[ingrediente(pan,3), ingrediente(huevo,2),ingrediente(carne,2)]).
composicion(entrada(ensMixta),[ingrediente(tomate,2), ingrediente(cebolla,1),ingrediente(lechuga,2)]).
composicion(entrada(ensFresca),[ingrediente(huevo,1), ingrediente(remolacha,2),ingrediente(zanahoria,1)]).
composicion(postre(budinDePan),[ingrediente(pan,2),ingrediente(caramelo,1)]).

%calorías(nombreIngrediente, cantidadCalorias)
calorias(pan,30).
calorias(huevo,18).
calorias(carne,40).
calorias(caramelo,170).

%proveedor(nombreProveedor, [nombreIngredientes])
proveedor(disco, [pan, caramelo, carne, cebolla]).
proveedor(sanIgnacio, [zanahoria, lechuga, miel, huevo]).

% 1:
% caloriasTotal(Plato, CantidadDeCalorias).
caloriasTotal(Plato, CantidadDeCalorias) :-
    plato(Plato),
    findall(CaloriasIngrediente, caloriasDeIngrediente(Plato, Calorias), CaloriasPlato),
    sumlist(CaloriasPlato, CantidadDeCalorias).

plato(Plato) :- composicion(Plato, _).

caloriasDeIngrediente(Plato, Calorias) :-
    ingredienteDePlato(Ingrediente, Plato),
    tipoIngrediente(Ingrediente, TipoIngrediente),
    cantidadIngrediente(Ingrediente, Cantidad),
    calorias(TipoIngrediente, CaloriasIngrediente),
    Calorias is CaloriasIngrediente * Cantidad.

ingredienteDePlato(Ingrediente, Plato) :- 
    composicion(Plato, Ingredientes),
    member(Ingrediente, Ingredientes).

tipoIngrediente(ingrediente(Nombre, _), Nombre).
cantidadIngrediente(ingrediente(_, Cantidad), Cantidad).

% 2:
% platoSimpatico(Plato).
platoSimpatico(Plato) :-
    tiene(pan, Plato),
    tiene(huevo, Plato),
    caloriasTotal(Plato, CaloriasPorcion),
    between(0, 199, CaloriasPorcion).

tiene(NombreIngrediente, Plato) :-
    ingredienteDePlato(ingrediente(NombreIngrediente, _), Plato).

% 3:
% menuDiet(Entrada, PlatoPrincipal, Postre).
menuDiet(Entrada, PlatoPrincipal, Postre) :-
    esEntrada(Entrada),
    esPlatoPrincipal(PlatoPrincipal),
    esPostre(Postre),
    caloriasTotal(Entrada, CaloriasEntrada),
    caloriasTotal(PlatoPrincipal, CaloriasPlatoPrincipal),
    caloriasTotal(Postre, CaloriasPostre),
    CaloriasTresPlatos CaloriasEntrada + CaloriasPlatoPrincipal + CaloriasPostre,
    between(0, 450, CaloriasTresPlatos).

esEntrada(entrada(_)).
esPlatoPrincipal(platoPrincipal(_)).
esPostre(postre(_)).

% 4:
% tieneTodo(Proveedor, Plato).
tieneTodo(Proveedor, Plato) :-
    plato(Plato),
    proveedor(Proveedor, LoQueTiene),
    forall(tiene(NombreIngrediente, Plato), member(NombreIngrediente, LoQueTiene)).

% 5:
% ingredientePopular(Ingrediente).
ingredientePopular(Ingrediente) :-
    tiene(Ingrediente, _),
    findall(Plato, tiene(Ingrediente, Plato), Platos),
    length(Platos, Total),
    Total > 3.

% 6:
% cantidadTotal(Ingrediente, ListaDeCantidadesDePlatos, TotalNecesarioDeIngredienteParaHacerLista).
cantidadTotal(Ingrediente, ListaPlatos, Total) :-
    tiene(Ingrediente, _),
    findall(CantidadTiene, cantidadCadaPlato(Ingrediente, ListaPlatos, CantidadTiene), Cantidades),
    sumlist(Cantidades, Total).

cantidadCadaPlato(Ingrediente, ListaPlatos, Cantidad) :-
    member(PlatoYCantidad, ListaPlatos),
    cantidadYPlato(PlatoYCantidad, Plato, CantidadDePlatos),
    cuantoRequiere(Plato, Ingrediente, CantidadIngrediente),
    Cantidad is CantidadIngrediente * CantidadDePlatos.

cuantoRequiere(Plato, NombreIngrediente, Cantidad) :-
    ingredienteDePlato(Ingrediente, Plato),
    tipoIngrediente(Ingrediente, NombreIngrediente),
    cantidadIngrediente(Ingrediente, Cantidad).

cantidadYPlato(cantidad(Plato, CantidadDePlatos), Plato, CantidadDePlatos).