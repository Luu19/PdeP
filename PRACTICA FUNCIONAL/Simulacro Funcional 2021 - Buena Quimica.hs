{-
De los PRODUCTOs conocemos:
    DESCRIPCION TECNICA 
    INDICE DE PELIGROSIDAD
    COMPONENTES

-}
data Producto = Producto {
    descripcion :: String,
    peligrosidad :: Int,
    componentes :: [String]
} deriving (Show)

--1.
tienenBuenaQuimica :: Producto -> Producto -> Bool
tienenBuenaQuimica producto1  producto2 = (tienenMismosComponentes (componentes producto1)  (componentes producto2) ) && (descripcionIncluida (descripcion producto1) (descripcion producto2))

descripcionIncluida :: String -> String -> Bool
descripcionIncluida descripcion1 descripcion2 = (any esIgual descripcion2  $ words descripcion1) || (any esIgual descripcion1  $ words descripcion2)

tienenMismosComponentes :: [String] -> [String] -> Bool
tienenMismosComponentes (componente1 : componentes) componentesLista2 =  (tienenMismosComponentes componentes componentesLista2) && (elem componente1 componentesLista2)

esIgual :: String -> String -> Bool
esIgual descripcion = ((== descripcion) . take (length descripcion))

--
type Sensor = Producto -> Bool

type ProductosProhibidos = [String]

contieneElProducto :: String -> [String] -> Bool
contieneElProducto elemento lista = elem elemento lista

productoIlegal :: Sensor --Si es TRUE es Ilegal, sino no
sensorProductoIlegal producto = contieneElProducto (descripcion producto) ProductosProhibidos

detectaPetroleo :: Sensor --Si es TRUE tiene petroleo sino no
sensorDetectaPetroleo producto = contieneElProducto "petroleo" (componentes producto)

esPeligro :: Int -> Sensor --Si es True es peligroso 
sensorPeligrosidad indice producto = indice >= (peligrosidad producto) 

contieneFuncionol :: Sensor --Si es True contiene
contieneFuncionol producto = contieneElProducto "funcionol" (componentes producto)

dispositivoDeControlDeCalidad :: [Sensor]
dispositivoDeControlDeCalidad = [productoIlegal, detectaPetroleo, contieneFuncionol] ++ (map esPeligro [5, 50])
--Parte 2
--1.
habilitaProducto :: [Sensor] -> Producto -> Bool
habilitaProducto dispositivo producto = cuantos not dispositivo producto > cuantos id dispositivo producto

cuantos :: (a -> a) -> [Sensor] -> Producto -> Int
cuantos f           []         producto = 0       
cuantos f (sensor1 : sensores) producto 
    | f.sensor1 $ producto              = 1 + cuantos f sensores producto
    | otherwise                         = cuantos f sensores producto

--2.
--Agregar nuevos sensores :
agregaSensor :: [Sensor] -> Sensor -> [Sensor]
agregaSensor dispositivo sensor = sensor ++ dispositivo

--a.
habilitaTodo :: Sensor
habilitaTodo _ = True

--b.
-- ??

--c.
multiple :: [Sensor] -> Sensor
multiple sensores producto = any (noPasaSensor producto) sensores

noPasaSensor :: Producto -> Sensor -> Bool
noPasaSensor producto sensor = not.sensor $ producto

--d.
esPeligro :: Int -> Sensor --Si es True es peligroso 
sensorPeligrosidad indice producto = indice >= (peligrosidad producto) 

--3.
productosRechazados :: [Sensor] -> [Producto] -> [Producto]
productosRechazados dispositivo productos = filter not.(habilitaProducto dispositivo) productos

--Parte 3
--1.
invertir :: (Sensor) -> (Sensor)
invertir sensor = not . sensor 

-- Sí, si un producto tiene inf. componentes puede ser habilitado. Todos los sensores podrían analizarlo.
