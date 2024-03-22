data Serie = Serie {
    nombreSerie :: String,
    actores :: [Actor],
    presupuestoAnual :: Int,
    temporadas :: Int, 
    rating :: Float,
    cancelada :: Bool
} deriving (Show)

data Actor = Actor {
    nombre :: String,
    sueldoAnual :: Int,
    restricciones :: [String]
} deriving (Show)

modificaActores :: ([Actor] -> [Actor]) -> Serie -> Serie
modificaActores funcion serie = serie { actores = funcion (actores serie) }

modificaTemporadas :: (Int -> Int) -> Serie -> Serie
modificaTemporadas funcion serie = serie { temporadas = funcion (temporadas serie) }

modificaCancelacion :: (Bool -> Bool) -> Serie -> Serie
modificaCancelacion funcion serie = serie { cancelada = funcion (cancelada serie) }

--1.
--a.
estaEnRojo :: Serie -> Bool
estaEnRojo serie =  (presupuestoAnual serie < ) . sum . map sueldoAnual . actores $ serie

--b.
esProblematica :: Serie -> Bool
esProblematica serie = (> 3) . length . filter masDeXRestriccion 1 $ actores serie

masDeXRestriccion :: Int -> Actor -> Bool
masDeXRestriccion cantidad actor = (> cantidad) . length $ restricciones actor 

--2.
type Productor = Serie -> Serie

--a.
conFavoritismos :: Actor -> Actor -> Productor
conFavoritismos favorito1 favorito2 serie = reemplazarDosActores favorito1 favorito2 serie

reemplazarDosActores :: Actor -> Actor -> Serie -> Serie
reemplazarDosActores favorito1 favorito2  serie = modificaActores ( (favorito2 :) . (favorito1 :)  . drop 2) serie

--b.
johnnyDeep :: Actor
johnnyDeep = Actor "Johnny Deep" 20000000 []

helenaBonham :: Actor
helenaBonham =  Actor "Helena Bonham" 15000000 []

timBurton :: Productor
timBurton serie = reemplazarDosActores johnnyDeep helenaBonham serie

--c.
gatoPardeitor :: Productor
gatoPardeitor = id

--d.
estireitor :: Productor
estireitor serie = modificaTemporadas ( * 2) serie

--e.
desespereitor :: [Productor] -> Productor
desespereitor productores serie = foldr ($) serie productores

--f.
canceleitor :: Int -> Productor
canceleitor ratingEsperado serie = modificaCancelacion (const (esCancelada serie ratingEsperado)) serie

esCancelada :: Serie -> Int -> Bool
esCancelada serie ratingEsperado = estaEnRojo serie || ratingEsperado > rating serie

--3.
bienestarSerie :: Serie -> Int
bienestarSerie serie 
    | cancelada serie                                               = 0
    | temporadas serie > 4                                          = 5
    | temporadas serie < 4 && not (length . actores $ serie < 10)   = (10 - temporadas serie) * 2
    | (length . actores $ serie < 10)                               = 3
    | otherwise                                                     = (10 -) . length . filter masDeXRestriccion 2 . actores $ serie

--4.
aumentanBienestar :: [Serie] -> [Productor] -> [Serie]
aumentanBienestar series productores =  map (aplicarPor (laHacenMasEfectiva productores)) $ series 

aplicarPor :: (a -> [b]) -> a -> a 
aplicarPor funcion semilla = foldr ($) semilla (funcion semilla)

laHacenMasEfectiva :: [Productor] -> Serie -> [Productor]
laHacenMasEfectiva (productor1 : productor2 : productores) serie = mayorSegunBienestar serie productor1 productor2 : laHacenMasEfectiva productores serie

mayorSegunBienestar :: Serie -> Productor -> Productor -> Productor
mayorSegunBienestar serie productor1 productor2 
    | (bienestarSerie . productor1) serie > (bienestarSerie . productor2) serie = productor1
    | otherwise                                                                 = productor2

--5.
{-
a. Si, se puede aplicar y devuelve la misma lista.

b. Si, se puede ya que solo agregar mas actores a una lista infinita.
-}

--6.
esControvertida :: Serie -> Serie
esControvertida serie =  (not . estaOrdenado) . map sueldoAnual $ actores serie

estaOrdenado :: [Int] -> Bool
estaOrdenado (x:y:xs) = x => y && estaOrdenado (y:xs)
estaOrdenado _        = True

--7.
funcionLoca :: (Int -> Int) -> (a -> String) -> [a] -> [Int]