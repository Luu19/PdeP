/* PRACTICA OBJETOS: GAMEFLIX AND CHILL */

object gameFlix{

    var juegos = #{}

    method filtrarJuegos(unaCategoria){
        return juegos.filter({ unJuego => unJuego.esDeCategoria(unaCategoria) })
    }

    method buscarJuegoDeNombre(unNombre){
        return juegos.findOrElse({ unJuego => unJuego.suNombreEs(unNombre) }, {throw new Exception(message = "No se encuentra el juego!")})
    }

    method recomerdarJuego(){
        return juegos.anyOne()
    }
.pagarSuscripcion()

    method cobrarSuscripciones(){
        usuarios.forEach({ unUsuario => self.cobrarSuscripcion() })
    }
    /*
    method cobrarSuscripcion(unUsuario){
        if(!unUsuario.puedePagarSuscripcion()){
            unUsuario.actualizarSuscripcion(prueba)
        }else{
            unUsuario.pagarSuscripcion()
        }
    }
    PREGUNTAR A FEDE LO DEL CAMBIO DE SUSCRIPCIÓN */

}

/* USUARIOS */
class Usuario{
    var suscripcion
    var dineroDisponible
    var humor

    method jugar(unJuego, unasHoras){
        if(self.permiteJugar(unJuego)){
            unJuego.afectarA(self, unasHoras)
        } 
    }

    method permiteJugar(unJuego){
        suscripcion.permiteJugar(unJuego)
    }

    method actualizarSuscripcion(unaSuscripcion){
        suscripcion = unaSuscripcion
    }

    method puedePagar(unaCantidad){
        return dineroDisponible < unaCantidad
    }

    method pagarSuscripcion(){
        if(self.puedePagar(suscripcion.costo())){
            dineroDisponible -= suscripcion.costo()
        }else{
            self.actualizarSuscripcion(prueba)
        }
    }

    method aumentarHumor(unaCantidad){
        humor += unaCantidad
    }

    method reducirHumor(unaCantidad){
        humor -= unaCantidad
    }

    method comprarSkins(){
        if(self.puedePagar(30)){
            dineroDisponible -= 30
        }else{
            throw new Exception(message = "No tengo dinero!")
        }
    }

    method tirarTodoAlCarajo(){
        self.actualizarSuscripcion(infantil)
    }
}

/* SUSCRIPCIONES */
object premium{
    method permiteJugar(unJuego){
        return true
    }

    method costo(){
        return 50
    }
}

object base{
    method permiteJugar(unJuego){
        return unJuego.esBarato()
    }

    method costo(){
        return 25
    }
}

object prueba{
    method permiteJugar(unJuego){
        return unJuego.esDeCategoria("Demo")
    }

    method costo(){
        return 0
    }
}

object infantil{
    method permiteJugar(unJuego){
        return unJuego.esDeCategoria("Infantil")
    }

    method costo(){
        return 10
    }
}

/* JUEGOS */
class Juego{
    const nombre
    const precio
    const categoria

    method esDeCategoria(unaCategoria){
        return categoria.equals(unaCategoria)
    }

    method suNombreEs(unNombre){
        return nombre.equals(unNombre)
    }

    method esBarato(){
        return precio < 30
    }

}

/* LOS HAGO COMO CLASES YA QUE UN JUEGO QUE "NACE" CON UN TIPO SIEMPRE SERÁ DEL MISMO TIPO */
class JuegoViolento inherits Juego{
    method afectarA(unaPersona, horasJugadas){
        unaPersona.reducirHumor(10 * horasJugadas)
    }
}

class JuegoMOBA inherits Juego{
    method afectarA(unaPersona, horasJugadas){
        unaPersona.comprarSkins()
    }
}

class JuegoTerror inherits Juego{
    method afectarA(unaPersona, horasJugadas){
        unaPersona.tirarTodoAlCarajo()
    }
}

class JuegoEstrategico inherits Juego{
    method afectarA(unaPersona, horasJugadas){
        unaPersona.aumentarHumor(5 * horasJugadas)
    }
}