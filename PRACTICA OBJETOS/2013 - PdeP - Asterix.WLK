/* 2013 PARCIAL : ASTERIX */
/*
Las PERSONAS pueden mejorar su desempeño tomando pociones mágicas
Las PERSONAS tienen:
    ->fuerza
    ->resistencia

Una POCION se prepara mezclando diferentes ingredientes y el efecto de la poción depende
de la fuerza y resistencia de la persona. 
Los INGREDIENTES:
    ->dulce de leche: + 10 ptos de fuerza, si la persona no está en combate, la revive con + 2 ptos resistencia
    ->puñado de hongos silvestres: + ptos fuerza como cantidadHongos haya en el puñado, si son
    cantidadHongos > 5 disminuye a la mitad la resistencia
    ->grog: quien lo ingiera es + fuerte como ingredientes tenga la pocion
    ->grog XD: mismo efecto que grog y duplica la resistencia

Las personas se puede organizar en EJERCITOS
Los EJERCITOS luchan contra:
    ->ejercitos
    ->persona

Existen ejercitos romanos denominados LEGIONES que adoptan diferentes formaciones (pueden cambiar en cualquier momento):
    ->tortuga: defensiva, poder = 0, ningun integrante recibe daño, sin importan el daño que le causen a la legion
    ->en cuadro: mismo comportamiento que los ejercitos comunes, menos la cantidad de integrantes al frente,
    esa cantidad se determina al armar la formacion
    ->frontem allargate: el poder de la legion es + 10% de lo normal, la mitad de los integrantes va adelante
    el daño a recibir se duplica
Si queda con un poder debajo de lo establecido (el mismo para todas las legiones), la formacion debe volver 
a tortuga
*/

//PERSONA
class Persona{
    var resistencia
    var fuerza
    var property estaEnCombate = true

    method poder(){
        return fuerza * resistencia
    }

    method recibirDanio(unaCantidad){
        resistencia -= unaCantidad
        self.validarResistencia()
    }

    method validarResistencia(){
        if(resistencia <= 0){
            self.quedarFueraDeCombate()
        }
    }

    method quedarFueraDeCombate(){
        estaEnCombate = false
    }

    method tomarUnaPocion(unaPocion){
        unaPocion.afectarA(self)
    }

    method aumentarFuerzaEn(unaCantidad){
        fuerza += unaCantidad
    }

    method aumentarResistenciaEn(unaCantidad){
        resistencia += unaCantidad
    }

    method revivir(){
        estaEnCombate = true
    }

    method disminuirMitadDeResistencia(){
        resistencia -= resistencia / 2
    }

    method duplicarResistencia(){
        resistencia *= 2
    }
}

//POCION
class Pocion{
    const unosIngredientes

    method afectarA(unaPersona){
        unosIngredientes.forEach({ unIngrediente => unIngrediente.surtirEfectoPara(unaPersona, self.cantidadIngredientes()) })
    }

    method cantidadIngredientes(){
        return unosIngredientes.size()
    }
}

//INGREDIENTES
object dulceDeLeche{
    method surtirEfectoPara(unaPersona, cantidadIngredientesPocion){
        if(unaPersona.estaEnCombate()){ 
            unaPersona.aumentarFuerzaEn(10) 
        }else{
            unaPersona.revivir() 
            unaPersona.aumentarResistenciaEn(2) 
        }
        //Tengo mis dudas con este punto, capaz pueda delegar para que no esté ese feo if
    }
}

class PuniadoDeHongos{
    var cantidadDeHongos

    method surtirEfectoPara(unaPersona, cantidadIngredientesPocion){
        unaPersona.aumentarFuerzaEn(cantidadDeHongos)
        self.correspondeDisminuirResistencia(unaPersona)
    }

    method correspondeDisminuirResistencia(unaPersona){
        if(cantidadDeHongos > 5){
            unaPersona.disminuirMitadDeResistencia() 
        }
    }
}

class Grog{
    method surtirEfectoPara(unaPersona, cantidadIngredientesPocion){
        unaPersona.aumentarFuerzaEn(cantidadIngredientesPocion) 
    }
}

