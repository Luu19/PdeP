/* 2017 PARCIAL : FIESTA DE DISFRACES */
/*
Una FIESTA tiene:
    ->lugar 
    ->fecha
    ->invitados
Un INVITADO tiene:
    ->disfraz (puede cambiarlo)
Un DISFRAZ tiene:
    ->nombre
    ->dia confeccionado
*/
//FIESTA
class Fiesta{
    var invitados = #{}

    method esUnBodrio(){
        return invitados.all({ unInvitado => not unInvitado.estaConformeConSuDisfraz() })
    }

    method mejorDisfrazDeLaFiesta(){
        return self.disfracesDeLaFiesta().max({ unDisfraz => unDisfraz.puntaje() })
    }

    method disfracesDeLaFiesta(){
        return invitados.map({ unaPersona => unaPersona.disfrazQueUsa() })
    }

    method estaInvitado(unaPersona){
        return invitados.contains(unaPersona)
    }

    method agregarInvitado(unInvitado){
        self.verificarInvitados(unInvitado)
        invitados.add(unInvitado)
    }

    method verificarInvitados(unInvitado){
        if(self.condicionesDeInvitado(unInvitado)){
            throw new Exception(message = "No es posible invitarlo")
        }
    }

    method condicionesDeInvitado(unInvitado){
        return self.estaInvitado(unInvitado) || unInvitado.tieneDisfraz()
    }
}

class FiestaInolvidable inherits Fiesta{
    override method condicionesDeInvitado(unInvitado){
        return super(unInvitado) and (unInvitado.esSexie() and unInvitado.estaConformeConSuDisfraz()) 
    }
}

//DISFRAZ
class Disfraz {
    var caracteristicas
    var nivelDeGracia
    var fechaConfeccion
    var fiesta
    var nombre

    method puntaje(unaPersona){
        return caracteristicas.sum({ unaCaracteristica => unaCaracteristica.puntos(self, unaPersona) })
    }

    method diasAntesDeLaFiesta(unaFecha){
        return fiesta.day() - unaFecha.day()
    }

    method estaConfeccionadoHace(unaFecha){
        return unaFecha.day() - fechaConfeccion.day() 
    }

    method cantidadDeLetrasDeNombre(unaCantidad){
        return nombre.size() == unaCantidad
    }

}

// TIPOS DE DISFRAZ
object gracioso{
    method puntos(unDisfraz, unaPersona){
        return self.puntosDeAcuerdoA(unaPersona, unDisfraz.nivelDeGracia())
    }

    method puntosDeAcuerdoA(unaPersona, nivelDeGraciaDisfraz){
        if(unaPersona.esMayorDe(50)){
            return nivelDeGraciaDisfraz * 3
        }
        return nivelDeGraciaDisfraz
    }

}

class Tobaras{
    var diaQueLoCompro

    method puntos(unDisfraz, unaPersona){
        if(unDisfraz.diasAntesDeLaFiesta(diaQueLoCompro) > 5){
            return 5
        }else{
            return 3
        }
    }
}

class caretas{
    var puntosPorPersonajeSimulado
    
    method puntos(unDisfraz, unaPersona){
        return puntosPorPersonajeSimulado
    }
}

object sexies{
    method puntos(unDisfraz, unaPersona){
        if(unaPersona.esSexie()){
            return 15
        }else{
            return 2
        }
    }
}


// PERSONAS
class Persona{
    const personalidad
    var edad
    var disfraz

    method esSexie(){
        return personalidad.esSexie(self)
    }

    method esMenorDe(unaEdad){
        return edad < unaEdad
    }

    method esMayorDe(unaEdad){
        return edad > unaEdad
    }

    method disfrazQueUsa(){
        return disfraz
    }

    method puedeIntercambiarDisfrazCon(unaPersona, unaFiesta){
        return unaFiesta.estanInvitados(unaPersona, self) and self.estaConformeCon(unaPersona.disfrazQueUsa()) and not self.estaConformeConSuDisfraz()
    }

    method tieneDisfraz(){
        return disfraz =/ NULL
    }

    method estaConformeConSuDisfraz()

    method estaConformeCon(unDisfraz)
}

//TIPOS DE PERSONA
class PersonaCaprichosa inherits Persona{
    var cantidadParDeLetras

    override method estaConformeCon(unDisfraz){
        return unDisfraz.cantidadDeLetrasDeNombre(cantidadParDeLetras)
    }

    method estaConformeConSuDisfraz(){
        return self.estaConformeCon(disfrazQueUsa)
    }
}

class PersonaPretenciosa inherits Persona{
    override method estaConformeCon(unDisfraz){
        return unDisfraz.estaConfeccionadoHace(new Date()) < 30
    }

    method estaConformeConSuDisfraz(){
        return self.estaConformeCon(disfrazQueUsa)
    }
}

class PersonaNumerologa inherits Persona{
    var unaCifra

    override method estaConformeCon(unDisfraz){
        return unDisfraz.puntaje(self) > 10 && unDisfraz.puntaje(self) == unaCifra
    }

    method estaConformeConSuDisfraz(){
        return self.estaConformeCon(disfrazQueUsa)
    }
}

// PERSONALIDADES
object alegre{
    method esSexie(unaPersona){
        return false
    }
}

object taciturna{
    method esSexie(unaPersona){
        return unaPersona.esMenorDe(30)
    }
}

object cambiante{
    method esSexie(){
        return [alegre, taciturna].anyOne().esSexie()
    }
}