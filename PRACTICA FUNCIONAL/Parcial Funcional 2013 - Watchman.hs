{-
De un VIGILANTE se conoce :
    NOMBRE
    HABILIDADES 
    ANIO EN QUE APARECIO



-}

data Vigilante = Vigilante {
    nombre :: String,
    habilidades :: [String],
    anioQueAparece :: Int
} deriving (Show)

type Evento = [Vigilante] -> [Vigilante]
type Aventura = [Evento]

agregarHabilidad :: String -> Vigilante -> Vigilante
agregarHabilidad habilidad vigilante = modificaHabilidades ( : habilidad) vigilante

modificaHabilidades :: ([String] -> [String]) -> Vigilante -> Vigilante
modificaHabilidades funcion vigilante = vigilante { habilidades = funcion $ habilidades vigilante }

--EVENTOS :
--a.
destruccionDeNiuShork :: Evento
destruccionDeNiuShork vigilantes = seRetira "Rorschach" . seRetira "Dr Manhattan" $ vigilantes

seRetira :: String -> Evento
seRetira nombre vigilantes = filter (=/ nombre) vigilantes

--b. Retiro / Muerte
muerteVigilante :: String -> Evento
muerteVigilante nombre vigilantes = filter (=/ nombre) vigilantes

--c.
guerraVietnam :: Evento
guerraVietnam vigilantes = ( ++ filter (not.esAgenteDeGobierno) vigilantes) . map agregarHabilidad "cinismo" . filter esAgenteDeGobierno $ vigilantes 

guerraVietnam' :: Evento
guerraVietnam (vigilante1 : vigilantes)
    | esAgenteDeGobierno vigilante1 = agregarHabilidad "cinismo" vigilante1 : guerraVietnam' vigilantes
    | otherwise                     = vigilante1 : guerraVietnam' vigilantes

guerraDeVietnam'' :: [Vigilante] -> [Vigilante]
guerraDeVietnam'' = map (agregarHabilidadSi esAgenteDeGobierno "cinismo")

agregarHabilidadSi :: (Vigilante -> Bool) -> String -> Vigilante -> Vigilante
agregarHabilidadSi condicion habilidad vigilante
  | condicion vigilante = agregarHabilidad habilidad vigilante
  | otherwise           = vigilante


esAgenteDeGobierno :: Vigilante -> Bool
esAgenteDeGobierno vigilante = elem (nombre vigilante) (map fst agentesDelGobierno)

agentesDelGobierno = [("Jack Bauer","24"), ("El Comediante","Watchmen"), ("Dr. Manhattan", "Watchmen"), ("Liam Neeson","Taken")]

--d.
accidenteDeLaboratorio :: Int -> Evento
accidenteDeLaboratorio anio vigilantes = (Vigilante "Dr Manhattan" ["manipulacion de materia a nivel atomico"] anio) : vigilantes

--e.
actaDeKeene :: Evento
actaDeKeene vigilantes = filter (not . flip tieneSucesor vigilantes) vigilantes 

tieneSucesor :: Vigilante -> [Vigilante] -> Bool
tieneSucesor vigilante vigilantes =  any (== nombre vigilante)  vigilantes 

--1.
-- *
historia :: Aventura -> [Vigilante] -> [Vigilante]
historia aventura vigilantes = map ($ vigilantes) aventura

-- *
eventosRandom = [destruccionDeNiuShork , muerteVigilante "comediante" , guerraVietnam , accidenteDeLaboratorio 1959 , actaDeKeene]

historiaRandom :: [Vigilante] -> [Vigilante]
historiaRandom vigilantes = historia eventosRandom vigilantes

--2.
-- *
nombreDelSalvador :: [Vigilante] -> String
nombreDelSalvador vigilantes = nombre . maximoSegun (length . habilidades) . destruccionDeNiuShork $ vigilantes

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun funcion lista = foldl1 (mayorSegun funcion) lista

mayorSegun :: Ord b => (a -> b) -> a -> a -> a
mayorSegun f a b 
    | f a > f b = a
    | otherwise = b

-- *
elElegido :: [Vigilante] -> String
elElegido vigilantes = head . habilidades . maximoSegun (length . nombre) . guerraVietnam $ vigilantes

-- *
patriarca :: [Vigilante] -> String
patriarca vigilantes = anioQueAparece . minimoSegun anioQueAparece . actaDeKeene $ vigilantes

minimoSegun :: Ord b => (a -> b) -> [a] -> a
minimoSegun funcion lista = foldl1 (menorSegun funcion) lista

menorSegun :: Ord b => (a -> b) -> a -> a -> a
menorSegun f a b 
    | f a < f b = a
    | otherwise = b

