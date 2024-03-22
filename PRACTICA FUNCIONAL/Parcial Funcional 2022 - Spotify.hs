{-
Currify

De las CANCIONes se sabe :
    TITULO
    GENERO
    DURACION EN s

De cada ARTISTA se sabe :
    NOMBRE
    CANCIONES 
    EFECTO PREFERIDO

-}
cambioDuracion :: (Int -> Int) -> Cancion -> Cancion
cambioDuracion funcion cancion = cancion { duracion = funcion (duracion cancion) }

modificoTitulo :: (String -> String) -> Cancion -> Cancion
modificoTitulo funcion cancion = cancion { titulo = funcion (titulo cancion) }

modificoGenero :: (String -> String) -> Cancion -> Cancion
modificoGenero funcion cancion = cancion { genero = funcion (genero cancion) }

modificaCanciones :: ([Cancion] -> [Cancion]) -> Artista -> Artista
modificaCanciones funcion artista = artista { canciones = funcion (canciones artista) }

--EFECTOS :
acortar :: Efecto
acortar cancion = cambioDuracion (reduceTiempo 60) cancion

reduceTiempo :: Int -> Int -> Int
reduceTiempo reduce tiempo 
    | tiempo - reduce < 0 = 0
    | otherwise           = tiempo - reduce

remixar :: Efecto
remixar cancion = modificoGenero (const "remixado") . cambioDuracion (* 2) . modificoTitulo (++ " remix") $ cancion

acustizar :: Int -> Efecto
acustizar duracion cancion 
    | genero cancion =/ "acustico" = cambioDuracion (const duracion) . modificoGenero (const "acustico") $ cancion
    | otherwise                    = cancion

metaEfecto :: [Efecto] -> Efecto
metaEfecto efectos cancion = foldr ($) cancion efectos

--PARTE A :
--1.
data Cancion = Cancion {
    titulo :: String, 
    genero :: String,
    duracion :: Int
} deriving (Show)

--2.
data Artista = Artista {
    nombre :: String,
    canciones :: [Cancion],
    efectoPreferido :: Efecto
} deriving (Show)

--3.
type Efecto = Cancion -> Cancion

--4.
cancion1 = Cancion "Cafe para dos" "rock melancolico" 146
cancion2 = Cancion "Fui hasta ahi" "rock" 279

artista1 = Artista "Los escarabajos" [rocketRaccoon, mientrasMiBateriaFesteja, tomateDeMadera] acortar
artista2 = Artista "Adela" [teAcordas, unPibeComoVos, daleMechaALaLluvia] remixar
artista3 = Artista "El tigre Joaco" [] (acustizar 6)

--PARTE B
--1.
vistazo :: Artista -> [Cancion]  --Devuelve las 3 canciones cortas del artista
vistazo artista = take 3 . filter esCancionCorta $ (canciones artista)

esCancionCorta :: Cancion -> Bool
esCancionCorta cancion = duracion cancion < 150

--2.
playList :: String -> Artista -> [Cancion]
playList genero1 artista = filter (esCancionDeGenero genero1) (canciones artista)

esCancionDeGenero :: String -> Cancion -> Bool
esCancionDeGenero genero1 cancion = genero1 == (genero cancion)

--PARTE C
--1.
hacerseDJ :: Artista -> Artista
hacerseDJ artista = modificaCanciones (map (efectoPreferido artista)) artista

--2.
tieneGustoHomogeneo :: Artista -> Bool
tieneGustoHomogeneo artista = sonDelMismoGenero (canciones artista)

--Hay dos formas de hacer sonDelMismoGenero :
sonDelMismoGenero :: [Cancion] -> Bool
sonDelMismoGenero (cancion1 : cancion2 : canciones) = (genero cancion1 == genero cancion2) && sonDelMismoGenero canciones

sonDelMismoGenero' :: [Cancion] -> Bool
sonDelMismoGenero' (cancion1 : canciones) = all (== (genero cancion1) . genero) canciones

--3.
formarBanda :: String -> [Artista] -> Artista
formarBanda nombreBanda integrantes = Artista nombreBanda (cancionesBanda integrantes) (efectoBanda integrantes)

cancionesBanda :: [Artista] -> [Cancion]
cancionesBanda integrantes = concat . map canciones $ integrantes

efectoBanda :: [Artista] -> (Efecto)
efectoBanda integrantes =  foldl1 (.) . map efectoPreferido $ integrantes

--4.
obraMaestraProgresiva :: Artista -> Cancion
obraMaestraProgresiva artista = Cancion (concatenoTitulos artista) (generoSuperador (canciones artista) ) ( duracionObraMaestra artista )

concatenoTitulos :: Artista -> String
concatenoTitulos artista =  (foldl1 (++)) . map titulo $ canciones artista 

duracionObraMaestra :: Artista -> Int
duracionObraMaestra artista = sum . map duracion $ canciones artista

generoSuperador :: [Cancion] -> String
generoSuperador canciones = foldl1 supremoSegunGenero . map genero $ canciones

supremoSegunGenero :: String -> String -> String
supremoSegunGenero "rock"          _      = "rock"
supremoSegunGenero   _           "rock"   = "rock"
supremoSegunGenero "reggaeton"     otro   = otro
supremoSegunGenero     otro   "reggaeton" = otro
supremoSegunGenero genero1  genero2  
    | length genero1 > length genero2       = genero1
    | otherwise                             = genero2

--PARTE D :
--1.
{-
No, no puede ya que, al tener infinitas canciones, nunca se terminará de aplicar su efecto preferido a todas sus 
canciones.
-}

--2.
{-
No, no podemos echar un vistazo a su musica ya que, por las infinitas canciones, nunca terminaremos de evaluar
su lista de canciones para saber qué cancion es corta.
Nunca pasara del -> filter esCortaCancion <- como para llegar al -> take 3 <-.
-}

--3.
{-
No, no podra crear una obra maestra progresiva debido a que por tener infinitas canciones, nunca terminara
de sumar los segundos de las canciones, concatenar titulos y evaluar los generos.
-}