/* 2016 PARCIAL: SUEÑOS */
/*

*/

class Persona{
    var sueniosCumplidos = #{}
    var sueniosPendientes = #{}
    var hijosQueTiene
    var nivelFelicidad
    var tipoPersona


    method cumplirSuenio(unSuenio){
        if(self.esSuenioPendiente(unSuenio)){
            self.validarCumplimiento(unSuenio)
            unSuenio.cumplirsePara(self)
        }
    }

    method sumarFelicidad(unaCantidad){
        nivelFelicidad += unaCantidad
    }

    method cumplirSuenioMasPreciado(){
        tipoPersona.cumplirSuenioMasPreciadoPara(self)
    }

    method validarCumplimiento(unSuenio){
       unSuenio.puedeSerCumplidoPor(self)
    }

    method esSuenioPendiente(unSuenio){
        return sueniosPendientes.contains(unSuenio)
    }

    method eliminarDePendientes(unSuenio){
        sueniosPendientes.eliminarDePendientes(unSuenio)
    }

    method agregarSuenioCumplido(unSuenio){
        sueniosCumplidos.add(unSuenio)
    }

    method tenerHijos(unaCantidad){
        hijosQueTiene += unaCantidad
    }

    method quiereEstudiar(unaCarrera){
        self.carrerasQueQuiereEstudiar().any({ carrera => carrera.equals(unaCarrera)})
    }

    method carrerasQueQuiereEstudiar(){
        return self.sueniosRelacionadosAEstudiar().map({ unSuenio => unSuenio.carreraAEstudiar() })
    }

    method sueniosRelacionadosAEstudiar(){
        return sueniosPendientes.filter({ unSuenio => unSuenio.trataSobreEstudiar() })
    }

    method plataQueQuiereGanar(){
        return self.suenioSobreGanarDinero().dineroQueQuiereGanar()
    }

    method suenioSobreGanarDinero(){
        return sueniosPendientes.find({ unSuenio => unSuenio.trataSobreGanarDinero() })
    }

    method suenioMasImportante(){
        sueniosPendientes.max({ unSuenio => unSuenio.felicidonio() })
    }

    method suenioCualquiera(){
        return sueniosPendientes.anyOne()
    }

    method primerSuenio(){
        return sueniosPendientes.asList().first()
    }

    method nivelFelicidadDeSueniosPendientes(){
        return sueniosPendientes.sum({ unSuenio => unSuenio.felicidonio() })
    }

    method esFeliz(){
        return nivelFelicidad > self.nivelFelicidadDeSueniosPendientes()
    }

    method esAmbiciosa(){
        return self.tieneSueniosPendientesConFelicidadMayorA(100) || self.tieneSueniosCumplidosConFelicidadMayorA(100)
        /*
            otra forma: 
            self.tieneSueniosConFelicidadMayorA(100, sueniosPendientes)
            or 
            self.tieneSueniosConFelicidadMayorA(100, sueniosCumplidos)     
            method tieneSueniosConFelicidadMayorA(unaCantidad, unosSuenios){
                return unosSuenios.filter({ unSuenio => unSuenio.otorgaFelicidadMayorA(unaCantidad) }).size() > 3
            }
        */
    }

    method tieneSueniosPendientesConFelicidadMayorA(unaCantidad){
        return sueniosPendientes.filter({ unSuenio => unSuenio.otorgaFelicidadMayorA(unaCantidad) }).size() > 3
    }

    method tieneSueniosCumplidosConFelicidadMayorA(unaCantidad){
        return sueniosCumplidos.filter({ unSuenio => unSuenio.otorgaFelicidadMayorA(unaCantidad) }).size() > 3
    }
}

//TIPOS DE PERSONA
class TipoPersona{
    var criterioSuenioPersona

    method cumplirSuenioMasPreciadoPara(unaPersona){
        unaPersona.cumplirSuenio(criterioSuenioPersona.aply(unaPersona))
    }
}
//Esto permite agregar más criterios, sin embargo se podría resolver de una mejor manera (?)
const realista = new TipoPersona(criterioSuenioPersona = {unaPersona => unaPersona.suenioMasImportante() })
const alocado = new TipoPersona(criterioSuenioPersona = {unaPersona => unaPersona.suenioRandom() })
const obsesivo = new TipoPersona(criterioSuenioPersona = {unaPersona => unaPersona.primerSuenio() })

