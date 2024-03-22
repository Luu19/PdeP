/* PARCIAL 2017: INMOBILIARIA */
/*
Las OPERACIONES pueden ser:
    ->Alquileres: se conoce la cantidad de meses de alquiler, comision que corresponde 
    al agente (cantidad de meses de alquiler * valor de inmueble / 50000)
    ->Venta: porcentaje de valor sobre el inmueble (comision)
De todos los INMUEBLES se conoce el tamaño en metros cuadrados, cantidad de ambientes y operacion 
(venta alquiler)
El valor del inmueble depende de que:
    ->si es una casa, valor particular
    ->PH valor = 14000 * metro cuadrado con un minimo de 500000
    ->los deptos es 350000 * ambiente
El PRECIO de todas las propiedades se afecta depende la ZONA donde esten, esos valores cambian

Un CLIENTE puede solicitar a un empleado realizar una reserva sobre una propiedad
o concretar la operacion publicada:
    ->si una propiedad esta reservada no se concreta la operacion de otro cliente que no sea el que
    reservo
*/

// PUNTO 1
class Empleado{
    var reservas
    var operacionesCerradas

    method reservarPropiedadPara(unaOperacion, unCliente){
        unaOperacion.hacerReservaPara(unCliente)
        reservas.add(nuevaReserva)
    }

    method cerrarOperacion(unaOperacion, unCliente){
        unaOperacion.cerrarPara(unCliente)
        operacionesCerradas.add(unaOperacion)
    }

    method comisionDeOperacion(unaOperacion){
        return unaOperacion.comision()
    }

    method totalComisionesPorOperacionesCerradas(){
        return operacionesCerradas.sum({ unaOperacion => unaOperacion.comision() })
    }

    method totalOperacionesCerradas(){
        return operacionesCerradas.size()
    }

    method totalReservas(){
        return reservas.size()
    }

    //3
    method vaATenerProblemasCon(otroEmpleado){
        return self.cerroOperacionesEnLaMismaZonaQue(otroEmpleado) && self.cerroOperacionQueReserve(otroEmpleado)
    }

    method cerroOperacionesEnLaMismaZonaQue(unEmpleado){
        return self.zonasDondeCerroOperacion().any({ unaZona => unEmpleado.cerroOperacionEn(unaZona) })
    }

    method cerroOperacionEn(unaZona){
        return self.zonasDondeCerroOperacion().contains(unaZona)
    }

    method zonasDondeCerroOperacion(){
        return operacionesCerradas.map({ unaOperacion => unaOperacion.zonaInmueble() })
    }

    method cerroOperacionQueReserve(otroEmpleado){
        return reservas.any({ unaReserva => otroEmpleado.cerroOperacion(unaReserva) })
    }

    method cerroOperacion(unaOperacion){
        return operacionesCerradas.contains(unaOperacion)
    }
}

//4
class Estado{
    method reservarPara(unaOperacion, unCliente)
}

object disponible inherits Estado{
    override method reservarPara(unaOperacion, unCliente){
        unaOperacion.reservate()
    }

    method cerrarPara(unaOperacion, unCliente){
        throw new Exception(message = "hay que reservar primero")
    }
}

class Reservada inherits Estado{
    var clienteQueReservo

    override method reservarPara(unaOperacion, unCliente){
        throw new Exception(message = "Ya esta reservada")
    }

    method cerrarPara(unaOperacion, unCliente){
        self.validarCierre(unCliente)
        unaOperacion.cerrate()
    }

    method validarCierre(unCliente){
        if(!unCliente == clienteQueReservo){
            unaOperacion.cerrate()
        }
    }
}

object cerrada{
    method cerrarPara(unaOperacion, unCliente){
        throw new Exception(message = "Ya esta cerrada")
    }

    override method reservarPara(unCliente){
        throw new Exception(message = "Ya esta cerrada")
    }
}

// OPERACIONES
class Operacion{
    var unInmueble
    var property estado 

    method comision()

    method hacerReservaPara(unCliente){
        estado.reservarPara(self, unCliente)
    }

    method reservate(){
        estado = reservada
    }

    method cerrate(){
        estado = cerrada
    }

    method cerrarOperacionPara(unCliente){
        estado.cerrarPara(self, unCliente)
    }

    method zonaInmueble(){
        return inmueble.zonaDondeEstaUbicada()
    }
}

class Alquiler inherits Operacion{
    var cantidadMesesDeAlquiler

    override method comision(){
        return cantidadMesesDeAlquiler * unInmueble.valorInmueble() / 50000
    }
}

class Venta inherits Operacion{

    override method comision(){
        return unInmueble.valorInmueble() * ( inmobiliaria.porcentajePorVenta() /100 )
    }
}

// INMUEBLES
class Inmueble{
    var zonaDondeEstaUbicada
    var metrosCuadrados
    var cantidadAmbientes
    
    method valorInmueble(){
        return zonaDondeEstaUbicada.plus()
    }
}

class Casa inherits Inmueble{
    var precioParticular

    override method valorInmueble(){
        return super() + precioParticular
    }
}

class Local inherits Casa{
    var tipo

    override method valorInmueble(){
        return tipo.valor(super())
    }
}

object galpon{
    method valor(unValor){
        return unValor / 2
    }
}

class ALaCalle{
    var property valor

    method valor(unValor){
        return valor
    }
}

class PH inherits Inmueble{
    override method valorInmueble(){
        return (super() + metrosCuadrados * 14000).min(500000)
    }
}

class Departamento inherits Inmueble{
    override method valorInmueble(){
        return super() + cantidadAmbientes * 350000
    }
}



// ZONA
class Zona{
    var property plus
}

// PUNTO 2
object inmobiliaria{
    var empleados
    var porcentajePorVenta

    method mejorEmpleadoSegun(criterio){
        return empleados.max(criterio)
    }
}

const totalComisiones = { unEmpleado => unEmpleado.totalComisionesPorOperacionesCerradas() }
const cantidadOperacionesCerradas = { unEmpleado => unEmpleado.totalOperacionesCerradas() }
const cantidadRerservas = { unEmpleado => unEmpleado.totalReservas() }