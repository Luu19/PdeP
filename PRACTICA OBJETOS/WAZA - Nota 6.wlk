/* 2022 PARCIAL : WAZA */
/*
De los USUARIOS se conoce
	->nombre
	->dni
	->dinero en cuenta
	->vehiculo asociado
	->registro de infracciones

De las INFRACCIONES se conoce
	->costo 
	->si estan o no pagadas, la multa puede ser pagada si el usuario
	tiene o no el dinero, en caso contrario no se paga

De los VEHICULOS se sabe que
	->consumen combustible 
	->capacidad maxima del tanque
	->cantidad de combustible
	->velocidad promedio
	->todos los vehiculos consumen 2l de combustible al recorrer una determinada
	distancia
		*Camionetas: no ecológicas, pierde 4l base y 5l de combustible 
		adicional por cada kilometro
		*Deportivo: ecologicos si velocidad promedio < 120km,
		sin importan la distancia que recorran pierden 0.2l adicionales
		*Familiares: ecologicos, no tienen perdida adicional

Para la CARGA
	->el combustible tiene costo de 160 x litro
	->el usuario debe tener plata para pagar la carga, caso contrario
	no se carga
	->no se puede superar la capacidad del tanque del vehiculo

De la ZONA se conoce
	->velocidad máxima
	->usuarios que transitan por ella
	->controles
Se pide activar controles de una zona, esto genera las multas para cada
usuario de la zona
Los controles pueden ser
	*De velocidad: si la velocidad promedio del vehiculo > velocidad permitida,
	multa de 3000
	*Ecologicos: si el auto no es ecologico, multa de 1500
	*Regulatorios: los usuarios con dni par pueden moverse los dias pares del mes y
	los usuarios con dni impar pueden moverse los dias impares del mes, 
	si no se cumple, multa de 2000

De la APP se conoce
	->usuarios que posee 
	->zonas 
La app debe 
	->decirle a los usuarios que paguen las multas
	->obtener zona + transitada
	->conocer usuarios complicados
*/
//OBJETOS UTILES
object dia{
	method esDiaPar(){
		return new Date().day().even()
	}
}

object combustible{
	method costoPorLitro(){
		return 160
	}

	method costoDeCarga(unaCantidad){
		return self.costoPorLitro() * unaCantidad
	}

}

//USUARIOS
class Usuario{
	var nombre
	var dni
	var dineroDisponible
	var suVehiculo
	var infracciones = #{}

	method recorrer(unaDistanciaEnKm){
		suVehiculo.consumirCombustiblePara(unaDistanciaEnKm)
	}

	method recargarCombustibleAlVehiculo(unaCantidad){
		self.validarPagoDeCombustible(unaCantidad)
		self.pagarCombustible(unaCantidad)
		vehiculo.recargarTanque(unaCantidad)
	}

	method validarPagoDeCombustible(unaCantidad){
		if(not self.puedePagarCombustible(unaCantidad)){
			throw new Exception(message = "No hay dinero suficiente")
		}
	}

	method puedePagarCombustible(unaCantidad){
		return dineroDisponible > combustible.costoDeCarga(unaCantidad)
	}

	method pagar(unaCantidad){
		dineroDisponible -= unaCantidad
	}

	method pagarCombustible(unaCantidad){
		self.pagar(combustible.costoDeCarga(unaCantidad)) 
	}

	method pagarMulta(unaMulta){
		self.validarPagoDeMulta(unaMulta)
		self.pagar(unaMulta.costo())
		infracciones.remove(unaMulta)
		/*
		En este caso puedo asumir que si remuevo la multa, está pagada o, también, 
		puedo enviarle el mensaje unaMulta.pagate() dejandola en las multas que conoce
		*/
	}

	method validarPagoDeMulta(unaMulta){
		if(not self.puedePagarMulta(unaMulta)){
			throw new Exception(message = "No hay dinero suficiente")
		}
	}

	method puedePagarMulta(unaMulta){
		return unaMulta.suCostoEsMenorA(dineroDisponible)
	}

	method adjudicarMulta(unaMulta){
		infracciones.add(unaMulta)
	}

	method transitaAMasDe(unaVelocidad){
		return suVehiculo.tieneVelocidadPromedioMayorA(unaVelocidad)
	}

	method esEcologico(){
		return suVehiculo.esEcologico()
	}

	method tieneDNIPar(){
		return dni.even()
	}

	method puedeMoverseEnDiaPar(){
		return self.tieneDNIPar() && dia.esDiaPar()
	}

	method pagarTodasLasMultasQuePueda(){
		self.multasQuePuedePagar().forEach({ unaMulta => self.pagarMulta(unaMulta) })
		self.multasQueNoPuedePagar().forEach({ unaMulta => unaMulta.aumentarCostoEnPorcentaje(10) })
	}

	method multasQuePuedePagar(){
		return infracciones.filter({ unaMulta => self.puedePagarMulta(unaMulta) })
	}

	method multasQueNoPuedePagar(){
		return infracciones.filter({ unaMulta => not self.puedePagarMulta(unaMulta) })
	}

