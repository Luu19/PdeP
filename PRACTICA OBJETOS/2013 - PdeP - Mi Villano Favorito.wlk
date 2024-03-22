/* 2013 PARCIAL: MI VILLANO FAVORITO */
/*
Modelar mundo de fantansía
Los MINIONS:
    ->originalmente amarrillos 
        *Estos son peligrosos si tiene + 2 armas
        *El nivel de concentracionse calcula como la potencia de las armas + la cantidad de bananas
    ->comen bananas y tienen armas de las cuales se conoce potencia y nombre de c/u
    ->si toman suero mutante se convierten en violetas y pierden las armas que tenian hasta el momento
    y se quedan con una banana menos
    ->los minions violetas
        *Pueden volver a tener armas y comer bananas, como los amarrillos
        *Son siempre peligrosos
        *El nivel de concentracion es igual a la cantidad de bananas
    ->cuando un minion violeta toma suero mutante, vuelve a ser amarillo, mantiene las mismas armas
    de antes y pierde una banana 

Cuando un VILLANO planifica una maldad busca entre sus minions lo que sean aptos para realizarla
y los asigna para participar
Un minion puede participar de muchas maldades o de ninguna
Las MALDADES al realizarse alteran la ciudad en la que vive el villano, excepto aquellas maldades que
no tengan minions asignados, en este caso tirar un error

Algunas MALDADES son
    ->congelar: minions con un rayo congelante, requiere nivel de concentracion de 500, pero puede cambiar
    Al realizarla disminuye la temperatura de la ciudad en 30 grados y premia a todos los minions con 10 bananas
    ->robar: solo sirven los minions peligrosos con un nivel de concentracion particular que depende del 
    objetivo del robo
    Al realizarse la ciudad deja de tener todo lo que fue robado, algunas cosas 
        *Piramides: premia a los minions con 10 bananas y requiere de un nivel de concentracion
        de al menos la mitad de lo que mide la piramide
        *Suero Mutante: requiere minions que tengan al menos 100 bananas (bien alimentados) y requiere 
        de un nivel de concentracion minimo de 23, premia a los minions con consumir el suero mutante
        *La Luna: requiere que los minions tengan un rayo para encoger, no importa la concentracion, y premia
        a los minions con un rayo congelante de potencia = 10
*/

/*
RESPUESTAS PUNTO 4:
a) ¿Qué pasaría si los minions pudieran ser de otro color, de manera que, por ejemplo, los minions
violetas se transforman en verdes al tomar el suero mutante, y éstos en amarillos, y además siendo verdes
hacen cosas diferentes? 
Se debería agregar el color como un objeto, en el caso del ejemplo "verde", agregar el metodo
correspondiente al minion de manera que modifique su color, luego ir al color donde si toma el suero el
minion cambia a ese color, en este caso si cambia de violeta a verde, en el metodo tomarSueroMutante
en vez de violetizate() deberia ir otro "verdizate()" y de esta manera en el objeto "verde" al tomarSueroMutante
en deberia estar el mensaje "amarillate()".

b) ¿Y si se estableciera que una vez que un minion amarillo pasa a violeta, es irreversible, y ya no puede
volver a cambiar, por más suero mutante que tome?
En el objeto violeta, solo se debe borrar el mensaje que le enviamos al minion y, en caso de querer, agregar
un comentario que aclare que ese metodo no hace nada
*/

//OBJETOS UTILES
object builderMinion{
    method nuevoMinion(unColor, unaCantidadDeBananas, unArma){
        return new Minion(color = unColor, cantidadDeBananas = unaCantidadDeBananas, armas = #{unArma})
    }
}

//ARMAS
class Arma{
    const nombreArma
    const potencia

    method potencia(){
        return potencia
    }

    method seLlama(unNombre){
        return nombreArma.equals(unNombre)
    }
}

//VILLANO
class Villano{
    var minions
    var ciudadDondeVive
    var maldades

    method nuevoMinion(){
        const nuevaArma = new Arma(nombreArma = "rayo congelante", potencia = 10)
        minions.add(builderMinion.nuevoMinion(amarillo, 5, nuevaArma))
    }

    method otorgarArmas(unMinion, unArma){
        unMinion.agregarArma(unArma)
    }

    method alimentar(unMinion, unaCantidadDeBananas){
        unMinion.sumarBananas(unaCantidadDeBananas)
    }

    method planificarUnaMaldad(unaMaldad){
        minions.forEach({ unMinion => self.asignarMinionA(unaMaldad, unMinion)})
        maldades.add(unaMaldad)
    }

    method asignarMinionA(unaMaldad, unMinion){
        if(unaMaldad.puedeSerRealizadaPor(unMinion)){
            unaMaldad.incluir(unMinion)
        }
    }

    method realizarUnaMaldad(unaMaldad){
        unaMaldad.realizarseEn(ciudadDondeVive)
    }

