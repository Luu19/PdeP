data Persona = Persona {
    nombrePersona :: String,
    suerte :: Int,
    inteligencia :: Int,
    fuerza :: Int
} deriving (Show, Eq)

data Pocion = Pocion {
    nombrePocion :: String,
    ingredientes :: [Ingrediente]
}

type Efecto = Persona -> Persona

data Ingrediente = Ingrediente {
    nombreIngrediente :: String,
    efectos :: [Efecto]
}

nombresDeIngredientesProhibidos = [
    "sangre de unicornio",
    "veneno de basilisco",
    "patas de cabra",
    "efedrina"
]

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun _ [ x ] = x
maximoSegun f ( x : y : xs)
    | f x > f y = maximoSegun f (x:xs)
    | otherwise = maximoSegun f (y:xs)

--1.
--a.
sumaDeNiveles :: Persona -> Int
sumaDeNiveles persona = suerte persona + fuerza persona + inteligencia persona

--b.
diferenciaDeNiveles :: Persona -> Int
diferenciaDeNiveles persona = nivelMasAlto persona - nivelMasBajo persona

nivelMasAlto :: Persona -> Int
nivelMasAlto persona = maximum [suerte persona, inteligencia persona, fuerza persona]

nivelMasBajo :: Persona -> Int
nivelMasBajo persona = minimum [suerte persona, inteligencia persona, fuerza persona]

--c.
nivelesMayoresA :: Int -> Persona -> Int
nivelesMayoresA n persona = length . filter (> n) $ [suerte persona, inteligencia persona, fuerza persona]

--2.
efectosDePocion :: Pocion -> [Efecto]
efectosDePocion pocion = concat . map efectos $ ingredientes pocion

--3.
--a.
pocionHardcore :: [Pocion] -> [String]
pocionHardcore pociones = filter (tieneAlMenosXEfectos 4) pociones

tieneAlMenosXEfectos :: Int -> Pocion -> Bool
tieneAlMenosXEfectos cantidad pocion = (=> cantidad ) . length . efectosDePocion $ pocion

--b.
pocionesProhibidas :: [Pocion] -> Int
pocionesProhibidas pociones = length . filter tieneIngredienteProhibido $ pociones 

tieneIngredienteProhibido :: Pocion -> Bool
tieneIngredienteProhibido pocion = any (flip elem nombresDeIngredientesProhibidos) (map nombreIngrediente . ingredientes $ pocion)

--c.
sonTodasDulces :: [Pocion] -> Bool
sonTodasDulces pociones = all (contiene "azucar") pociones

contiene :: String -> Pocion -> Bool
contiene ingrediente pocion = elem ingrediente (map nombreIngrediente . ingredientes $ pocion)

--4.
{-
Definir la función tomarPocion que recibe una poción y una persona, y 
devuelve como quedaría la persona después de tomar la poción. Cuando una persona toma una poción, 
se aplican todos los efectos de esta última, en orden.
-}
tomarPocion :: Pocion -> Persona -> Persona
tomarPocion pocion persona = foldr ($) persona (efectosDePocion pocion)

--5.
{-
Definir la función esAntidotoDe que recibe dos pociones y una persona, y 
dice si tomar la segunda poción revierte los cambios que se producen en la persona al tomar la primera.
-}
esAntidotoDe :: Pocion -> Pocion -> Persona -> Bool
esAntidotoDe pocion1 pocionAntidoto persona = (== persona) . tomarPocion pocionAntidoto . tomarPocion pocion1 $ persona

--6.
personaMasAfectada :: Pocion -> (Persona -> Int) -> [Persona] -> Persona
personaMasAfectada pocion cuantificador personas = maximoSegun (cuantificador . tomarPocion pocion) personas
