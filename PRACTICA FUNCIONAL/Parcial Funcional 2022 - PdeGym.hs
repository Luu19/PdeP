{-
De las PERSONAs se conoce :
    NOMBRE
    CANTIDAD DE CALORIAS
    INDICE DE HIDRATACION -> va de 0 a 100
    CANTIDAD DE TIEMPO DISPONIBLE PARA ENTRENAR 
    CONJ DE EQUIPAMIENTOS
-}

type Ejercicio = Int -> Persona -> Persona

data Persona = Persona {
    nombre :: String,
    cantidadCalorias :: Int,
    indiceDeHidratacion :: Int,
    tiempoDisponible :: Int,
    equipamientos :: [String]
} deriving (Show)

modificaNombre :: (String -> String) -> Persona -> Persona
modificaNombre funcion persona = persona { nombre = funcion (nombre persona) }

modificaCalorias :: (Int -> Int) -> Persona -> Persona
modificaCalorias funcion persona = persona { cantidadCalorias = funcion (cantidadCalorias persona) }

pierdeCalorias :: Int -> Persona -> Persona
pierdeCalorias pierde persona = modificaCalorias (- pierde) persona

modificaIndice :: (Int -> Int) -> Persona -> Persona
modificaIndice funcion persona = persona { indiceDeHidratacion =  funcion (indiceDeHidratacion persona) }

modificarEquipamiento :: ([String] -> [String]) -> Persona -> Persona
modificarEquipamiento funcion persona = persona { equipamientos = funcion (equipamientos persona) }

pierdeHidratacion :: Int -> Persona -> Persona
pierdeHidratacion pierde persona = modificaIndice (- pierde) persona

pierdeCada :: Int -> Int -> Persona -> Persona
pierdeCada repe calorias persona = pierdeCalorias (repe * calorias) persona 

--PARTE A :
--1.
abdominales :: Ejercicio
abdominales repes persona = pierdeCada repes 8 persona

--2.
flexiones :: Ejercicio
flexiones repes persona = pierdeHidratacion (2 * (div repes 10)) . pierdeCada repes 16 $ persona

--3.
levantarPesas :: Int -> Ejercicio
levantarPesas peso repes persona = pierdeHidratacion (peso * (div repes 10)) . pierdeCada repes 32 $ persona

--4.
laGranHomeroSimpson :: Ejercicio
laGranHomeroSimpson _ persona = persona

--Otras acciones :
--1.
renovarEquipo :: Persona -> Persona
renovarEquipo persona = modificarEquipamiento (map ("Nuevo" ++)) persona

--2.
volverseYoguista :: Persona -> Persona
volverseYoguista persona = modificarEquipamiento (const ["Colchoneta"]) . modificaIndice (multiplicaHidratacion 2) . pierdeCalorias ( div (cantidadCalorias persona) 2 ) $ persona

multiplicaHidratacion :: Int -> Int -> Int
multiplicaHidratacion numero indice 
    | indice * numero > 100 = 100
    | otherwise             = indice * numero

--3.
volverseBodyBuilder :: Persona -> Persona
volverseBodyBuilder persona = modificaNombre (++ " BB") . modificaCalorias (* 3) . modificaIndice (multiplicaHidratacion 3) . soloEquipaPesas $ persona

--4.
comerUnSandwich :: Persona -> Persona
comerUnSandwich persona = modificaIndice (const 100) . modificaCalorias (+ 500) $ persona

--PARTE B :
type Duracion = Int
type Rutina   = (Duracion, [Ejercicio]) 

puedeHacerRutina :: Rutina -> Persona -> Bool
puedeHacerRutina (duracion, _ ) persona = duracion < (tiempoDisponible persona)

--1.
esPeligrosa :: Rutina -> Persona -> Bool
esPeligrosa rutina persona = condicionesDePeligro . hacerRutina rutina $ persona

hacerRutina :: Rutina -> Persona -> Persona
hacerRutina rutina persona = foldr ($) persona rutina

condicionesDePeligro :: Persona -> Bool
condicionesDePeligro persona = cantidadCalorias persona < 50 && indiceDeHidratacion persona < 10

--2.
esBalanceada :: Rutina -> Persona -> Persona
esBalanceada rutina persona = condicionesDeBalance caloriasAntes . hacerRutina rutina $ persona
    where caloriasAntes = cantidadCalorias persona

condicionesDeBalance :: Int -> Persona -> Bool
condicionesDeBalance caloriasAntes persona = indiceDeHidratacion persona > 80 && (div caloriasAntes 2) > cantidadCalorias persona

-- *
elAbdominableAbdominal :: Rutina
elAbdominableAbdominal = (60, abdominalesInfinitos)

abdominalesInfinitos :: [Ejercicio]
abdominalesInfinitos = map abdominales (enumFrom 1)

--PARTE C :
--1.
seleccionarGrupoDeEjercicio :: Persona -> [Persona] -> [Persona]
seleccionarGrupoDeEjercicio persona personas = filter (tienenMismoTiempo persona) personas

tienenMismoTiempo :: Persona -> Persona -> Bool
tienenMismoTiempo persona1 persona2 = tiempoDisponible persona1 == tiempoDisponible persona2

--2.
promedioRutina :: Rutina -> [Persona] -> (Float, Float)
promedioRutina rutina personas =  (hacerPromedioDe cantidadCalorias rutina personas , hacerPromedioDe indiceDeHidratacion rutina personas)

hacerPromedioDe :: (Persona -> Int) -> Rutina -> [Persona] -> Float
hacerPromedioDe funcion rutina personas = (flip div (length personas) ) . sum . map funcion . map (hacerRutina rutina) $ personas
