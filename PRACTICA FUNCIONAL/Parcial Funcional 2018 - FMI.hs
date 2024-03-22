{-
De cada PAIS conocemos:
INGRESO PER CAPITA
POBLACION ACTIVA EN EL SECTOR PUBLICO
POBLACION ACTIVA EN EL SECTOR PRIVADO
LISTA DE RECURSOS NATURALES
DEUDA QUE MANTIENE CON EL FMI

-}
type RecetaFMI = Pais -> Pais

cambiarDeuda :: (Int -> Int) -> Pais -> Pais
cambiarDeuda f pais = pais{ deudaConFMI = f (deudaConFMI pais) }

sacarPorcentaje :: Int -> Int -> Int
sacarPorcentaje porcentaje numero = div (porcentaje * numero) 100

cambiarPuestosDeTrabajoSectorPublico :: (Int -> Int) -> Pais -> Pais 
cambiarPuestosDeTrabajoSectorPublico f pais = pais { poblacionActivaEnSectorPublico = f (poblacionActivaEnSectorPublico pais) }

cambiarIngresoPerCapita :: (Int -> Int) -> Pais -> Pais 
cambiarIngresoPerCapita f pais = pais { ingresoPerCapita = f (ingresoPerCapita pais) }

cambiarRecursosNaturales :: ([String]- > [String]) -> Pais -> Pais
cambiarRecursosNaturales f pais = pais { recursosNaturales = f (recursosNaturales pais) }

--1.
--a.
data Pais = Pais {
    ingresoPerCapita :: Int,
    poblacionActivaEnSectorPublico :: Int,
    poblacionActivaEnSectorPrivado :: Int,
    recursosNaturales :: [RecursosNaturales],
    deudaConFMI :: Int
}deriving (Show)

data RecursosNaturales = Mineria | Petroleo | Ecoturimo | IndustriaPesada
--b.
namibia :: Pais
namibia = Pais 4140 400000 650000 [Mineria, Ecoturimo] 50000000

--2.
--RECETAS DEL FMI

prestarDolares :: Int -> RecetaFMI
prestarDolares nMillones pais = cambiarDeuda (+ (sacarPorcentaje 150 nMillones)) pais 

reducirPuestosDeTrabajoSectorPublico :: Int -> RecetaFMI
reducirPuestosDeTrabajoSectorPublico cantidadAReducir pais
| poblacionActivaEnSectorPublico pais > 100 = (cambiarIngresoPerCapita (- sacarPorcentaje 20 (ingresoPerCapita pais))). (cambiarPuestosDeTrabajoSectorPublico (- cantidadAReducir)) $ pais
| otherwise                                 = (cambiarIngresoPerCapita (- sacarPorcentaje 15 (ingresoPerCapita pais))). (cambiarPuestosDeTrabajoSectorPublico (- cantidadAReducir)) $ pais

empresaAfinFMI :: String -> RecetaFMI
empresaAfinFMI recursoNatural pais = cambiarRecursosNaturales (filter (recursoNatural =/)) . cambiarDeuda (- 2000000) $ pais

establecerBlindaje :: RecetaFMI
establecerBlindaje pais = (cambiarPuestosDeTrabajoSectorPublico (- 500)). cambiarDeuda (+ div (calcularPBI pais) 2) $ pais

calcularPBI :: Pais -> Int
calcularPBI pais = ingresoPerCapita pais * (poblacionActivaEnSectorPrivado pais + poblacionActivaEnSectorPublico pais)

--3.
--a.
recetaMisteriosa :: Pais -> Pais
recetaMisteriosa pais = (empresaAfinFMI Mineria).(prestarDolares 200000000) $ pais

--4.
--a.
sePuedeZafar :: [Pais] -> [Pais]
sePuedeZafar paises = filter ((== Petroleo).recursosNaturales) paises --Composicion, Orden Superior y Ap Parcial

--b.
deudaAFavorFMI :: [Pais] -> Int
deudaAFavorFMI paises = sum. (map deudaConFMI) $ paises --Composicion, Orden Superior y Ap Parcial 

--c.
{-
    En "sePuedeZafar" aparecen los 3 conceptos, aplico ap parcial en (==Petroleo), luego composición en la condición
    para filter la cual, a su vez, es una función de orden superior.
    En "deudaAFavorFMI" aparecen los 3 conceptos una vez más, (map deudaFMI) es una composición parcial,
    a su vez en sum y map aplico composición y ambas son funciones de orden superior.

-}
--5.
estaOrdenada :: Pais -> [RecetaFMI] ->  Bool
estaOrdenada pais _ condicion = pais
estaOrdenada pais (receta1 : receta2 : recetas) condicion = calcularPBI.receta1 pais < calcularPBI.receta2 pais &&  estaOrdenada pais (receta2: recetas) 

--6.
{-
Si un país tiene infinitos recursos naturales, modelado con esta función
recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos
a. ¿qué sucede evaluamos la función 4a con ese país?
    No se puede evaluar la función 4a con este país, ya que esa función evalua una lista de países.
    En caso de que el país sea declarado [PaisConInfRecursosNaturales], la función se quedará evaluando 
    infinitamente la lista de recursos naturales por ende nunca devolverá una lista.

b. ¿y con la 4b?
    No se puede evaluar la función 4a con este país, ya que esa función evalua una lista de países.
    En caso de que el país sea declarado [PaisConInfRecursosNaturales], no díra el total de deuda a favor.
-}
