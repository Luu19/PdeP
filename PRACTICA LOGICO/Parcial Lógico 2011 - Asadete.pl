/* Parcial Lógico: El Asadito 2011 */
/* BASE DE CONOCIMIENTO */
% define quiénes son amigos de nuestro cliente
amigo(mati). 
amigo(pablo). 
amigo(leo).
amigo(fer). 
amigo(flor).
amigo(ezequiel). 
amigo(marina).

% define quiénes no se pueden ver
noSeBanca(leo, flor). 
noSeBanca(pablo, fer).
noSeBanca(fer, leo). 
noSeBanca(flor, fer).

% define cuáles son las comidas y cómo se componen
% functor achura contiene nombre, cantidad de calorías
% functor ensalada contiene nombre, lista de ingredientes
% functor morfi contiene nombre (el morfi es una comida principal)
comida(achura(chori, 200)). 
comida(achura(chinchu, 150)).
comida(ensalada(waldorf, [manzana, apio, nuez, mayo])).
comida(ensalada(mixta, [lechuga, tomate, cebolla])).
comida(morfi(vacio)).
comida(morfi(mondiola)).
comida(morfi(asado)).

% relacionamos la comida que se sirvió en cada asado
% cada asado se realizó en una única fecha posible: functor fecha + comida 
asado(fecha(22,9,2011), chori). 
asado(fecha(22,9,2011), waldorf). 
asado(fecha(22,9,2011), vacio). 
asado(fecha(15,9,2011), mixta).
asado(fecha(15,9,2011), mondiola).
asado(fecha(15,9,2011), chinchu).

% relacionamos quiénes asistieron a ese asado
asistio(fecha(15,9,2011), flor). 
asistio(fecha(15,9,2011), pablo). 
asistio(fecha(15,9,2011), leo). 
asistio(fecha(15,9,2011), fer). 
asistio(fecha(22,9,2011), marina).
asistio(fecha(22,9,2011), pablo).
asistio(fecha(22,9,2011), flor).
asistio(fecha(22,9,2011), mati).

% definimos qué le gusta a cada persona
leGusta(mati, chori). 
leGusta(fer, mondiola). 
leGusta(pablo, asado).
leGusta(mati, vacio). 
leGusta(fer, vacio).
leGusta(mati, waldorf). 
leGusta(flor, mixta).

% 1:
% a-
leGusta(ezequiel, Algo) :- leGusta(mati, Algo).
leGusta(ezequiel, Algo) :- leGusta(fer, Algo).

% b-
leGusta(marina, Algo) :- leGusta(flor, Algo).
leGusta(marina, mondiola).

% c-
leGusta(leo, Algo) :- leGusta(_, Algo), Algo \= waldorf.

% 2:
% asadoViolento(Fecha).
asadoViolento(Fecha) :-
    asado(Fecha, _),
    forall(asistio(Fecha, Alguien), soportoAAlguien(Alguien, Fecha)).

soportoAAlguien(Alguien, Fecha) :-
    asistio(Fecha, Otra),
    noSeBanca(Alguien, Otra).

% 3:
% calorias(Comida, Calorias).
calorias(Comida, Calorias) :-
    comida(Comida),
    calculoCaloriasSegun(Comida, Calorias).

calculoCaloriasSegun(achura(_, Calorias), Calorias).
calculoCaloriasSegun(morfi(_), 200).
calculoCaloriasSegun(ensalada(_, Ingredientes), Cantidad) :-
    length(Ingredientes, Cantidad).

% 4:
% asadoFlojito(Fecha).
asadoFlojito(Fecha) :-
    asado(Fecha, _),
    findall(Caloria, caloriasDeComidasEn(Fecha, Caloria), Calorias),
    sumlist(Calorias, Total),
    between(0, 400, Total).

caloriasDeComidasEn(Fecha, Calorias) :-
    asado(Fecha, NombreComida),
    informacionComida(NombreComida, Comida),
    calorias(Comida, Calorias).

informacionComida(NombreComida, achura(NombreComida, _)).
informacionComida(NombreComida, ensalada(NombreComida, _)).
informacionComida(NombreComida, morfi(NombreComida)).

% 5:
/* BASE DE CONOCIMIENTO EXTRA */
hablo(fecha(15,09,2011), flor, pablo). 
hablo(fecha(15,09,2011), pablo, leo). 
hablo(fecha(15,09,2011), leo, fer). 
hablo(fecha(22,09,2011), flor, marina).
hablo(fecha(22,09,2011), marina, pablo).
reservado(marina).

% chismeDe(Fecha, ConoceChisme, DeQuienConocenElChisme).
chismeDe(Fecha, ConoceChisme, DeQuienConocenElChisme) :-
    hablo(Fecha, ConoceChisme, DeQuienConocenElChisme).

chismeDe(Fecha, ConoceChisme, DeQuienConocenElChisme) :-
    hablo(Fecha, ConoceChisme, DeQuienConocenElChisme),
    reservado(ConoceChisme).

chismeDe(Fecha, ConoceChisme, DeQuienConocenElChisme) :-
    hablo(Fecha, OtraPersona, DeQuienConocenElChisme),
    not(reservado(OtraPersona)),
    chismeDe(Fecha, ConoceChisme, OtraPersona).

% 6:
% disfruto(Persona, FechaAsado).
disfruto(Persona, Fecha) :-
    amigo(Persona),
    asado(Fecha, _),
    findall(Comida, comidasQueLeGustaron(Persona, Fecha, Comida), Comidas),
    length(Comidas, Total),
    Total > 3.

comidasQueLeGustaron(Persona, Fecha, Comida) :-
    asistio(Fecha, Persona),
    asado(Fecha, Comida),
    leGusta(Persona, Comida).

% 7:
% asadoRico(ComidasRicas).
asadoRico(ComidasRicas) :-
    findall(Comida, comida(Comida), Comidas),
    sonRicas(Comidas, ComidasRicas)
    ComidasRicas \= [].

sonRicas([], []).
sonRicas([Comida | Comidas], [Comida | ComidasRicas]) :-
    esRica(Comida),
    sonRicas(Comidas, ComidasRicas).

sonRicas([_, | Comidas], ComidasRicas) :- 
    sonRicas(Comidas, ComidasRicas).

esRica(morfi(_)).
esRica(ensalada(_, Ingredientes)) :- length(Ingredientes, Cantidad), Cantidad > 3.
esRica(achura(Tipo)) :- esMorciOChori(Tipo).

esMorciOChori(morci).
esMorciOChori(chori).
