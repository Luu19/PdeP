import Distribution.Compat.CharParsing (between)
{-
De cada INVESTIGADOR conocemos :
    NOMBRE 
    EXPERIENCIA
    SU POKEMOS COMPANIERO
    MOCHILA
    POKEMONES CAPTURADOS

EXISTEN CUATRO RANGOS DE EXPERIENCIA =
    CIELO -> 0
    ESTRELLA -> 100
    CONSTELACION -> 500
    GALAXIA -> 2000

De los POKEMON se conoce :
    NOMBRE
    DESCRIPCION
    NIVEL
    CANTIDAD PUNTOS BASE DE INV
    ES ALFA 
-}

data Investigador = Investigador {
    nombre :: String,
    experiencia :: Float,
    pokemonAmigo :: Pokemon,
    mochila :: [Item],
    pokemonesCapturados :: [Pokemon]
} deriving (Show )

data Pokemon = Pokemon {
    nombrePokemon :: String,
    descripcion :: String,
    nivel :: Int,
    cantidadPuntos :: Int
    esAlfa :: Bool
} deriving (Show)

operacionAlfa :: Pokemon -> Pokemon
operacionAlfa pokemon = pokemon { cantidadPuntos = cantidadPuntos pokemon * 2 }

between :: Eq a => a -> a -> a -> Bool
between n x y = elem n [x..y]

agregarItem :: Item -> Investigador -> Investigador
agregarItem item investigador = modificarItem (item :) investigador

modificarItem :: ([Item] -> [Item]) -> Investigador -> Investigador
modificarItem funcion investigador = investigador { mochila = funcion (mochila investigador) }

modificaExperiencia :: (Float -> Float) -> Investigador -> Investigador
modificaExperiencia funcion investigador = investigador { experiencia = funcion (experiencia investigador) }

modificaPokemonCompaniero :: (Pokemon -> Pokemon) -> Investigador -> Investigador
modificaPokemonCompaniero funcion investigador = investigador { pokemonAmigo = funcion (pokemonAmigo investigador) } 

agregarPokemon :: Pokemon -> Investigador -> Investigador
agregarPokemon pokemon investigador = modificaPokemones (pokemon :) investigador

modificaPokemones :: ([Pokemon] -> [Pokemon]) -> Investigador -> Investigador
modificaPokemones funcion investigador = investigador { pokemonesCapturados = funcion (pokemonesCapturados investigador) }
--1.
akari = Investigador "Akari" 1499 oshawott [] [oshawott] (False)

oshawott = Pokemon "Oshawott"  "una nutria que pelea con la caparazón de su pecho" 5 3

--2.
rangoDeInvestigador :: Investigador -> String
rangoDeInvestigador investigador 
    | esRangoCielo investigador        = "Cielo"
    | esRangoEstrella investigador     = "Estrella"
    | esRangoConstelacion investigador = "Constelacion"
    | esRangoGalaxia investigador      = "Galaxia"

esRangoCielo :: Investigador -> Bool
esRangoCielo investigador = beetween (experiencia investigador) 0 99

esRangoEstrella :: Investigador -> Bool
esRangoEstrella investigador = between (experiencia investigador) 100 499

esRangoConstelacion :: Investigador -> Bool
esRangoConstelacion investigador = beetween (experiencia investigador) 499 1999

esRangoGalaxia :: Investigador -> Bool
esRangoGalaxia investigador = experiencia investigador == 2000

--3.
type Item =     Float -> Float
type Actividad = Investigador -> Investigador

obtenerItem ::  Item -> Actividad
obtenerItem item investigador = modificaExperiencia item . agregarItem item $ investigador

bayas :: Item
bayas experiencia =  (^2) . (+ 1) $ experiencia

apricorns :: Item
apricorns experiencia = (* 1.5) $ experiencia

guijarros :: Item
guijarros experiencia = (+ 2) $ experiencia

fragmentosDeHierro :: Float -> Item
fragmentosDeHierro cantidadFragmentos experiencia = (/ cantidadFragmentos)

admirarPaisaje :: Actividad
admirarPaisaje investigador = modificaExperiencia (* 0.95) . pierdeXItems 3 $ investigador

