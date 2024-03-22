{-
De los ANIMALes se conoce:
    COEFICIENTE INTELECTUAL
    ESPECIE 
    CAPACIDADES
-}
vocales = ['a', 'e', 'i', 'o', 'u']

esVocal :: [Char] -> Bool
esVocal  (x : xs) =  elem x vocales || esVocal xs 

modificaCoeficiente :: (Int -> Int) -> Animal -> Animal
modificaCoeficiente funcion animal = animal { coeficiente = funcion (coeficiente animal) }

modificaCapacidades :: ([String] -> [String]) -> Animal -> Animal
modificaCapacidades funcion animal = animal { capacidades = funcion (capacidades animal) }

aplicaTransformaciones :: [Transformacion] -> Animal -> Animal
aplicaTransformaciones transformaciones animal = foldr ($) animal transformaciones

--1.
data Animal = Animal {
    coeficiente :: Int,
    especie :: String,
    capacidades :: [String]
} deriving (Show)

--2.
type Transformacion = Animal -> Animal

inteligenciaSuperior :: Int -> Transformacion
inteligenciaSuperior incremento animal = modificaCoeficiente (+ incremento) animal

pinkificar :: Transformacion 
pinkificar animal = modificaCapacidades (drop (length capacidades animal)) animal

superpoderes :: Transformacion
superpoderes animal 
    | especie animal == "elefante"                                = modificaCapacidades ("no tenerle miedo a los ratones" :) animal
    | (especie animal == "raton") && (coeficiente animal > 100)   = modificaCapacidades ("hablar" :) animal
    | otherwise                                                   = animal

--3.
type Criterio = Animal -> Bool

antropomorfico :: Criterio
antropomorfico animal = puedeHablar animal && coeficiente animal > 60

puedeHablar :: Criterio
puedeHablar animal = any (== "hablar") (capacidades animal) 

noTanCuerdo :: Criterio
noTanCuerdo animal = (> 2) . length . filter pinkiesca $ capacidades animal

pinkiesco :: String -> Bool
pinkiesco capacidad =  (== "hacer" . take 4) capacidad && pinkiesca . drop (length "hacer") $ capacidad

pinkiesca :: String -> Bool
pinkiesca palabra = (length palabra =< 4) && esVocal palabra

--4.
type Experimento = [Transformacion] 

experimentoExitoso :: Experimento -> Animal -> Criterio -> Bool
experimentoExitoso transformaciones animal criterio = criterio . aplicaTransformaciones transformaciones $ animal

--5.
aplicoExperimentoYfiltroSegun :: (Animal -> a) Experimento -> Criterio -> [Animal] -> [a]
aplicoExperimentoYfiltroSegun transformaciones criterio animales = map reporte . filter criterio . map (aplicaTransformaciones transformaciones) $ animales

--i.
listaDeCoeficientes :: Experimento -> [Animal] -> [String] -> [Int]
listaDeCoeficientes transformaciones animales capacidades = aplicoExperimentoYfiltroSegun coeficiente transformaciones (tieneUnaCapacidad capacidades) $ animales

tieneUnaCapacidad :: [String] -> Animal -> Bool
tieneUnaCapacidad capacidades animal = any (flip elem capacidades) (capacidades animal)

--ii.
listaDeEspecies :: Experimento -> [Animal] -> [String] -> [String]
listaDeEspecies transformaciones animales capacidades = aplicoExperimentoYfiltroSegun especie transformaciones (tieneTodas capacidades) $ animales

tieneTodas :: [String] -> Animal -> Bool
tieneTodas capacidades animal = all (flip elem capacidades) (capacidades animal)

--iii.
listaCantidadDeCapacidades :: Experimento -> [Animal] -> [String] -> [Int]
listaCantidadDeCapacidades transformaciones animales capacidades = aplicoExperimentoYfiltroSegun (length . capacidades) transformaciones (not . tieneTodas capacidades) $ animales
