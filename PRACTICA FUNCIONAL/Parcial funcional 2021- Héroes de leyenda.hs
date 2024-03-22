{-
Todo héroe tiene un:
NOMBRE
EPITETO
RECONOCIMIENTO
ARTEFACTOS --> RAREZA
-}
type Rareza = Int
type Artefacto = (String, Rareza)
Tarea :: Heroe -> Heroe
type Labor = [Tarea]
--1.
data Heroe = Heroe {
    nombre :: String,
    epiteto :: String,
    reconocimiento :: Int,
    artefacto :: [Artefacto]
    tareas :: Labor
} deriving (Show)

--2.

haceHistoria :: Heroe -> Heroe
haceHistoria heroe 
    | reconocimiento heroe > 1000                = nuevoEpiteto "El mitico" heroe 
    | estaEntre 1000 500  (reconocimiento heroe) = (nuevoEpiteto "El maginifico").(aniadeArtefacto ("Lanza del Olimpo", 100)) $ heroe
    | estaEntre 500 100   (reconocimiento heroe) = (nuevoEpiteto  "Hoplita").(aniadeArtefacto ("Xiphos", 50)) $ heroe
    | otherwise                                  = heroe

--FUNCIONES USADAS 
estaEntre :: Int -> Int -> Int -> Bool
estaEntre extremo1 extremo2 valor = (extremo1 > valor && valor > extremo2) || (extremo1 < valor && valor < extremo2)

nuevoEpiteto :: String -> Heroe -> Heroe
nuevoEpiteto epiteto heroe = mapeoEpiteto (const epiteto) heroe 

mapeoEpiteto :: (String -> String) -> Heroe  -> Heroe
mapeoEpiteto funcionCambio heroe = heroe { epiteto = funcionCambio (apiteto heroe)}

aniadeArtefacto :: Artefacto -> Heroe -> Heroe
aniadeArtefacto artefacto heroe = mapeaArtefacto (artefacto :) heroe

mapeaArtefacto :: (Artefacto -> [Artefacto]) -> Heroe -> Heroe
mapeaArtefacto funcion heroe = heroe { artefacto = funcion (artefacto heroe) }

--3.
{-
● Encontrar un artefacto: el héroe gana tanto reconocimiento como rareza del artefacto, además de
guardarlo entre los que lleva.
● Escalar el Olimpo: esta ardua tarea recompensa a quien la realice otorgándole 500 unidades de
reconocimiento y triplica la rareza de todos sus artefactos, pero desecha todos aquellos que luego de
triplicar su rareza no tengan un mínimo de 1000 unidades. Además, obtiene "El relámpago de Zeus"
(un artefacto de 500 unidades de rareza).
● Ayudar a cruzar la calle: incluso en la antigua Grecia los adultos mayores necesitan ayuda para ello.
Los héroes que realicen esta tarea obtiene el epíteto "Groso", donde la última 'o' se repite tantas veces
1 Epíteto: apodo por el cual puede llamarse a alguien en lugar de su nombre y sigue identificando al sujeto.
como cuadras haya ayudado a cruzar. Por ejemplo, ayudar a cruzar una cuadra es simplemente
"Groso", pero ayudar a cruzar 5 cuadras es "Grosooooo".
● Matar una bestia: Cada bestia tiene una debilidad (por ejemplo: que el héroe tenga cierto artefacto, o
que su reconocimiento sea al menos de tanto). Si el héroe puede aprovechar esta debilidad, entonces
obtiene el epíteto de "El asesino de <la bestia>". Caso contrario, huye despavorido, perdiendo su
primer artefacto. Además, tal cobardía es recompensada con el epíteto "El cobarde".
-}

encontrarUnArtefacto :: Artefacto -> Tarea
encontrarUnArtefacto (nombre, rareza) heroe = (aumentaReconocimiento rareza).(aniadeArtefacto (nombre, rareza)) $ heroe
--
aumentaReconocimiento :: Int -> Heroe -> Heroe
aumentaReconocimiento rareza heroe = heroe { reconocimiento = suma rareza (reconocimiento heroe)}
suma num1 num2 = num1 + num2