pierdeXItems :: Int -> Investigador -> Investigador
pierdeXItems cantidad investigador = modificarItem (drop cantidad) investigador

capturarPokemon :: Pokemon -> Actividad
capturarPokemon pokemon investigador = esNuevoCompanieroSi ((> 20) . cantidadPuntos) pokemon . agregarPokemon pokemon $ investigador

esNuevoCompanieroSi :: (Pokemon -> Bool) -> Pokemon -> Investigador -> Investigador
esNuevoCompanieroSi condicion pokemon investigador 
    | condicion pokemon = modificaPokemonCompaniero (const pokemon) investigador
    | otherwise         = investigador

combatirPokemon :: Pokemon -> Actividad
combatirPokemon pokemonACombatir investigador 
    | leGana (pokemonAmigo investigador) pokemonACombatir = modificaExperiencia (+ (cantidadPuntos pokemonAmigo / 2)) investigador
    | otherwise                                           = investigador

leGana :: Pokemon -> Pokemon -> Bool
leGana pokemon1 pokemon2 = nivel pokemon1 > nivel pokemon2

--4.
type Expedicion = [Actividad]

realizanExpedicion :: Expedicion -> [Investigador] -> [Investigador]
realizanExpedicion expedicion investigadores = map (haceExpedicion expedicion) investigadores

haceExpedicion :: Expedicion -> Investigador -> Investigador
haceExpedicion expedicion investigador = foldr ($) investigador expedicion

realizarReporteDeSegun :: (Investigador -> a) -> (Investigador -> Bool) -> Expedicion -> [Investigador] -> [a]
realizarReporteDeSegun funcionMapeo condicionDeFiltro expedicion investigadores = map funcionMapeo . filter condicionDeFiltro . realizanExpedicion expedicion $ investigadores

-- *
reporteMasDeTresPokemonAlfa :: Expedicion -> [Investigador] -> [String]
reporteMasDeTresPokemonAlfa expedicion investigadores = realizarReporteDeSegun nombre (tieneMasDeXPokemonAlfa 3) expedicion investigadores

tieneMasDeXPokemonAlfa :: Int -> Investigador -> Bool
tieneMasDeXPokemonAlfa cantidad investigador = (> 3) . length . filter esAlfa $ (pokemonesCapturados investigador)

-- *
reporteSonRangoGalaxia :: Expedicion -> [Investigador] -> [Int]
reporteSonRangoGalaxia expedicion investigadores = realizarReporteDeSegun experiencia esRangoGalaxia expedicion investigadores

-- *
reportePokemonConNivelDiez :: Expedicion -> [Investigador] -> [Pokemon]
repprtePokemonConNivelDiez expedicion investigadores = realizarReporteDeSegun pokemonAmigo (tienePokemonConNivel 10) expedicion investigador

tienePokemonConNivel :: Int -> Investigador -> Bool
tienePokemonConNivel nivelPokemon investigador = (> 10) . nivel . pokemonAmigo $ investigador

-- *
reporteUltimosTresPokemons :: Expedicion -> [Investigador] -> [Pokemon]
reporteUltimosTresPokemons expedicion investigadores = concat $ realizarReporteDeSegun primerosTresCapturados tienenTodosNivelImpar expedicion investigadores

ultimosTresCapturados :: Investigador -> [Pokemon]
ultimosTresCapturados investigadores =  (take 3 . pokemonesCapturados) 
    --Tomos los 3 primeros ya que a medida que los capturaba los colocaba al comienzo de la lista 

tienenTodosNivelImpar :: Investigador -> Bool
tienenTodosNivelImpar investigador = all (odd . nivel) (pokemonesCapturados investigador)

--5.
{-
Los reportes anteriores que pueden realizarse, en caso de que un investigador
tenga infinitos pokemones, som sonRangoGalaxia y pokemonConNivel10. Porque el resto de los reportes 
implica recorrer toda la lista infinita de pokemonesCapturados para finalizar la funcion, en cambio en 
sonRangoGalaxia necesitamos informacion del investigador y en pokemonConNivel10 necesitamos
la informacion de pokemonAmigo, nunca recurrimos a la lista de pokemonesCapturados.
-}