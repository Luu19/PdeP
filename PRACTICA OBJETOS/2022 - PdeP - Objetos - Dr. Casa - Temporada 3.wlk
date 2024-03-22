/* PRACTICA 2022: DR. CASA */
/*
------------------------------------- PRACTICA 2022: DR. CASA PARTE 1 -------------------------------------
Una persona:
    ->puede contraer enfermedades
    ->cuando una persona vive un dia, la enfermedad causa efecto
    ->tiene cantidad de celulas
    -> se conoce la temperatura 
    -> temperatura > 45, queda en coma

Una enfermedad:
    ->tiene cantidad de celulas que amenaza de la persona
    ->la cantidad de celulas puede cambiar
    ->son agresivas o no
Las enfermedades se dividen en:
    ->infecciosa: aumentan temperatura de la persona en tantos grados como (cantidad celulas amenazadas / 1000)
        Se pueden reproducir y aumenta el doble la cantidad de celulas amenazadas
        Una enfermedad infecciosa es agresiva si la cantidad de celulas amenazadas supera el 10% de las 
        celulas totales de la persona
    ->autoinmunes: destruyen la cantidad de celulas amenazadas de la persona
        Una enfermedad autoinmune es agresiva si afecto a la persona mas de un mes, es decir si causo efecto
        +30 veces


------------------------------------- PRACTICA 2022: DR. CASA PARTE 2 -------------------------------------
Los MEDICOS:
    ->saben atender a los pacientes, esto consiste en darles una dosis de medicamento propia de cada medico
    ->si contraen una enfermedad tratan de curarse a si mismos
Existen MEDICOS que son JEFES DE DEPARTAMENTO:
    ->cuando tienen que atender a un paciente le ordenan a uno de sus subordinados que lo haga

Cuando el paciente/persona recibe el medicamente las enfermedades se atenuan:
    ->cada enfermedad se atenua en la cantidad de medicamento recibida * 15
    ->las enfermedades se curan en caso de que no afecten a mas celulas


------------------------------------- PRACTICA 2022: DR. CASA PARTE 3 -------------------------------------
Los pacientes/personas se puede hacer transfuciones de celulas:
    ->deben ser compatibles segun factor sanguineo 
    *Los A pueden donar a los A, a los R y reciben de A y O
    *Los R solo puede donar a R pero reciben de todos
    *Los O donan a todos pero reciben solo de A
    ->la cantidad a donar debe ser mayor a 500 celulas pero menor o igual a un cuarto de celulas totales
    ->cuando se realiza la transfusion el donante resta la cantidad que dona y el receptor aumenta la 
    cantidad que donaron
    ->en caso de que no se pueda realizar la transfusion, lanzar excepcion

*/
/* Punto a y b */
const malaria500 = new EnfermedadInfecciosa(cantidadCelulasAmenazadas = 500)
const malaria800 = new EnfermedadInfecciosa(cantidadCelulasAmenazadas = 800)
const otitis = new EnfermedadInfecciosa(cantidadCelulasAmenazadas = 100)
const lupus = new EnfermedadAutoinmune(cantidadCelulasAmenazadas = 10000) 

/* ENFERMEDAD */
class Enfermedad{
    var property cantidadCelulasAmenazadas
    
    method atenuarse(unaCantidad){
        cantidadCelulasAmenazadas -= unaCantidad
    }

    method estaCurada(){
        return cantidadCelulasAmenazadas <= 0
    }

    method afectarA(unaPersona)

    method esAgresivaPara(unaPersona)

}

class EnfermedadInfecciosa inherits Enfermedad{

    method reproducir(){
        cantidadCelulasAmenazadas *= 2
    }

    override method afectarA(unaPersona){
        unaPersona.aumentarTemperatura(cantidadCelulasAmenazadas / 10000)
    }

    override method esAgresivaPara(unaPersona){
        return cantidadCelulasAmenazadas > unaPersona.cantidadDeCelulas() * 0.1
    }

}

class EnfermedadAutoinmune inherits Enfermedad{
    var diasQueAfectoEnfermedad

    override method afectarA(unaPersona){
        unaPersona.destruirCelulasEn(cantidadCelulasAmenazadas)
        diasQueAfectoEnfermedad++
    }

    override method esAgresivaPara(unaPersona){
        return diasQueAfectoEnfermedad > 30
    }
}

object LaMuerte inherits Enfermedad(cantidadCelulasAmenazadas = 0){
    override method atenuarse(unaCantidad){

    }

    override method afectarA(unaPersona){
        unaPersona.disminuirTodaLaTemperatura()
    }

