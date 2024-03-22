{-
De las PERSONAs conocemos :
    NOMBRE 
    CANTIDAD DE DINERO
    SUERTE
    LISTA DE FACTORES -> FACTOR (NOMBRE FACTOR, VALOR)
-}

data Persona = {
    nombre :: String,
    cantidadDinero :: Int,
    suerte :: Int,
    listaFactores :: [Factor]
} deriving (Show)

data Factor = Factor {
    nombreFactor :: String,
    valor :: Int
} deriving (Show)

--1.
suerteTotal :: Persona -> Int
suerteTotal persona 
    | tieneAmuleto persona = (suerte persona *) . valor $ encuentra "amuleto" (listaFactores persona)
    | otherwise            = suerte persona

encuentra :: String -> [Factor] -> Factor
encuentra nombre factores = head . filter ((== nombre) . nombreFactor) $ factores

--2.
data Juego = Juego {
    nombreJuego :: String,
    cuantoGanaCon :: Int -> Int,
    criterios :: [Persona -> Bool]
} deriving (Show)

--a.
ruleta :: Juego
ruleta = Juego "Ruleta" gananciaRuleta [condicionRuleta] 

gananciaRuleta :: Int -> Int
gananciaRuleta apuesta = apuesta * 37

condicionRuleta :: Persona -> Bool
condicionRuleta persona = (> 80) . suerte $ persona

--b.
maquinita :: Int -> Juego
maquinita jackPot = Juego "Maquinita" (gananciaMaquinita jackPot) [condicionMaquinita1, condicionMaquinita2]

gananciaMaquinita :: Int -> Int -> Int
gananciaMaquinita jackPot apuesta = jackPot + apuesta

condicionMaquinita1 :: Persona -> Bool
condicionMaquinita1 persona = suerte persona > 95 

condicionMaquinita2 :: Persona -> Bool
condicionMaquinita2 persona = elem "paciencia" (map nombreFactor $ listaFactores persona)

--3.
puedeGanar :: Juego -> Persona -> Bool
puedeGanar juego persona = all cumpleCondicion persona (criterios juego)

cumpleCondicion :: Persona -> (Persona -> Bool) -> Bool
cumpleCondicion persona condicion = condicion persona

--4.
--a.
cantidadDineroTotal :: Persona -> Int -> [Juego] -> Int
cantidadDineroTotal persona apuestaInicial juegos = (foldr (\apuesta juego -> (cuantoGanaCon juego) apuesta) apuestaInicial ) . filter (flip puedeGanar persona) $ juegos

--b.
cantidadDineroTotal' :: Persona -> Int -> [Juego] -> Int
cantidadDineroTotal' persona apuestaInicial (juego1 : juegos) 
    | puedeGanar juego1 persona         = (cuantoGanaCon juego1) apuestaInicial + cantidadDineroTotal' persona apuestaInicial juegos
    | otherwise                         = cantidadDineroTotal' persona apuestaInicial juegos 

--5.
noPuedenGanarEnNada :: [Persona] -> [Juego] -> [Persona]
noPuedenGanarEnNada (jugador : jugadores) juegos 
    | any (flip (not.puedeGanar) jugador) juegos = jugador : noPuedenGanarEnNada jugadores juegos
    | otherwise                                  = noPuedenGanarEnNada jugadores juegos

--6.
apuestaEn :: Int -> Persona -> Juego -> Persona
apuestaEn apuesta persona juego 
    | puedeGanar juego persona = aumentaDinero ( (cuantoGanaCon juego) apuesta ) persona
    | otherwise                = reduceDinero apuesta persona

aumentaDinero :: Int -> Persona -> Persona
aumentaDinero aumento persona = modificaDineroJugador (+ aumento) persona

reduceDinero :: Int -> Persona -> Persona
reduceDinero reduce persona = modificaDineroJugador (- reduce) persona

modificaDineroJugador :: (Int -> Int) -> Persona -> Persona
modificaDineroJugador funcion persona = persona { cantidadDinero = funcion (cantidadDinero persona) }

--7.
elCocoEstaEnLaCasa :: Eq z = > (x, a) -> (c -> [d])  -> z -> [((a -> [d]) , c)] -> Bool