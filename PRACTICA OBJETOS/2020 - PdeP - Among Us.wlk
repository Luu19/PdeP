/* PARCIAL 2020: AMONG US */
/*
Jugadores:
    -> tripulantes: cooperan con las tareas
    -> impostores: sabotean la nave 

La nave es única, conoce a los jugadores, cantidad impostores y cantidad tripulantes

De los JUGADORES sabemos color, mochila (arranca vacia), nivel de sospecha que arranca en 40 y tareas a realizar
La mochila tiene items que se usan una sola vez, despues se sacan

*/

// PUNTO 1 y 2
class Jugador{
    var estaVivo
    var nivelSospecha = 40
    var mochila = #{}
    var tareas = []

    method esSospechoso(){
        return nivelSospecha > 50
    }

    method buscarItem(unItem){
        mochila.add(unItem)
    }

    method tieneItem(unItem){
        return mochila.contains(unItem)
    }

    method aumentarNivelSospecha(unaCantidad){
        nivelSospecha += unaCantidad
    }

    method disminuirNivelSospecha(unaCantidad){
        nivelSospecha -= unaCantidad
    }

    method realizarTareas()

    method completoTodasLasTareas(){
        return tareas.equals([])
    }

    method llamarReunionDeEmergencia(){
        nave.convocarVotacion()
    }

    method estaVivo(){
        return estaVivo
    }

    method expulsar(){
        self.muerto()
    }

    method muerto(){
        estaVivo =  false
    }

    method tieneMochilaVacia(){
        return mochila.isEmpty()
    }

}

/* TIPO JUGADOR */
class JugadorImpostor inherits Jugador{

    method realizarTareas(){

    }

    override method completoTodasLasTareas(){
        return true
    }

    method realizarSabotaje(unSabotaje){
        unSabotaje.realizarse()
    }

    method votar(){
        return nave.jugadorAlAzar()
    }

    override method expulsar(){
        super()
        nave.actualizarImpostores()
    }

}


class JugadorTripulante inherits Jugador{
    var personalidad
    var votarEnBlanco

    method realizarTareas(){
        const tarea = tareas.find({ unaTarea => self.esRealizable(unaTarea) })
        tarea.serRealizadaPor(self)
        tareas.remove(tarea)
        self.informarANave()
    }

    method esRealizable(unaTarea){
        return unaTarea.puedeSerRealizadaPor(self)
    }

    method informarANave(){
        nave.tareaRealizada()
    }

    method votar(){
        if(votarEnBlanco){
            return votoEnBlanco
        }else{
           return personalidad.voto() 
        }
    }

    override method expulsar(){
        super()
        nave.actualizarTripulantes()
    }

    method votoEnBlanco(){
        votarEnBlanco = true 
    }
}

/* SABOTAJES */
object reducirOxigeno{

    method realizarse(){
        nave.reducirOxigeno(10)
    }
}

class ImpugnarAUnJugador{
    var jugadorImpugnado

    method realizarse(){
        jugadorImpugnado.votoEnBlanco()
    }
}

object votoEnBlanco{
    method expulsar(){

    }
}


/* NAVE */
object nave{
    var nivelOxigeno
    var jugadores = #{}
    var cantidadImpostores
    var cantidadTripulantes

    method aumentarNivelOxigeno(unaCantidad){
        nivelOxigeno += unaCantidad
    }

    method tareaRealizada(unaTarea){
        if(self.todasLasTareasFueronRealizadas()){
            throw new Exception(message = "Ganan Tripulantes!")
        }
    }

    method todasLasTareasFueronRealizadas(){
        jugadores.all({ unJugador => unJugador.completoTodasLasTareas() })
    }

    method reducirOxigeno(unaCantidad){
        if(!self.alguienTiene("tubo de oxigeno")){
            nivelOxigeno -= unaCantidad
            self.validarNivelOxigeno()
        }
    }

    method alguienTiene(unItem){
        jugadores.any({ unJugador => unJugador.tieneItem(unItem) })
    }

    method validarNivelOxigeno(){
        if(nivelOxigeno <= 0){
            throw new Exception(message = "Ganan Impostores!")
        }
    }

    method convocarVotacion(){
       const votados =  jugadores.jugadoresVivos().map({ unJugador => unJugador.votar() })
       const elMasVotado = votados.max({ voto => votados.ocurrencesOf(voto) })
       elMasVotado.expulsar()
       self.informarGanadorSiCorresponde()
    }

    method jugadoresVivos(){
        return jugadores.filter({ unJugador => unJugador.estaVivo() })
    }

    method actualizarImpostores(){
        cantidadImpostores -= 1
    }

    method actualizarTripulantes(){
        cantidadTripulantes -= 1
    }

    method informarGanadorSiCorresponde(){
        if(cantidadImpostores == 0){
            throw new Exception(message = "Ganan Tripulantes!")
        }

        if(cantidadImpostores == cantidadTripulantes){
            throw new Exception(message = "Ganan Impostores!")
        }
    }

    method jugadorAlAzar(){
        return self.jugadoresVivos().anyOne()
    }

    method jugadorNoSospechoso(){
        return self.jugadoresVivos().findOrDefault({ unJugador => not unJugador.esSospechoso() }, votoEnBlanco)
    }

    method jugadorSospechoso(){
        return self.jugadoresVivos().findOrDefault({ unJugador => unJugador.esSospechoso() }, votoEnBlanco)
    }

    method tieneMochilaVacia(){
        return self.jugadoresVivos().findOrDefault({ unJugador => unJugador.tieneMochilaVacia() }, votoEnBlanco)
    }

}

/* PERSONALIDADES */
object troll{
    method voto(){
        return nave.jugadorNoSospechoso()
    }
}

object detective{
    method voto(){
        return nave.jugadorSospechoso()
    }
}

object materialista{
    method voto(){
        return nave.tieneMochilaVacia()
    }
}

/* TAREAS */
class TareaQueRequiereItem{
    var items

    method puedeSerRealizadaPor(unTripulante){
        return items.all({ unItem => unTripulante.tieneItem(unItem) })
    }

    method serRealizadaPor(unTripulante)
}

object arreglarTableroElectrico inherits TareaQueRequiereItem(items = ["llave Inglesa"]){
    override method serRealizadaPor(unTripulante){
        if(self.puedeSerRealizadaPor(unTripulante)){
            unTripulante.desecharItems(items)
            unTripulante.aumentarNivelSospecha(10)
        }
    }
}

object sacarLaBasura inherits TareaQueRequiereItem(items = ["bolsa de consorcio", "escoba"]){
    override method serRealizadaPor(unTripulante){
        if(self.puedeSerRealizadaPor(unTripulante)){
            unTripulante.desecharItem(items)
            unTripulante.disminuirNivelSospecha(4)
        }
    }

}

object ventilarNave{
    method serRealizadaPor(unTripulante){
        nave.aumentarNivelOxigeno(5)
    }
}