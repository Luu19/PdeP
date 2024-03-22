/*
    Los empleados quedan incapacitados cuando su salud < salud critica
    Empleados tienen salud, habilidades y saber resolver misiones
        -> espias: salud critica = 15, apreden habilidades al completar misiones
        -> oficinistas: salud critica = 40 - 5 * cant estrellas, si sobrevive a una mision gana una estrella
    
    Para resolver mision se puede armar equipos
    Algunos empleados son jefes de otros empleados, pueden ser asistifos por sus empleados cuando la mision
    lo necesite. Los jefes puede ser espias u oficinistas
*/

class Empleado{
    var salud
    var habilidades = []
    var property puesto /* oficinista o espia */

    method estaIncapacitado(){
        return puesto.saludCritica() < salud
    }

    method puedeUsarHabilidad(unaHabilidad){
        return not self.estaIncapacitado() && self.tieneHabilidad(unaHabilidad)
    }

    method tieneHabilidad(unaHabilidad){
        return habilidades.contains(unaHabilidad)
    }

    method cumplirMision(unaMision){
        if(self.puedeCumplirMision(unaMision)){
            unaMision.realizarse(self)
        }
    }

    method puedeCumplirMision(unaMision){
        return unaMision.puedeSerCumplidaPor(self)
    }

    method recibirDanio(unaCantidad){
        salud -= unaCantidad
    }

    method estaVivo(){
        return salud > 0
    }

    method registrarMision(unaMision){
        puesto.registrarMision(unaMision, self)
    }

    method aprenderHabilidades(listaDeHabilidades){
        self.habilidadesQueNoSe(listaDeHabilidades) + habilidades
    }

    method habilidadesQueNoSe(listaDeHabilidades){
        return listaDeHabilidades.filter({ unaHabilidad => not self.tieneHabilidad(unaHabilidad) })
    }

    method habilidades(){
        return habilidades.asSet() // elimina los repetidos
    }

    method sobreviveMision(unaMision){
        if(self.estaVivo()){
            self.registrarMision(unaMision)
        }
    }
}

class Equipo{
    var integrantes = #{}

    method puedeCumplirMision(unaMision){
        return integrantes.any({ unIntegrante => unIntegrante.puedeCumplirMision() })
    }

    method recibirDanio(unaCantidad){
        integrantes.forEach({ unIntegrante => unIntegrante.recibirDanio(unaCantidad / 3) })
    }

    method sobreviveMision(unaMision){
        integrantes.forEach({unIntegrante => unIntegrante.sobreviveMision(unaMision) })
    }

}

class EmpleadoJefe inherits Empleado{
    var subordinados = #{}

    override method puedeUsarHabilidad(unaHabilidad){
        return subordinados.any({ unSubordinado => unSubordinado.puedeUsarHabilidad(unaHabilidad) })
    }
}

/* PUESTOS */
object espia{
    method saludCritica(){
        return 15
    }

    method registrarMision(unaMision, empleado){
        empleado.aprenderHabilidades(unaMision.habilidadesNecesarias())
    }
}

class Oficinista{
    var cantidadEstrellas

    method saludCritica(){
        return 40 - 5 * cantidadEstrellas
    }

    method registrarMision(unaMision, empleado){
        cantidadEstrellas += 1
        self.asciendePuesto(empleado)
    }

    method asciendePuesto(empleado){
        if(cantidadEstrellas == 3){
            empleado.puesto(espia)
        }
    }
}

class Mision{
    var nivelPeligrosidad
    var habilidadesNecesarias

    method puedeSerCumplidaPor(unEmpleado){
        if(!self.tieneTodasLasHabilidades(unEmpleado)){
            throw new Exception(message = "No puede ser cumplida!")
        }
    }

    method tieneTodasLasHabilidades(unEmpleado){
        return habilidadesNecesarias.all({ unaHabilidad => unEmpleado.tieneHabilidad(unaHabilidad) })
    }

    method realizarse(unEmpleado){
        self.puedeSerCumplidaPor(unEmpleado)
        unEmpleado.recibirDanio(nivelPeligrosidad)
        unEmpleado.sobreviveMision(self)
    }

}