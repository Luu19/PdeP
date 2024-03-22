/* Parcial Lógico: Rey Leon 2010 */
/* BASE DE CONOCIMIENTO */
%comio(Personaje, Bicho)
comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).
comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).
comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).
pesoHormiga(2).

%peso(Personaje, Peso)
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).

% 1:
% a-
% jugosita(Cucaracha).
jugosita(Cucaracha) :-
    tamanioCucaracha(Cucaracha, Tamanio),
    pesoSegunBicho(Cucaracha, Peso),
    tamanioCucaracha(OtraCucaracha, Tamanio),
    pesoSegunBicho(OtraCucaracha, OtroPeso),
    Cucaracha \= OtraCucaracha,
    Peso > OtroPeso.

tamanioCucaracha(cucaracha(_, Tamanio, _), Tamanio).

% b-
% hormigofilico(Personaje).
hormigofilico(Personaje) :- 
    comio(Personaje, Hormiga),
    comio(Personaje, OtraHormiga),
    esHormiga(Hormiga),
    esHormiga(OtraHormiga),
    Hormiga \= OtraHormiga.

esHormiga(hormiga(_)).

% c-
% cucarachofobico(Personaje).
cucarachofobico(Personaje) :-
    personaje(Personaje),
    forall(comio(Personaje, Insecto), not(esCucaracha(Insecto))).

personaje(Personaje) :- peso(Personaje, _).

esCucaracha(cucaracha(_, _, _)).

% d-
% picarones(Picarones).
picarones(Picarones) :-
    findall(Personaje, personaje(Personaje), Personajes),
    posiblesPicarones(Personajes, Picarones).

posiblesPicarones([Personaje | Personajes], [Personaje | Picarones]) :-
    esPicaron(Personaje),
    posiblesPicarones(Personajes, Picarones).

posiblesPicarones([_ | Personajes], Picarones) :-
    posiblesPicarones(Personajes, Picarones).

esPicaron(Personaje) :- 
    comio(Personaje, Algo),
    esPicaronSegun(Algo).

esPicaron(pumba).

esPicaronSegun(Cucaracha) :- jugosita(Cucaracha).
esPicaronSegun(vaquitaSanAntonio(remeditos, _)).

% 2:
/* BASE DE CONOCIMIENTO EXTRA */
persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).

comio(shenzi,hormiga(conCaraDeSimba)).

peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

% a-
% engorda(Personaje, Cuanto).
engorda(Personaje, Cuanto) :-
    personaje(Personaje),
    findall(PesoBicho, pesoAnimalQueComio(Personaje, PesoBicho), Pesos),
    sumlist(Pesos, Cuanto).

pesoAnimalQueComio(Personaje, PesoBicho) :-
    comio(Personaje, Bicho),
    pesoSegunBicho(Bicho, PesoBicho).

engorda(Personaje, 0) :- esBicho(Personaje).

esBicho(cucaracha(_)).
esBicho(hormiga(_)).
esBicho(vaquitaSanAntonio(_)).

pesoSegunBicho(cucaracha(_, _, Peso), Peso).
pesoSegunBicho(Hormiga, Peso) :- esHormiga(Hormiga), pesoHormiga(Peso).
pesoSegunBicho(vaquitaSanAntonio(_, Peso), Peso).

% b-
% Al predicado anterior agrego:
pesoAnimalQueComio(Personaje, PesoAnimal) :-
    persigue(Personaje, Otro),
    peso(Otro, PesoAnimal),
    Personaje \= Otro.

% c-
% engorda(Personaje, Cuanto).
% hecho una vez más para evitar confusiones.
pesoAnimalQueComio(Personaje, PesoAnimal) :-
    persigue(Personaje, Otro),
    peso(Otro, Peso),
    engorda(Otro, CuantoOtro),
    PesoAnimal is Peso + CuantoOtro,
    Personaje \= Otro.

% 3:
% rey(Personaje).
rey(Rey) :-
    personaje(Rey),
    persigue(_, Rey),
    forall((personaje(Otro), Otro \= Rey), adora(Otro, Rey)).

adora(Personaje, Rey) :- not(comio(Rey, Personaje)).
adora(Personaje, Rey) :- not(persigue(Rey, Personaje)).

