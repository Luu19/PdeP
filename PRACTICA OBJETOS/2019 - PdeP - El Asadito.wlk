/* PARCIAL 2019: ASADITO */
/*
PUNTO 1:
Cada PERSONA:
    ->sabe su posicion
    ->elementos que tiene cerca
Una persona le puede pedir a otra que le alcance una cosa:
    ->si la otra persona no tiene el elemento, no se puede lograr
    ->lo que ocurre depende del criterio de cada persona:
        *sordos->le pasan lo primero que tienen a mano
        *le pasan todo los elementos
        *le cambian la posicion de la mesa a esa persona
        *le pasan el elemento que quiere al comensal
    ->cuando se pasa el elemento, el que lo da, deja de tener el elemento cerca, quien lo recibe ahora tiene
    el elemento cerca
*/
/* PERSONA */
class Persona{
    var posicionEnLaMesa
    var elementosQueTieneCerca = #{}
    var criterioDeAlcanzarCosas
    var criterioDeComida
    var loQueComio = []

    method pedirElementoA(unElemento, unaPersona){
        unaPersona.pasarElemento(unElemento, self)
    }

    method pasarElemento(unElemento, unaPersona){
        self.validarCercaniaDelElemento(unElemento)
        criterioDeAlcanzarCosas.darElemento(unElemento, self, unaPersona)
    }

    method validarCercaniaDelElemento(unElemento){
        if(!self.tieneCerca(unElemento)){
            throw new Exception(message = "No lo tengo")
        }
    }

    method tieneCerca(unElemento){
        return elementosQueTieneCerca.contains(unElemento)
    }

    method pasarUnElementoCualquieraA(unaPersona){
        const elementoQuePasa = elementosQueTieneCerca.anyOne()
        unaPersona.recibirElemento(elementoQuePasa)
        self.dejarDeTenerElementoCerca(elementoQuePasa)
    }

    method pasarleTodosLosElementosA(unaPersona){
        unaPersona.recibirElementos(elementosQueTieneCerca)
        self.alejarTodosLosElementos()
    }

    method intercambiarPosicionCon(unaPersona){
        const nuevaPosicion = unaPersona.posicionEnLaMesa()
        unaPersona.cambiarPosicion(posicionEnLaMesa)
        self.cambiarPosicion(nuevaPosicion)
    }

    method lePasaElemento(unElemento, unaPersona){
        unaPersona.recibirElemento(unElemento)
        self.dejarDeTenerElementoCerca(unElemento)
    }

    method dejarDeTenerElementoCerca(unElemento){
        elementosQueTieneCerca.remove(unElemento)
    }

    method alejarTodosLosElementos(){
        elementosQueTieneCerca.clear()
    }

    method recibirElemento(unElemento){
        elementosQueTieneCerca.add(unElemento)
    }

    method recibirElementos(listaDeElementos){
        listaDeElementos.forEach({ unElemento => self.recibirElemento(unElemento) })
    }

    method cambiarPosicion(unaPosicion){
        self.posicionEnLaMesa(unaPosicion)
    }

    method cambiarCriterioAlcanzarCosas(unCriterio){
        self.criterioDeAlcanzarCosas(unCriterio)
    }

    method come(unaComida){
        if(criterioDeComida.puedeComer(unaComida)){
           loQueComio.add(unaComida) 
        } 
    }

    method cambiarCriterioComida(unCriterio){
        self.criterioDeComida(unCriterio)
    }

    method estaPipon(){
        loQueComio.any({ unaComida => unaComida.esPesada() })
    }

    method laPasaBien(){
        return self.comioAlgo() 
    }

    method comioAlgo(){
        return not loQueComio.isEmpty()
    }

    method comioCarne(){
        return loQueComio.any({ unaComida => unaComida.esCarne() })
    }

}

/* CRITERIOS */
object sordos{
    method darElemento(unElemento, personaQueDa, unaPersona){
        personaQueDa.pasarUnElementoCualquieraA(unaPersona)
    }
}

object quierenComerTranquilos{
    method darElemento(unElemento, personaQueDa, unaPersona){
        personaQueDa.pasarleTodosLosElementosA(unaPersona)
    }
}

object cambiarPosicion{
    method darElemento(unElemento, personaQueDa, unaPersona){
        personaQueDa.intercambiarPosicionCon(unaPersona)
    }
}

object lePasaLoQuePide{
    method darElemento(unElemento, personaQueDa, unaPersona){
        personaQueDa.lePasaElemento(unElemento, unaPersona)
    }
}

/* CRITERIOS DE COMIDA */
object vegetariano{
    method puedeComer(unaComida){
        return not unaComida.esCarne()
    }
}

object dietetico{
    method puedeComer(unaComida){
        return unaComida.calorias() < 500
    }
}

object alternado{
    method puedeComer(unaComida){
        return [false, true].anyOne()
    }
}

class CombinacionDeCondiciones{
    var condiciones

    method puedeComer(unaComida){
        return condiciones.all({ unaCondicion => unaCondicion.aply(unaComida) })
    }
}

/* COMIDA */
class Comida{
    var property calorias
    var property esCarne

    method esPesada(){
        return calorias > 500
    }
}

/* OBJETOS */
object osky inherits Persona{
    override method laPasaBien(){
        return true
    }
}

object moni inherits Persona{
    override method laPasaBien(){
        const posicionDeMoni = new Posicion(X = 1, Y = 1)
        return super() and posicion.equals(posicionDeMoni)
    }
}

object facu inherits Persona{
    override method laPasaBien(){
        return super() and self.comioCarne()
    }   
}

object vero inherits Persona{
    override method laPasaBien(){
        return super() and elementosQueTieneCerca.size() < 3
    }
}