escalarOlimpo :: Tarea
escalarOlimpo heroe = (aniadeArtefacto ("Relampago de Zeus", 500)).(filtraArtefactos 1000).triplicaRareza.(aumentaReconocimiento 500) $ heroe
--
triplicaRareza :: Heroe -> Heroe 
triplicaRareza heroe = mapeaArtefacto (map (*3).snd) heroe

filtraArtefactos :: Int -> Heroe -> Heroe
filtraArtefactos numero heroe = mapeaArtefacto (filter (>numero).snd) heroe 

ayudarACruzarLaCalle :: Int -> Tarea
ayudarACruzarLaCalle numeroCalles heroe = mapeoEpiteto (const ("Groso" ++ take numeroCalles listaInfinitaDeO)) heroe

listaInfinitaDeO :: String
listaInfinitaDeO = "o" : listaInfinitaDeO

type Debilidad = Heroe -> Bool
data Bestia = Bestia {
    nombre :: String,
    debilidad :: Debilidad
} deriving (Show)
matarBestia :: Bestia -> Tarea
matarBestia bestia heroe 
    | aprovechaDebilidad bestia heroe = nuevoEpiteto ("El asesino de " ++ nombre bestia) heroe
    | otherwise                       = pierdePrimerArtefacto.(nuevoEpiteto "El cobarde") heroe
--
aprovechaDebilidad :: Bestia -> Heroe -> Bool
aprovechaDebilidad bestia heroe = (debilidad bestia) heroe

pierdePrimerArtefacto :: Heroe -> Heroe
pierdePrimerArtefacto heroe = mapeaArtefacto (drop 1) heroe

--4.
heracles = Heroe "Heracles" "Guardian del   Olimpo" 700 [("Pistola", 1000), ("Relampago de Zeus", 500)] [matarAlLeonDeNemea]

--5.
leonDeNemea = Bestia "Leon de Nemea" epitetoMayorA20
epitetoMayorA20 heroe = (>20). length $ epiteto heroe

matarAlLeonDeNemea bestia heroe = matarBestia bestia heroe 

--6.
hacerHeroeTarea :: Tarea -> Heroe -> Heroe 
hacerHeroeTarea tarea heroe = (agregarTarea tarea).tarea heroe
--
agregarTarea :: Tarea -> Heroe -> Heroe
agregarTarea tarea heroe = mapeaTarea (tarea :) heroe

mapeaTarea :: ([Tarea] -> [Tarea]) -> Heroe -> Heroe
mapeaTarea funcion heroe = heroe { tareas = funcion (tareas heroe) }

--7.
presumirTareas :: Heroe -> Heroe -> (Heroe, Heroe)
presumirTareas heroe1 heroe2 
    | leGana heroe1 heroe2                   = (heroe1, heroe2)
    | leGana heroe2 heroe1                   = (heroe2, heroe1)
    | otherwise                                                       = presumirTareas (realizarTareasDelOtro heroe1 . tareas $ heroe2) (realizarTareasDelOtro heroe2 . tareas $ heroe1)

leGana :: Heroe -> Heroe -> Bool
leGana heroe1 heroe2 = (reconocimiento heroe1 > reconocimiento heroe2) || (reconocimiento heroe1 == reconocimiento heroe2 && sumaRarezasDeArtefactos heroe1 > sumaRarezasDeArtefactos heroe2)
--
sumaRarezasDeArtefactos :: Heroe -> Int
sumaRarezasDeArtefactos heroe = sum . (map snd) . artefacto $ heroe

realizarTareasDelOtro :: Heroe -> [Tarea] -> Heroe
realizarTareasDelOtro heroe listaTareas = foldr hacerHeroeTarea heroe listaTareas -- == hacerLabor

--8.
-- El resultado es un loop infinito, ya que nunca se termina de concretar un resultado.

--9.
hacerLabor :: [Tarea] -> Heroe -> Heroe
hacerLabor labor heroe = foldr hacerHeroeTarea heroe labor  --Como un labor = tarea puedo aplicar hacerTareaHeroe

--10.
--No se puede saber el estado final del heroe ya que justamente la lista es infinita, jamás terminará de
--evaluar la lista y nunca sabremos el estado final del heroe.
