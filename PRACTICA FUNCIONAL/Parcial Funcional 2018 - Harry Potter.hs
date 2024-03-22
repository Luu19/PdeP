{-
De los MAGOs se sabe : 
    NOMBRE
    EDAD 
    SALUD
    HECHIZOS 
-}

modificaSalud :: (Int -> Int) -> Mago -> Mago
modificaSalud funcion mago = mago { salud = funcion (salud mago) }

modificaHechizos :: ([Hechizo] -> [Hechizo]) -> Mago -> Mago
modificaHechizos funcion mago = mago  { hechizos = funcion (hechizos mago) }

--1.
data Mago = Mago {
    nombre :: String,
    edad :: Int,
    salud :: Int,
    hechizos :: [Hechizo]
} deriving (Show)

type Hechizo = Mago -> Mago

--a.
curar :: Int -> Hechizo
curar recuperaSalud mago = modificaSalud (+ recuperaSalud) mago

--b.
lanzarRayo :: Hechizo
lanzarRayo mago 
    | salud mago > 10  = modificaSalud (- 10) mago
    | otherwise        = modificaSalud (flip div 2) mago

--c.
amnesia :: Int -> Hechizo
amnesia n mago = modificaHechizos (drop n) mago

--d.
confundir :: Hechizo
confundir mago = ($ mago) . head . hechizos $ mago

--2.
--a.
poder :: Mago -> Int
poder mago = salud mago + edad mago * (length . hechizos $ mago)

--b.
danio :: Mago -> Hechizo -> Int
danio mago hechizo = salud $ hechizo mago

--c.
diferenciaDePoder :: Mago -> Mago -> Int
diferenciaDePoder mago1 mago2 = abs (poder mago1 - poder mago2)

--3.
data Academia = Academia {
    magos :: [Mago],
    examenDeIngreso :: Mago -> Bool
} deriving (Show)

--a.
hayAlgunRincenwind :: Academia -> Bool
hayAlgunRincenwind academia = elem "Rincewind" . map nombre . filter noTienenHechizos $ magos academia

noTienenHechizos :: Mago -> Bool
noTienenHechizos mago = (== 0) . length $ hechizos mago

--b.
sonTodosLosViejosNionios :: Academia -> Bool
sonTodosLosViejosNionios academia = all esNionio . filter esViejo $ magos academia 

esViejo :: Mago -> Bool
esViejo mago = (> 50) . edad $ mago 

esNionio :: Mago -> Bool
esNionio mago = (> salud mago) . length $ hechizos mago

--c.
noPasarianElIngreso :: Academia -> Int
noPasarianElIngreso academia = length . filter (not . examenDeIngreso $ academia) $ magos academia

--d.
sumatoriaDeEdadMagos :: Academia -> Int
sumatoriaDeEdadMagos academia = sum . map edad . filter (sabeMasDeXHechizos 20) $ magos academia

sabeMasDeXHechizos :: Int -> Mago -> Bool
sabeMasDeXHechizos numero mago = (> numero) . length $ hechizos mago

--4.
--c. i.

maximoSegun funcion lista = foldl1 funcion lista 

mejorHechizoContra :: Mago -> Mago -> Hechizo
mejorHechizoContra mago1 mago2 = maximoSegun (leHaceMasDanio mago1) (hechizos mago2) 

leHaceMasDanio :: Mago -> Hechizo -> Hechizo -> Hechizo
leHaceMasDanio mago hechizo1 hechizo2
    | danio hechizo1 mago < danio hechizo2 mago = hechizo1
    | otherwise                                 = hechizo2

--c. ii.
mejorOponente :: Mago -> Academia -> Mago   
mejorOponente mago academia = maximoSegun (tieneMasDiferenciaDePoder mago) (magos academia)

tieneMasDiferenciaDePoder :: Mago -> Mago -> Mago -> Mago 
tieneMasDiferenciaDePoder magoSemilla mago1 mago2 
    | diferenciaDePoder magoSemilla mago1 > diferenciaDePoder magoSemilla mago2 = mago1
    | otherwise                                                                 = mago2

--5.
--a.
noPuedeGanarle :: Mago -> Mago -> Bool
noPuedeGanarle mago1 mago2  = (== salud mago1) . salud . flip aplicarHechizos (hechizos mago2) $ mago1

aplicarHechizos :: Mago -> [Hechizo] -> Mago
aplicarHechizos mago hechizos = foldr ($) mago hechizos

--b.
laTieneDeHija :: Academia -> Academia -> Bool
laTieneDeHija academia1 academia2 = puedeGanarle (head . magos $ academia2) (magos academia1)

puedeGanarle :: Mago -> [Mago] -> Bool
puedeGanarle mago magos = all (noPuedeGanarle mago) magos 
