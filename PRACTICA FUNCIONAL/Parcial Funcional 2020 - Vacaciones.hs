{-
Estadísticas de los tours que ofrece a sus clientes.
De los TURISTAs se conoce:
NIVEL DE CANSANCIO Y ESTRÉS
VIAJA SOLO
IDIOMAS QUE HABLA
-}
type Idioma = String

data Turista = Turista {
    cansancio :: Int,
    estres :: Int,
    viajaSolo :: Bool,
    idiomasQueHabla :: [Idioma]
} deriving (Show, Eq)

type Excursion = Turista -> Turista

mapeoCansancio :: (Int -> Int) -> Turista -> Turista
mapeoCansancio f turista = turista { cansancio = f (cansancio turista) }

mapeoEstres :: (Int -> Int) -> Turista -> Turista
mapeoEstres f turista = turista { estres = f (estres turista) }

mapeoIdioma :: ([String] -> [String]) -> Turista -> Turista
mapeoIdioma f turista = turista { idiomasQueHabla = f (idiomasQueHabla turista) }

agregaIdioma :: String -> Turista -> Turista
agregaIdioma idioma turista = mapeoIdioma (idioma :) turista

acompaniado :: Turista -> Turista
acompaniado turista = turista { viajaSolo = const False (viajaSolo turista) }

--EXCURSIONES
irPlaya :: Excursion
irPlaya turista | viajaSolo turista = mapeoCansancio (- 5) turista
                |    otherwise      = mapeoEstres (- 1) turista

apreciarElementoDelPaisaje :: String -> Excursion
apreciarElementoDelPaisaje elemento turista = mapeoEstres (- length elemento) turista

caminar :: Int -> Excursion
caminar minutos turista = mapeoEstres (+ div minutos 4) . mapeoCansancio (+ div minutos 4) $ turista

salirAHablarIdioma :: String -> Excursion 
salirAHablarIdioma idioma turista = acompaniado . (agregaIdioma idioma) $ turista

data Marea = Tranquila | Moderada | Fuerte deriving (Show, Eq)

paseoEnBarco :: Marea ->Excursion
paseoEnBarco marea turista | marea == Tranquila = (mapeoEstres (+ 6)) . mapeoCansancio (+ 10) $ turista
                           | marea == Moderada  = turista
                           | marea == Fuerte    = (caminar 10) . (apreciarElementoDelPaisaje "mar") . (salirAHablarIdioma "Aleman") $ turista

--1.
ana   = Turista 0  21 False ["espaniol"]
betho = Turista 15 15 True  ["aleman"]
cathi = Turista 15 15 True  ["aleman", "catalan"]

--2.
--a.
hacerExcursion :: (Excursion) -> Turista -> Turista
hacerExcursion excursion turista = (mapeoEstres (- div 10 100) ). excursion $ turista

--b.
deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

type Indice = Turista -> Int

deltaExcursionSegun :: (Indice) -> Turista -> (Excursion) -> Int
deltaExcursionSegun indice turista excursion = (deltaSegun indice turista) . hacerExcursion excursion $ turista

--c.
--i.
{-Saber si una excursión es educativa para un turista, que implica que termina
aprendiendo algún idioma-}
esEducativa :: (Excursion) -> Turista -> Bool
esEducativa excursion turista = (> 0). (flip (deltaExcursionSegun length.idiomasQueHabla) excursion) $ turista 

--ii.
esDesestresante :: (Excursion) -> Turista -> Bool
esDesestresante excursion turista = (> 3) . (flip (deltaExcursionSegun estres) excursion) $ turista 

--3.
type Tour = [Excursion]

completo = [salirAHablarIdioma "melmacquiano", irPlaya, caminar 40, apreciarElementoDelPaisaje "cascada", caminar 20]

ladoB :: (Excursion) -> Tour
ladoB excursion = [paseoEnBarco Tranquila, hacerExcursion excursion, caminar 120]

islaVecina :: Marea -> Tour 
islaVecina marea | marea == Fuerte = [paseoEnBarco Fuerte, apreciarElementoDelPaisaje "lago", paseoEnBarco Fuerte]
                 |    otherwise    = [paseoEnBarco marea, irPlaya, paseoEnBarco marea]

--a.
hacerTour ::  Tour -> Turista -> Turista
hacerTour turista tour =  (flip (foldr hacerExcursion) tour).mapeoEstres (+ length tour) $ turista

--b.
tuorsConvincentes :: [Tour] -> Turista -> Bool
tuorsConvincentes listaDeTour turista = any (flip tourConveniente turista) $ listaDeTour

tourConveniente :: Tour -> Turista -> Bool
tourConveniente tour turista = any (flip esDesestresante tour) turista && dejaAcompaniado tour turista

dejaAcompaniado :: Tour -> Turista -> Bool
dejaAcompaniado tour turista = not . (any viajaSolo.(hacerTour tour)) $ turista

--c.
efectividadTour :: Tour -> [Turista] -> Int
efectividadTour turistas tour = sum (map negate.(espiritualidad tour)) . filter (tourConveniente tour) $ turistas

espiritualidad :: Tour -> Turista -> Int
espiritualidad tour turista = deltaSegun indiceEspiritualidad (hacerTour tour turista) turista 

indiceEspiritualidad :: Turista -> Int
indiceEspiritualidad turista = cansancio turista + estres turista 

--4.
--a.
infinitasPlayas :: Tour
infinitasPlayas = repeat irPlaya

{-
b.


c.

-}
