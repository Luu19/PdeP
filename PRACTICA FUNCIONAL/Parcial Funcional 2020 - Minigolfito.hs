-- Modelo inicial
data Jugador = Jugador {
    nombre :: String,
    padre :: String,
    habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
    fuerzaJugador :: Int,
    precisionJugador :: Int
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
    velocidad :: Int,
    precision :: Int,
    altura :: Int
} deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f a = foldl1 (mayorSegun f) a

mayorSegun f a b | f a > f b = a
                 | otherwise = b

--1.
--a.
type Palo = Habilidad -> Tiro

--i.
putter :: Palo
putter habilidad = Tiro 10 (precisionJugador habilidad * 2) 0

--ii.
madera :: Palo 
madera habilidad = Tiro 100 ( div (precisionJugador habilidad) 2 ) 5

--iii.
hierros :: Int -> Palo 
hierros n habilidad = Tiro (fuerzaJugador habilidad * n ) (div (precisionJugador habilidad) n) (alturaMinima n)

alturaMinima :: Int -> Int
alturaMinima n 
    | n - 3 > 0 = n - 3
    | otherwise = 0

--b.
palos :: [Palo]
palos = [putter, madera] ++ map hierros EnumFromTo 1 10

--2.
golpe :: Jugador -> ( Palo ) -> Tiro
golpe jugador palo = palo (habilidad jugador)

--3.

tiroNulo :: Tiro
tiroNulo = Tiro 0 0 0

cambiaVelocidad :: (Int -> Int) -> Tiro -> Tiro
cambiaVelocidad f tiro = tiro { velocidad = f $ velocidad tiro }

cambioAltura :: (Int -> Int) -> Tiro -> Tiro
cambioAltura f tiro = tiro { altura = f $ altura tiro }

cambioPrecision :: (Int -> Int) -> Tiro -> Tiro
cambioPrecision f tiro = tiro { precision = f $ precision tiro }

data Obstaculo = Obstaculo {
    condicion :: Tiro -> Bool,
    efecto    :: Tiro -> Tiro
}

superaObstaculo :: Obstaculo -> Tiro -> Tiro
superaObstaculo obstaculo tiro 
    | (condicion obstaculo) tiro = (efecto obstaculo) tiro
    | otherwise                  = tiroNulo
--a.
tunelConRampita :: Obstaculo
tunelConRampita = Obstaculo condicionTunel efectoRampita

efectoRampita :: Tiro -> Tiro
efectoRampita tiro = duplicaVelocidad. cambioPrecision (const 100) . cambioAltura (const 0) $ tiro  

condicionTunel :: Tiro -> Bool
condicionTunel tiro = precision tiro > 90

duplicaVelocidad tiro = cambiaVelocidad (* 2) tiro

--b.
laguna :: Int -> Obstaculo
laguna largoLaguna = Obstaculo condicionLaguna (efectoLaguna largoLaguna)

efectoLaguna :: Tiro -> Tiro
efectoLaguna tiro = cambioAltura (flip div largoLaguna) tiro

condicionLaguna :: Tiro -> Bool
condicionLaguna tiro = velocidad tiro > 80 && between 1 5 (altura tiro)

--c.
hoyo :: Obstaculo
hoyo = Obstaculo condicionHoyo efectoHoyo

condicionHoyo :: Tiro -> Bool
condicionHoyo tiro = (between 5 20 (velocidad tiro)) && (altura tiro == 0) && (precision tiro > 95)

efectoHoyo :: Tiro -> Tiro
efectoHoyo _ = tiroNulo

--4.
--a.
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter ((condicion obstaculo) . golpe jugador) palos

--b.
cuantosObstaculosSupera :: [Obstaculo] -> Tiro -> Int
cuantosObstaculosSupera             []             tiro = 0
cuantosObstaculosSupera (obstaculo1 : obstaculos)  tiro    
| (condicion obstaculo1)        tiro                     = 1 + cuantosObstaculosSupera obstaculos (efecto obstaculo1 $ tiro) 
|  otherwise                                             = 0  

--c.
paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos =  maximoSegun ((cuantosObstaculosSupera obstaculos).(golpe jugador)) palos

--5.
type PuntosFinalTorneo = [(Jugador, Puntos)]

padresQuePierdenApuesta :: PuntosFinalTorneo -> [String]
padresQuePierdenApuesta listaDeJugadores = padresHijosPerdedores . filter ((=/ jugadorGanador) . fst) $  listaDeJugadores
    where jugadorGanador = mayorSegun snd $ listaDeJugadores

padresHijosPerdedores :: PuntosFinalTorneo -> [String]
padresHijosPerdedores jugadores = map (padre.fst) jugadores