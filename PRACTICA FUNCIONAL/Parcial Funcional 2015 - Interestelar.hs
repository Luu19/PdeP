{-
Cada PLANETA tiene:
    NOMBRE 
    POSICION EN EL ESPACIO
    RELACION --> tiempo que equivale pasar un año ahí

Cada ASTRONAUTA tiene :
    NOMBRE
    EDAD TERRESTRE
    PLANETA EN QUE ESTA 
-}

aumentaEdad :: Int -> Astronauta -> Astronauta
aumentaEdad aumento astronauta = modificaEdadAstronauta (+ aumento) astronauta

modificaEdadAstronauta :: (Int -> Int) -> Astronauta -> Astronauta
modificaEdadAstronauta f astronauta = astronauta { edad = f $ edad astronauta }

cambiaPlaneta :: Planeta -> Astronauta -> Astronauta
cambiaPlaneta planeta astronauta = astronauta { planetaEnQueEsta = const planeta $ planetaEnQueEsta astronauta }

data Planeta = Planeta {
    nombre :: String,
    posicion :: (Float, Float, Float),
    relacion :: Int -> Int
} deriving (Show)

data Astronauta = Astronauta {
    nombreAstronauta :: String,
    edad :: Int,
    planetaEnQueEsta :: Planeta
} deriving (Show)

fst3 (x,_,_) = x
snd3 (_,y,_) = y
thr3 (_,_,z) = z

coordX :: Planeta -> Int
coordX planeta = fst3 . posicion $ planeta

coordY :: Planeta -> Int
coordY planeta = snd3 . posicion $ planeta

coordZ :: Planeta -> Int
coordZ planeta = thr3 . posicion $ planeta

--1.
--a.
distanciaEntrePlanetas :: Planeta -> Planeta -> Int
distanciaEntrePlanetas planeta1 planeta2 = sqrt $ (coordX planeta1 - coordX planeta2) ^ 2 + (coordY planeta1 - coordY planeta2) ^ 2 + (coordZ planeta1 - coordZ planeta2) ^ 2

--b.
tiempoDeViaje :: Planeta -> Planeta -> Int -> Int
tiempoDeViaje planeta1 planeta2 velocidadDeViaje = div (distanciaEntrePlanetas planeta1 planeta2) velocidadDeViaje

--2.
pasarTiempo :: Int ->  Astronauta -> Astronauta
pasarTiempo anioQuePasa astronauta =  aumentaEdad ((relacion . planetaEnQueEsta $ astronauta) anioQuePasa) astronauta

--3.
type Nave = Planeta -> Planeta -> Int

--a.
naveVieja :: Int -> Nave
naveVieja cantidadTanquesOxigeno origen destino
    | cantidadTanquesOxigeno < 6 = tiempoDeViaje origen destino 10
    | otherwise                  = tiempoDeViaje origen destino 7

--b.
naveFuturista :: Nave
naveFuturista origen destino = foldl1 (tiempoDeViaje origen destino) (enumFrom 1)

realizaViaje :: Planeta -> Planeta -> Nave -> Astronauta -> Astronauta
realizaViaje origen destino nave astronauta = cambiaPlaneta destino . (flip pasarTiempo astronauta) $ nave origen destino

--4.
--a.
rescate :: Astronauta -> [Astronauta] -> Nave -> [Astronauta]
rescate astronautaVarado astronautas nave planetaDeRescate = (map realizaViaje planetaDeRescate planetaOrigen) . (aumentaEdad (nave planetaOrigen planetaDeRescate) astronautaVarado :) . map (realizaViaje planetaOrigen planetaDeRescate) $ astronautas
    where planetaOrigen astronautas = planetaEnQueEsta . head $ astronautas  
    where planetaDeRescate astronautaVarado = planetaEnQueEsta astronautaVarado 

--b.
puedenSerRescatados :: [Astronauta] -> Nave -> [Astronauta] -> [Astronauta]
puedenSerRescatados astronautasRescatistas nave astronautasVarados = filter (puedeSerRescatado astronautasRescatistas nave) astronautasVarados

puedeSerRescatado :: [Astronauta] -> Nave -> Astronauta -> Bool
puedeSerRescatado astronautas nave rescatado = all (not . ( > 90) . edad) $ rescate rescatado astronautas nave 

--5.
f :: (Eq c , Eq b) => (b -> elemento -> c) -> b -> (Int -> elemento -> Bool) -> [elemento] -> Bool

