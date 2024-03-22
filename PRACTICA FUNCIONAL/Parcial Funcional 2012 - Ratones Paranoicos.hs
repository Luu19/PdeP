{-
isAlfa me dice si es un caracter
isUpper me dice si es mayuscula
isDigit me dice si es un numero
tails convierte un String en una lista de Strings de todos los segmentos hasta el final
                        tails "abc" == ["abc", "bc", "c",""]

fromEnum :: Char -> Int

toEnum :: Int -> Char
-}
--DICCIONARIO :
diccionario = ["aaron", "abaco", "abecedario", "baliente", "beligerante"]

--A.
type Requisito = [Char] -> Bool

--1.
empiezaConLetra :: Char -> Requisito
empiezaConLetra letra password = (== letra) . take 1 $ password 

--2.
numeros :: [Char]
numeros = "123456789"

tieneAlMenosUnNumero :: Requisito
tieneAlMenosUnNumero password = any (flip elem numeros) password

--3.
tieneXMayusculas :: Int -> Requisito
tieneXMayusculas cantidad password = (== numero) . length . filter esMayuscula $ password

esMayuscula :: Char -> Bool
esMayuscula letra = isUpper letra

--4.
esIndeducible :: Requisito
esIndeducible password = not . any (flip elem password) $ diccionario

empiezaCon :: String -> String -> Bool
empiezaCon empieza palabra = (== empieza) . take (length empieza) $ palabra

contieneA :: String -> String -> Bool
contieneA palabraAContener palabra = elem palabraAContener (tails palabra)

{- contieneA' :: String -> String -> Bool
contieneA' palabraAContener palabra = 
(== palabraAContener) . flip (tomoDesde palabra) (length palabraAContener) . posicionPrimerCaracter $ palabraAContener || contieneA palabraAContener (drop (posicionCaracter palabraAContener) palabra)
    where posicionCaracter palabra = flip posicion palabra $ take 1 palabraAContener

tomoDesde :: [a] -> Int -> Int -> [a]
tomoDesde lista posicion tantasPosiciones = take tantasPosiciones . drop (posicion - 1) $ lista

posicion :: Eq a => a -> [a] -> Int
posicion     _           [] = 0  
posicion elemento (elemento1 : elementos) 
    | elemento1 == elemento = 1
    | otherwise             = 1 + posicion elemento elementos
-}
--B.
data Usuario = Usuario {
    nombreUsuario :: String,
    passwordEncriptado :: String
} deriving (Show)

data App = App {
    listaDeUsuarios :: [Usuario],
    requisitosDePassword :: [Requisito],
    metodoDeEncriptado :: String -> String
} deriving (Show)

--1.
puedoUsar :: String -> App -> Bool
puedoUsar password app = all (cumpleRequisito password) (requisitosDePassword app)

cumpleRequisito :: String -> Requisito -> Bool
cumpleRequisito password requisito = requisito password

--2.
--a.
cesar :: Int -> String -> String
cesar n password = map (cesar' n) password

cesar' :: Int -> Char -> Char
cesar' n letra = (!! n) $ abecedarioDesde letra 

abecedarioDesde :: Char -> [Char]
abecedario letraComienzo 
    | isAlfa letraComienzo  = abecedario letraComienzo
    | otherwise             = [letraComienzo .. '9'] ++ ['1'.. pred letraComienzo]

abecedario :: Char -> [Char]
abecedario comienzo 
    | isUpper comienzo = [comienzo .. 'Z'] ++ ['A'.. pred comienzo]
    | otherwise        = [comienzo .. 'z'] ++ ['a'.. pred comienzo]

--b.
textoHash :: String -> Int
textoHash password = sum . map fromEnum $ password

--3.
registrarse :: String -> String -> App -> App
registrarse nombreARegistrar password app = agregaUsuarioSi (puedoUsar password) (Usuario nombreARegistrar (metodoDeEncriptado app $ password)) app

agregaUsuarioSi :: (App -> Bool) -> Usuario -> App -> App
agregaUsuarioSi condicion usuario app
    | condicion app = agregarUsuario usuario app
    | otherwise     = app

agregarUsuario :: Usuario -> App -> App
agregarUsuario usuario app = app { listaDeUsuarios = usuario : (listaDeUsuarios app) }

--4.
--a.
paradigma = App [] [((> 6) . length), (not . (== 't') . take 1)] (cesar 4)

--b.
faceButt = App infinitosUsuarios [] []

infinitosUsuarios :: [Usuario]
infinitosUsuarios = iterate (flip (map agregarNum) ["1"..]) usuarioRandom

agregarNum :: Usuario -> String -> Usuario
agregarNum usuario agregado = cambiarNombre (++ agregado) . cambiarPassword (++ agregado) $ usuario

cambiarNombre :: (String -> String) -> Usuario -> Usuario
cambiarNombre funcion usuario = usuario { nombreUsuario = funcion (nombreUsuario usuario) }

cambiarPassword :: (String -> String) -> Usuario -> Usuario
cambiarPassword funcion usuario = usuario { passwordEncriptado = funcion (passwordEncriptado usuario) }
