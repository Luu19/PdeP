{-
De los SUPERHEROES conocemos:
NOMBRE
VIDA 
PLANETA DE ORIGEN
ARTEFACTO --> (NOMBRE, DAÑO)
VILLANO ENEMIGO

De los VILLANOS conocemos:
NOMBRE 
PLANETA DE ORIGEN
ARMA
-}
type Danio = Int
type Nombre = String
type Artefacto = (Nombre, Danio)

data SuperHeroe = SuperHeroe {
    nombre :: Nombre,
    vida :: Int,
    planetaDeOrigen :: String,
    artefacto :: Artefacto,
    enemigo :: Villano
} deriving (Show, Eq)

data Villano = Villano {
    nombre :: Nombre, 
    planetaDeOrigen :: String,
    arma :: Arma 
} deriving (Show, Eq)

mapeaArtefacto :: (Artefacto -> Artefacto) -> SuperHeroe -> SuperHeroe
mapeaArtefacto funcion superHeroe = superHeroe { artefacto = funcion (artefacto superHeroe) }

mapeoVida :: (Int -> Int) -> Heroe -> Heroe 
mapeoVida funcion heroe = heroe { vida = funcion (vida heroe)}

mapeaNombreSuper :: (String -> String) -> SuperHeroe
mapeaNombreSuper funcion superHeroe = superHeroe { nombre = funcion (nombre superHeroe) }

--1.
--a.
ironMan = SuperHeroe "Tony Stark" 100 "Tierra" ("Traje", 12) thanos
thor = SuperHeroe "Thor Odinson" 300 "Asgard" ("Stormbreaker", 0) loki

--b.
thanos = Villano "Thanos" "Titan" guanteleteDelInfinito
loki = Villano "Loki Laufeyson" "Jotunheim" cetro

--2.
type Arma = SuperHeroe -> SuperHeroe

guanteleteDelInfinito :: Arma
guanteleteDelInfinito superHeroe = disminuyeVida 80 heroe 

cetro :: Arma
cetro superHeroe | planetaDeOrigen superHeroe == "Tierra" = (disminuyeVida 20).rompeArtefacto $ heroe 
                 |  otherwise                             = disminuyeVida 20 heroe

--FUNCIONES USADAS
rompeArtefacto :: SuperHeroe -> SuperHeroe --agrega "machacado" y 30 de danio
rompeArtefacto superHeroe = mapeaArtefacto (\(nombre, danio)-> ("machacado "++ nombre , danio + 30)) superHeroe

disminuyeVida :: Int -> SuperHeroe -> SuperHeroe
disminuyeVida porcentaje heroe = mapeoVida (reglaDeTresYResta 80 (vida heroe)) heroe

reglaDeTresYResta :: Int -> Int -> Int -> Int
reglaDeTresYResta numero1 numero2 numero3 = numero3 - (div (numero1 * numero2) 100)

--3.
sonAntagonistas :: SuperHeroe -> Villano -> Bool
sonAntagonistas superHeroe villano = loTieneDeEnemigo superHeroe villano || (planetaDeOrigen superHeroe) == (planetaDeOrigen villano)

loTieneDeEnemigo :: SuperHeroe -> Villano -> Bool
loTieneDeEnemigo superHeroe villano = (enemigo superHeroe) == villano

--4. 
villanoAtacaSuperHeroe :: SuperHeroe -> Villano -> SuperHeroe
villanoAtacaSuperHeroe superHeroe villano | enemigo superHeroe == villano = superHeroe
                                          |    otherwise                  = (arma villano) superHeroe

--5.
sobreviveAlVillano ::  [SuperHeroe]-> Villano -> [SuperHeroe]
sobreviveAlVillano listaDeSuper villano = (map (cambiaNombre "Super")).(filter ((> 50).vida)). map (arma villano) $ listaDeSuper

--6.
vuelvenACasa :: [SuperHeroe] -> [SuperHeroe]
vuelvenACasa listaDeSuper = (map arreglaArtefacto.mapeoVida (30 +)). (flip sobreviveAlVillano thanos) $ listaDeSuper

arreglaArtefacto :: SuperHeroe -> SuperHeroe
arreglaArtefacto superHeroe = mapeaArtefacto (\(nombre, danio)-> (drop (length "machacado ") nombre , 0)) superHeroe

--7.
esVillanoDebil :: Villano -> [SuperHeroe] -> Bool
esVillanoDebil villano listaDeSuper = all (flip loTieneDeEnemigo villano) listaDeSuper && not any tieneArtefactoDaniado listaDeSuper

tieneArtefactoDaniado :: SuperHeroe -> Bool
tieneArtefactoDaniado superHeroe =  (== "machacado"). (take (length "machacado")) .fst . artefacto $ superHeroe

--8.
drStrange = SuperHeroe "Stephen Strange " 60 "Tierra" ("Capa de Levitacion", 0) thanos

infinitosClonesDeStrange :: [SuperHeroe]
infinitosClonesDeStrange = map (modificaNombreSuperHeroe drStrange) ["1"..]  

modificaNombreSuperHeroe :: SuperHeroe ->  String -> SuperHeroe 
modificaNombreSuperHeroe superHeroe agregadoNombre  = mapeaNombreSuper (++ agregadoNombre) superHeroe

--9.
{-a. No, no podemos obtener esa lista ya que, para obtenerla, deberíamos evaluar a todos los clones, sin 
embargo en este caso nunca terminaremos de evaluar los clones de la lista debido a que son infinitos
-}
{-b. No, no podemos ya que ambas listas son infinitas y jamás se terminaran de evaluar-}