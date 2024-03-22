--1.
--i.
data Cuenta = Cuenta {
    identificador :: String,
    saldo :: Int
} deriving (Show)

type Transaccion = Cuenta -> Cuenta

type Bloque = (String, Transaccion)
type BlockChain = [Bloque]

--ii.

modificarSaldo :: (Int -> Int) -> Cuenta -> Cuenta
modificarSaldo f cuenta = cuenta { saldo = f $ saldo cuenta } 

aumentarSaldo :: Int -> Cuenta -> Cuenta
aumentarSaldo aumento cuenta = modificarSaldo (+ aumento) cuenta

--a. Transacciones de Pago
pago :: Int -> Transaccion
pago montoAPagar cuenta = modificarSaldo (- montoAPagar) cuenta

--b. Transaccion de Cobro
cobrar :: Int -> Transaccion
cobrar montoACobrar cuenta = aumentarSaldo montoACobrar cuenta

--c. Transaccion de Mineria
mineria :: Transaccion
mineria cuenta = aumentarSaldo 25 cuenta

--2.
--i.

correspondeIDCuenta :: String -> Cuenta -> Bool
correspondeIDCuenta id cuenta = id == (identificador cuenta)

--ii.
primeraQueCumple :: (Cuenta -> Bool) -> [Cuenta] -> Cuenta
primeraQueCumple condicion listaCuentas =  head . filter condicion $ listaCuentas
    
--iii.
todasMenosLaPrimera :: (Cuenta -> Bool) -> [Cuenta] -> [Cuenta]
todasMenosLaPrimera condicion listaCuentas = filter (/= primera) $ listaCuentas
    where primera = primeraQueCumple condicion listaCuentas

--3.
modificarPorId :: String -> (Transaccion) -> [Cuenta] -> [Cuenta]
modificarPorId id transaccion listaCuentas = (transaccion . primeraQueCumple (correspondeIDCuenta id) $ listaCuentas) : todasMenosLaPrimera (correspondeIDCuenta id) listaCuentas

--4.
ejecutaTransacciones :: [Cuenta] -> Bloque -> [Cuenta]
ejecutaTransacciones listaCuentas (id, transaccion) = modificarPorId id transaccion listaCuentas

--5.
cuentaEstable :: [Cuenta] -> Bool
cuentaEstable listaCuentas = all ((>=0).saldo) listaCuentas

--6.
chequeoDeBlockchain :: BlockChain -> [Cuenta] -> Bool
chequeoDeBlockchain blockchain listaCuentas = (>0).length.(ejecutaBlockChain blockchain) $ listaCuentas

ejecutaBlockChain :: BlockChain -> [Cuenta] -> [Cuenta]
ejecutaBlockChain (bloque1 : bloques) listaCuentas 
    |               _           []                                 = []
    |               []          _                                  = []
    |  cuentaEstable . ejecutaTransacciones listaCuentas $ bloque1 = (ejecutaTransacciones listaCuentas bloque1) : ejecutaBlockChain bloques listaCuentas 
    |               otherwise                                      = ejecutaBlockChain bloques listaCuentas 
