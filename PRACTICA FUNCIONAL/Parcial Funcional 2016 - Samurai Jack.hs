{-

-}

data Personaje = Personaje {
    nombre :: String,
    salud :: Float,
    elementos :: [Elemento],
    anioPresente :: Int
}deriving (Show)

data Elemento = Elemento {
    tipo :: String,
    ataque :: (Personaje-> Personaje), --Elemento de ataque se usa sobre un rival
    defensa :: (Personaje-> Personaje) --Elemento de defensa se utiliza sobre el Personaje que lo tiene
}deriving (Show)

--Funciones usadas
cambiarAnioPersonaje :: (Int -> Int) -> Personaje -> Personaje
cambiarAnioPersonaje f personaje = personaje { anioPresente = f (anioPresente personaje) }

cambiarSaludPersonaje :: (Float -> Float) -> Personaje -> Personaje
cambiarSaludPersonaje f personaje = personaje { salud = f (salud personaje) }

--1.
--a.
mandarAlAnio :: Int -> Personaje -> Personaje
mandarAlAnio anioMandar personaje = cambiarAnioPersonaje (const anioMandar) personaje

--b.
meditar :: Int -> Personaje -> Personaje
meditar valor personaje = cambiarSaludPersonaje (+ div valor 2) personaje

--c.
causarDanio :: Int -> Personaje -> Personaje
causarDanio salud personaje = cambiarSaludPersonaje (- salud) personaje

--2.
--a.
esMalvado :: Personaje -> Bool
esMalvado personaje = any (== "Maldad").tipo (elementos personaje)

--b.
danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento = (-) (salud personaje)  (salud.(ataque elemento) $ personaje)

--c.
enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje enemigos = filter (puedeLlegarAMatarlo personaje) enemigos

puedeLlegarAMatarlo :: Personaje -> Personaje -> Bool
puedeLlegarAMatarlo personaje enemigo = any ((==0).(danioQueProduce personaje)) (elementos enemigo) 

--3.
--a.
concentracion :: Int -> Elemento
concentracion concentracionIndicada = Elemento "Magia" noHacerNada ( (!! concentracionIndicada).(iterate meditar)) 
--iterate lo que va a hacer es componer la funcion infinitamente formando una lista pero con concentracionIndicada tomaremos solo el resultado que esta en esa posicion de la lista

noHacerNada :: Personaje -> Personaje
noHacerNada = id 

--b.
esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados cantidad = replicate cantidad (Elemento "Maldad" (causarDanio 1) noHacerNada)

--c.
katana :: Elemento
katana = Elemento "Magia" (causarDanio 1000) noHacerNada

jack :: Personaje
jack = Personaje "Jack" 300 [concentracion 3 , katana] 200 

{-
data Personaje = Personaje {
    nombre :: String,
    salud :: Float,
    elementos :: [Elemento],
    anioPresente :: Int
}deriving (Show)
-}
--d.
portalAlFuturoDeAku :: Elemento
portalAlFuturoDeAku anio = Elemento "Magia" (mandarAlAnio (anio + 2800)) generaNuevoAku

generaNuevoAku :: Personaje -> Personaje
generaNuevoAku personajeAku = aku (anioPresente personajeAku) (salud personajeAku) 

listaDeElementosDeAku :: Int -> [Elemento]
lista anioEnQueVive = (concentracion 4) : (esbirrosMalvados (anioEnQueVive*100)) : portalAlFuturoDeAku

aku :: Int -> Float -> Personaje
aku anioEnQueVive salud = Personaje "Aku" salud listaDeElementosDeAku 

--4.
luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor | (==0).salud $ atacante = (defensor , atacante)
                         | otherwise              = luchar (proximoAtacante defensor atacante) (proximoDefensor atacante defensor)

proximoDefensor :: Personaje -> Personaje -> Personaje
proximoDefensor defensor atacante = foldr ($) atacante (elementos defensor)

proximoAtacante :: Personaje -> Personaje -> Personaje
proximoAtacante atacante defensor = foldr ($) defensor (elementos atacante)

--5.
f :: (z -> b -> (z, z)) -> (Int -> z) -> z -> [a] -> [c]
f x y z
| y 0 == z = map (fst.x z)
| otherwise = map (snd.x (y 0))