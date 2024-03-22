/* 2012 PARCIAL: COMPANIA FINANCIERA */
/*
Calcular el monto máximo de dinero a prestar a clientes
Si se trata de un EMPLEADO
    ->monto equivalente al valor total de sus biene registrados menos un % fijado por cada hijo, actualmete
    es 10%, puede cambiar
Si es una EMPRESA
    ->monto equivalente a el monto que le permita el organismo que le brinda garantía
        *Fondo de garantía: importe de referencia y el monto a prestar es el doble del mínimo entre
        el importe de referencia y el capital social de la empresa
        *Pool de empresas: presta un monto equivalente a la suma de los capitales sociales de la empresa que 
        lo conforman, cuyos capitales sean mayores al de la empresa que pide préstamo
La financiera da préstamos a organismos públicos
    ->presta como máximo un importe acordado con cada organismo al que se le descuenta un porcentaje
    de gastos administrativos que depende de dónde está ubicado el organismo
        *Nacional: 10%
        *Judicial: 20%
        *Ente autárquico: 5%
        *GCBA: 10%
        Puede que en el futuro estos porcentajes cambien o se agreguen otros criterios para ubicar 
        a un organismo público
Un cliente cuando pide un préstamos puede ser que tenga otros otorgados, por lo tanto se le resta el total de 
saldos pendientes de pago de todos los préstamos ya dados.
*/

//FINANCIERA
object financiera{
    var porcentajePorHijo = 10

    method montoMaximoAOtorgarA(unCliente){
        return unCliente.cantidadAPrestar(porcentajePorHijo) - self.cantidadSaldosPendientesDe(unCliente)
    }

    method otorgarPrestamoA(unCliente){
        const unPrestamo = new Prestamo(unDeudor = unCliente, cantidadPrestada = self.montoMaximoAOtorgarA(unCliente), fecha = new Date())
        prestamosOtorgados.add(unPrestamo)
    }

    method actualizarPorcentajePorHijo(unPorcentaje){
        porcentajePorHijo = unPorcentaje
    }

    method cantidadSaldosPendientesDe(unCliente){
        return self.saldosPendientesDe(unCliente).sum()
    }

    method saldosPendientesDe(unCliente){
        return self.prestamosPendientesDe(unCliente).map({ unPrestamo => unPrestamo.saldoPendiente() })
    }

    method prestamosPendientesDe(unCliente){
        return self.prestamosPedientes().filter({ unPrestamo => unPrestamo.esDe(unCliente) })
    }

    method prestamosPedientes(){
        return prestamosOtorgados.filter({ unPrestamo => unPrestamo.estaPendiente() })
    }

    method cobrarA(unCliente, unImporte){
        self.prestamoPendienteMasAntiguoDe(unCliente).pagar(unImporte)
    }

    method prestamoPendienteMasAntiguoDe(unCliente){
        return self.prestamosPendientesDe(unCliente).min({ unPrestamo => unPrestamo.fecha() })
        //No sé si esto funciona pero dejo una solución alternativa
        /*
        self.prestamosPendientesOrdenadosDe(unCliente).take(1)
        method prestamosPendientesOrdenadosDe(unCliente){
            return self.prestamosPendientesDe(unCliente).sortBy({ unP1, unP2 => unP1.fecha() < unP2.fecha() })
        }
        */
    }


}

//PRESTAMOS
class Prestamo{
    var unDeudor
    var cantidadPrestada
    var fecha
    var deudaPendiente = cantidadPrestada
    var property estaPendiente = true

    method esDe(unCliente){
        return unDeudor.equals(unCliente)
    }

    method saldoPendiente(){
        return deudaPendiente
    }

    method pagar(unaCantidad){
        self.validarEstado()
        deudaPendiente -= unaCantidad
    }

    method validarEstado(){
        if(deudaPendiente <= 0){
            estaPendiente = false
        }
    }
}

//CLIENTES
class Empleado{
    var valorDeBienes = [] //Lista de valor de cada bien
    var cantidadHijos

    method cantidadAPrestar(unPorcentajePorHijo){
        return valorDeBienes.sum() - cantidadHijos * unPorcentajePorHijo / 100
    }
}

class Empresa{
    var organismoQueBrindaGarantia
    var capital

    method cantidadAPrestar(unPorcentaje){
        return organismoQueBrindaGarantia.cantidadAPrestar(self)
    }

    method tieneCapitalSocialMayorA(unaCantidad){
        return capital > unaCantidad
    }

    method capitalSocial(){
        return capital
    }
}

class OrganismosPublicos{
    var montoAcordado
    var ubicacion

    method cantidadAPrestar(unPorcentaje){
        return montoAcordado - ubicacion.porcentajeGastosAdministrativos() / 100
    }
}

//UBICACION
class Ubicacion{
    var property porcentajeGastosAdministrativos
}

const poderEjecutivo = new Ubicacion(porcentajeGastosAdministrativos = 10)
const poderJudicial = new Ubicacion(porcentajeGastosAdministrativos = 20)
const enteAutartico = new Ubicacion(porcentajeGastosAdministrativos = 5)
const gcba = new Ubicacion(porcentajeGastosAdministrativos = 10)
/// ...


//ORGANISMOS QUE DAN GARANTIA
class Fondo{
    var importeDeReferencia

    method cantidadAPrestar(unEmpresa){
        return 2 * [unEmpresa.capitalSocial(), importeDeReferencia].min()
    }
}

class PoolDeEmpresas{
    var empresas

    method cantidadAPrestar(unEmpresa){
        return self.capitalesSocialesDelPool().filter({ unCapital => unEmpresa.tieneCapitalSocialMayorA(unCapital) }).sum()
    }

    method capitalesSocialesDelPool(){
        return empresas.map({ unaEmpresa => unaEmpresa.capitalSocial() })
    }
}


