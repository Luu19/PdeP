import Text.Show.Functions
{-
NOP --> No operation, el programa sigue en la próxima instrucción.
ADD --> Suma los valores de los dos acumuladores, el resultado queda en el
        acumulador A, el acumulador B debe quedar en 0
DIV --> Divide el valor del acumulador A por el valor del acumulador B, el
        resultado queda en el acumulador A, el acumulador B debe quedar
        en 0
SWAP --> Intercambia los valores de los acumuladores (el del A va al B y
        viceversa)
LOD addr --> Carga el acumulador A con el contenido de la memoria de datos
        en la posición addr
STR addr val --> Guarda el valor val en la posición addr de la memoria de datos
LODV val --> Carga en el acumulador A el valor val
-}
--3.1
--1.
type Instruccion = Microprocesador -> Microprocesador

--type PC = (a -> b) -> Int

data Microprocesador = Microprocesador{
    memoriaDatos :: [Int],
    acumuladorA :: Int,
    acumuladorB :: Int,
    programCounter :: Int, --se incrementa cada vez que se ejecuta una función --EN REVISIÓN jeje
    etiqueta :: String, --etiqueta con mensaje del último error producido 
    programas :: [Instruccion]
} deriving (Show)

mapAcumuladorA :: (Int -> Int) -> Microprocesador -> Microprocesador
mapAcumuladorA f micro = micro { acumuladorA = f (acumuladorA micro) }

mapAcumuladorB :: (Int -> Int) -> Microprocesador -> Microprocesador
mapAcumuladorB f micro = micro { acumuladorB = f (acumuladorB micro) }

setAcumuladorB :: Int -> Microprocesador -> Microprocesador
setAcumuladorB numero micro = mapAcumuladorB (const numero) micro

setAcumuladorA :: Int -> Microprocesador -> Microprocesador
setAcumuladorA numero micro = mapAcumuladorA (const numero) micro

--a.
xt8088 = Microprocesador  [] 3 7 0 [] division2por0

--3.2
--1.
nop:: Instruccion
nop micro = id micro

--FUNCIONES USADAS
incrementaProgram micro = micro{ programCounter = programCounter micro + 1}

--2.


--3.3
--1. Modelar las instrucciones LODV, SWAP y ADD.
add :: Instruccion
add micro = mapAcumuladorA (acumuladorB micro +).setAcumuladorB 0 $ micro 

lodv :: Int -> Instruccion
lodv valor micro = setAcumuladorA valor micro

swap :: Instruccion 
swap micro = setAcumuladorA (acumuladorB micro).setAcumuladorB (acumuladorA micro) $ micro

--3.4
--1. Modelar la instrucción DIV, STR y LOD.
divide :: Instruccion
divide micro | acumuladorB micro == 0 = micro { etiqueta = "DIVISION BY ZERO"}
             | otherwise              = mapAcumuladorA (flip div (acumuladorB micro)).setAcumuladorB 0 $ micro

str:: Int -> Int -> Instruccion
str addr val micro = micro { memoriaDatos = agregarValor val addr (memoriaDatos micro) }

--FUNCIONES USADAS
agregarValor valor indice lista = take (indice - 1) lista ++ valor : drop indice lista

lod:: Int -> Instruccion
lod posicion micro = setAcumuladorA ((memoriaDatos micro) !! (posicion - 1)) micro

--PUNTO 5 --> Cambios al dominio
--7.1
--Carga de Programas
cargaDePrograma :: [Instruccion] -> Microprocesador -> Microprocesador
cargaDePrograma programa micro = mapProgramas (programa ++) micro 

mapProgramas :: ([Instruccion] -> [Instruccion]) -> Microprocesador -> Microprocesador
mapProgramas funcion micro = micro { programas = funcion (programas micro)}

--Instrucciones/ Programas
suma10y22 :: [Instruccion]
suma10y22 = [add, lodv 22, swap, lodv 10]

division2por0 :: [Instruccion]
division2por0 = [divide, lod 1, swap, lod 2, str 2 0, str 1 2]

--7.2
ejecutarProgramas :: Microprocesador -> Microprocesador
ejecutarProgramas micro = foldr ejecutarInstruccion micro (programas micro)

ejecutarInstruccion :: Instruccion -> Microprocesador -> Microprocesador
ejecutarInstruccion instruccion elMicro  | length (etiqueta elMicro) > 0 = elMicro 
                                         |         otherwise             = instruccion . incrementaProgram $ elMicro

--7.3
fp20 = Microprocesador [] 7 24 0 [] []
--Ya va a salir :D
ifnz :: [Instruccion] -> Instruccion
ifnz programa micro | acumuladorA micro == 0 = ejecutarProgramas.cargaDePrograma programa $ micro 
                    | otherwise              = micro

--7.4
depurarProgramas :: Microprocesador -> [Instruccion] -> [Instruccion]
depurarProgramas  _                []               = []
depurarProgramas micro      (programa1 : programas)
| saberSiTieneAlgun0.programa1 micro && (any (==0).memoriaDatos).programa1 micro =  depurarProgramas programas micro
| otherwise                                                                      = programa1 : depurarProgramas programas micro

saberSiTieneAlgun0 :: Microprocesador -> Bool
saberSiTieneAlgun0 micro = acumuladorA micro == 0 && acumuladorB micro == 0 
