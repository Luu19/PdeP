--- PARCIAL TRANSFORMERS ---
{-

-}
data Autobot = 
Robot {
    nombreRobot :: String,
    fuerzaVelocidadResistencia :: (Int,Int,Int),
    valores :: (Int,Int,Int) -> (Int,Int)
}
| Vehiculo {
    velocidadResistencia :: (Int,Int)
}

--1.
maximoSegun :: (a -> b -> c) -> a -> b -> c
maximoSegun funcion valor1 valor2 
    | esMasGrande valor1 valor funcion = valor1
    | otherwise                        = valor2

esMasGrande :: a -> b -> (a -> b -> c) -> Bool
esMasGrande valor1 valor2 funcion = ((funcion) valor1 valor2) > ((funcion) valor2 valor1)

--2.
data Autobot = 
Robot {
    nombreRobot :: String,
    fuerzaVelocidadResistencia :: (Int,Int,Int),
    valores :: (Int,Int,Int) -> (Int,Int)
}
| Vehiculo {
    nombreVehiculo :: String
    velocidadResistencia :: (Int,Int)
}
fst3 :: (a, b, c) -> b
fst3 ( x , _ , _) = x

snd3 :: (a, b, c) -> b
snd3 ( _ , x , _) = x

thr3 :: (a, b, c) -> b
thr3 ( _ , _ , x) = x

fuerzaAutobot :: Autobot
fuerzaAutobot autobot = fst3 . fuerzaVelocidadResistencia $ autobot

velocidadAutobot :: Autobot
velocidadAutobot autobot = snd3 . fuerzaVelocidadResistencia $ autobot

resistenciaAutobot :: Autobot
resistenciaAutobot autobot = thr3 . fuerzaVelocidadResistencia $ autobot

velocidadVehiculo :: Autobot
velocidadVehiculo autobot = fst . velocidadResistencia $ autobot

resistenciaVehiculo :: Autobot
resistenciaVehiculo autobot = snd . velocidadResistencia $ autobot

--3.
transformar :: Autobot -> Autobot
transformar autobot = Vehiculo (nombreRobot autobot) ((valores autobot) (fuerzaVelocidadResistencia autobot))

--4.
velocidadContra :: Autobot -> Autobot -> Int
velocidadContra autobot1 autobot2 
    | fuerzaAutobot autobot1 - resistenciaAutobot autobot2 > 0 = velocidadAutobot autobot1 - (fuerzaAutobot autobot1 - resistenciaAutobot autobot2)
    | otherwise                                                = velocidadAutobot autobot1

--5.
elMasRapido :: Autobot -> Autobot -> Autobot
elMasRapido autobot1 autobot2 = mayorSegun velocidadContra autobot1 autobot2

mayorSegun :: (Autobot -> Autobot -> Int) -> Autobot -> Autobot -> Autobot
mayorSegun f autobot1 autobot2 
    | f autobot1 autobot2 > f autobot2 autobot1 = autobot1
    | otherwise                                 = autobot2

--6.
--a.
domina :: Autobot -> Autobot -> Autobot
domina autobot1 autobot2 |

--PREGUNTAR ESTE PARCIAL A FEDE