object alocado{
    method cumplirSuenioMasPreciadoPara(unaPersona){
        unaPersona.cumplirSuenio(unaPersona.suenioCualquiera())
    }
}

object obsesivo{
    method cumplirSuenioMasPreciadoPara(unaPersona){
        unaPersona.cumplirSuenio(unaPersona.primerSuenio())
    }
}

//SUEÑOS
class Suenio{
    var felicidadQueGenera

    method puedeSerCumplidoPor(unaPersona)

    method felicidonio(){
        return felicidadQueGenera
    }

    method otorgaFelicidadMayorA(unaCantidad){
        return felicidadQueGenera > unaCantidad
    }

    method cumplirsePara(unaPersona){
        self.cumplirseDeAcuerdoA(unaPersona)
        unaPersona.eliminarDePendientes(self)
        unaPersona.agregarSuenioCumplido(self)
        unaPersona.sumarFelicidad(felicidadQueGenera)
        // Esto no me convence, pero podría abstraerlo en otro método de la persona
    }

    method cumplirseDeAcuerdoA(unaPersona)

    method trataSobreEstudiar(){
        return false
    }

    method trataSobreGanarDinero(){
        return false
    }
}

//TIPOS DE SUEÑOS
class CarreraSoniada inherits Suenio{
    const carreraSoniada

    override method puedeSerCumplidoPor(unaPersona){
        if(!unaPersona.quiereEstudiar(carreraSoniada)){
            throw new Exception(message = "No se puede cumplir este suenio")
        }else{
            if(unaPersona.yaEstudio(carreraSoniada)){
                throw new Exception(message = "No se puede cumplir este suenio")
            }
        }
    }

    override method cumplirseDeAcuerdoA(unaPersona){
        //
    }

    override method trataSobreEstudiar(){
        return true
    }

    method carreraAEstudiar(){
        return carreraSoniada
    }
}

class TrabajoSoniado inherits Suenio{
    var property dineroQueQuiereGanar

    override method puedeSerCumplidoPor(unaPersona){
        if(dineroQueQuiereGanar < unaPersona.plataQueQuiereGanar()){
            throw new Exception(message = "No se puede cumplir este suenio")
        }
    }

    override method cumplirseDeAcuerdoA(unaPersona){
        //no especifica
    }

    override method trataSobreGanarDinero(){
        return true
    }
}

class AdoptarHijo inherits Suenio{
    var cantidadHijosAAdoptar

    override method puedeSerCumplidoPor(unaPersona){
        if(unaPersona.tieneHijos()){
            throw new Exception(message = "No se puede cumplir este suenio")
        }
    }

    override method cumplirseDeAcuerdoA(unaPersona){
        unaPersona.tenerHijos(cantidadHijosAAdoptar)
    }
}

class Viajar inherits Suenio{
    var lugar

    override method puedeSerCumplidoPor(unaPersona){
        if(!unaPersona.quiereViajar(lugar)){
            return throw new Exception(message = "No se puede cumplir este suenio")
        }
    }

    override method cumplirseDeAcuerdoA(unaPersona){
        //no especifica
    }
}

class TenerHijo inherits Suenio{
    var cantidadHijos

    override method puedeSerCumplidoPor(unaPersona){
        //no se especifica
    }

    override method cumplirseDeAcuerdoA(unaPersona){
        unaPersona.tenerHijos(cantidadHijos)
    }
}

//SUENIOS MULTIPLES
class SuenioMultiple inherits Suenio{
    var suenios

    override method puedeSerCumplidoPor(unaPersona){
        suenios.forEach({ unSuenio => unSuenio.puedeSerCumplidoPor(unaPersona) })
    }

    override method cumplirseDeAcuerdoA(unaPersona){
        suenios.forEach({ unSuenio => unSuenio.cumplirseDeAcuerdoA(unaPersona) })
    }
}

