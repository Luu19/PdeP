{- MUSICA FUNCIONAL -}

data Nota = Nota {
    tono :: Float,
    volumen :: Float,
    duracion :: Int
} deriving (Eq, Show)

type Cancion = [Nota]

cambiarVolumen :: (Float -> Float) -> Nota -> Nota
cambiarVolumen delta nota = nota { volumen = delta (volumen nota) }

cambiarTono :: (Float -> Float) -> Nota -> Nota
cambiarTono delta nota = nota { tono = delta (tono nota) }

cambiarDuracion :: (Float -> Float) -> Nota -> Nota
cambiarDuracion delta nota = nota { duracion = delta (duracion nota) }

promedio :: [Float] -> Float
promedio lista = sum lista / fromIntegral (length lista)

--1.
--a.
esAudible :: Nota -> Bool
esAudible nota = elem (tono nota) (enumFromTo 20 20000) && (volumen nota > 10)

--b.
esMolesta :: Nota -> Bool
esMolesta nota 
    | esAudible nota && tono nota < 250     = volumen nota > 85
    | esAudible nota && tono nota => 250    = volumen nota > 55
    | otherwise                             = esAudible nota

--2.
--a.
silencioTotal :: Cancion -> Int 
silencioTotal notas = sum . map duracion . filter (not.esAudible) $ notas

--b.
sinInterrumpciones :: Cancion -> Bool
sinInterrumpciones notas = all esAudible . filter ((0.1 >) . duracion) $ notas

--c.
peorMomento :: Cancion -> Int
peorMomento notas = maximum . map volumen . filter esMolesta $ notas

--3.
type Filtro = Cancion -> Cancion

--a.
trasponer :: Int -> Filtro
trasponer escalar tonos = map (cambiarTono (* escalar)) tonos

--b.
acotarVolumen :: Int -> Int -> Filtro
acotarVolumen volMax volMiN tonos = cambiarVolumenSi (> volMax) volMiN tonos ++ cambiarVolumenSi (< volMiN)

cambiarVolumenSi :: (Int -> Bool) -> Int -> Cancion -> Cancion
cambiarVolumenSi condicion nuevoVolumen tonos = map (cambiarVolumen (const nuevoVolumen)) . filter (condicion . volumen) $ tonos

--c.
normalizar :: Filtro
normalizar tonos = map (cambiarVolumen (const volumenPromedioCancion)) tonos
    where volumenPromedioCancion tonos = promedio $ map volumen tonos 

--4.
--a.
f :: (b -> a -> Bool) -> [a -> b] -> a -> a -> Bool
f g [] y z = g y z
f g (x : xs) y z = g (x y) z || f g xs y z

--b.
infringeCopyright :: [Filtro] -> Cancion -> Cancion -> Bool
infringeCopyright filtros cancionOriginal cancionSospechosa = cancionOriginal == cancionSospechosa || any  (produceCancionIgual cancionOriginal cancionSospechosa) filtros

produceCancionIgual :: Cancion -> Cancion -> Filtro -> Bool
produceCancionIgual cancionOriginal cancionSospechosa filtro = (cancionOriginal ==) . filtro $ cancionSospechosa

--5.
tunear :: [Filtro] -> Cancion -> Cancion
tunear filtros cancion = normalizar . foldr ($) cancion $ filtros
