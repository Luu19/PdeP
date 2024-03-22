{-
La PIZZA tiene:
    INGREDIENTES
    TAMANIO --> CANTIDAD DE PORCIONES
    CANTIDAD DE CALORIAS

En cuanto al tamanio:
4 porciones = individual
6 = chica
8 = grande
10 = gigante

-}

--1.
--a.
data Pizza = Pizza {
    ingredientes :: [String]
    tamanio :: Int,
    cantidadCalorias :: Int
} deriving (Show)

--b.
grandeDeMuzza :: Pizza
grandeDeMuzza = Pizza ["salsa", "mozzarella", "oregano"] 8 350

--2.
nivelDeSatisfaccion :: Pizza -> Int
nivelDeSatisfaccion pizza 
    | contiene  pizza "palmito"      = 0
    | (cantidadCalorias pizza) < 500 = calculaSatisfaccion pizza
    | otherwise                      = div (calculaSatisfaccion pizza) 2

contiene :: Pizza -> String -> Bool
contiene pizza ingrediente = elem ingrediente (ingredientes pizza)

cantidadDeIngredientes :: Pizza
cantidadDeIngredientes = (length . ingredientes)

calculaSatisfaccion :: Pizza -> Int
calculaSatisfaccion pizza = (* 80) $ cantidadDeIngredientes pizza

--3.
valorDePizza :: Pizza -> Int
valorDePizza pizza = (* tamanio pizza) . (* 120) . cantidadDeIngredientes $ pizza

--4.
modificaIngredinte :: ([String] -> [String]) -> Pizza -> Pizza
modificaIngredinte funcion pizza = pizza { ingredientes = funcion (ingredientes pizza) }

modificaTamanio :: (Int -> Int) -> Pizza -> Pizza
modificaTamanio funcion pizza 
    | funcion (tamanio pizza) == 8 = tamanio pizza
    | otherwise                    = f (tamanio pizza)

agregaIngredientes :: [String] -> Pizza -> Pizza
agregaIngredientes ingredientes pizza = modificaIngrediente ( ++ ingredientes) pizza

sumaCalorias :: Int -> Pizza -> Pizza
sumaCalorias caloriasASumar pizza = pizza { cantidadCalorias = (cantidadCalorias pizza) + caloriasASumas }

--a.
nuevoIngrediente :: String -> Pizza -> Pizza
nuevoIngrediente ingrediente pizza = modificaIngrediente ( ++ ingrediente) pizza

--b.
agrandar :: Pizza -> Pizza
agrandar pizza = modificaTamanio (+ 2) $ pizza

--c.
mezcladita :: Pizza -> Pizza -> Pizza
mezcladita pizza1 pizza2 = sumaCalorias (div (cantidadCalorias pizza1) 2)  . (flip agregaIngredientes pizza2) . filter (flip not.contiene pizza2) $ (ingredientes pizza1)

--5.
type Pedido = [Pizza]

nivelDeSatisfaccionPedido :: Pedido -> Int
nivelDeSatisfaccion pedido = sum . map calculaSatisfaccion $ pedido

--6.
type Pizzeria = Pedido -> Pedido
--a.
pizzeriaLosHijosDePato :: Pizzeria
pizzeriaLosHijosDePato pedido = map (nuevoIngrediente "palmito") pedido 

--b.
pizzeriaElResumen :: Pizzeria
pizzeriaElResumen           [pizza]          =  [pizza]
pizzeriaElResumen (pizza1 : pizza2 : pizzas) = (mezcladita pizza1 pizza2) : pizzeriaElResumen pizzas

--c.
pizzeriaEspecial :: Pizza -> Pizzeria
pizzeriaEspecial pizzaPredilecta pedido = map (mezcladita pizzaPredilecta) pedido

pizzeriaPescadito :: Pizzeria
pizzeriaPescadito pedido = pizzeriaEspecial anchoasBasica pedido

anchoasBasica = Pizza ["salsa", "anchoas"] 8 270

--d.
pizzeriaGourmet :: Int -> Pizzeria
pizzeriaGourmet nivelDeExquisitez pedido = map agrandar . filter ((> nivelDeExquisitez).nivelDeSatisfaccion) $ pedido

pizzeriaLaJaula :: Pizzeria
pizzeriaLaJaula pedido = pizzeriaGourmet 399 pedido

--7.
--a.
sonDignasDeCalleCorrientes :: Pedido -> [Pizzeria] -> [Pizzeria]
sonDignasDeCalleCorrientes pedido pizzerias = filter superaElNivelDeSatisfaccion . map ($ pedido) $ pizzerias

superaElNivelDeSatisfaccion :: Pedido -> Bool
superaElNivelDeSatisfaccion pedido = (> (nivelDeSatisfaccionPedido pedido) . nivelDeSatisfaccionPedido ) 

--b.
mejorPizzeria :: Pedido -> [Pizzeria] -> Pizzeria
mejorPizzeria pedido pizzeria = foldl1 (mayorSegun (nivelDeSatisfaccionPedido pedido)) pizzeria

mayorSegun :: (a -> Int) -> a -> a -> a
mayorSegun f a b
    | f a > f b = a
    | otherwise = b

--8.
yoPidoCualquierPizza 
yoPidoCualquierPizza x y z = any (odd . x . fst) z && all (y . snd) z

--9.
laPizzeriaPredilecta :: [Pizzeria] -> Pizzeria
laPizzeriaPredilecta pizzerias = foldl1 ( . ) (head pizzerias) pizzerias   