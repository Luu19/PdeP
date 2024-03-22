/* 2013 PARCIAL: QUIDDITCH */
/*
Cada EQUIPO esta formado por:
    ->guardian
    ->golpeadores (2)
    ->cazadores (3)
    ->buscador
Para jugar se utilizar tres tipos de PELOTAS:
    ->quaffle: los cazadores deben meter la quaffle en algún aro del equipo oponente para tener 
    + 10 ptos, el guardian debe proteger los aros. Hay solo 1 quaffle en el juego
    ->bludger: los golpeadores batean una bludger hacia un jugador de otro equipo, los jugadores 
    grosos pueden evitar goles desviando la quaffle (este dato qué hace acá). Hay 2 bludgers en el juego
    ->snitch: el buscador debe agarrar la snitch, al hacerlo + 150 ptos a su equipo y termina el partido

Cuando un equipo juega contra otro, cada jugador juega un turno de acuerdo a su puesto:
    ->cazador: si tiene la quaffle intenta meter gol y para eso debe
        *Evitar bloqueos-> cada jugador del otro equipo intenta bloquear el tiro del cazador
        y, si puede bloquear el tiro, se interrumpe el mismo. Cuando uni bloquea, los otros dejan de seguir
        bloqueando.
        *Si mete gol, el equipo + 10 ptos  y el cazador gana + 5 ptos de skill
        *Si el tiro es bloqueado, el cazador - 2 ptos de skill y el que bloqueó gana + 10 ptos skill
        *El cazador pierde la quaffle (sin importar si hizo gol o no) y ña agarra el cazador + rapido del
        equipo rival
    ->buscador: si esta buscando la snitch, debe hacer un random entre 1 y 1000 y si el numero obtenido
    es menor a su habilidad + la cantidad de turnos entonces la encontró
    si esta persiguiendo la snitch, debe correr a 5000km para atraparla, en cada turno recorre una cantidad 
    de kms igual a su velocidad / 1.6, una vez que la atrapó, 
    aumenta sus skills + 10 ptos y su equipo suma + 150 ptos
    ->golpeador: elige un blanco util del equipo al azar, si puede golpear a su blanco, el jugador
    sufre los efectos de ser golpeado por una bludger y el golpeador sube sus skills + 1 ptos
    Para poder golpear a otro debe darse que la punteria del golpeador sea mayor que el nivel de reflejos
    del blanco o si saca un 8 en un random de 1 a 10.
    ->guardian: no hace nada, participa en los bloqueos
*/
//OBJETOS UTILES
calculoFecha{
    method aniosDesde(unAnio){
        return new Date().year() - unAnio
    }
}

object mercadoDeEscobas{
    var valorVelocidad = 200

    method valorVelocidad(){
        return valorVelocidad
    }

    method actualizarValorVelocidad(unValor){
        valorVelocidad = unValor
    }
}

//JUGADOR
class Jugador{
    var puntosDeSkills
    var peso
    var fuerza
    var punteria
    var nivelDeReflejos
    var nivelDeVision
    var escoba
    const suEquipo

    method nivelDeManejoDeEscoba(){
        return puntosDeSkills  / peso
    }

    method velocidad(){
        return escoba.velocidad() * self.nivelDeManejoDeEscoba()
    }

    method habilidad(){
        return self.habilidad() + puntosDeSkills + self.terminoDePosicion() //Varía de acuerdo a la posicion en el campo del Jugador
    }

    method lePasaElTrapoA(unJugador){
        return self.habilidad() > unJugador.habilidad() * 2
    }

    method esGroso(){
        return self.habilidadMayorA(suEquipo.habilidadPromedio()) && self.velocidad() > mercadoDeEscobas.valorVelocidad()
    }

    method habilidadMayorA(unValor){
        return self.habilidad() > unValor
    }

    method lePasaElTrapoATodos(unosJugadores){
        return unosJugadores.all({ unJugador => self.lePasaElTrapoA(unJugador) })
    }

    method esCazador(){
        return false
    }

    method puedeBloquear(){
        return true
    }

    method serGolpeadoPorUnaBludger(){
        self.perderPuntosSkills(2)
        escoba.recibirGolpe()
        self.efectosSecundarios()
    }

    method ganarPuntosSkills(unaCantidad){
        puntosDeSkills += unaCantidad
    }

