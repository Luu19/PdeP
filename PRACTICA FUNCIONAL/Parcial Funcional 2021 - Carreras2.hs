{-
De cada AUTO conocemos :
    COLOR 
    VELOCIDAD
    DISTANCIA QUE RECORRIO

De la CARRERA nos interesa el estado de los autos que participan 
-}

modificaDistancia :: (Int -> Int) -> Auto -> Auto
modificaDistancia funcion auto = auto { distancia = funcion (distancia auto) }

--PUNTO 1.
type Carrera = [Auto]

data Auto = Auto {
    color :: String,
    velocidad :: Int,
    distanciaQueRecorrio :: Int
} deriving (Show, Eq)

--a.
estaCerca :: Auto -> Auto -> Bool
estaCerca auto1 auto2 = ( auto1 =/ auto2 ) &&  ( (< 10) . distancia auto1 $ auto1 )

distancia :: Auto -> Auto -> Int
distancia auto1 auto2 = abs (distancia auto1 - distancia auto2)

--b.
vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto carrera = all (leGana auto) carrera && all (not . estaCerca) carrera

leGana :: Auto -> Auto -> Bool
leGana auto otroAuto = distancia auto > distancia otroAuto 

--c.
puesto :: Auto -> Carrera -> Int
puesto auto carrera = (+ 1) . length . filter (not . leGana auto) $ carrera

--PUNTO 2.
--a.
corre :: Int -> Auto -> Auto
corre tiempo auto   = modificaDistancia (+ tiempo * (velocidad auto) ) auto


--b.
--i.
alterarVelocidad :: (Int -> Int) -> Auto -> Auto
alterarVelocidad modificador auto = auto { velocidad = modificador (velocidad auto) }

--i.
bajarVelocidad :: Int -> Auto -> Auto
bajarVelocidad reduce 
    | velocidad auto - reduce < 0 = alterarVelocidad (const 0) auto
    | otherwise                   = alterarVelocidad (- reduce) auto

--PUNTO 3.
type PowerUp = Auto -> Carrera -> Carrera

--a.
terremoto :: PowerUp
terremoto auto carrera = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad 50) carrera

--b.
miguelitos :: Int -> PowerUp
miguelitos reduce auto carrera =  afectarALosQueCumplen (leGana auto) (bajarVelocidad reduce) carrera

--c.
jetPack :: Int -> PowerUp
jetPack tiempo auto carrera = afectarALosQueCumplen (== auto) (alterarVelocidad (const (velocidad auto)) . corre tiempo . alterarVelocidad (* 2)) carrera

--PUNTO 4.
type Evento = Carrera -> Carrera
type Color = String

--a.
simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos = armarTabla carrera $ foldr ($) carrera eventos

armarTabla :: Carrera -> Carrera -> [(Int, Color)]
armarTabla (auto1 : autos) carreraFinal =  (puesto auto1 carreraFinal , color auto1) : armarTabla autos carreraFinal

--b.
--i.
correnTodos :: Int -> Carrera -> Carrera
correnTodos tiempo carrera = map (corre tiempo) carrera

--ii.
usaPowerUp :: PowerUp -> String -> Carrera -> Auto
usaPowerUp powerUp color carrera = powerUp . head . (filter (= color) ) $ carrera 

