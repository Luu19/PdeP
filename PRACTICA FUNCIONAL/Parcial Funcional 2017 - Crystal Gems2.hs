data Aspecto = UnAspecto {
    tipoDeAspecto :: String,
    grado :: Float
} deriving (Show, Eq)

type Situacion = [Aspecto]

--Nos indica si el primer aspecto es mejor que el segundo
mejorAspecto mejor peor = grado mejor < grado peor

--Nos indica si ambos aspectos son iguales
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2

--Nos busca un aspecto
buscarAspecto aspectoBuscado = head.filter (mismoAspecto aspectoBuscado)

--Nos busca un tipo de aspecto
buscarAspectoDeTipo tipo = buscarAspecto (UnAspecto tipo 0)

reemplazarAspecto aspectoBuscado situacion = aspectoBuscado : (filter (not.mismoAspecto aspectoBuscado) situacion)

tipoDeAspectos :: [String]
tipoDeAspectos = ["Tension", "Incertidumbre", "Peligro"]

--1. Trabajando con situaciones
--a.
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto funcion aspecto = aspecto { grado = funcion (grado aspecto) }

--b.
esMejorSituacion :: Situacion -> Situacion -> Bool
esMejorSituacion situacion1 situacion2 = all (\aspecto -> mejorAspecto aspecto . buscarAspecto aspecto $ situacion1) situacion2 

--c.
modificarSituacion :: (Float -> Float) -> String -> Situacion -> Situacion
modificarSituacion situacion modificacion tipoAspecto = (flip reemplazarAspecto situacion) . modificarAspecto modificacion . buscarAspectoDeTipo tipoAspecto $ situacion

--2. Modelando Gemas y personalidades posibles:
--a.
type Personalidad = Situacion -> Situacion

data Gema = Gema {
    nombre :: String,
    fuerza :: Int,
    personalidad :: Personalidad
} deriving (Show)

--b.
--i.
vidente :: Personalidad
vidente situacion = modificarSituacion (/ 2) "incertidumbre" . modificarSituacion  (- 10) "tension" $ situacion

--ii.
relajada :: Int -> Personalidad
relajada relajacionDeGema situacion = modificarSituacion (* relajacionDeGema) "peligro" . modificarSituacion (- 30) "tension" $ situacion

--3.
leGana :: Gema -> Gema -> Situacion -> Bool
leGana gema1 gema2 situacion = (fuerza gema1 => fuerza gema2) && (esMejorSituacion (personalidad gema1 $ situacion) (personalidad gema2 $ situacion))

--4. Fusion
fusionDeGemas :: Situacion -> Gema -> Gema -> Gema
fusionDeGemas situacion gema1 gema2 = Gema (nombreDeGemaFusionada gema1 gema2) (fuerzaGemaFusionada gema1 gema2 situacion) (personalidadGemaFusionada gema1 gema2)

nombreDeGemaFusionada :: Gema -> Gema -> String --a.
nombreDeGemaFusionada gema1 gema2 
    | nombre gema1 == nombre gema2 = nombre gema1
    | otherwise                    = (nombre gema1) ++ (nombre gema2)

personalidadGemaFusionada :: Gema -> Gema -> Personalidad --b.
personalidadGemaFusionada gema1 gema2 = (personalidad gema1) . (personalidad gema2) . modificarTodaLaSituacion (- 10)

modificarTodaLaSituacion :: (Float -> Float) -> Situacion -> Situacion
modificarTodaLaSituacion modificacion situacion = map modificacion situacion

fuerzaGemaFusionada :: Gema -> Gema -> Situacion -> Int
fuerzaGemaFusionada gema1 gema2 situacion
    | sonCompatibles gema1 gema2 situacion = (fuerza gema1 + fuerza gema2) * 10 --i.
    | leGana gema1 gema2                   = fuerza gema1 * 7
    |otherwise                             = fuerza gema2 * 7

sonCompatibles :: Gema -> Gema -> Situacion -> Bool
sonCompatibles gema1 gema2 situacion = mejorSituacion (personalidadGemaFusionada gema1 gema2 $ situacion) (personalidad gema1 $ situacion) && mejorSituacion (personalidadGemaFusionada gema1 gema2 $ situacion) (personalidad gema2 $ situacion)

--5. Fusion Grupal
fusionGrupal :: [Gema] -> Situacion -> Gema 
fusionGrupal gemas situacion = foldl1 (fusionDeGemas situacion) gemas
