/* 2014 PARCIAL: MINIONS */
/*
Existen dos razas de EMPLEADOS:
    ->biclopes: dos ojos, utiles para todas las tareas, estamina limitada a 10 puntos
    ->ciclopes: un solo ojo, aciertan a la mitad de los disparos, no tienen estamina limitada

Cada EMPLEADO tiene:
    ->un rol que puede cambiar
        *soldado: equipados con un arma para defender un sector, cada vez que usa el arma, gana practica y 
        suma puntos incrementando en 2 el danio que causa. Si cambia el rol, se pierde toda la practica
        *obrero: tienen cinturon con herramientas
        *mucama: no defienden sectores

Tareas de laboratorio:
    ->arreglar una maquina: tiene una complejidad,
    las maquinas requieren de distintas herramientas para arreglarla, quien arregla
    debe tener tanta estamina como complejidad tenga la maquina
        *Quien arregla pierde tantos puntos de estamina como complejidad tenga la maquina
        *La dificultad de esta tarea es el doble de la complejidad de la maquina
    ->defender sector: el empleado NO debe ser mucama y el empleado debe tener fuerza >= al nivel amenaza
    *La fuerza de un empleado es (estamina / 2 + 2) de acuerdo a:
        *Soldados suman fuerza el danio que causan por practica
        *ciclopes usan mitad de fuerza total
    ->limpiar un sector: dificultad = 10 (se debe poder modificar), para limpiar se requiere al menos
    estamina = 4 si el sector es grande, 1 en otro caso (si el sector no es grande), al limpiar se pierde
    tanta estamina como la requerida para limpiar el sector, a menos que el empleado sea una mucama. Las
    mucamas siempre puede limpiar y no pierden estamina al hacerlo

Para recuperar la estamina los empleados comen FRUTA:
    ->bananas: recuperan 10 ptos
    ->manzanas: recuperan 5 ptos
    ->uvas: recuperan 1 pto
*/

class Empleado{
    var estamina
    var tareasRealizadas
    var rol

    method comerFruta(unaFruta){
        self.aumentarEstaminaEn(unaFruta.valorNutritivo())
    }

    method aumentarEstaminaEn(unaCantidad){
        estamina += unaCantidad
    }

    method experienciaDeEmpleado(){
        return self.cantidadTareasRealizadas() * self.sumatoriaDeDificultadDeTareas()
    }

    method cantidadTareasRealizadas(){
        return tareasRealizadas.size()
    }

    method sumatoriaDeDificultadDeTareas(){
        return tareasRealizadas.sum({ unaTarea => unaTarea.dificultad() })
    }

    method realizarTarea(unaTarea){
        const unEmpleado = self.quienDelegaTarea()
        unaTarea.puedeSerRealizadaPor(unEmpleado)
        unaTarea.serRealizadaPor(unEmpleado)
        self.agregarTareaRealizada(unaTarea)
    }

    method agregarTareaRealizada(unaTarea){
        tareasRealizadas.add(unaTarea)
    }

    method perderPuntosDeEstamina(unaCantidad){
        estamina -= unaCantidad
    }

    method tieneEstaminaMayorA(unaCantidad){
        return estamina > unaCantidad
    }

    method tieneHerramientas(unasHerramientas){
        return rol.tieneHerramientas(unasHerramientas) //solo para los obreros
    }

    method fuerza(){
        return rol.fuerzaEmpleado() + estamina / 2 + 2
    }

    method puedeDefenderSector(){ //menos para mucama
        return rol.puedeDefenderSector()
    }

    method perderEstaminaAlDefender(){
        rol.perderEstaminaAlDefender(self, estamina / 2)
    }

    method razaDificultadAlDefender(unaCantidad) //este es abstracto

    method perderPuntosAlLimpiar(unaCantidad){
        rol.perderPuntosAlLimpiar(self, unaCantidad)
    }

    method quienDelegaTarea(){
        return rol.quienDelegaTarea(self)
    }

}

//ROLES
class Rol{
    method puedeDefenderSector(){
        return true
    }

    method tieneHerramientas(unasHerramientas){
        return false
    }

    method fuerzaEmpleado(){
        return 0
    }

    method perderPuntosAlLimpiar(unaCantidad){
        rol.perderPuntosAlLimpiar(self, unaCantidad)
    }

    method perderEstaminaAlDefender(unEmpleado, unaCantidad){
        unEmpleado.perderPuntosDeEstamina(unaCantidad)
    }

    method quienDelegaTarea(unEmpleado){
        return unEmpleado
    }
}

class Obreros inherits Rol{
    var herramientas

