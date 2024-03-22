/* PARCIAL 2022: INTENSAMENTE */

/*
Supongamos a Riley un estandar de PERSONA
Las PERSONAS tienen nivel de felicidad y una emocion dominante la cual puede cambiar

Cuando una PERSONA vive un EVENTO el recuerdo asociado se agrega a sus recuerdos del dia con descripcion, fecha
y la emocion dominante de la PERSONA en el momento

Los recuerdos se asientan de maneras diferentes segun la emocion dominante del recuerdo:
    ->alegria y nivelDeFelicidad > 500: el recuerdo se convierte en un pensamiento central
    ->triste: el recuerdo se convierte en un pensamiento central, disminuye el coeficiente de la persona en 10%
    (el nivelDeFelicidad no puede quedar por debajo de 1)
    ->disgusto, furia o temor: no pasa nada
*/

/* RECUERDOS */
class Recuerdo{
    var descripcion
    var fecha
    var property emocion

    method esDificilDeExplicar(){
        return descripcion.words().size() > 10
    }

    method esAlegre(){
        return emocion.equals(alegria)
    }

    method tienePalabra(unaPalabra){
        descripcion.words().contains(unaPalabra)
    }

    method tieneEmocion(unaEmocion){
        return emocion.equals(unaEmocion)
    }

    method puedeRememorarse(unaPersona){
        return unaPersona.edad() / 2 < (new Date()).year() - fecha.year()
    }
}

/* PERSONA */
class Persona{
    var edad
    var recuerdosDelDia = #{}
    var emocionDominante
    var nivelDeFelicidad
    var property pensamientosCentrales = #{} // con el property queda hecho el punto 4
    var procesosMentales = []
    var memoriaALargoPlazo = #{}
    var property pensamientoActual

    method vivirUnEvento(unaDescripcion){
        recuerdosDelDia.add(new Recuerdo( descripcion = unaDescripcion, fecha = new Date(), emocion = emocionDominante ))
    }

    method asentarRecuerdo(unRecuerdo){
        emocionDominante.asentarRecuerdo(unRecuerdo, self)
    }

    method agregarPensamientoCentral(unRecuerdo){
        pensamientosCentrales.add(unRecuerdo)
    }

    method disminuyeCoeficienteFelicidad(unPorcentaje){
        nivelDeFelicidad -=  nivelDeFelicidad * unPorcentaje/100
        self.validarFelicidad()
    }

    method validarFelicidad(){
        if(nivelDeFelicidad < 1){
            throw new Exception(message = "Muy triste")
        }
    }

    method tieneFelicidadMayor(unaCantidad){
        return nivelDeFelicidad > unaCantidad
    }

    method recuerdosRecientes(){
        return recuerdosDelDia.reverse().take(5) // teniendo en cuenta que los mas recientes se agregan al final
    }

    method pensamientosCentralesDificilesDeExplicar(){
        return pensamientosCentrales.filter({ unPensamiento => unPensamiento.esDificilDeExplicar() })
    }

    method niegaRecuerdo(unRecuerdo){
        return emocionDominante.niega(unRecuerdo)
    }

    method dormir(){
        self.ordenarProcesosMentales()
        procesosMentales.forEach({ unProceso => unProceso.aply(self) })
    }

    method ordenarProcesosMentales(){
        if(procesosMentales.contains(liberarDeRecuerdos)){
            procesosMentales.remove(liberarDeRecuerdos)
            procesosMentales.add(liberarDeRecuerdos)
        }
    }
    
    method asentarRecuerdos(unosRecuerdos){
        unosRecuerdos.forEach({ unRecuerdo => self.asentarRecuerdo(unRecuerdo) })
    }

    method asentarRecuerdosDelDia(){
        self.asentarRecuerdos(unosRecuerdos)
    }

    method asentarRecuerdosQueTenganPalabra(palabraClave){
        self.asentarRecuerdos(recuerdosDelDia.filter({ unRecuerdo => unRecuerdo.tienePalabra(palabraClave) }))
    }

    method realizarProfundizacion(){
        self.recuerdosAProfundizar().forEach({ unRecuerdo => self.profundizar(unRecuerdo) })
        /*self.profundizarRecuerdos(self.recuerdosAProfundizar())
            method profundizarRecuerdos(unosRecuerdos){
                unosRecuerdos + memoriaALargoPlazo
            }
         */
    }

    method profundizar(unRecuerdo){
        memoriaALargoPlazo.add(unRecuerdo)
    }