    override method esAgresivaPara(unaPersona){
        return true
    }

}

/* PERSONA */
class Persona{
    var enfermedades = #{}
    var property cantidadDeCelulas
    var property temperatura
    var property factorSanguineo

    method contraerEnfermedad(unaEnfermedad){
        enfermedades.add(unaEnfermedad)
    }

    method vivirUnDia(){
        enfermedades.forEach({ unaEnfermedad => unaEnfermedad.afectarA(self) })
    }

    method aumentarTemperatura(unaCantidad){
        temperatura += unaCantidad
        self.verificarComa()
    }

    method destruirCelulasEn(unaCantidad){
        cantidadDeCelulas -= unaCantidad
    }

    method verificarComa(){
        if(self.estaEnComa()){
            throw new Exception(message = "ESTOY EN COMA!")
        }
    }

    method estaEnComa(){
        return temperatura >= 45 or cantidadDeCelulas < 1000000
    }

    method cantidadCelulasAfectadasPorEnfermedadesAgresivas(){
        return self.enfermedadesAgresivas().sum({ unaEnfermedad => unaEnfermedad.cantidadCelulasAmenazadas() })
    }

    method enfermedadesAgresivas(){
        return enfermedades.filter({ unaEnfermedad => unaEnfermedad.esAgresivaPara(self) })
    }

    method enfermedadQueMasCelulasAfecta(){
        return enfermedades.max({ unaEnfermedad => unaEnfermedad.cantidadCelulasAmenazadas() })
    }

    method vivirUnMes(){
        31.times({ i => self.vivirUnDia() })
    }

    method recibirMedicamento(unaCantidad){
        enfermedades.forEach({ unaEnfermedad => unaEnfermedad.atenuarse(unaCantidad) })
        enfermedades.removeAllSuchThat({ unaEnfermedad => unaEnfermedad.estaCurada() })
    }

    method disminuirTodaLaTemperatura(){
        self.temperatura(0)
    }

    method donarA(unaPersona, unaCantidadDeCelulas){
        self.validarDonacion()
        self.realizarDonacion(unaPersona, unaCantidadDeCelulas)
    }

    method validarDonacion(){
        if(!self.puedeDonarA(unaPersona, unaCantidadDeCelulas)){
            throw new Exception(message = "No puede donar")
        }
    }

    method puedeDonarA(unaPersona, unaCantidadDeCelulas){
        return self.esCompatibleCon(unaPersona) && self.puedeDonarCelulas(unaCantidadDeCelulas)
    }

    method realizarDonacion(unaPersona, unaCantidadDeCelulas){
        self.reducirCantidadCelulas(unaCantidadDeCelulas)
        unaPersona.aumentarCantidadCelulas(unaCantidadDeCelulas)
    }

    method reducirCantidadCelulas(unaCantidad){
        cantidadDeCelulas -= unaCantidad
    }

    method aumentarCantidadCelulas(unaCantidad){
        cantidadDeCelulas += unaCantidad
    }

    method esCompatibleCon(unaPersona){
        return factorSanguineo.puedeDonarleA(unaPersona.factorSanguineo())
    }

    method puedeDonarCelulas(unaCantidadDeCelulas){
        return unaCantidadDeCelulas > 500 && unaCantidadDeCelulas < cantidadDeCelulas / 4 
    }

}

/* MEDICO */
class Medico inherits Persona{
    var dosisDeMedicamento

    method atenderA(unaPersona){
        unaPersona.recibirMedicamento(dosisDeMedicamento * 15)
    }

    method contraerEnfermedad(unaEnfermedad){
        super(unaEnfermedad)
        self.atenderA(self)
    }
}

class JefeDeDepartamento inherits Medico{
    var subordinados = #{}

    override method atenderA(unaPersona){
        subordinados.anyOne().atenderA(unaPersona)
    }
}

/* FACTOR SANGUINEO */
object factorA{
    method puedeDonarleA(otroFactor){
        return [factorA, factorR].contains(otroFactor) && otroFactor.puedeRecibir(self)
    }

    method puedeRecibir(unFactor){
        return [factorA, factorO].contains(unFactor)
    }
}

object factorR{
    method puedeDonarleA(otroFactor){
        return factorR.equals(otroFactor) && otroFactor.puedeRecibir(self)
    }

    method puedeRecibir(unFactor){
        return true
    }
}

object factorO{
    method puedeDonarleA(otroFactor){
        return otroFactor.puedeRecibir(self)
    }

    method puedeRecibir(unFactor){
        return unFactor.equals(factorA)
    }
}