/* 2016 PARCIAL: ANGRY BIRDS */
//PAJAROS
class Pajaro{

    var ira

    method fuerza(){
        return ira * 2
    }

    method enojar(){

    }

    method esFuerte(){
        return self.fuerza() > 50
    }

    method serLanzadoA(unaIsla){
        unaIsla.derribarObstaculosPor(self)
    }

    method tieneFuerzaMayorA(unaCantidad){
        return self.fuerza() > unaCantidad
    }

    method tranquilizarse(){
        ira-=5
    }

}

class PajaroRencoroso inherits Pajaro{
    var cantidadVecesQueSeEnojo = 0
    var multiplicador 

    override method fuerza(){
        return ira * multiplicador * cantidadVecesQueSeEnojo
    }

    method enojar(){
        cantidadVecesQueSeEnojo++
    }

}

const red = new PajaroRencoroso(multiplicador = 10)

object bomb inherits Pajaro{
    var topeMaximo = 9000

    override method fuerza(){
        return super().max(topeMaximo)
    }

    var cambiarTopeMaximo(unaCantidad){
        topeMaximo = unaCantidad
    }

}

object chuck inherits Pajaro{
    var velocidadALaQueCorre

    override method fuerza(){
        return (velocidadALaQueCorre - 80).max(0) * 5 + 150
    }

    override method enojar(){
        velocidadALaQueCorre *= 2
    }

    override method tranquilizarse(){

    }
}

object terence inherits PajaroRencoroso{
    method multiplicador(unNumero){
        multiplicador = unNumero
    }
}

object matilda inherits Pajaro{
    var huevos = #{}

    override method fuerza(){
        return super() + self.fuerzaDeTodosSusHuevos() 
    }

    override method enojar(){
        huevos.add(new Huevo(peso = 2))
    }

    method fuerzaDeTodosSusHuevos(){
        return huevos.sum({ unHuevo => unHuevo.fuerza() })
    }
}

class Huevo{
    var peso

    method fuerza(){
        return peso
    }
}

/// ISLA
class Isla{
    var pajaros = #{}

    method parajosFuertesDeLaIsla(){
        return pajaros.filter({ unPajaro => unPajaro.esFuerte() })
    }

    method fuerzaDeIsla(){
        return self.parajosFuertesDeLaIsla().sum({ unPajaro => unPajaro.fuerza() })
    }
}

//ISLA SINIESTRA
object islaPajaro{

    method sucederUnEvento(unEvento){
        unEvento.afectarA(pajaros)   // Se debería pasar los pajaros o la isla? 
                                    // Ya que esta última es quien los conoce
    }

    method atacar(unaIsla){
        self.lanzarPajaroA(unaIsla)
    }

    method atacarIslaCerdito(){
        self.atacar(islaCerdito)
    }

    method lanzarPajarosA(unaIsla){
        pajaros.forEach({ unPajaro => unPajaro.serLanzadoA(unaIsla) })
    }

    method seRecuperaronLosHuevos(){
        return islaCerdito.tieneObstaculosEnPie()
    }

}

// EVENTOS

class Evento{
    method afectarA(pajaros)
}

object sesionDeManejoDeIra inherits Evento{
    override method afectarA(unosPajaros){
        pajaros.forEach({ unPajaro => unPajaro.tranquilizarse() })
    }
}

class InvasionDeCerditos inherits Evento{
    var cantidadCerditos

    override method afectarA(unosPajaros){
        (cantidadCerditos / 100).roundUp().times({ i => self.enojarPajaros(unosPajaros) })
    }

    method enojarPajaros(unosPajaros){
        unosPajaros.forEach({ unPajaro => unPajaro.enojar() })
    }
}

class FiestaSorpresa inherits Evento{
    var homenajeados

    override method afectarA(unosPajaros){
        homenajeados.forEach({ unPajaro => unPajaro.enojar() })
    }
}

class SerieDeEventosDesafortunados inherits Evento{
    var eventos

    override method afectarA(unosPajaros){
        eventos.forEach({ unEvento => unEvento.afectarA(unosPajaros) })
    }
}

// GUERRA PORCINA
object islaCerdito inherits Isla{
    var obstaculos

    method derribarObstaculosPor(unPajaro){
        if(self.obstaculoMasCercano().puedeSerDerribadoPor(unPajaro)){
            obstaculos.remove(self.obstaculoMasCercano())
        }
    }

    method obstaculoMasCercano(){
        return obstaculos.first()
    }

    method tieneObstaculosEnPie(){
        return not obstaculos.isEmpty()
    }
}

//OBSTACULOS
class Obstaculo{
    method puedeSerDerribadoPor(unPajaro){
        return unPajaro.tieneFuerzaMayorA(self.resistencia())
    }

    method resistencia()
}


class Pared inherits Obstaculo{
    var ancho
    var multiplicador

    override method resistencia(){
        return multiplicador * ancho
    }
}

//No me acuerdo cómo se hacia para simplificar esto
class ParedMadera inherits Parede(multiplicador = 10){

}

class ParedDeVidrio inherits Parede(multiplicador = 25){

}

class ParedDePiedra inherits Parede(multiplicador = 50){

}

object cerditosObreros inherits Obstaculo{
    override method resistencia(){
        return 50
    }
}

class CerditoArmado inherits Obstaculo{
    var arma

    override method resistencia(){
        return 10 * arma.resistencia()
    }
}

//Después puede ser un escudo/casco/otro
class Arma{
    var property resistencia
}