    override method tieneHerramientas(unasHerramientas){
        return unasHerramientas.all({ unaHerramienta => herramientas.contains(unaHerramienta) })
    }

}

object Mucama inherits Rol{
    override method puedeDefenderSector(){
        return false
    }

    override method perderPuntosAlLimpiar(unaCantidad){
        //no pierde nada
    }

    override method perderEstaminaAlDefender(unEmpleado, unaCantidad){
        //tecnicamente siquiera deberia tener el metodo 
        //pero por cuestiones de polimorfismo me parecio adecuado agregarlo
    }

}

class Soldado{
    var arma
    var practica

    override method fuerzaEmpleado(){
        return practica
    }

    override method perderEstaminaAlDefender(unEmpleado, unaCantidad){
        arma.incrementaDanio(2)
        practica++
    }
}

class Arma{
    var danio

    method incrementaDanio(unaCantidad){
        danio += unaCantidad
    }
}

//ROL AGREGADO

class Capataz inherits Rol{
    var subordinados = #{}
    override method quienDelegaTarea(unEmpleado){
        return subordinados.findOrDefault({ unSubordinado => unSubordinado.experienciaDeEmpleado() }, 
                                          { unEmpleado })
        //No entendi si trata de quien tiene más experiencia en UNA tarea, pero como tampoco se habla del
        //nivel de experiencia en una tarea, tome sobre el conjunto de tareas que se habla en el punto 2
    }
}

//RAZAS
class EmpleadoBiclope inherits Empleado{

    method razaDificultadAlDefender(unaCantidad){
        return unaCantidad
    }

    method override aumentarEstaminaEn(unaCantidad){
        estamina = (estamina + unaCantidad).min(10)
    }
}

class EmpleadoCiclope inherits Empleado{
    method razaDificultadAlDefender(unaCantidad){
        return unaCantidad * 2
    }

    override method fuerza(){
        return super() / 2
    }
}

//TAREAS
class Tarea{
    var mensajeDeError

    method puedeSerRealizadaPor(unEmpleado){
        if(!self.tieneLoNecesarioParaRealizarTarea(unEmpleado)){
            mensajeDeError.aply()
        }
    }

    method serRealizadaPor(unEmpleado)

    method tieneLoNecesarioParaRealizarTarea(unEmpleado)

    method dificultad(unEmpleado)
}


class ArreglasMaquina inherits Tarea{
    var complejidadMaquina
    var herramientasNecesarias
    var mensajeDeError = { throw new Exception(message = "No puede arreglar la maquina") }

    override method serRealizadaPor(unEmpleado){
        unEmpleado.perderPuntosDeEstamina(complejidadMaquina)
    }

    override method tieneLoNecesarioParaRealizarTarea(unEmpleado){
        return unEmpleado.tieneEstaminaMayorA(complejidadMaquina) && unEmpleado.tieneHerramientas(herramientasNecesarias)
    }

    override method dificultad(unEmpleado){
        return complejidadMaquina * 2
    }
}

class DefenderSector inherits Tarea{
    var gradoAmenaza
    var mensajeDeError = { throw new Exception(message = "No puede defender este sector") }

    override method tieneLoNecesarioParaRealizarTarea(unEmpleado){
        return unEmpleado.puedeDefenderSector() && unEmpleado.fuerza() >= gradoAmenaza 
    }

    override method serRealizadaPor(unEmpleado){
        unEmpleado.perderEstaminaAlDefender()
    }

    //TENGO MUCHISIMAS DUDAS CON ESTA PARTE
    method dificultad(unEmpleado){
        return unEmpleado.razaDificultadAlDefender(gradoAmenaza)
    }
}

class LimpiarSector inherits Tarea{
    var dificultad
    var tamanioSector
    var mensajeDeError = { throw new Exception(message = "No puede limpiar este sector") }

    override method tieneLoNecesarioParaRealizarTarea(unEmpleado){
        return unEmpleado.tieneEstaminaMayorA(tamanioSector.estaminaNecesaria())
    }

    override method serRealizadaPor(unEmpleado){
        unEmpleado.perderPuntosAlLimpiar(tamanioSector.estaminaNecesaria())
    }

    override method dificultad(unEmpleado){
        return dificultad
    }
}

object grande{
    method estaminaNecesaria(){
        return 4
    }
}

object otroTamanio{
    method estaminaNecesaria(){
        return 1
    }
}


//FRUTAS
//dependiendo de la fruta se va a modelar
class Fruta{
    var valorNutritivo

    method valorNutritivo(){
        return valorNutritivo
    }
}
const banana = new Fruta(valorNutritivo = 10)
const manzana = new Fruta(valorNutritivo = 5)
const uvas = new Fruta(valorNutritivo = 1)