    method minionMasUtil(){
        return minions.max({ unMinion => self.cantidadDeVecesQueParticipoEnMaldades(unMinion) })
    }

    method cantidadDeVecesQueParticipoEnMaldades(unMinion){
        return self.minionsParticipantesEnMaldades().occurrencesOf(unMinion)
    }

    method minionsInutiles(){
        return minions.filter({ unMinion => self.cantidadDeVecesQueParticipoEnMaldades(unMinion).equals(0) })
    }

    method minionsParticipantesEnMaldades(){
        return maldades.map({ unaMaldad => unaMaldad.minionsAsignados() }).flatten() 
    }
}

//CIUDAD
class Ciudad{
    var nombre
    var lugares
    var temperatura

    method quitar(unLugar){
        lugares.remove(unLugar)
    }

    method disminuirTemperaturaEn(unaCantidad){
        temperatura -= unaCantidad
    }

}

//MALDADES
class Maldad{
    var minionsAsignados = #{}

    method puedeSerRealizadaPor(unMinion)

    method incluir(unMinion){
        minionsAsignados.add(unMinion)
    }
}

class Congelarse inherits Maldad{
    var nivelEstablecido = 500

    method puedeSerRealizadaPor(unMinion){
        return unMinion.tieneArma("rayo congelante") && unMinion.tieneNivelDeConcentracionMayorA(nivelEstablecido)
    }

    method realizarseEn(unaCiudad){
        unaCiudad.disminuirTemperaturaEn(30)
        minionsAsignados.forEach({ unMinion => unMinion.sumarBananas(10) })
    }

    method modificarNivel(unaCantidad){
        nivelEstablecido = unaCantidad
    }
}

class Robar inherits Maldad{
    var objetivo

    method puedeSerRealizadaPor(unMinion){
        return unMinion.esPeligroso() && objetivo.puedeSerRobadorPor(unMinion)
    }

    method realizarseEn(unaCiudad){
        unaCiudad.quitar(objetivo)
        minionsAsignados.forEach({ unMinion => objetivo.robarse(unMinion) })
    }
}

//OBJETIVOS
class Piramides{
    const altura

    method puedeSerRobadorPor(unMinion){
        return unMinion.tieneNivelDeConcentracionMayorA(altura / 2)
    }

    method robarse(unMinion){
        unMinion.sumarBananas(10)
    }
}

object suertoMutante{
    method puedeSerRealizadaPor(unMinion){
        return unMinion.estaBienAlimentado() && unMinion.tieneNivelDeConcentracionMayorA(23)
    }

    method robarse(unMinion){
        unMinion.tomarSueroMutante()
    }
}

object luna{
    method puedeSerRobadorPor(unMinion){
        return unMinion.tieneArma("rayo encogedor")
    }

    method robarse(unMinion){
        const nuevaArma = new Arma(nombreArma = "rayo congelante", potencia = 10)
        unMinion.agregarArma(nuevaArma)
    }
}



//MINION
class Minion{
    var color
    var property cantidadDeBananas
    var armas

    method agregarArma(unArma){
        armas.add(unArma)
    }

    method sumarBananas(unaCantidadDeBananas){
        cantidadDeBananas += unaCantidadDeBananas
    }

    method nivelDeConcentracion(){
        return color.nivelDeConcentracion(self)
    }

    method esPeligroso(){
        return color.esPeligroso(self)
    }

    method tomarSueroMutante(){
        color.tomarSueroMutante(self)
    }

    method cantidadDePotenciaDeArmas(){
        return armas.sum({ unArma => unArma.potencia() })
    }

    method cantidadArmas(){
        return armas.size()
    }

    method estaBienAlimentado(){
        return cantidadDeBananas > 100
    }

    method tieneArma(nombreArma){
        return armas.any({ unArma => unArma.seLlama(nombreArma) })
    }

    method tieneNivelDeConcentracionMayorA(unaCantidad){
        return self.nivelDeConcentracion() > unaCantidad
    }

    method violetizate(){
        color = violeta
        self.perderArmas()
        self.perderUnaBanana()
    }

    method amarillate(){
        color = amarillo
        self.perderUnaBanana()
    }

    method perderArmas(){
        armas = #{}
    }

    method perderUnaBanana(){
        cantidadDeBananas -= 1
    }
}

//COLORES dijo jotabalbin
object amarillo{
    method nivelDeConcentracion(unMinion){
        return unMinion.cantidadDePotenciaDeArmas() + unMinion.cantidadDeBananas()
    }

    method esPeligroso(unMinion){
        return unMinion.cantidadArmas() > 2
    }

    method tomarSueroMutante(unMinion){
        unMinion.violetizate()
    }
}

object violeta{
    method nivelDeConcentracion(unMinion){
        return unMinion.cantidadDeBananas()
    }

    method esPeligroso(unMinion){
        return true
    }

    method tomarSueroMutante(unMinion){
        unMinion.amarillate()
    }
}
