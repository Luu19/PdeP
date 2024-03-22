{-
De los PELEADORes se conoce:
    PUNTOS DE VIDA
    RESISTENCIA
    ATAQUES QUE CONOCE
-}
type Ataque = Peleador -> Peleador

modificaVida :: (Int -> Int) -> Peleador -> Peleador
modificaVida funcion peleador = peleador { puntosDeVida = funcion (puntosDeVida peleador) }

reduceVida :: Int -> Peleador -> Peleador
reduceVida reducir peleador = modificaVida (- reducir) peleador

modificaAtaque :: ([Ataque] -> [Ataque]) -> Peleador -> Peleador
modificaAtaque funcion peleador = peleador { ataques = funcion (ataques peleador) }

--1.
--a.
data Peleador = Peleador {
    puntosDeVida :: Int,
    resistencia :: Int,
    ataques :: [Ataque]
} deriving (Show)

--b.
--i.
estaMuerto :: Peleador -> Bool
estaMuerto peleador = puntosDeVida peleador < 1

--ii.
esHabil :: Peleador -> Bool
esHabil peleador = (> 10) . length $ ataques peleador

--c.
--i.
golpe :: Int -> Ataque
golpe intensidadGolpe peleador = reduceVida (div intensidadGolpe resistencia peleador) peleador

--ii.
toqueDeLaMuerte :: Ataque
toqueDeLaMuerte peleador = reduceVida (puntosDeVida peleador) peleador

--iii.
patada :: String -> Ataque
patada parteDelCuerpo peleador 
    | parteDelCuerpo == "pecho"     = patadaAlPecho peleador
    | parteDelCuerpo == "la carita" = patadaALaCara peleador
    | parteDelCuerpo == "la nuca"   = patadaALaNuca peleador
    | otherwise                     = peleador

patadaAlPecho :: Ataque
patadaAlPecho peleador 
    | estaMuerto peleador = modificaVida (+ 1) peleador
    | otherwise           = reduceVida 10 peleador

patadaALaCara :: Ataque
patadaALaCara peleador = reduceVida (div (puntosDeVida peleador) 2) peleador

patadaALaNuca :: Ataque
patadaALaNuca peleador = modificaAtaque (drop 1) peleador

--a.
tresPatadasCara :: Ataque
tresPatadasCara peleador = (3 !! ). iterate (patada "la carita") $ peleador

ataquesBruceLee :: [Ataque]
ataquesBruceLee = [toqueDeLaMuerte, golpe 500, tresPatadasCara]

bruceLee = Peleador 200 25 ataquesBruceLee

--2.
mejorAtaqueEnemigo :: Peleador -> Peleador -> Ataque
mejorAtaqueEnemigo peleador enemigo = foldl1 (mejorAtaque peleador) (ataques enemigo)

mejorAtaque :: Peleador -> Ataque -> Ataque -> Ataque
mejorAtaque peleador ataque1 ataque2
    | (puntosDeVida.ataque1) peleador < (puntosDeVida.ataque2) peleador = ataque1
    | otherwise                                                         = ataque2

--3.
--a.
terrible :: Ataque -> [Peleador] -> Bool
terrible ataque enemigos = (div (length enemigos) 2 >). length . filter (not.estaMuerto) . map ataque $ enemigos

--b.
peligroso :: Peleador -> [Peleador] -> Bool
peligroso peleador enemigos = all (flip terrible enemigos) (ataques peleador)

--c.
invencible :: Peleador -> [Peleador] -> Bool
invencible peleador enemigos = (== puntosDeVida peleador). puntosDeVida . aplicaAtaques peleador . map (mejorAtaqueEnemigo peleador) $ enemigos

aplicaAtaques :: Peleador -> [Ataque] -> Peleador
aplicaAtaques peleador ataques = foldr ($) peleador ataques

