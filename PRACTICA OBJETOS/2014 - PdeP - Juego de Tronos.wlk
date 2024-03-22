/* 2014 PARCIAL: JUEGOS DE TRONOS */
/*
De los PERSONAJES sabemos:
    ->casa a la que pertenece
    ->conyuges

De la CASA sabemos:
    ->Patrimonio = dinero
    ->Nombre de la ciudad que es
    ->Miembros
Las casa tienen restricciones de con quién se puede casar un miembro
    ->Casa Lannister:
        Solo se permite un conyuge
    ->Casa Stark:
        No se permite conyuge miembro de la misma casa
    ->Casa Guardia de Noche:
        No permite conyuge
*/
// Resuelto en 1hs

object continentePonitente{
    var casas = #{}

    method casaMasPobre(){
        return casas.min({ unaCasa => unaCasa.patrimonio() })
    }
}

//PERSONAJE
class Personaje{
    var casa
    var conyuges = #{}
    var acompaniantes = #{}
    var personalidad
    var property estaVivo

    method hacerConspiracionContra(unPersonaje){
        personalidad.accionarContra(unPersonaje)
    }

    method estaSolo(){
        return acompaniantes.isEmpty()
    }

    method esPeligroso(){
        return self.tieneAliadosRicos() or self.tieneConyugesConPlata() or self.tieneAlianzaConAlguienPeligroso()
    }

    method tieneAliadosRicos(){
        return self.aliados().filter({ unAliado => unAliado.tieneMasDeCantidadMonedas(10000) })
    }

    method tieneConyugesConPlata(){
        return conyuges.all({ unConyuge => unConyuge.esDeCasaRica() })
    }

    method esDeCasaRica(){
        return casa.esRica()
    }

    method tieneMasDeCantidadMonedas(unaCantidad){
        return self.patrimonio() > unaCantidad
    }

    method tieneAlianzaConAlguienPeligroso(){
        return self.aliados().any({ unAliado => unAliado.esPeligroso() })
    }

    method aliados(){
        return acompaniantes + casa.miembrosDeLaCasa() + conyuges
    }

    method esAliado(unPersonaje){
        return self.aliados().contains(unPersonaje)
    }

    method mePuedoCasarCon(unPersonaje){
        return casa.admiteCasamientoEntre(self, unPersonaje)
    }

    method casarseCon(unPersonaje){
        if(self.mePuedoCasarCon(unPersonaje)){
            conyuges.add(unPersonaje)
        }else{
            throw new Exception(message = "No somos el uno para el otro")
        }
    }

    method patrimonio(){
        return casa.patrimonioDeCadaMiembro()
    }

    method tieneUnSoloConyuge(){
        return conyuges.size().equals(1)
    }

    method morir(){
        estaVivo = false
    }

    method derrocharDineroEn(unPorcentaje){
        casa.reducirDineroEnPorcentaje(unPorcentaje)
    }
}

//PERSONALIDAD
object sutiles{
    method accionarContra(unPersonaje){
        const miembroDeCasaMasPobre = continentePonitente.casaMasPobre().algunMiembroDisponible()
        unPersonaje.casarseCon(miembroDeCasaMasPobre)
    }
}

object asesino{
    method accionarContra(unPersonaje){
        unPersonaje.morir()
    }
}

object asesinoPrecavido{
    method accionarContra(unPersonaje){
        if(unPersonaje.estaSolo()){
            unPersonaje.morir()
        }
    }
}

class Disipados{
    var porcentajeADerrochar

    method accionarContra(unPersonaje){
        unPersonaje.derrocharDineroEn(porcentajeADerrochar)
    }
}

object miedoso{
    method accionarContra(unPersonaje){

    }
}

//CASA
class Casa{
    var restriccionesDeCasorio = #{}
    var miembros = #{}
    var patrimonio

    method admiteCasamientoEntre(unMiembro, unPersonaje){
        return self.cumpleRestriccionesDeCasarseCon(unMiembro, unPersonaje)
    }

    method algunMiembroSePuedeCasarCon(unPersonaje){
        return miembros.any({ unMiembro => self.cumpleRestriccionesDeCasarseCon(unMiembro, unPersonaje) })
    }

    method cumpleRestriccionesDeCasarseCon(unMiembro, unPersonaje){
        return restriccionesDeCasorio.all({ unaRestriccion => unaRestriccion.seCumplePara(unMiembro, unPersonaje) })
    }

    method esRica(){
        return patrimonio > 1000
    }

    method patrimonioDeCadaMiembro(){
        return patrimonio / self.cantidadDeMiembros()
    }

    method cantidadDeMiembros(){
        return miembro.size()
    }

    method miembrosDeLaCasa(){
        return miembros
    }

    method algunMiembroDisponible(){
        // anyOne() ya que pueden tener más de un conyuge y depende la casa lo permite o no
        return self.miembrosVivos().anyOne()
    }

    method miembrosVivos(){
        return miembros.filter({ unMiembro => unMiembro.estaVivo() })
    }

    method reducirDineroEnPorcentaje(unPorcentaje){
        patrimonio -= patrimonio * unPorcentaje / 100
    }
}

// ACOMPANIANTES
class Acompaniante{
    method tieneMasDeCantidadMonedas(unaCantidad){
        return false
    }

    method esPeligroso()
}

class Lobo inherits Acompaniante{
    var raza 

    override method esPeligroso(){
        return raza.equals(huargos)
    }
}

class Dragon inherits Acompaniante{ //Tengo en cuenta que un miembro puede tener muchos dragones, corte Daenarys
    override method esPeligroso(){
        return true
    }
}

//RESTRICCIONES
class Restriccion{
    method seCumplePara(unMiembro, unPersonaje)
}

object restriccionLannister inherits Restriccion{
    override method seCumplePara(unMiembro, unPersonaje){
        return not unMiembro.tieneUnSoloConyuge()
    }
}

object restriccionStark inherits Restriccion{
    override method seCumplePara(unMiembro, unPersonaje){
        return unMiembro.casaALaQuePertenece().equals(unPersonaje.casaALaQuePertenece())
    }
}

//CONSPIRACIONES
object builderConspiracion{
    method construirUnaConspiracion(unPersonaje, unosComplotados){
        self.validarConspiracion(unPersonaje)
        return new Conspiracion(complotados = unosComplotados, personajeObjetivo = unPersonaje)
    }

    method validarConspiracion(unPersonaje){
        if(!unPersonaje.esPeligroso()){
            throw new Exception(message = "Conspiracion no valida")
        }
    }
}

class Conspiracion{
    var complotados
    var personajeObjetivo

    method cantidadDeTraidores(){
        return self.aliadosDelPersonajeObjetivoEnConspiracion().size()
    }

    method aliadosDelPersonajeObjetivoEnConspiracion(){
        return complotados.filter({ unComplotado => personajeObjetivo.esAliado(unComplotado) })
    }

    method realizarConspiracion(){
        complotados.forEach({ unComplotado => unComplotado.hacerConspiracionContra(personajeObjetivo) })
    }

    method objetivoCumplido(){
        return not personajeObjetivo.esPeligroso()
    }
}
