/* 2015 PARCIAL: DRAGON BALL Z */
/*
De los GUERREROS se conoce:
    ->su potencial ofensivo
    ->nivel experiencia
    ->nivel energia tal que si es == 0, mueren
    *Cuando un guerrero ataca a otro, la victima pierde energia en un 10% del potencial ofensivo del atacante, y
    aumentan en 1 punto la experiencia
    ->come semilla ermitaño y su nivel de energia se restaura
*/
object dragonBallZ{
    var jugadores = #{}

    method asignarJugadoresA(unTorneo){
        unTorneo.seleccionarJugadores(jugadores)
    }
}

class Guerrero{
    var potencialOfensivo
    var nivelEnergiaInicial
    var energia = nivelEnergiaInicial
    var nivelExperiencia
    var estaVivo = true
    var traje

    method atacarA(unGuerrero){
        unGuerrero.recibirDanio(potencialOfensivo)
    }

    method recibirDanio(unaCantidad){
        traje.protegerA(self, unaCantidad)
        self.aumentarExperiencia(1)
        self.validarEnergia()
    }

    method validarEnergia(){
        if(energia <= 0){
            self.morir()
        }
    }

    method aumentarExperiencia(unaCantidad){
        nivelExperiencia += unaCantidad
    }

    method morir(){
        estaVivo = false
    }

    method comerSemilla(){
        energia = nivelEnergiaInicial
    }

    method disminuirEnergia(unaCantidad){
        energia -= unaCantidad
    }

    method disminuirEnergiaPorAtaque(unaCantidad){
        self.disminuirEnergia(unaCantidad * 0.1) //aumenta la resistencia de acuerdo al nivel
    }

    method duplicarExperiencia(){
        nivelExperiencia *= 2
    }

    method aumentarExperienciaEnPorcentaje(unPorcentaje){
        nivelExperiencia += nivelExperiencia * (unPorcentaje / 100)
    }

    method cantidadElementosTraje(){
        return traje.cantidadElementos()
    }
}

//SUPER SAIYANS ///TERMINAR ESTA PARTE
class Saiyan inherits Guerrero{
    var nivelSaiyan //se convierte en superSaiyan

    override method atacarA(unGuerrero){
        unGuerrero.recibirDanio(self.poderAtaque())
    }

    method poderAtaque(){
        return nivelSaiyan.poderAtaque(potencialOfensivo)
    }

    override method recibirDanio(unaCantidad){
        nivel.recibirDanio(self, unaCantidad)
    }

    override method comerSemilla(){
        potencialOfensivo += potencialOfensivo * 0.5 //Tomé como si el potencial ofensivo = poder ataque
    }

    method validarEnergiaSaiyan(){
        if(self.tienePocaEnergia()){
            self.volverAEstadoInicial()
        }
    }

    method volverAEstadoInicial(){
        nivelSaiyan = normal
    }

    method tienePocaEnergia(){
        return energia < nivelEnergiaInicial  * 0.01
    }
}

//NIVELES SAIYAN
class NivelSaiyan{
    var resistencia

    method poderAtaque(unaCantidad){
        return  unaCantidad + unaCantidad * 0.5
    }

    method recibirDanio(unSaiyan, unaCantidad){
        const danioARestar = unaCantidad - unaCantidad * resistencia / 100
    }
}

object normal{
    method poderAtaque(unaCantidad){
        return unaCantidad
    }

    method recibirDanio(unSaiyan, unaCantidad){
        unSaiyan.recibirDanio(unaCantidad)
    }
}

const nivel1 = new NivelSaiyan(resistencia = 5)

const nivel2 = new NivelSaiyan(resistencia = 7)

const nivel3 = new NivelSaiyan(resistencia = 15)

//TORNEO
class Torneo{
    var jugadores = #{}
    var modalidadJuego

    method seleccionarJugadores(unosJugadores){
        modalidadJuego.asignarJugadoresA(self, unosJugadores)
    }

    method agregarJugadores(unosJugadores){
        jugadores + unosJugadores.take(16)
    }
}

class ModalidadJuego{
    method asignarJugadoresA(unTorneo, unosJugadores){
        unTorneo.agregarJugadores(self.jugadoresApropiados(unosJugadores))
    }

    method jugadoresApropiados(unosJugadores)
}

object powerlsBest inherits ModalidadJuego{
    method jugadoresApropiados(jugadores){
        return jugadores.sortBy({ unJ, otroJ => unJ.poderAtaque() > otroJ.poderAtaque() })
    }
}

object funny inherits ModalidadJuego{
    method jugadoresApropiados(jugadores){
        return jugadores.sortBy({ unJ, otroJ => unJ.cantidadElementosTraje() > otroJ.cantidadElementosTraje() })
    }
}

object surprise inherits ModalidadJuego{
    method jugadoresApropiados(jugadores){
        return jugadores.take(16)
    }
}


//TRAJES
class Traje{
    var nivelDesgaste

    method protegerA(unaCantidad, unGuerrero){
        if(!self.estaGastado()){
            self.surtirEfectoSegunTraje(unaCantidad, unGuerrero)
            self.aumentarDesgaste(5)
        }else{
            unGuerrero.disminuirEnergiaPorAtaque(unaCantidad)
        }
    }

    method aumentarDesgaste(unaCantidad){
        nivelDesgaste += unaCantidad
    }

    method estaGastado(){
        return nivelDesgaste >= 100
    }

    method surtirEfectoSegunTraje(unaCantidad, unGuerrero)

    method amortiguarDanioEn(unaCantidad, unGuerrero, danioARestar){
        unGuerrero.recibirDanio(unaCantidad - danioARestar)
    }

    method cantidadElementos(){
        return 1
    }

}

//TIPOS DE TRAJE
class TrajeEntrenamiento inherits Traje{ //Puedo tener muchos trajes de entrenamiento
    override method surtirEfectoSegunTraje(unaCantidad, unGuerrero){
        self.amortiguarDanioEn(unaCantidad, unGuerrero, 0)
        unGuerrero.duplicarExperiencia()
        //No sé si está bien modelarlo de esta manera, sin embargo es donde me pareció correcto dado que
        //un guerrero al sufrir un ataque se relaciona con la experiencia, más adelante puede cambiar
    }
}

class TrajesComunes inherits Traje{
    var unPorcentaje

    override method surtirEfectoSegunTraje(unaCantidad, unGuerrero){
        self.amortiguarDanioEn(unaCantidad, unGuerrero, unaCantidad * unPorcentaje / 100)
    }
}


class TrajesModularizados inherits Traje{
    var piezas

    override method surtirEfectoSegunTraje(unaCantidad, unGuerrero){
        self.amortiguarDanioEn(unaCantidad, unGuerrero, self.sumatoriaDeResistenciaDePiezas())
        unGuerrero.aumentarExperienciaEnPorcentaje(self.porcentajePiezasNoGastadas())
    }

    override method estaGastado(){
        return piezas.all({ unaPieza => unaPieza.estaGastada() })
    }

    method sumatoriaDeResistenciaDePiezas(){
        return self.piezasNoGastadas().sum({ unaPieza => unaPieza.resistencia() })
    }

    method piezasNoGastadas(){
        return piezas.filter({ unaPieza => not unaPieza.estaGastada() })
    }

    method porcentajePiezasNoGastadas(){
        return self.piezasNoGastadas().size() * 100 / piezas.size()
    }

    override cantidadElementos(){
        return piezas.size()
    }
}

class Pieza{
    var desgaste
    var property resistencia

    method estaGastada(){
        return desgaste >= 20
    }
}