	method esComplicado(){
		return self.montoDeMultasQueNoPuedePagar() > 50000
	}

	method montoDeMultasQueNoPuedePagar(){
		return self.multasQueNoPuedePagar().sum({ unaMulta => unaMulta.costo() })
	}
}

//VEHICULOS
class Vehiculo{
	var distanciaDeterminada
	var capacidadMaximaDelTanque
	var cantidadDeCombustible
	var velocidadPromedio

	method recargarTanque(unaCantidad){
		cantidadDeCombustible = (cantidadDeCombustible + unaCantidad).max(capacidadMaximaDelTanque)
	}

	method consumirCombustiblePara(unaDistanciaEnKm){
		cantidadDeCombustible -= self.litrosBaseDeConsumo() + self.consumoCombustibleAdicional(unaDistanciaEnKm) 
	}

	method litrosBaseDeConsumo(){
		return 2
	}

	method tieneVelocidadPromedioMayorA(unaVelocidad){
		return velocidadPromedio > unaVelocidad
	}

	//Metodos abstractos
	method consumoCombustibleAdicional(unaDistanciaEnKm)
	method esEcologico()
}

//TIPOS VEHICULOS
class Camioneta inherits Vehiculo{
	override method litrosBaseDeConsumo(){
		return super() * 2
	}

	override method consumoCombustibleAdicional(unaDistanciaEnKm){
		return 5 * (distanciaDeterminada - unaDistanciaEnKm)
	}

	override method esEcologico(){
		return false
	}
}

class Deportivo inherits Vehiculo{
	override method esEcologico(){
		return velocidadPromedio < 120
	}

	override method consumoCombustibleAdicional(unaDistanciaEnKm){
		return 0.2 * (distanciaDeterminada - unaDistanciaEnKm)
	}
}

class Familiar inherits Vehiculo{
	override method esEcologico(){
		return true
	}

	override method consumoCombustibleAdicional(consumoCombustibleAdicional){
		return 0
	}
}

//INFRACCIONES
class Infraccion{
	var property costo
	var estaPagada = false //cuando se genera no está pagada

	method suCostoEsMenorA(unaCantidad){
		return costo < unaCantidad
	}

	method pagate(){
		estaPagada = true
	}

	method aumentarCostoEnPorcentaje(unPorcentaje){
		costo += costo * unPorcentaje / 100
	}
}

//ZONAS
class Zona{
	var usuariosQueTransitan
	var velocidadPermitida //podría ser un const 
	var controlesDeZona = []

	method activarControlesDeZona(){
		controlesDeZona.forEach({ unControl => unControl.activarse(usuarios, velocidadPermitida) })
	}

	method cantidadDeUsuarios(){
		return usuariosQueTransitan.size()
	}
}

//CONTROLES
class Control{
	const multaQueCorresponde

	method activarse(unosUsuarios, velocidadPermitida){
		self.usuariosAMultar(unosUsuarios, velocidadPermitida)
		.forEach({ unUsuario => unUsuario.adjudicarMulta(multaQueCorresponde) })
	}

	method usuariosAMultar(unosUsuarios, velocidadPermitida)
}

//TIPOS DE CONTROLES
object controlDeVelocidad inherits Control(multaQueCorresponde = new Infraccion(costo = 3000)){

	override method usuariosAMultar(unosUsuarios, velocidadPermitida){
		return unosUsuarios.filter({ unUsuario => unUsuario.transitaAMasDe(velocidadPermitida) })
	}
}

object controlEcologico inherits Control(multaQueCorresponde = new Infraccion(costo = 1500)){

	override method usuariosAMultar(unosUsuarios, velocidadPermitida){
		return unosUsuarios.filter({ unUsuario => not unUsuario.esEcologico() })
	}
}


object controlRegulatorio inherits Control(multaQueCorresponde = new Infraccion(costo = 2000)){

	override method usuariosAMultar(unosUsuarios, velocidadPermitida){
		return self.usuariosConDNIImparEnDiaPar(unosUsuarios) + self.usuariosConDNIParEnDiaImpar(unosUsuarios)
	}

	method usuariosConDNIImparEnDiaPar(unosUsuarios){
		return unosUsuarios.filter({ unUsuario => not unUsuario.puedeMoverseEnDiaPar()  })
	}

	method usuariosConDNIParEnDiaImpar(){
		return unosUsuarios.filter({ unUsuario => unUsuario.puedeMoverseEnDiaPar() })
	}
}

//APP
object waza{
	var usuariosDeApp = #{}
	var zonasDeApp = #{}

	method pagarMultas(){
		usuariosDeApp.forEach({ unUsuario => unUsuario.pagarTodasLasMultasQuePueda() })
	}

	method obtenerZonaMasTransitada(){
		return zonasDeApp.max({ unZona => unaZona.cantidadDeUsuarios() })
	}

	method usuariosComplicados(){
		return usuariosDeApp.filter({ unUsuario => unUsuario.esComplicado() })
	}
}
