/* 2013 PARCIAL: JALOGUIN */
/*
Para tener caramelos los nenes intentan asustar a los adultos
De los NINIOS
    ->capacidad de asustar se calcula como la sumatoria del susto que generan los elementos que tenga puesto
    multiplicado por la actitud del ninio (1 a 10)
        *Trajes : asusta según el personaje, si es tierno asusta 2 y si es terrorifico asusta 5
        *Maquillaje : actualmente todos asustan 3 pero puede cambiar
    ->si logra asustar a un adulto, recibe de este una X unidad de caramelos que suma a su bolsa

Los ADULTOS
    ->comunes: se asustan si tienen un tolerancia menor que la capacidad de susto del ninio y
    dan tantos caramelos como la mitad de su tolerancia
    La tolerancia se calcula como 10 * la cantidad de ninios que intentaron asustarlo con más de 15 caramelos
    ->abuelos: se asustan siempre y entregan la mitad de caramelos que un adulto comun
    ->necios: no se asustan
*/

//NINIOS
class Ninio{
    var elementos
    var actitud
    var cantidadCaramelos
    var estado

    method capacidadDeAsustar(){
        return self.cantidadDeSustoQueGeneraElementos() * self.actitud()
    }

    method actitud(){
        return estado.actitud(actitud)
    }

    method cantidadDeSustoQueGeneraElementos(){
        return elementos.sum({ unElemento => unElemento.cantidadSusto() })
    }

    method asustarA(unAdulto){
        unAdulto.serAsustadoPor(self)
    }

    method recibirCaramelos(unaCantidad){
        cantidadCaramelos += unaCantidad
    }

    method cantidadCaramelosEnBolsa(){
        return cantidadCaramelos
    }

    method elementosQueUsa(){
        return elementos
    }

    method comer(unaCantidad){
        if(estado.puedeComer()){
           self.validarCantidadAComer(unaCantidad)
            estado.comer(self, unaCantidad)
            cantidadCaramelos -= unaCantidad 
        } 
    }

    method validarCantidadAComer(unaCantidad){
        if(cantidadCaramelos < unaCantidad){
            throw new Exception(message = " NO TENES SUFICIENTES CARAMELOS ")
        }
    }
}

//ADULTO
class Adulto{
    method serAsustadoPor(unNinio){
        if(self.puedeAsustarsePor(unNinio)){
            unNinio.recibirCaramelos(self.cantidadDeCaramelosQueDa())
        }
    }

    method puedeAsustarsePor(unNinio)
    method cantidadDeCaramelosQueDa()
}

class Comun inherits Adulto{
    var cantidadDeIntentosDeSusto

    override method serAsustadoPor(unNinio){
        super(unNinio)
        self.aumentarIntentoDeSusto(unNinio)
    }

    override method puedeAsustarsePor(unNinio){
        return unNinio.capacidadDeAsustar() > self.tolerancia()
    }

    method tolerancia(){
        return 10 * cantidadDeIntentosDeSusto
    }

    override method cantidadDeCaramelosQueDa(){
        return self.tolerancia() / 2
    }

    method aumentarIntentoDeSusto(unNinio){
        if(unNinio.tieneCantidadDeCaramelosMayorA(15)){
            cantidadDeIntentosDeSusto++
        }
    }
}

class Abuelo inherits Comun{

    override method cantidadDeCaramelosQueDa(){
        return super() / 2
    }

    override method puedeAsustarsePor(unNinio){
        return true
    }
}

class Necio inherits Adulto{

    override method puedeAsustarsePor(unNinio){
        return false
    }

    override method cantidadDeCaramelosQueDa(){
        return 0
    }
}

//ELEMENTOS
class Maquillaje{
    var susto =  3

    method cantidadSusto(){
        return susto
    }
}

//Son clases ya que puedo tener muchos trajes tierno y muchos trajes terrorificos
class TrajeTierno{
    method cantidadSusto(){
        return 2
    }
}

class TrajeTerrorifico{
    method cantidadSusto(){
        return 5
    }
}

//BUILDER DE LEGIÓN
object builderDeLegion{
    method crearLegion(unosNinios){
        self.validarCreacion(unosNinios)
        return new Legion(ninios = unosNinios)
    }

    method validarCreacion(unosNinios){
        if(unosNinios.size() < 2){
            throw new Exception(message = "No podés crear una legión")
        }
    }
}

//LEGIONES
class Legion{
    var ninios = #{}

    method asustarA(unaPersona){
        unaPersona.serAsustadoPor(self)
    }

    method capacidadDeAsustar(){
        return ninios.sum({ unNinio => unNinio.capacidadDeAsustar() })
    }

    method recibirCaramelos(unaCantidad){
        self.liderDeLaLegion().recibirCaramelos(unaCantidad)
    }

    method cantidadCaramelosEnBolsa(){
        return ninios.sum({ unNinio => unNinio.cantidadCaramelosEnBolsa() })
    }

    method liderDeLaLegion(){
        return ninios.max({ unNinio => unNinio.capacidadDeAsustar() })
    }
}

//SUPER - LEGIÓN
class SuperLegion{
    var integrantes = #{}

    method asustarA(unaPersona){
        unaPersona.serAsustadoPor(self)
    }

    method recibirCaramelos(unaCantidad){
        integrantes.forEach({ unIntegrante => unIntegrante.recibirCaramelos(unaCantidad) })
        //no especifica asi que supuse era asi
    }

    method capacidadDeAsustar(){
        return integrantes.sum({ unIntegrante => unIntegrante.capacidadDeAsustar() })
    }

    method cantidadCaramelosEnBolsa(){
        return integrantes.sum({ unIntegrante => unIntegrante.cantidadCaramelosEnBolsa() })
    }
}

//ESTADISTICAS
class Barrio{
    var ninios = #{}

    method tresNiniosConMasCaramelos(){
        return self.niniosOrdenadosSegunCantidadCaramelos().take(3)
    }

    method elementosUsandosPorNiniosConMas10Cramelos(){
        return self.niniosConMuchosCaramelos().map({ unNinio => unNinio.elementosQueUsa() }).flatten().asSet()
    }

    method niniosConMuchosCaramelos(){
        return self.niniosOrdenadosSegunCantidadCaramelos().take(10)
    }

    method niniosOrdenadosSegunCantidadCaramelos(){
        return ninios.sortBy({ unN1, unN2 => unN1.cantidadCaramelosEnBolsa() > unN2.cantidadCaramelosEnBolsa() })
    }
}


//INDIGESTION
class Estado{
    method puedeComer(){
        return true
    }
}

object sano inherits Estado{
    method comer(unNinio, unaCantidad){
        if(unaCantidad > 10){
            unNinio.empachate()
        }
    }

    method actitud(unaCantidad){
        return unaCantidad
    }
}

object empachado inherits Estado{
    method comer(unNinio, unaCantidad){
        if(unaCantidad >= 10){
            unNinio.quedarEnCama()
        }
    }

    method actitud(unaCantidad){
        return unaCantidad / 2
    }
}

object enCama inherits Estado{
    method comer(unNinio, unaCantidad){
        //no hace nada
    }

    override method puedeComer(){
        return false
    }

    method actitud(unaCantidad){
        return 0
    }
}