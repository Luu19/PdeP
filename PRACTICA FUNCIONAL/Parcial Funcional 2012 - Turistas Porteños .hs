{-
De los LUGARes se conoce :
    NOMBRE 
    DISTANCIA
    CARACTERISTICAS -> Lista de atracciones o cosas tipicas del lugar

-}

data Lugar = Lugar {
    nombre :: String,
    distanciaDeBsAs :: Int,
    caracteristicas :: [String] 
} deriving (Show)

data Turista = Turista {
    nombreTurista :: String,
    estilo :: Lugar -> Bool
} deriving (Show)

--1.
esComestible :: String -> Bool
esComestible producto = any (== "Comestible") $ words producto
{- Ejem.: esComestible "Comestible : Chocolate"
        any (== "Comestible") ["Comestible", ":", "Cholocate"] -> True
-}

--2.
puedeIr :: Turista -> [Lugar] -> [Lugar]
puedeIr turista lugares = filter (estilo turista) lugares

--3.
lugarMasElegido :: [Turista] -> [Lugar] -> Lugar
lugarMasElegido turistas lugares = head . (flip filter lugares) $ foldr1 (.) (map estilo turistas) 

--4.
puedenIrTodosA :: [Turista] -> Lugar -> Bool
puedenIrTodosA turistas lugar = all (flip puedeIr lugar) turistas

--5.
compatiblesParaTodos :: [Turista] -> [Lugar] -> [Lugar]
compatiblesParaTodos familia lugares = filter (puedenIrTodosA familia) lugares
