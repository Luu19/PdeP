{- De cada AUTO se conoce:
COLOR
VELOCIDAD
DISTANCIA que recorrió

De la carrera:
ESTADO ACTUAL DE AUTOS
-}

--1.
data Auto = Auto {
    color :: String,
    velocidad :: Int,
    distancia :: Int
} deriving (Show)

type Carrera = [Auto]
--a. 
estanCerca :: Auto -> Auto -> Bool
estanCerca auto1 auto2 =  (< 10).(distanciaEntre auto1) $ auto2  && (auto1 =/ auto2)

distanciaEntre :: Auto -> Auto -> Int
distanciaEntre auto1 auto2 = abs (distancia auto1 - distancia auto2)

--b.

vaTranquilo auto1 carrera = not. (any (estanCerca auto1)) $ carrera && lesGanaTodos auto1 carrera

lesGanaTodos auto1 carrera = all (distancia auto1 >).(map distancia) carrera

--c.
puesto auto carrera = (+ 1 ).length.(filter (> distancia auto).distancia ) carrera

--2.
--a.
correr :: Int -> Auto -> Auto
correr tiempo (Auto color velocidad distancia) = Auto color velocidad (distancia + tiempo * velocidad)

--b i.
alterarVelocidad :: (Int -> Int) -> Auto -> Auto
alterarVelocidad modificador (Auto color velocidad distancia) = Auto color (modificador velocidad) distancia

--b ii.
reducirVelocidad :: (Int -> Int -> Int) -> Int -> Auto -> Auto
reducirVelocidad modificador reduce (Auto color velocidad distancia) = Auto color (modificador reduce velocidad) distancia

modificador reduce velocidad | (velocidad - reduce) > 0 = velocidad - reduce
                             | otherwise                = 0

--3.
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a] 

--POWER UPS
terremoto :: Auto -> Carrera -> Carrera 
terremoto auto carrera = afectarALosQueCumplen (estanCerca auto)  (modificador 50) carrera

miguelitos :: Int -> Auto -> Carrera -> Carrera
miguelitos bajaVelocidad auto carrera = afectarALosQueCumplen (lesGanaTodos auto) (modificador bajaVelocidad) carrera

jetPack:: Int -> Auto -> Carrera -> Carrera
jetPack tiempo auto = afectarALosQueCumplen (== auto)  ((corre tiempo).alterarVelocidad (*2)) carrera


--4.
--a.
type Eventos = Carrera -> Carrera
simularCarrera :: Carrera -> [Eventos] -> [(Int, Color)]
simularCarrera carrera listaEventos = (armarTabla).(mapeoCarrera carrera) $ listaEventos

mapeoCarrera carrera listaEventos = foldr ($) carrera listaEventos []
armarTabla carrera = map (\ auto -> (puesto auto carrera, color auto)) carrera

--b.
--i.
correnTodos :: Int -> Carrera -> Carrera
correnTodos tiempo autos = map (correr tiempo) autos

usaPowerUp :: (Auto -> Carrera -> Carrera) -> String -> Carrera
usaPowerUp powerUp color carrera = powerUp . (buscarAuto color) $ carrera

buscarAuto :: String -> [Auto] -> Auto
buscarAuto colorAuto carrera = head.(filter (== colorAuto).color) $ carrera

