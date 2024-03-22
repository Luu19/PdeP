/* 2011 PARCIAL : ERAGON / MUNDO ÉPICO */
/*
Todo PERSONAJE tiene
    ->nivel de aptitud
        *Humano, fuerza de voluntad (propia de cada ser) + aptitud del bando al cual pertenezca
            ->algunos humanos nacen como jinetes de dragón y su nivel de aptitud es el mismo que se calcula
            para el ser humano + la aptitud del dragón
            ->los humanos no poseen magia, es decir magia = 0, pero
            los jinetes de dragon tienen magia que se calcula la habilidad nata (7) * puntos magicos de dragon
        *Dragon, siempre es 42
            ->la magia varía para cada dragon
        *Sombra, cantidad de espíritus malignos que posea (propio de cada sombra) * sus puntos mágicos
            ->la magia es cantidad de espíritus mágicos * 5 + 15
    ->bando al que pertenece
Todo HUMANO puede derrotar a un contrincante si lo supera en aptitud
    ->para el caso de un jinete debe ser del bando contrario del contrincante
Las SOMBRAS pueden derrotar a un contrincante si lo supera en al menos 10 puntos de magia 

Existen dos bandos principales
    ->vardenos
    ->el imperio
Los ideales del bando guían las acciones de quien pertenece a él
Un BANDO tiene un líder que suma moral y fuerza al equipo
Los líderes se eligen 
    ->lider vardeno, tiene mayor aptitud entre todos los vardenos
    ->lider del imperio, no se elige y es siempre el mismo
Dentro de cada bando hay mujeres y ninios, no deben involucrarse en las peleas
Cuando hay guerra cada bando elige de acuerdo a
    ->los humanos vardenos van a la lucha si su aptitud es mayor a 18
    ->los humanos del imperio van a la lucha siempre
    ->los dragones van a la lucha siempre
    ->las sombras van a la lucha si tienen al menos 5 espíritus malignos
    ->los jinetes van a la lucha si su dragón los respeta

De un EJERCITO sabemos
    ->poder de ataque es la suma de la aptitud de sus integrantes + los puntos de moral (varían con cada ejercito)

Los DRAGONES evalúan a los personajes y deciden si merecen respeto o no
    ->dragones de vardenos, respetan a quienes tienen una aptitud mayor a 30 y sean vardenos
    ->dragones del imperio, respetan a quienes tengan aptitud mayor que la de ellos
*/

//OBJETOS UTILES
object builderDeEjercito{
    method armarEjercito(integrantesEjercito){
        return new Ejercito(integrantes = integrantesEjercito, puntosMoral = 0)
    }
}


//PERSONAJES
class Humano{
    var fuerzaDeVoluntad
    const suBando
/*
    Nunca dice que un Humano/Personaje cambia de bando sin embargo al realizarlo con composición es más sencillo
    dado que luego si tenemos que hacer heredar JineteDeDragon de Humano, hay un conflicto, sin embargo eso
    podría arreglarse con una clase intermedia de esto, es decir HumanoIntermedio inherits Humano,
    poner el método correspondiente y a su vez heredar HumanoVardeno inherits HumanoIntermedio y
    HumanoImperio inherits HumanoIntermedio
*/
    method puedeDerrotarA(unPersonaje){
        return self.nivelDeAptitud() > unPersonaje.nivelDeAptitud()
    }

    method nivelDeAptitud(){
        return fuerzaDeVoluntad + suBando.nivelDeAptitud()
    }

    method puntosDeMagia(){
        return 0
    }

    method tieneNivelDeAptitudMayorA(unaCantidad){
        return self.nivelDeAptitud() > unaCantidad
    }

    method esVardeno(){
        return suBando.equals(vardeno)
    }

    method estaDispuestoALuchar(){
        return suBando.estaListoParaLuchar(self)
    }
}

class JineteDeDragon inherits Humano{
    var suDragon

    override method nivelDeAptitud(){
        return super() + suDragon.nivelDeAptitud()
    }

    override method puntosDeMagia(){
        return self.habilidadNata() * suDragon.puntosDeMagia()
    }

    method habilidadNata(){
        return 7
    }

    method esRespetadoPorSuDragon(){
        return suDragon.respetaA(self)
    }

    override method estaDispuestoALuchar(){
        return self.esRespetadoPorSuDragon()
    }
}

class Sombra{
    var cantidadEspiritusMalignos

    method puedeDerrotarA(unPersonaje){
        return self.puntosDeMagia() > unPersonaje.puntosDeMagia() + 10
    }

    method nivelDeAptitud(){
        return cantidadEspiritusMalignos * self.puntosDeMagia()
    }

    method puntosDeMagia(){
        return cantidadEspiritusMalignos * 5 + 15
    }

    method estaDispuestoALuchar(){
        return cantidadEspiritusMalignos >= 5
    }
}

//DRAGONES
class Dragon{
    const puntosDeMagia

    method nivelDeAptitud(){
        return 42
    }

    method puntosDeMagia(){
        return puntosDeMagia
    }

    method estaDispuestoALuchar(){
        return true
    }

    method bendecirA(unEjercito){
        unEjercito.aumentarMoralEn(self.cantidadPersonajesMerecenRespeto(unEjercito.miembros()))
    }

    method cantidadGuerrerosMerecenRespeto(unosPersonajes){
        return self.personajesQueMerecenRespeto(unosPersonajes).size()
    }

    method personajesQueMerecenRespeto(unosPersonajes){
        return unosPersonajes.filter({ unPersonaje => self.respetaA(unPersonaje) })
    }

    method respetaA(unPersonaje)
}

//TIPOS DRAGONES
class DragonDeVardeno inherits Dragon{
    override method respetaA(unPersonaje){
        return unPersonaje.esVardeno() && unPersonaje.tieneNivelDeAptitudMayorA(30)
    }
}

class DragonDeImperio inherits Dragon{
    override method respetaA(unPersonaje){
        return unPersonaje.tieneNivelDeAptitudMayorA(self.nivelDeAptitud())
    }
}

//EJERCITOS
class Ejercito{
    var integrantes = #{}
    var puntosMoral

    method poderDeAtaque(){
        return self.nivelDeAptitud() + puntosMoral
    }

    method nivelDeAptitud(){
        return integrantes.sum({ unIntegrante => unIntegrante.nivelDeAptitud() })
    }

    method aumentarMoralEn(unaCantidad){
        puntosMoral += unaCantidad
    }
}

//BANDOS
class Bando{
    var miembros = #{}

    method nivelDeAptitud(){
        return miembros.sum({ unMiembro => unMiembro.nivelDeAptitud() })
    }

    method puedeDerrotarA(unBando){
        return self.lider().puedeDerrotarA(unBando.lider())
    }

    method ejercitoDispuestoALuchar(){
        const miembrosDispuestosALuchar = self.miembrosDispuestosALuchar()
        return builderDeEjercito.armarEjercito(miembrosDispuestosALuchar) 
    }

    method miembrosDispuestosALuchar(){
        return miembros.filter({ unMiembro => unMiembro.estaDispuestoALuchar() })
    }

    method lider()
}

object vardeno inherits Bando{

    override method lider(){
        return miembros.max({ unMiembro => unMiembro.nivelDeAptitud() })
    }

    method estaListoParaLuchar(unMiembro){
        return unMiembro.nivelDeAptitud() > 18
    }
}

object imperio inherits Bando{
    var lider

    override method lider(){
        return lider
    }

    method estaListoParaLuchar(unMiembro){
        return true
    }
}