    method puedeTenerDesequilibrioHormonal(){
        return self.hayPensamientoCentralEnMemoriaALargoPlazo() or self.todosLosRecuerdosDelDiaTienenLaMismaEmocion()
    }

    method hayPensamientoCentralEnMemoriaALargoPlazo(){
        pensamientosCentrales.any({ unRecuerdo => memoriaALargoPlazo.contains(unRecuerdo) })
    }

    method todosLosRecuerdosDelDiaTienenLaMismaEmocion(){
        const emocionDeRecuerdo = recuerdosDelDia.anyOne().emocion()
        recuerdosDelDia.all({ unRecuerdo => unRecuerdo.tieneEmocion(emocionDeRecuerdo) })
    }

    method tenerDesequilibrioHormonal(){
        self.disminuirPorcentajeDeFelicidad(15)
        self.perderTresPensamientosCentralesAntiguos()
    }

    method disminuirPorcentajeDeFelicidad(unPorcentaje){
        nivelDeFelicidad -= nivelDeFelicidad * unPorcentaje/100
    }

    method perderTresPensamientosCentralesAntiguos(){
        pensamientosCentrales = pensamientosCentrales.sortedBy { r1, r2 => r1.fecha() < r2.fecha() }.drop(3)
    }

    method restaurarFelicidadEn(unaCantidad){
        nivelDeFelicidad += unaCantidad
    }

    method liberarDeRecuerdosDelDia(){
        recuerdosDelDia = #{}
    }

    method rememorar(){
        pensamientoActual = memoriaALargoPlazo.find({ unRecuerdo => unRecuerdo.puedeRememorarse(self) })
    }

    method cantidadDeRepeticionesDe(unRecuerdo){
        return memoriaALargoPlazo.ocurrencesOf(unRecuerdo)
    }

    method tieneUnDejaVu(){
        self.esRecuerdoRepetido(pensamientoActual)
    }

    method esRecuerdoRepetido(pensamientoActual){
        if(cantidadDeRepeticionesDe(unRecuerdo) >= 1){
            return true
        }else{
            return false
        }
    }
}

/* PROCESO MENTALES */

object asentamiento{
    method aply(unaPersona){
        unaPersona.asentarRecuerdosDelDia()
    }
}

class AsentamientoSelectivo{
    var palabraClave

    method aply(unaPersona){
        unaPersona.asentarRecuerdosQueTenganPalabra(palabraClave)
    }
}

object profundizacion{
    method aply(unaPersona){
        unaPersona.realizarProfundizacion()
    }
}

object controlHormonal{
    method aply(unaPersona){
        if(unaPersona.puedeTenerDesequilibrioHormonal()){
            unaPersona.tenerDesequilibrioHormonal()
        }
    }
}

object restauracionCognitiva{
    method aply(unaPersona){
        unaPersona.restaurarFelicidadEn(100)
    }
}

object liberarDeRecuerdos{
    method aply(unaPersona){
        unaPersona.liberarRecuerdosDelDia()
    }
}

/* ESTADOS */
class Estado{
    method asentarRecuerdo(unRecuerdo, unaPersona){

    }

    method niega(unRecuerdo){
        return false
    }

    method esAlegre(){
        return false
    }
}

object alegria inherits Estado{
    override method asentarRecuerdo(unRecuerdo, unaPersona){
        if(unaPersona.tieneFelicidadMayor(500)){
            unaPersona.agregarPensamientoCentral(unRecuerdo)
        }
    }

    override method niega(unRecuerdo){
        return not unRecuerdo.esAlegre() 
    }

    override method esAlegre(){
        return true
    }
}

object tristeza inherits Estado{
    override method asentarRecuerdo(unRecuerdo, unaPersona){
        unaPersona.agregarPensamientoCentral(unRecuerdo)
        unaPersona.disminuyeCoeficienteFelicidad(10)
    }

    override method niega(unRecuerdo){
        return unRecuerdo.esAlegre()
    }
}

const desagrado = new Estado()
const temor = new Estado()


/* EMOCIONES COMPUESTAS */
class EmocionesCompuestas{
    var emociones = []

    method niegaRecuerdo(unRecuerdo){
        emociones.all({ unaEmocion => unaEmocion.niega(unRecuerdo) })
    }

    method esAlegre(){
        emociones.any({ unaEmocion => unaEmocion.esAlegre() })
    }

    method asentarRecuerdo(unRecuerdo, unaPersona){
        emociones.forEach({ unaEmocion => unaEmocion.asentarRecuerdo(unRecuerdo, unaPersona) })
    }
}