{-
De los LADRONes se conoce:
    NOMBRE
    HABILIDADES
    ARMAS QUE LLEVA

De los REHENes se conoce:
    NOMBRE
    NIVEL DE COMPLOT 
    NIVEL DE MIEDO
    PLAN CONTRA LOS LADRONES --> Puede Involucrar a otro rehen

ARMA => Pistola :: Int -> Rehen -> Rehen
        Ametralladora :: Rehen -> Rehen

Formas de Intimidar a los rehenes :
    Disparos -> Dispara al techo, usa arma que le cause más miedo al rehen
    Hacerse el malo:
        Berlin -> aumenta miedo del rehen en la cant. de letras que sumen sus habilidades
        Rio -> aumenta el nivel de complot en 20
        Otro caso -> aumenta el miedo del rehen en 10

Si rehen tiene complot > miedo, idea planes como :
    Atacar ladron -> le quita tantas armas como la cant. de letras del nombre de su companiero divido x 10
    Esconderse -> ladron pierde tantas armas como habilidades dividio x 3

-}

type Arma = Rehen -> Rehen
type Plan = Ladron -> Ladron

data Ladron = Ladron {
    nombre :: String,
    habilidades :: [String],
    armas :: [Arma]
} deriving (Show)

data Rehen = Rehen {
    nombreRehen :: String
    nivelComplot :: Int,
    nivelMiedo :: Int,
    plan    :: [Plan]
} deriving (Show)

--Modifica :
modificaComplot :: (Int -> Int) -> Rehen -> Rehen
modificaComplot funcion rehen = rehen { nivelComplot = funcion (nivelComplot rehen) }

modificaMiedo :: (Int -> Int) -> Rehen -> Rehen
modificaMiedo funcion rehen = rehen { nivelMiedo = funcion (nivelMiedo rehen) }

modificaArmas :: ([Armas] -> [Armas]) -> Ladron -> Ladron
modificaArmas funcion ladron = ladron { armas = funcion (armas ladron) } 

--Aumenta o reduce :
aumentaMiedo :: Int -> Rehen -> Rehen
aumentaMiedo miedo rehen =  modificaMiedo (+ miedo) rehen

aumentaComplot :: Int -> Rehen -> Rehen
aumentaComplot complot rehen = modificaComplot (+ complot) rehen

reduceComplot :: Int -> Rehen -> Rehen
reduceComplot reduce rehen = modificaComplot (- reduce) rehen

quitaArmas :: Int -> Ladron -> Ladron
quitaArmas cuantas = modificaArmas (drop cuantas) ladron

--Armas :
pistola ::  Int -> Arma
pistola calibre  rehen = aumentaMiedo (3 * (length "pistola") ) . reduceComplot (5 * calibre) $ rehen

ametralladora :: Int -> Arma
ametralladora balas rehen = aumentaMiedo balas . reduceComplot (div (nivelComplot rehen) 2) $ rehen

--Funciones :
masMiedoDa :: Rehen -> [Arma] -> Arma
masMiedoDa rehen armas = foldl1 (cualGeneraMasMiedo rehen) armas

cualGeneraMasMiedo a arma1 arma2 
    | (nivelMiedo.arma1) a > (nivelMiedo.arma2) a = arma1
    | otherwise                                   = arma2
    
dispararAlTecho :: Rehen -> Arma -> Rehen
dispararAlTecho rehen arma = arma rehen 

--Formas de Intimidar :
type Intimidar = Ladron -> Rehen -> Rehen
disparos :: Intimidar
disparos ladron rehen = dispararAlTecho rehen . masMiedoDa rehen $ (armas ladron) 

hacerseElMalo :: Intimidar
hacerseElMalo ladron rehen 
    | nombre ladron == "Berlin" = aumentaMiedo ( sum . map length $ (habilidades ladron)) rehen
    | nombre ladron == "Rio"    = aumentaComplot 20 rehen
    | otherwise                 = aumentaMiedo 10 rehen

--Planes de Rehenes :
atacarLadron :: Rehen -> Plan
atacarLadron companiero ladron = quitaArmas (div (length nombreRehen companiero) 10) ladron

esconderse :: Plan
esconderse ladron = quitaArmas (div (length habilidades ladron) 3) ladron

--1.
tokio = Ladron "Tokio" ["trabajo psicologico", "entrar en moto"] [pistola 9, pistola 9, ametralladora 30]
profesor = Ladron "Profesor" ["disfrazarse de linyera", "disfrazarse de payaso", "estar siempre un paso adelante"] []

pablo = Rehen "Pablo" 40 30 [esconderse]
arturito = Rehen "Arturito" 70 50 [esconderse, atacarLadron pablo]

--2.
esInteligente :: Ladron -> Bool
esInteligente ladron = (> 2) . length . habilidades $ ladron

--3.
consigueArma :: Arma -> Ladron -> Ladron
consigueArma arma ladron = modificaArmas  (++ arma) ladron

--4.
intimidaRehen :: Ladron -> Rehen -> (Intimidar) -> Rehen
intimidaRehen ladron rehen intimidar =  intimidar ladron rehen

--5.
calmaLasAguas :: Ladron -> [Rehen] -> [Rehen]
calmaLasAguas ladron rehenes = map (dispararAlTecho ladron) . filter ((> 60).nivelComplot) $ rehenes

--6.
puedeEscaparseDeLaPolicia :: Ladron -> Bool
puedeEscaparseDeLaPolicia ladron = any seDisfraza $ habilidades ladron

seDisfraza :: String -> Bool
seDisfraza habilidad = (== "disfrazarse de") . drop (length "disfrazarse de") $ habilidad

--7.
pintaMalLaCosa :: [Ladron] -> [Rehen] -> Bool
pintaMalLaCosa ladrones rehenes = nivelDeComplotPromedio rehenes > (* cantidadArmasLadrones ladrones) . nivelDeMiedoPromedio $ rehenes

cantidadArmasLadrones :: [Ladron] -> Int
cantidadArmasLadrones ladrones = sum . map length.armas $ ladrones

nivelDeComplotPromedio :: [Rehen] -> Int
nivelDeComplotPromedio rehenes = (flip div (length rehenes) ). sum  . map nivelComplot $ rehenes

nivelDeMiedoPromedio :: [Rehen] -> Int
nivelDeMiedoPromedio rehenes = (flip div (length rehenes) ). sum  . map nivelMiedo $ rehenes

--8.
seRebelanRehenes :: [Rehen] -> Ladron -> Ladron
seRebelanRehenes rehenes ladron = (foldr ejecutaPlan ladron) . map (reduceComplot 10) $ rehenes

ejecutaPlan :: Rehen -> Ladron -> Ladron
ejecutaPlan rehen ladron = foldr ($) ladron (plan rehen)

--9.
planValencia :: [Rehen] -> [Ladron] -> Int
planValencia rehenes ladrones = (* 1000000) . cantidadArmasLadrones . map (planValenciaObstaculos rehenes) $ ladrones

planValenciaObstaculos :: [Rehen] -> Ladron -> Ladron
planValenciaObstaculos rehenes = (seRebelanRehenes rehenes . consigueArma (ametralladora 45))

--12.
funcion :: a -> (b -> String) -> (a -> b -> Bool) -> Int -> [b] -> Bool
funcion cond num lista str = (> str) . sum . map (length . num) . filter (lista cond) 
