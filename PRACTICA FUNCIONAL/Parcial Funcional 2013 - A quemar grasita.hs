{-
Calcular el efecto que producen las rutinas de ejercicio en sus socios con las maquinas.

De cada Persona nos interesa :
    EDAD 
    PESO 
    COEF DE TONIFICACION

-}

data Persona = Persona {
    edad :: Int,
    peso :: Int,
    coefDeTonificacion :: Int
} deriving (Show)

type Maquina = [Ejercicio]
type Ejercicio = Persona -> Int -> Persona 

reducePeso :: Int -> Persona -> Persona
reducePeso reduce persona = modificaPeso (- reduce) persona

modificaPeso :: (Int -> Int) -> Persona -> Persona
modificaPeso funcion persona = persona { peso = funcion (peso persona) }

aumentaCoeficiente :: Int -> Persona -> Persona
aumentaCoeficiente aumento persona = modificaCoeficiente (+ aumento) persona

modificaCoeficiente :: (Int -> Int) -> Persona -> Persona
modificaCoeficiente funcion persona = persona { coefDeTonificacion = funcion (coefDeTonificacion persona) }

--1.
estaObeso :: Persona -> Bool
estaObeso persona = peso persona > 100

saludable :: Persona -> Bool
saludable persona = not . estaObeso persona && coefDeTonificacion persona > 5

--2.
bajaDePeso :: Persona -> Int -> Persona
bajaDePeso persona calorias 
    | estaObeso persona                     = reducePeso (div calorias 150) persona
    | edad persona > 30 && calorias > 200   = reducePeso        1           persona
    |          otherwise                    = reducePeso (div calorias (peso persona * edad persona)) persona

--3.
--a.
cinta :: Int -> Ejercicio
cinta velocidad persona tiempo = bajaDePeso persona (1 * velocidad * tiempo )

--i.
caminata :: Int -> Ejercicio
caminata velocidad persona tiempo = cinta velocidad persona tiempo

--ii.
entrenamientoEnCinta :: Ejercicio
entrenamientoEnCinta persona tiempo = cinta (velocidad tiempo) persona tiempo
    where velocidad tiempo = 6 + (div tiempo 5)

--b.
pesas :: Int -> Ejercicio
pesas kilos persona tiempo 
    | tiempo > 10 = aumentaCoeficiente (div kilos 10) persona
    | otherwise   = persona

--c.
colina :: Int -> Ejercicio
colina inclinacion persona tiempo = bajaDePeso persona (2 * tiempo * inclinacion)

--d.
montania :: Int -> Ejercicio
montania inclinacionPrimeraColina persona tiempo = aumentaCoeficiente 1 . flip (colina (inclinacionPrimeraColina + 3)) (tiempo / 2) . flip (colina inclinacionPrimeraColina) (tiempo / 2)  $ persona 

--4.
--a.
type Rutina = (String , Int , [Ejercicio])

fst3 ( x, _, _) = x
snd3 ( _, x, _) = x
thr3 ( _, _, x) = x


haceRutina :: Rutina -> Persona -> Persona
haceRutina rutina persona = foldr (haceEjercicio tiempoEjercicio) persona (snd3 rutina)
    where tiempoEjercicio rutina = (flip div (length . thr3 $ rutina) ) . snd3 $ rutina

haceEjercicio :: Int -> Ejercicio -> Persona ->Persona
haceEjercicio tiempo ejercicio persona = ejercicio persona tiempo

--b.
resumenRutina :: Rutina -> Persona -> (String, Int, Int)
resumenRutina rutina persona = (fst3 rutina , deltaSegun peso persona . haceRutina rutina  $ persona , deltaSegun coefDeTonificacion persona . haceRutina rutina $ persona) 

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f aAntes aDespues = abs (f aAntes - f aDespues)

--5.
rutinasParaEstarSaludable :: [Rutina] -> Persona -> [(String, Int, Int)]
rutinasParaEstarSaludable rutinas persona = map (flip resumenRutina persona) . filter (estaSaludable persona) $ rutinas

estaSaludable :: Persona -> Rutina -> Bool
estaSaludable persona rutina = saludable . haceRutina rutina $ persona
