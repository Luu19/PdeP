{-
De las CRIATURAs nos interesa:
NIVEL DE PELIGROSIDAD
ACCIONES A CUMPLIR PARA DESHACERNOS DE ELLA

De las PERSONAs conocemos:
EDAD
ITEMS QUE TIENE 
EXPERIENCIA 

-}

cambiaExperiencia :: (Int -> Int) -> Persona -> Persona
cambiaExperiencia f persona = persona { experiencia = f (experiencia persona) }

--1.

data Criatura = Criatura {
    peligrosidad :: Int,
    accionesPorCumplir ::  Persona -> Bool
}deriving (Show)

data Persona = Persona {
    edad :: Int,
    items :: [Item],
    experiencia :: Int
}deriving (Show)

data Item = SopladorDeHojas | DisfrazOveja
type AsuntoPendiente :: Persona -> Bool

siempreDetras :: Criatura
siempreDetras = Criatura 0 (const False)

gnomos :: Int -> Criatura
gnomos cantidadGnomos = Criatura (2^cantidadGnomos) (tieneItem SopladorDeHojas)

fantasma :: Int -> (AsuntoPendiente) -> Criatura
fantasmas categoria asuntoPendiente = Criatura (categoria*20) asuntoPendiente

tieneItem :: Item -> Persona -> Bool
tieneSoplador item persona = any (==item) (items persona) 



--2.
enfrentarse :: Persona -> Criatura -> Persona
enfrentarse persona criatura | (accionesPorCumplir criatura) persona = ganaExperiencia (peligrosidad criatura) persona
                             | otherwise                             = ganaExperiencia 1 persona

ganaExperiencia :: Int -> Persona -> Persona
ganaExperiencia numero persona = cambiaExperiencia (+ numero) persona

--3.
--a.
enfrentarMuchasCriaturas :: Persona -> [Criatura] -> Int
enfrentarMuchasCriaturas persona criaturas = (flip (deltaSegun experiencia) persona). (foldr enfrentarse persona)  $ criaturas

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

--b.
asuntoCategoria3 :: AsuntoPendiente
asuntoCategoria3 persona = (edad persona < 13) && (tieneItem DisfrazOveja persona)

asuntoCategoria1 :: AsuntoPendiente
asuntoCategoria1 persona = experiencia persona > 10

type EjemploConsulta = [siempreDetras, gnomos 10, fantasma 3 asuntoCategoria3, fantasma 1 asuntoCategoria1]

--SEGUNDA PARTE
--1.
zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf  _          _               _           [] = []
zipWithIf  _          _               []          _  = [] 
zipWithIf funcion condicion (cabeza1 : cola1) (cabeza2 : cola2)
| condicion cabeza2 = funcion cabeza1 cabeza2 : zipWithIf funcion condicion cola1 cola2
| otherwise         = cabeza2 : zipWithIf funcion (cabeza1 : cola1) cola2

--2.
--a.
abecedarioDesde :: Char -> [Char]
abecedarioDesde comienzo | comienzo =/ 'a'= [comienzo .. 'z'] : ['a' .. pred comienzo]
                         | otherwise      = abecedario

abecedario :: [Char]
abecedario = ['a'..'z']

--b.
desencriptarLetra :: Char -> Char -> Char
desencriptarLetra letraClave letraParaDesencriptar = (desencriptarLetra' letraParaDesencriptar abecedario) .abecedarioDesde $ letraClave

desencriptarLetra' :: Char -> [Char] -> [Char] -> Char 
desencriptarLetra' letraParaDesencriptar (cabeza1 : cola1) (cabeza2 : cola2) | letraParaDesencriptar == cabeza1 = cabeza2 
                                                                             | otherwise                        = desencriptarLetra' letraParaDesencriptar cola1 cola2

--c.
cesar :: Char -> String -> String
cesar letraClave textoParaDesencriptar = zipWithIf desencriptarLetra esLetra (abecedarioDesde letraClave) textoParaDesencriptar

esLetra :: Char -> Bool
esLetra caracter = elem caracter abecedario 

--d.
todasPosibles :: [String]
todasPosibles = map (\letraClave -> cesar letraClave "jrzel zrfaxal!") abecedario

--3.
vigenere :: String -> String -> String
vigenere textoClave textoParaDesencriptar = desencriptarTexto (cycle textoClave) textoParaDesencriptar

desencriptarTexto :: String -> String -> String
desencriptarTexto unTexto textoParaDesencriptar = zipWithIf desencriptarLetra esLetra unTexto textoParaDesencriptar

