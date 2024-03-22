{-
De los GUANTELETEs se conoce:
MATERIAL
GEMAS QUE POSEE

De los PERSONAJEs se conoce:
EDAD
ENERGIA
HABILIDADES
NOMBRE
PLANETA DONDE VIVEN

GUANTELETE COMPLETO --> POSEE 6 GEMAS Y MATERIAL = "uru" y SE TIENE LA POSIBILIDAD
                        DE CHASQUEAR Y REDUCIR EL UNIVERSO A LA MITAD DE LA CANTIDAD DE PERSONAJES
                        si tenemos 4 queda 2, si tenemos 5 quedan 2
-}

--FUNCIONES
cambiarEnergia :: (Int -> Int) -> Personaje -> Personaje
cambiarEnergia f personaje = personaje { energia = f (energia personaje) }

cambiarHabilidades :: ([String] -> [String]) -> Personaje -> Personaje
cambiarHabilidades f personaje = personaje { habilidades = f (habilidades personaje) }

cambiarPlaneta :: (String -> String) -> Personaje -> Personaje
cambiarPlaneta f personaje = personaje { planetaDondeVive = f (planetaDondeVive personaje) }

cambiarEdad :: (Int -> Int) -> Personaje -> Personaje
cambiarEdad f personaje = personaje { edad = f (edad personaje) }

--1.
type Gema = Personaje -> Personaje

data Guantelete = Guantelete {
    material :: String,
    gemas :: [Gema]
}deriving (Show)

data Personaje = Personaje {
    nombre :: String,
    edad :: Int,
    energia :: Int,
    habilidades :: [String],
    planetaDondeVive :: String
}deriving (Show)

type Universo = [Personaje]

chasquidoDeUnUniverso :: Guantelete -> Universo -> Universo
chasquidoDeUnUniverso guantelete universo | esCompleto guantelete = take (div (length universo) 2) universo
                                          | otherwise             = universo

esCompleto :: Guantelete -> Bool
esCompleto guantelete = (length gemas) == 6

--2.
esAptoParaPendex :: Universo -> Bool
esAptoParaPendex universo = any (<45).edad universo

energiaTotalUniverso :: Universo -> Int
energiaTotalUniverso universo = sum . (map energia) $ universo

--SEGUNDA PARTE
--3.
gemaDeLaMente :: Int -> Gema
gemaDeLaMente numero personaje = debilitarEnergia numero personaje

debilitarEnergia :: Int -> Personaje
debilitarEnergia numero personaje = cambiarEnergia (- numero) personaje

gemaDelAlma :: String -> Gema
gemaDelAlma habilidad personaje = (quitarHabilidad habilidad). (debilitarEnergia 10) $ personaje

quitarHabilidad :: String -> Personaje -> Personaje
quitarHabilidad habilidad personaje = cambiarHabilidades (filter (/= habilidad)) personaje

gemaDelEspacio :: String -> Gema
gemaDelEspacio planeta personaje = (transportarA planeta). (debilitarEnergia 20) $ personaje

transportarA :: String -> Personaje -> Personaje
transportarA planeta personaje = cambiarPlaneta (const planeta) personaje

gemaDelPoder :: Gema
gemaDelPoder personaje | length (habilidades personaje) <= 2 = (cambiarHabilidades (drop (length habilidades personaje))). debilitarEnergia (energia personaje) $ personaje
                       | otherwise                           = debilitarEnergia (energia personaje) personaje

gemaDelTiempo :: Gema 
gemaDelTiempo personaje | div (edad personaje) 2 < 18 = cambiarEdad (const 18) . (debilitarEnergia 50) $ personaje
                        | otherwise                   = cambiarEdad (const (div (edad personaje) 2)) . (debilitarEnergia 50) $ personaje

gemaLoca :: (Gema) -> Gema
gemaLoca gema personaje = gema. gema $ personaje

--4.
guanteleteDeGoma = Guantelete "goma" [gemaDelTiempo, gemaDelAlma "usarMjolnir", gemaLoca (gemaDelAlma "programacion Haskell")]

--5.
utilizar :: [Gema] -> Personaje -> Personaje
utilizar listaDeGemas personaje = foldr ($) personaje listaDeGemas

--6.
gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete personaje = gemaMasPoderosaDe personaje $ (gemas guantelete)

gemaMasPoderosaDe :: Personaje -> [Gemas] -> Gema
gemaMasPoderosaDe personaje (gema1 : gema2 : gemas) 
    | _ [gema1]                                             = gema1
    | (energia.gema1 personaje) < (energia.gema2 personaje) = gemaMasPoderosaDe personaje [gema1 : gemas]

--7.

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas tiempo)

--Y la función
usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3. gemas) guantelete

--Justifique si se puede ejecutar, relacionándolo con conceptos vistos en la cursada:
gemaMasPoderosa         punisher                guanteleteDeLocos
                --cualquier personaje
{-
Esta función no se puede utilizar ya que nunca se termina de evaluar todas las gemas
para saber cuál es la más poderosa de todas, queda en un loop infinito.
-} 

usoLasTresPrimerasGemas guanteleteDeLocos punisher
{-
Esta función sí se puede ejecutar ya que solo utiliza las primeras 3 gemas del guantelete infinito, 
es decir hace un "take 3 guanteleteDeLocos" y las utiliza.
-}