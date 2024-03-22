{-
De las LEYes nos interesa:
    TEMA QUE TRATA
    PRESUPUESTO QUE REQUIERE
    PARTIDOS POLITICOS QUE LA APOYAN

-}

data Ley = Ley {
    tema :: String,
    presupuesto :: Int,
    sectoresQueApoyan :: [String]
} deriving (Show)

--1.
sonCompatibles :: Ley -> Ley -> Bool
sonCompatibles ley1 ley2 = tienenSectorEnComun (sectoresQueApoyan ley1) (sectoresQueApoyan ley2) && tienenTemaIncluido (tema ley1) (tema ley2)

tienenSectorEnComun :: [String] -> [String] -> Bool
tienenSectorEnComun     []              sectores2   = False
tienenSectorEnComun  sectores1              []      = False
tienenSectorEnComun (sector1 : sectores1) sectores2 = (any (==sector1) sectores2) || tienenSectorEnComun sectores1 sectores2

tienenTemaIncluido :: String -> String -> Bool
tienenTemaIncluido tema1 tema2 = any coincideCon tema1 $ words tema2 || any coincideCon tema2 $ words tema1
    where coincideCon tema1 = ((== tema1) . take (length tema1)) 

--Parte 2

estaEn :: a -> [a] -> Bool
estaEn elemento lista = elem elemento lista

apoyadaPorSector :: String -> Ley -> Bool 
apoyadaPorSector sector ley = estaEn sector (sectoresQueApoyan ley)

type Juez = Ley -> Bool
type CorteSuprema = [Juez]
type TemasEnAgenda = [String]

apruebaPorOpinionPublica :: Juez --True si el tema esta en agenda
apruebaPorOpinionPublica ley = estaEn (tema ley) temasEnAgenda

apruebaPorUnidades :: Int -> Juez --True si no supera
apruebaPorUnidades unidades ley = unidades >= (presupuesto ley)

apoyaPartidoConservador :: Juez --True si el sector la apoya
apoyaPartidoConservador ley = apoyadaPorSector "Partido Conservador"  ley

apoyadaPorSectorFinaciero :: Juez --True si el sector la apoya
apoyadaPorSectorFinaciero ley = apoyadaPorSector "Sector Financiero"  ley

--1.
esConstitucional :: CorteSuprema -> Ley -> Bool
esConstitucional corteSuprema ley = cuantas id corteSuprema ley > cuantas not corteSuprema ley

cuantas :: (a -> a) -> CorteSuprema -> Ley -> Int
cuantas f       []         ley = 0
cuantas f (juez1 : jueces) ley 
    | f.juez1 $ ley            = 1 + cuantas f jueces ley
    | otherwise                = cuantas f jueces ley

--2.
agregarJuez :: CorteSuprema -> (Juez) -> CorteSuprema
agregarJuez corteSuprema juez = juez : corteSuprema

--a.
afirmativo :: Juez
afirmativo _ = True

--b. ??

--c.
apruebaPorUnidades :: Int -> Juez --True si no supera
apruebaPorUnidades unidades ley = unidades >= (presupuesto ley)

--3.
noEsConstitucional :: CorteSuprema -> [Leyes] -> [Leyes]
noEsConstitucional corteSuprema leyes = filter (not . esConstitucional corteSuprema) leyes

--Parte 3
--1.
haceLoContrario :: Juez -> Juez
haceLoContrario juez = not . juez

--2.
coincideCon :: String -> Juez -> [Ley] -> Bool
coincideCon sector juez (ley : leyes) = (juez ley) && (apoyadaPorSector sector ley) && (coincideCon sector leyes)