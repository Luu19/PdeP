{-
Un GUANTELETE esta tiene :
    MATERIAL
    GEMAS 

Un PERSONAJE tiene :
    NOMBRE
    EDAD 
    ENERGIA
    HABILIDADES
    PLANETA DONDE VIVE

-> Guantelete completo si tiene las 6 gemas y su material es uru 
-}

modificaEnergia :: (Int -> Int) -> Personaje -> Personaje
modificaEnergia funcion personaje = personaje { energia = funcion (energia personaje) }

modificaHabilidad :: ([String] -> [String]) -> Personaje -> Personaje
modificaHabilidad funcion personaje = personaje { habilidades = funcion (habilidades personaje) }

modificaEdad :: (Int -> Int) -> Personaje -> Personaje
modificaEdad funcion personaje = personaje { edad = funcion (edad personaje) }

reduceEnergia :: Int -> Personaje -> Personaje
reduceEnergia reduce personaje = modificaEnergia (- reduce) personaje

quitarHabilidad :: String -> Personaje -> Personaje
quitarHabilidad habilidad personaje = modificaHabilidad (filter (=/ habilidad)) personaje

cambiaPlaneta :: String -> Personaje -> Personaje
cambiaPlaneta planeta personaje = personaje { planetaDondeVive = const planeta (planetaDondeVive personaje) }

-- PRIMERA PARTE --
--PUNTO 1.
data Personaje = Personaje {
    nombre :: String,
    edad :: Int,
    energia :: Int,
    habilidades :: [String], 
    planetaDondeVive :: String
} deriving (Show)

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
} deriving (Show)

type Universo = [Personaje]

chasquidoDeUniverso :: Universo -> Universo
chasquidoDeUniverso universo = drop (div (length universo) 2) universo

--PUNTO 2.
aptoParaPendex :: Universo -> Bool
aptoParaPendex universo = any ((< 45) . edad) universo

energiaTotalUniverso :: Universo -> Int
energiaTotalUniverso universo = sum . map energia . filter (tieneMasDeXHabilidades 1) $ universo

tieneMasDeXHabilidades :: Int -> Personaje -> Bool
tieneMasDeXHabilidades numero personaje = (> numero) . length $ habilidades personaje

-- SEGUNDA PARTE --
type Gema = Personaje -> Personaje

--PUNTO 3.
gemaDeLaMente :: Int -> Gema
gemaDeLaMente debilitar personaje = reduceEnergia debilitar personaje

gemaDelAlma :: String -> Gema
gemaDelAlma habilidad personaje =  quitarHabilidad habilidad . reduceEnergia 10 $ personaje

gemaDelEspacio :: String -> Gema
gemaDelEspacio planeta personaje = cambiaPlaneta planeta . reduceEnergia 20 $ personaje

gemaDelPoder :: Gema
gemaDelPoder personaje 
    | tieneMenosDeXHabilidades 2  personaje = modificaEnergia (const 0) . modificaHabilidad (const []) $ personaje
    | otherwise                             = modificaEnergia (const 0) personaje

tieneMenosDeXHabilidades :: Int -> Personaje -> Bool
tieneMenosDeXHabilidades numero personaje = (< numero) . length $ habilidades personaje

gemalDelTiempo :: Gema
gemalDelTiempo personaje = reduceALaMitadLaEdad personaje

reduceALaMitadLaEdad :: Personaje -> Personaje
reduceALaMitadLaEdad personaje 
    | (flip div 2) . edad $ personaje < 18 = modificaEdad (const 18) personaje
    | otherwise                            = modificaEdad (flip div 2) personaje

gemaLoca :: Gema -> Gema 
gemaLoca gema personaje = (!! 2) . iterate gema $ personaje

--PUNTO 4.
guanteleteDeGoma :: Guantelete
guanteleteDeGoma = Guantelete "Goma" [gemalDelTiempo, gemaDelAlma "usarMjolni" , gemaLoca (gemaDelAlma "programacion en Haskell")]

--PUNTO 5.
utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldr ($) personaje gemas --De derecha a izquierda

--PUNTO 6.
gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete personaje = foldl1 (gemaQueMasDaniaA personaje) (gemas guantelete)

gemaQueMasDaniaA :: Personaje -> Gema -> Gema -> Gema
gemaQueMasDaniaA personaje gema1 gema2 
    | (energia . gema1) personaje < (energia . gema2) personaje = gema1
    | otherwise                                                 = gema2

