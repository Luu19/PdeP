{-
De los CHICOs se conoce :
    NOMBRE
    EDAD 
    HABILIDADES
    DESEOS
-}

modificaHabilidades :: ([String] -> [String]) -> Chico -> Chico
modificaHabilidades funcion chico = chico { habilidades = funcion (habilidades chico) }

agregarHabilidades :: [String] -> Chico -> Chico
agregarHabilidades habilidades chico = modificaHabilidades (++ habilidades) chico

modificaEdad :: (Int -> Int) -> Chico -> Chico
modificaEdad funcion chico = chico { edad = funcion (edad chico) }

--A. CONOCIENDO DESEOS
--1.
type Deseo = Chico -> Chico

data Chico = Chico {
    nombre :: String,
    edad :: Int,
    habilidades :: [String],
    deseos :: [Deseo]
} deriving (Show)

--a.
aprenderHabilidades :: [String] -> Deseo
aprenderHabilidades habilidadesNuevas chico = agregarHabilidades habilidadesNuevas chico

--b.
jugarVersionesNeedForSpeed :: [String]
jugarVersionesNeedForSpeed = map ("jugar Need For Speed " ++) ["1"..]

serGrosoEnNeedForSpeed :: Deseo
serGrosoEnNeedForSpeed chico = agregarHabilidades jugarVersionesNeedForSpeed chico

--c.
serMayor :: Deseo
serMayor chico = modificaEdad (const 18) Chico

--2.
--a.
wanda :: Chico -> Chico
wanda chico = modificaEdad (+ 1) . ($ chico) . head $ deseos chico

--b.
cosmo :: Chico -> Chico
cosmo chico = modificaEdad (flip div 2) chico

--c.
muffinMagico :: Chico -> Chico
muffinMagico chico = foldr ($) chico (deseos chico)

--B. EN BUSQUEDA DE PAREJA
--1.
--a.
tieneHabilidad :: String -> Chico -> Bool
tieneHabilidad habilidad chico = elem habilidad (habilidades chico)

--b.
esSuperMaduro :: Chico -> Bool
esSuperMaduro chico = edad chico > 18 && tieneHabilidad "saber manejar" (habilidades chico)

--2.
data Chicas = Chicas {
    nombreChica :: String
    condicion :: Chico -> Bool
} deriving (Show)

--a.
quienConquistaA :: Chica -> [Chico] -> [Chico]
quienConquistaA chica chicos 
    | any (condicion chica) chicos = head . filter (condicion chica) $ chicos
    | otherwise                    = head . reverse $ chicos 

--C. DA RULES
--1.
infractoresDeDaRules :: [Chico] -> [Chico]
infractoresDeDaRules chicos = filter tieneHabilidadProhibida chicos

tieneHabilidadProhibida :: Chico -> Bool
tieneHabilidadProhibida chico = any (flip elem habilidadesProhibidas) $ habilidades chico

habilidadesProhibidas :: [String]
habilidadesProhibidas = ["enamorar", "matar", "dominar al mundo"]
