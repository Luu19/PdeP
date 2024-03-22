{-
Se sabe que los BARABAROs tienen :
    NOMBRE
    FUERZA 
    HABILIDADES
    OBJETOS
-}

type Objeto = Barbaro -> Barbaro

data Barbaro = Barbaro {
    nombre :: String,
    fuerza :: Int,
    habilidades :: [String],
    objetos :: [Objeto]
} deriving (Show)

aumentaFuerza :: Int -> Barbaro -> Barbaro
aumentaFuerza aumento barbaro = modificaFuerza (+ aumento) barbaro

modificaFuerza :: (Int -> Int) -> Barbaro -> Barbaro
modificaFuerza funcion barbaro = barbaro { fuerza = funcion (fuerza barbaro) }

modificaHabilidades :: ([String] -> [String]) -> Barbaro -> Barbaro
modificaHabilidades funcion barbaro = barbaro { habilidades = funcion (habilidades barbaro) }

agregarHabilidad :: String -> Barbaro -> Barbaro
agregarHabilidad habilidad barbaro = modificaHabilidades (habilidad :) barbaro

modificarObjetos :: ([Objeto] -> [Objeto]) -> Barbaro -> Barbaro
modificarObjetos funcion barbaro = barbaro { objetos = funcion (objetos barbaro) }

modificaNombre :: (String -> String) -> Barbaro -> Barbaro
modificaNombre funcion barbaro = barbaro { nombre = funcion (nombre barbaro) }

aplicaObjetos :: Barbaro -> Barbaro
aplicaObjetos objetos barbaro = foldr ($) barbaro (objetos barbaro)

--PUNTO 1.
--i.
espadas :: Int -> Objeto
espadas peso barbaro = aumentaFuerza (2 * peso) barbaro

--ii.
amuletosMisticos :: String -> Objeto
amuletosMisticos habilidad barbaro = agregarHabilidad habilidad barbaro

--iii.
varitasDefectuosas :: Objeto
varitasDefectuosas barbaro = modificarObjetos (const []) . agregarHabilidad "hacer Magia" $ barbaro

--iv.
ardilla :: Objeto
ardilla = id

--v.
cuerda :: Objeto -> Objeto -> Objeto
cuerda objeto1 objeto2 = (objeto1 . objeto2)

--PUNTO 2.
megafono :: Objeto
megafono barbaro = modificaHabilidades potenciaHabilidades barbaro

potenciaHabilidades :: [String] -> [String]
potenciaHabilidades habilidades = concat . map toUpper $ habilidades

megafonoBarbico :: Objeto
megafonoBarbico = cuerda ardilla megafono

--PUNTO 3.
type Aventura = [Evento]
type Evento = Barbaro -> Bool

--i.
invasionDeSuciosDuendes :: Evento
invasionDeSuciosDuendes barbaro = elem "Escribir Poesia Atroz" $ habilidades barbaro

--ii.
cremalleraDelTiempo :: Evento
cremalleraDelTiempo barbaro = noTienePulgares barbaro

noTienePulgares :: Barbaro -> Bool
noTienePulgares barbaro = elem (nombre barbaro) ["Faffy", "Astro"]

--iii.
ritualDeFechorias :: [Barbaro -> Bool] -> Evento
ritualDeFechorias pruebas barbaro = any (pasaObstaculo barbaro) pruebas

pasaObstaculo :: Barbaro -> (Barbaro -> Bool) -> Bool
pasaObstaculo barbaro obstaculo = obstaculo barbaro

--a.
saqueo :: Barbaro -> Bool
saqueo barbaro = elem "robar" $ habilidades barbaro

--b.
gritoDeGuerra :: Barbaro -> Bool
gritoDeGuerra barbaro = (== 4 * cantidadObjetos barbaro) . poderDeGrito $ barbaro
    where poderDeGrito = sum . map length $ habilidades barbaro

cantidadObjetos :: Barbaro -> Int
cantidadObjetos barbaro = length $ objetos barbaro

--c.
caligrafia :: Barbaro -> Bool
caligrafia barbaro = all caligrafiaPerfecta (habilidades barbaro)

caligrafiaPerfecta :: String -> Bool
caligrafiaPerfecta habilidad = ( (> 3) . length . filter esVocal $ habilidad ) && (isUpper . take 1 $ habilidad)

esVocal :: Char -> Bool
esVocal letra = elem letra "aeiou" || elem letra "AEIOU"

--FUNCION SOBREVIVIENTE
sobrevivientes :: Aventura -> [Barbaro] -> [Barbaro]
sobrevivientes aventura barbaro = filter (pasaObstaculo barbaro) aventura

--PUNTO 4.
--A.
sinRepetidos :: Eq a => [a] -> [a]
sinRepetidos   []       = []
sinRepetidos  (x : xs)
    | elem x xs         = sinRepetidos xs
    | otherwise         = x : sinRepetidos xs


sinRepetidos' :: Eq a => [a] -> [a]
sinRepetidos'       []        = []
sinRepetidos' (x : xs)        = x : filter (=/ x) (sinRepetidos' xs)

--B.
descendientes :: Barbaro -> [Barbaro]
descendientes barbaro = iterate formaDescendiente barbaro

formaDescendiente :: Barbaro -> Barbaro
formaDescendiente barbaro = modificaNombre (++ "*") . modificaHabilidades sinRepetidos . aplicaObjetos $ barbaro

