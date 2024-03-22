{-
De las PERSONAs se conocen:
    HABILIDADES
    SI SON BUENOS O NO

De los POWER RANGERs se conocer:
    COLOR
    HABILIDADES
    NIVEL DE PELEA

-}

--1.
--a.
data Persona = Persona {
    habilidades :: [String],
    sonBuenos :: Bool
} deriving (Show)

--b.
data PowerRanger = PowerRanger {
    color :: String,
    habilidadesPowerRanger :: [String],
    nivelDePelea :: Int
} deriving (Show)

--2.
convertirEnPowerRanger :: String -> Persona -> PowerRanger
convertirEnPowerRanger color persona = PowerRanger color (powerRangerHabilidad (habilidades persona)) (powerRangerNivelPelea (habilidades persona))

powerRangerHabilidad :: [String] -> [String]
powerRangerHabilidad listaHabilidades = map ("super" ++) listaHabilidades

powerRangerNivelPelea :: [String] -> Int
powerRangerNivelPelea listaHabilidades = sum . (map length) $ listaHabilidades

--3.
formarEquipoRanger :: [String] -> [Persona] -> [PowerRanger]
formarEquipoRanger listaColores listaPersonas = (zipWith convertirEnPowerRanger (drop cantidadDeBuenos listaColores) ). (filter sonBuenos) $ listaPersonas
    where cantidadDeBuenos = length . filter sonBuenos $ listaPersonas

--4.
--a.
findOrElse :: (a -> Bool) -> a -> [a] -> a
findOrElse condicion elemento lista 
    | any condicion lista   = head . filter condicion $ lista
    | otherwise             = elemento

--b.
rangerLider :: [PowerRanger] -> PowerRanger
rangerLider listaPowerRanger = findOrElse ((== "rojo").color) (head listaPowerRanger) listaPowerRanger

--5.
--a.
maximumBy :: Ord b => [a] -> (a -> b) -> a 
maximumBy lista funcion = foldl1 (mayorSegun funcion) lista

mayorSegun f a b
    | f a > f b = a
    | otherwise = b

--b.
rangerMasPoderoso :: [PowerRanger] -> PowerRanger
rangerMasPoderoso listaPowerRanger = maximumBy listaPowerRanger nivelDePelea

--6.
rangerHabilidoso :: PowerRanger -> Bool
rangerHabilidoso powerRanger = (> 5).length.habilidades $ powerRanger

--7.
decirAy :: String
decirAy = repeat "ay"

--a.
alfa5 = PowerRanger "metalico" ["reparar cosas", decirAy]

--b.
-- Todas las funciones definidas anteriormente terminan.

--8.
data ChicaSuperpoderosa = ChicaSuperpoderosa {
    colorChica :: String,
    cantidadPelo :: Int
} deriving (Show)

chicaLider :: [ChicaSuperpoderosa] -> ChicaSuperpoderosa
chicaLider chicasSuperpoderosas = findOrElse ((=="rojo").colorChica) (head chicasSuperpoderosas) chicasSuperpoderosas

