
data Aspecto = UnAspecto {
    tipoDeAspecto :: TipoDeAspecto,
    grado :: Float
} deriving (Show, Eq)

type Situacion = [Aspecto]

data TipoDeAspecto = Tension | Incertidumbre | Peligro

mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor

mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2

buscarAspecto :: Aspecto -> Situacion -> Aspecto
buscarAspecto aspectoBuscado = head.filter (mismoAspecto aspectoBuscado)

buscarAspectoDeTipo :: TipoDeAspecto -> Situacion -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (UnAspecto tipo 0)

reemplazarAspecto :: Aspecto -> Situacion -> Situacion
reemplazarAspecto aspectoBuscado situacion = aspectoBuscado : (filter (not.mismoAspecto aspectoBuscado) situacion)

--1.
--a.
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto f aspecto = aspecto { grado = f (grado aspecto)}

--b.
mejorSituacion :: Situacion -> Situacion -> Bool
mejorSituacion unaSituacion otraSituacion = all (\unAspecto -> (mejorAspecto unAspecto).(buscarAspecto unAspecto) $ otraSituacion) unaSituacion

--c.
--La modifica el grado de la situación de acuerdo a un tipo de aspecto buscado 
modificarSituacion :: TipoDeAspecto -> (Float -> Float) -> Situacion -> Situacion
modificarSituacion tipoAspecto f situacion = reemplazarAspecto ((modificarAspecto f).(buscarAspectoDeTipo tipoAspecto) $ situacion) situacion

--2.
--a.
type Personalidad = Situacion -> Situacion

data Gema = Gema {
    nombre :: String,
    fuerza :: Int,
    personalidad :: Personalidad
}deriving (Show)

--b.
--i.
vidente :: Personalidad
vidente situacion = (modificarSituacion Incertidumbre (flip div 20)).(disminuirTension 10) $ situacion

disminuirTension :: Int -> Situacion -> Situacion
disminuirTension tensionADisminuir = modificarSituacion Tension (- tensionADisminuir) situacion

--ii.
relajada :: Int -> Personalidad
relajada relajamiento situacion = (disminuirTension 30).(modificarSituacion Peligro (+ relajamiento)) $ situacion

--3.
unaGemaLeGanaAOtra :: Gema -> Gema -> Situacion -> Bool
unaGemaLeGanaAOtra gema1 gema2 situacion = fuerza gema1 => fuerza gema2 && (mejorSituacion ((personalidad gema1) situacion) ((personalidad gema2) situacion))

--4.
fusionarGemas :: Situacion -> Gema -> Gema   -> Gema
fusionarGemas situacion gema1 gema2  = 
    Gema (nombreNuevaGemaFusion gema1 gema2) (fuerzaGemaFusion gema1 gema2 situacion) (personalidadGemaFusion gema1 gema2)
--a.
nombreNuevaGemaFusion :: Gema -> Gema -> String
nombreNuevaGemaFusion gema1 gema2
| nombre gema1 == nombre gema2 = nombre gema1
| otherwise                    = (nombre gema1)++ (nombre gema2)

--b.
personalidadGemaFusion :: Gema -> Gema -> (Personalidad)
personalidadGemaFusion gema1 gema2 = map (modificarAspecto (-10)).(personalidad gema1).(personalidad gema2) 

--c.
fuerzaGemaFusion :: Gema -> Gema -> Situacion -> Int
fuerzaGemaFusion gema1 gema2 situacion 
| sonCompatibles gema1 gema2 situacion = (fuerza gema1 + fuerza gema2) * 10 --i.
| otherwise                            = (gemaDominante gema1 gema2 situacion) * 7 --ii.

gemaDominante :: Gema -> Gema -> Situacion -> Gema
gemaDominante gema1 gema2 situacion | unaGemaLeGanaAOtra gema1 gema2 situacion = gema1
                                    | otherwise                                = gema2

sonCompatibles :: Gema -> Gema -> Situacion -> Bool
sonCompatibles gema1 gema2 situacion = 
(mejorSituacion ((personalidadGemaFusion gema1 gema2) situacion) ((personalidad gema1) situacion)) && (mejorSituacion ((personalidadGemaFusion gema1 gema2) situacion) ((personalidad gema2) situacion))

--5.
fusionGrupal :: Situacion -> [Gema] -> Gema
fusionGrupal situacion gemas = foldl1  (fusionarGemas situacion) gemas

