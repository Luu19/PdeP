{-
De los CHOFERes se conoce:
NOMBRE
KILOMETRAJE DEL AUTO
VIAJES QUE TOMÓ
CONDICION PARA TOMAR UN VIAJE

De los clientes queremos saber:
NOMBRE 
DÓNDE VIVE

De los VIAJEs se sabe:
FECHA 
CLIENTE 
COSTO

CONDICION PARA TOMAR VIAJE
--> Algunos choferes no tienen codición
--> Viajes de más de $200
--> El nombre del cliente tiene más de n letras
--> El cliente no viva en X zona 

-}

--1.
type CondicionDeViaje = Viaje -> Bool
data Chofer = Chofer {
    nombre :: String,
    kilometrajeDelAuto :: Int,
    viajesQueTomo :: [Viajes],
    condicionParaTomarViaje :: CondicionDeViaje
}deriving (Show)

type DondeVive= String
type Cliente = (String, DondeVive)


data Viaje = Viaje {
    fecha :: String,
    cliente :: Cliente,
    costo :: Int
}deriving (Show)

--2.
noCondicion :: CondicionDeViaje
noCondicion = (const False)

viajeMayorA200 :: CondicionDeViaje
viajeMayorA200 viaje = (>200).costo $ viaje

dependeNombreCliente :: Int -> CondicionDeViaje
dependeNombreCliente largoNombrePedido viaje = (> largoNombrePedido).fst.cliente $ viaje

noVivaEn :: String -> CondicionDeViaje
noVivaEn lugar viaje = (/= lugar).snd.cliente $ viaje

--3.
lucas = ("Lucas", "Victoria") --a.
daniel = Chofer "Daniel" 23500 [viajeLucas] (noVivaEn "Olivos") --b.
viajeLucas = Viaje "20/04/2017" lucas 150
alejandra = Chofer "Alejandra" 180000 [] noCondicion --c.

--4.
puedeTomarViaje :: Chofer -> Viaje -> Bool
puedeTomarViaje chofer viajeATomar = (condicionParaTomarViaje chofer) viajeATomar

--5.
liquidacionDeChofer :: Chofer -> Int
liquidacionDeChofer chofer = sum . map costo $ (viajesQueTomo chofer)

--6.
--a.
filtraChoferes :: Viaje -> [Chofer] -> [Chofer]
filtraChoferes viaje choferes = filter (flip puedeTomarViaje viaje) choferes

--b.
menosViajeTiene :: [Chofer] -> Chofer
menosViajeTiene viaje choferes 
| length (quienesTienenMenosViajes choferes) == 1 = head (quienesTienenMenosViajes choferes)
| otherwise                                       = head (quienesTienenMenosViajes choferes)

quienesTienenMenosViajes :: [Chofer] -> [Chofer]
quienesTienenMenosViajes    []               = []
quienesTienenMenosViajes (chofer : choferes) 
| any (> length (viajesQueTomo chofer)) (map (length.viajesQueTomo) choferes )  = [chofer]
| otherwise                                                                     = chofer : menosViajeTiene choferes 

--c.
tomaViaje :: Viaje -> [Chofer] -> Chofer 
tomaViaje viaje choferes = (agregaViaje viaje).menosViajeTiene. filtraChoferes viaje $ choferes

agregaViaje :: Viaje -> Chofer -> Chofer 
agregarViaje viaje chofer = modificaViajes (viaje :) chofer

modificaViajes :: ([Viaje] -> [Viaje]) -> Chofer -> Chofer
modificaViajes f chofer = chofer { viajesQueTomo = f (viajesQueTomo chofer)}

--7.
--a.
nitoInfy = Chofer "Nito Indy" 70000 viajeLucasInf (dependeNombreCliente 3)

viajeLucasInf :: [Viaje]
viajeLucas = repetirViaje (Viaje "11/03/2017" lucas 50) 

--b.
{- 
No se puede calcular la liquidación del chofer ya que nunca terminaríamos
de mapear la infinita lista de viajes que tiene con Lucas, por ende nunca se llega
a sumar el monto y si así fuera, este no terminaría nunca de realizar la suma ya que
nunca termina la lista.
-}  

--c.
{-
Sí, podemos saber esto ya que no involucra los viajes realizados, por ende se ejecuta sin
problemas.
-}

--8.
gongNeng :: Ord c => c -> (b -> Bool) -> [a] -> c
gongNeng arg1 arg2 arg3 =max arg1 . head . filter arg2 . map arg3