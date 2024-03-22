{-
De los JUGADORes se conoce :
    NOMBRE
    EDAD
    PROMEDIO DE GOL
    HABILIDAD
    VALOR DE CANSANCIO

De los EQUIPOs se conoce :
    NOMBRE 
    GRUPO AL QUE PERTENECE 
    LISTA DE JUGADORES
-}

quickSort     _      []   = []
quickSort criterio (x:xs) = (quickSort criterio . filter (not . criterio x)) xs ++ [x] ++ (quickSort criterio . filter (criterio x)) xs

modificaCansancio :: (Int -> Int) -> Jugador -> Jugador
modificaCansancio f jugador = jugador { valorDeCansancio = f (valorDeCansancio jugador) }

aumentaCansancio :: Int -> Jugador
aumentaCansancio aumento jugador = modificaCansancio (+ aumento) jugador

data Jugador = Jugador {
    nombre :: String,
    edad :: Int,
    promedioDegGol :: Float,
    habilidad :: Int,
    valorDeCansancio :: Int
} deriving (Show)

data Equipo = Equipo {
    nombreEquipo :: String,
    grupoAlQuePertenece :: Char,
    listaDeJugadores :: [Jugador]
} deriving (Show)

--1.
figuras :: Equipo -> [Jugador]
figuras equipo = filter esFigura (listaDeJugadores equipo)

esFigura :: Jugador -> Bool
esFigura jugador = habilidad jugador > 75 && promedioDegGol jugador > 0

--2.
tieneFarandulero :: Equipo -> Bool
tieneFarandulero equipo = any esFarandulero (listaDeJugadores equipo)

esFarandulero :: Jugador -> Bool
esFarandulero jugador = flip elem jugadoresFaranduleros . nombre $ jugador

jugadoresFaranduleros = ["Maxi Lopez", "Icardi", "Aguero", "Caniggia", "Demichelis"]

--3.
type Grupo = Char

figuritasDificiles :: [Equipo] -> Grupo -> [Jugador]
figuritasDificiles equipos grupo = filter esDificil . concat . map listaDeJugadores . filter ((== grupo).grupoAlQuePertenece) $ equipos

esDificil :: Jugador -> Bool
esDificil jugador = esFigura jugador && (not . esFarandulero) jugador && esJoven jugador

esJoven :: Jugador -> Bool
esJoven jugador = edad jugador < 27

--4.
jugarPartido :: Equipo -> Equipo
jugarPartido equipo  
    | esDificil jugador                             = modificaCansancio (const 50) jugador
    | esJoven jugador                               = aumentaCansancio (div valorDeCansancio jugador 10) jugador
    | (not . esJoven) jugador && esFigura jugador   = aumentaCansancio 20 jugador
    | otherwise                                     = aumentaCansancio (2 * valorDeCansancio jugador) jugador

--5.
ganaPartido :: Equipo -> Equipo -> Equipo
ganaPartido equipo1 equipo2 = mayorSegun (sumaDePromedio . mejores11) equipo1 equipo2

mejores11 :: Equipo -> [Jugador]
mejores11 equipo = take 11 . quickSort estaMenosCansado . listaDeJugadores $ equipo

estaMenosCansado :: Jugador -> Jugador -> Bool
estaMenosCansado jugador1 jugador2 = valorDeCansancio jugador1 < valorDeCansancio jugador2

sumaDePromedio :: [Jugador] -> Int
sumaDePromedio jugadores = sum . map promedioDegGol $ jugadores

mayorSegun f a b 
    | f a > f b = a
    | otherwise = b 

--6.
--Primera Resolucion :
seConsagraCampeon :: [Equipo] -> Equipo
seConsagraCampeon              [equipo]         = equipo
seConsagraCampeon (equipo1 : equipo2 : equipos) = seConsagraCampeon . ( : equipos ) $ ganaPartido equipo1 equipo2

--Segunda Resolucion :
seConsagraCampeon' :: [Equipo] -> Equipo
seConsagraCampeon'      [equipo]        = equipo
seConsagraCampeon (equipo1 : equipo2 : equipos)
    | leGana equipo1 equipo2            = seConsagraCampeon' (equipo1 : equipos)
    | otherwise                         = seConsagraCampeon' (equipo2 : equipos)

leGana :: Equipo -> Equipo -> Bool
leGana equipo1 equipo2 = (sumaDePromedio . mejores11) equipo1 > (sumaDePromedio . mejores11) equipo2

--7.
elMejorDelMundo :: [Equipo] -> String
elMejorDelMundo equipos = nombre . head . filter esFigura . listaDeJugadores . seConsagraCampeon $ equipos