const grog = new Grog()

object grogXD inherits Grog{
    override method surtirEfectoPara(unaPersona, cantidadIngredientesPocion){
        super(unaPersona, cantidadIngredientesPocion) 
        unaPersona.duplicarResistencia()
    }
}

//EJERCITO
class Ejercito{
    var soldados = #{}

    method poder(){
        return self.soldadosEnCombate().sum({ unSoldado => unSoldado.poder() })
    }

    method soldadosEnCombate(){
        return soldados.filter({ unSoldado => unSoldado.estaEnCombate() })
    }

    method recibirDanio(unaCantidad){
        self.soldadosOrganizados().forEach({ unSoldado => unSoldado.recibirDanio(self.danioPorCadaSoldado(unaCantidad)) })
    }

    method pelearContra(unEnemigo){
        self.validarEstadoDeSoldados()
        self.daniarAlMasDebilEn(self.diferenciaDePoderCon(unEnemigo))
    }

    method daniarAlMasDebilEn(unaCantidad){
        self.soldadosEnCombate().min({ unSoldado => unSoldado.poder() }).recibirDanio(unaCantidad)
    }

    method validarEstadoDeSoldados(){
        if(self.todosEstanFueraDeCombate()){
            throw new Exception(message = "Vamos a perder como en la guerra")
        }
    }

    //METODOS TÉCNICOS
    method danioPorCadaSoldado(unaCantidad){
        return unaCantidad / self.cantidadSoldadosQueVanAdelante()
    }

    method diferenciaDePoderCon(unEnemigo){
        return (unEnemigo.poder() - self.poder()).abs()
    }

    method todosEstanFueraDeCombate(){
        return soldados.all({ unSoldado => not unSoldado.estaEnCombate() })
    }

    method soldadosOrganizados(){
        soldados.sortedBy({ unS1, unS2 => unS1.poder() > unS2.poder() })
    }

    method cantidadSoldadosQueVanAdelante(){
        return self.soldadosQueVanAdelante().size()
    }

    method soldadosQueVanAdelante(){
        if(self.soldadosOrganizados().size() <= self.cantidadSoldadosAdelante()){
            return self.soldadosOrganizados()
        }else{
            return self.soldadosOrganizados().take(self.cantidadSoldadosAdelante())
        }
    }

    method cantidadSoldados(){
        return soldados.size()
    }

    method cantidadSoldadosAdelante(){
        return 10
    }
}

//LEGIONES
class Legion inherits Ejercito{
    var unaFormacion
    var minimoDePoder

    override method poder(){
        return unaFormacion.poder(super())
    }

    method cambiarFormacion(formacionNueva){
        unaFormacion = formacionNueva
    }

    override method recibirDanio(unaCantidad){
        self.validarPoder()
        super(unaFormacion.cantidadDanioARecibir(unaCantidad))
    }

    override method cantidadSoldadosAdelante(){
        return unaFormacion.cantidadSoldadosAdelante()
    }

    method validarPoder(){
        if(self.poder() < minimoDePoder){
            self.cambiarFormacion(tortuga)
        }
    }
}

//FORMACIONES
object tortuga{

    method poder(unaCantidad){
        return 0
    }

    method cantidadDanioARecibir(unaCantidad){
        return 0
    }
}

class EnCuadro{
    var cantidadIntegrantesAdelante

    method poder(unaCantidad){
        return unaCantidad
    }

    method cantidadDanioARecibir(unaCantidad){
        return unaCantidad
    }

    method cantidadSoldadosAdelante(unEjercito){
        return cantidadIntegrantesAdelante
    }
}

object frontemAllagarte{
    method poder(unaCantidad){
        return unaCantidad + unaCantidad * 0.1
    }

    method cantidadDanioARecibir(unaCantidad){
        return 2 * unaCantidad
    }

    method cantidadSoldadosAdelante(unEjercito){
        return unEjercito.cantidadSoldados() / 2
    }
}