    method perderPuntosSkills(unaCantidad){
        puntosDeSkills -= unaCantidad
    }

    method efectosSecundarios(){
        //no hace nada excepto en los casos de buscadores y cazadores        
    }

    method esUtilGolpearlo(){
        return true 
    }

    method tieneReflejosMenorA(unNumero){
        return unNumero > nivelDeReflejos
    }


    //METODOS ABSTRACTOS
    method jugarUnTurnoContra(unEquipo)
    method terminoDePosicion()
    
}

//EQUIPO
class Equipo{
    var jugadores = #{}

    method habilidadPromedio(){
        return self.hablidadTotal() / self.cantidadJugadores()
    }

    method hablidadTotal(){
        return jugadores.sum({ unJugador => unJugador.habilidad() })
    }

    method cantidadJugadores(){
        return jugadores.size()
    }

    method tieneJugadorEstrellaParaJugarContra(unEquipo){
        return jugadores.any({ unJugador => unJugador.lePasaElTrapoATodos(unEquipo.jugadoresDelEquipo()) })
    }

    method jugadoresDelEquipo(){
        return jugadores
    }

    method jugarContra(unEquipo){
        jugadores.forEach({ unJugador => unJugador.jugarUnTurnoContra(unEquipo) })
    }

    method obtenerQuaffle(){
        self.jugadorCazadorMasRapido().agarrarQuaflle()
        //No sé si estaría mal preguntar si es Cazador en este caso, ya que en base a eso
        //no estoy tomando una decisión porque solo busco el cazador más rápido :?
        //ACTUALIZACION: ARREGLADO
    }

    method jugadoresCazadores(){
        return jugadores.filter({ unJugador => unJugador.esCazador() })
    }

    method jugadorCazadorMasRapido(){
        return self.jugadoresCazadores().max({ unJugador => unJugador.velocidad() })
    }

    method bloquearTiroDe(unJugador){
        const jugadorQueBloqueaTiro = self.jugadorQuePuedeBloquearTiroDe(unJugador)
        if(self.puedeBloquearTiroDe(unJugador)){
            jugadorQueBloqueaTiro.ganarPuntosSkills(10)
            unJugador.perderQuaffle()
            self.obtenerQuaffle()
        }else{
            unJugador.hacerGol()
        }
    }

    method jugadorQuePuedeBloquearTiroDe(unJugador){
        return self.jugadoresQuePuedenBloquear().find({ unJugador => unJugador.puedeBloquearTiroDe(unJugador) })
    }

    method puedeBloquearTiroDe(unJugador){
        return self.jugadoresQuePuedenBloquear().any({ otroJugador => otroJugador.puedeBloquearTiroDe(unJugador) })
        //omití lo de que el jugador que bloquea recibe 10 ptos, ACTUALIZACIÓN: SOLUCIONADO
    }

    method jugadoresQuePuedenBloquear(){
        return jugadores.filter({ unJugador => unJugador.puedeBloquear() })
    }

    method algunJugadorPuedeSerGolpeadoPor(unJugador){
        const jugadorAlAzar = self.jugadoresBlancosUtiles().anyOne()
        if(unJugador.puedeGolpearA(jugadorAlAzar)){
            jugadorAlAzar.serGolpeadoPorUnaBludger()
            unJugador.ganarPuntosSkills(1)
        }
    }

    method jugadoresBlancosUtiles(){
        return self.jugadoresQuePuedenSerBlancosUtiles().filter({ unJugador => unJugador.esBlancoUtil() })
    }

    method jugadoresQuePuedenSerBlancosUtiles(){
        return jugadores.filter({ unJugador => unJugador.esUtilGolpearlo() })
    }

    method ganaPuntos(unaCantidad){
        puntos += unaCantidad
    }

    method tieneQuaffle(){
        return self.jugadoresCazadores().any({ unJugador => unJugador.tieneQuaffle() })
    }
}

//TIPOS DE JUGADORES
//Los hice como clases porque en ningún lado dice que un jugador puede cambiar de posicion
class JugadorCazador inherits Jugador{
    var tieneQuaffle = false //al principio del partido no la tiene

    override method terminoDePosicion(){
        return punteria * fuerza
    }

    override method jugarUnTurnoContra(unEquipo){
        if(tieneQuaffle){
            self.intentarMeterGolA(unEquipo)
        }
    }

