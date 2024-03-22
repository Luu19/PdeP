/* 2017 PARCIAL : VIKINGOS */
/*
De los VIKINGOS se conoce:
    ->casta social (esclavos, casta media y nobles)
    ->soldados o granjeros
Los vikingos forman parte de las EXPEDICIONES:
    ->son productivos
        *Un SOLDADO debe haber cobrado + 20 vidas y tener armas
        *Un GRANJERO depende cantidad hijos que tiene y las hectareas para alimentarlos, 
        (minimo de 2 hectareas x hijo)
        *En el caso de la casta Jarl, no van si tienen armas
        (Jarl - Soldado => no va, Jarl - Granjero => va)
    ->pueden ascender de casta 
        *Los Jarl ascienden a Karl, ganan 10 armas en caso de ser soldado y
        2 hijos y 2 hectareas en caso de ser granjero
        *Los Karl ascienden a Thrall
Una expedicion vale la pena cuando toda aldea y toca capital involucradas en la expedicion
vale la pena
    *Una capital vale la pena si en el botin hay al menos 3 monedas de oro por c/
    vikingo de la expedicion
    ->El botin es tantas modenas de oro como defensores derrotados plus factor riquesa capital
Cuando se invade una capital cada vikingo mata a un defensor
    *Una aldea vale la pena si el botin obtenido sacia la sed de saqueos (15 monedas o +),
    el botin es cantidad crucifijos en iglesias.
    Existen aldeas amuralladas que para valer la oena hay que tener una cant minima de vikingos
*/
//VIKINGOS
class Vikingo{
    var casta
    var dinero

    method esProductivo()

    method permitirSubirse(){
        return casta.permiteExpedicion(self)
    }

    method ganar(unaCantidad){
        dinero += unaCantidad
    }

    method tieneArmas(){
        return false
    }

    method ascender(){
        casta.ascender(self)
    }

    method ascenderA(unaCasta){
        casta = unaCasta
        self.obtenerPremiosAscenso()
    }

    method cobrarMuerte(){
        //no hace nada para el granjero
    }

    method obtenerPremiosAscenso()
}

class Soldado{
    var cantidadArmas 
    var property cantidadMuertes

    method esProductivo(){
        return self.cantidadMuertes() > 20 && self.tieneArmas()
    }

    override method tieneArmas(){
        return not cantidadArmas.equals(0)
    }

    override method obtenerPremiosAscenso(){
        cantidadArmas += 10
    }

    override method cobrarMuerte(){
        cantidadMuertes++
    }

}

class Granjero{
    var cantidadHijos
    var cantidadHectareas

    method esProductivo(){
        return cantidadHectareas > cantidadHijos * 2
    }

    override method obtenerPremiosAscenso(){
        cantidadHijos += 2
        cantidadHectareas += 2
    }
}

//EXPEDICION
class Expedicion{
    var vikingos
    var lugaresIncluidos = []

    method subirA(unVikingo){
        self.validarIncorporacion(unVikingo)
        vikingos.add(unVikingo)
    }

    method validarIncorporacion(unVikingo){
        if(!unVikingo.esProductivo() || !unVikingo.permitirSubirse()){
            throw new Exception(message = "No es apto para la expedicion")
        }
    }

    method valeLaPena(){
        return lugaresIncluidos.all({ unLugar => unLugar.valeLaPenaPara(self) })
    }

    method realizarse(){
        lugaresIncluidos.forEach({ unLugar => unLugar.serInvadidoPor(self) })
    }

    method cobrarMuertes(){
        vikingos.forEach({ unVikingo => unVikingo.cobrarMuerte() })
    }

    method dividir(unaCantidad){
        vikingos.forEach({ unVikingo => unVikingo.ganar( unaCantidad / self.cantidadVikingos() ) })
    }

    method cantidadVikingos(){
        return vikingos.size()
    }
}

//LUGARES
class Lugar{

    method serInvadidoPor(unaExpedicion){
        unaExpedicion.dividir(self.botin(unaExpedicion.cantidadVikingos()))
        self.sufrirDaniosPor(unaExpedicion)
    }

    method sufrirDaniosPor(unaExpedicion)

    method botin(unaExpedicion)
}

class Capital{
    var factorRiqueza
    var cantidadDefensores

    override method botin(cantidadVikingos){
        return cantidadVikingos * factorRiqueza
    }

    override method valeLaPenaPara(unaExpedicion){
        return self.botin(unaExpedicion.cantidadVikingos()) > unaExpedicion.cantidadVikingos() * 3 
    }

    override method sufrirDaniosPor(unaExpedicion){
        self.matarDefensores(unaExpedicion.cantidadVikingos())
        unaExpedicion.cobrarMuertes()
    }

    method matarDefensores(unaCantidad){
        cantidadDefensores -= unaCantidad
    }
}

class Aldea{
    var iglesias

    override method valeLaPenaPara(unaExpedicion){
        return self.botin(unaExpedicion) > 15
    }

    override method botin(cantidadVikingos){
        return self.cantidadCrucifijosEnIglesias()
    }

    method cantidadCrucifijosEnIglesias(){
        return iglesias.sum({ unaIglesia => unaIglesia.cantidadCrucifijos() })
    }

    override method sufrirDaniosPor(unaExpedicion){
        iglesias.forEach({ unaIglesia => unaIglesia.robarCrucifijos() })
    }
}

class Iglesia{
    var property cantidadCrucifijos

    method robarCrucifijos(){
        cantidadCrucifijos = 0
    }
}


//CASTA 
class Casta{
    method permitirSubirse(unVikingo){
        return true
    }

    method ascender(unVikingo){
    
    }
}

object jarl inherits Casta{
    override method permitirSubirse(unVikingo){
        return not unVikingo.tieneArmas()
    }

    override method ascender(unVikingo){
        unVikingo.ascenderA(karl)
    }
}
object karl inherits Casta{
    override method ascender(unVikingo){
        unVikingo.ascenderA(thrall)
    }

}
const thrall = new Casta()