    method intentarMeterGolA(unEquipo){
        unEquipo.bloquearTiroDe(self)
    }

    method hacerGol(){
        suEquipo.ganaPuntos(10)
        self.ganarPuntosSkills(5) 
    }

    method perderQuaffle(){
        tieneQuaffle = false
    }

    method agarrarQuaflle(){
        tieneQuaffle = true
    }

    override method esCazador(){
        return true
    }

    method puedeBloquearTiroDe(unJugador){
        return self.lePasaElTrapoA(unJugador)
    }

    override method efectosSecundarios(){
        self.perderQuaffle()
    }

    method esBlancoUtil(){
        return tieneQuaffle
    }

    override method tieneQuaffle(){
        return tieneQuaffle
    }
}

class JugadorGuardian inherits Jugador{
    override method terminoDePosicion(){
        return nivelDeReflejos + fuerza
    }

    override method jugarUnTurnoContra(unEquipo){
        //no hace nada, solo participa en los bloqueos, eso ya está previsto con el método "puedeBloquear"
    }

    method puedeBloquearTiroDe(unJugador){
        return [1, 2, 3].anyOne().equals(3)
    }

    method esBlancoUtil(){
        return suEquipo.tieneQuaffle()
    }
}

class JugadorGolpeador inherits Jugador{
    override method terminoDePosicion(){
        return punteria + fuerza
    }

    override method jugarUnTurnoContra(unEquipo){
        unEquipo.algunJugadorPuedeSerGolpeadoPor(self)
    }

    method puedeBloquearTiroDe(unJugador){
        return self.esGroso()
    }

    override method esUtilGolpearlo(){
        return false
    }

    method puedeGolpearA(unJugador){
        return  unJugador.tieneReflejosMenorA(punteria) || [1..10].anyOne() >= 8
    }
}

class JugadorBuscador inherits Jugador{
    var turnosBuscandoSnitch = 0
    var encontroSnitch = false
    var kmsQueRecorrio = 0
    var estado = normal

    override method terminoDePosicion(){
        return nivelDeReflejos *  nivelDeVision
    }

    method jugarUnTurnoContra(unEquipo){
        if(self.estaBuscandoSnitch() && !estado.estaAturdido()){
            tunosBuscandoSnitch++
        }else{
            encontroSnitch = true
            self.perseguirSnitch()
        }
    }

    method esBlancoUtil(){
        if(estado.estaAturdido()){
            return estado.esBlancoUtil()
        }
        return estado.esBlancoUtil()
    }

    method estaBuscandoSnitch(){
        return not self.encontroSnitch()
    }

    method perseguirSnitch(){
        kmsQueRecorrio += self.velocidad() / 1.6
        if(kmsQueRecorrio >= 5000){
            suEquipo.ganaPuntos(150)
            self.ganarPuntosSkills(10)
        }
    }

    method encontroSnitch(){
        return [1..1000].anyOne() < self.numeroParaEncontrarSnitch()
        //supuse algo tipo Haskell, ni idea si existe en wollok
    }

    method numeroParaEncontrarSnitch(){
        return self.habilidad() + turnosBuscandoSnitch
    }

    override method puedeBloquear(){
        return false
    }

    override method efectosSecundarios(){
        if(self.esGroso()){
            estado = aturdido
        }else{
            // supongo que se refiere a esto con reiniciar busqueda
            turnosBuscandoSnitch = 0
            kmsQueRecorrio = 0 
        }
    }

    method leFaltaPocoParaEncontrarLaSnitch(){
        return kmsQueRecorrio > 4000
    }
}
class Estado{
    method esBlancoUtil(unJugador){
        return unJugador.estaBuscandoSnitch() || unJugador.leFaltaPocoParaEncontrarLaSnitch()
    }
}


object aturdido inherits Estado{
    method estaAturdido(){
        return true
    }
}

object normal inherits Estado{
    method estaAturdido(){
       return false
    }
}



//ESCOBA
class Nimbus{
    var anioDeFabricacion
    var porcentajeSalud

    method velocidad(){
        return (80 - calculoFecha.aniosDesde(anioDeFabricacion)) * porcentajeSalud / 100
    }

    method recibirGolpe(){
        porcentajeSalud -= 10
    }
}

object saetaDeFuego{
    method velocidad(){
        return 100
    }

    method recibirGolpe(){
        //no pasa nada
    }
}