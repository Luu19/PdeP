/* 2011 PARCIAL : HEROES */
/*
Se conoce a los individuos que operan en cada COMPAÑIA

Para ganar una pelea la potencia de un INDIVIDUO debe ser mayor a la potencia del individuo con quien se enfrenta
De cada INDIVIDUO se sabe
    ->potencia se calcula como
        *Individuo comun: nivel de entrenamiento (numero que conoce cada persona) + la potencia del arma mas poderosa
        *Heroe: igual manera al individuo comun + potencia del poder
    ->armas que tiene, estas pueden cambiar o agregarse

Cada HEROE tiene 
    ->unico poder que aporta potencia adicional
        *Super Fuerza, suma potencia adicional que depende de cada superfuerza
        *Sabiduria, + 3 ptos por cada pelea del heroe
        *Poder Mistico, acumula poderes y la potencia que aporta es la sumatoria de la potencia de los
        poderes acumulados

Cuando un individuo gana una pelea mejoran sus habilidades
    ->si individuo comun, su nivel de entrenamiento + 1 hasta llegar a 1000
    ->si es heroe, depende del poder
        *Super Fuerza, incrementa + 1 pto 
        *Sabiduria, no gana nada
        *Mistico, obtiene un poder adicional que se suma a los que tiene, este depende de a quien venció.
        Calculamos qué poder otorga quien vencimos
            *Un heroe otorga el mismo poder que tiene
            *Un individuo comun otorga super fuerza nivel 5

De cada individuo se sabe también con quien peleó, después de la pelea ambos se deben registrar en su historial
*/

//COMPAÑIA
object compania{
    var integrantes = #{}

    method individuoPoderososContraLosQuePelearon(){
        return integrantes.map({ unIntegrante => unIntegrante.individuoMasPoderosoContraQuienPeleo() })
    }

    method potenciaTotal(){
        return integrantes.sum({ unIntegrante => unIntegrante.potencia() })
    }

    method puedeDestruirA(unaCompania){
        return integrantes.any({ unIntegrante => unIntegrante.loSuperaAUno(unaCompania.miembros()) })
    }

    method miembros(){
        return integrantes
    }

}

//INDIVIDUOS
class IndividuoComun{
    var nivelDeEntrenamiento
    var armas
    var individuosContraLosQuePeleo

    method potencia(){
        return nivelDeEntrenamiento + self.potenciaArmaMasPoderosa()
    }

    method potenciaArmaMasPoderosa(){
        return self.armaMasPoderosa().potencia()
    }

    method armaMasPoderosa(){
        return armas.max({ unArma => unArma.potencia() })
    }

    method pelearContra(unIndividuo){
        self.registrarPelea(unIndividuo)
        if(not unIndividuo.puedeVencerA(self)){
            self.mejorarHabilidades(unIndividuo)
        }
    }

    method puedeVencerA(unIndividuo){
        return self.potencia() > unIndividuo.potencia()
    }

    method mejorarHabilidades(unIndividuo){
        nivelDeEntrenamiento = (nivelDeEntrenamiento + 1).max(1000)
    }

    method registrarPelea(unIndividuo){
        individuosContraLosQuePeleo.add(unIndividuo)
        unIndividuo.registrarPelea(self)
    }

    method cantidadPeleas(){
        return individuosContraLosQuePeleo.size()
    }

    method poderQuePuedeOtorgar(){
        return new SuperFuerza(nivelDeFuerza = 5)
    }

    method esDignoDeConfianza(){
        return self.cantidadPeleas() > 13 && not self.llegoAlTopeDelEntrenamiento()
    }

    method llegoAlTopeDelEntrenamiento(){
        return nivelDeEntrenamiento.aquals(1000)
    }

    method individuoMasPoderosoContraQuienPeleo(){
        return individuosContraLosQuePeleo.max({ unIndividuo => unIndividuo.potencia() })
    }

    method loSuperaAUno(unosIndividuos){
        return unosIndividuos.any({ unIndividuo => self.esMejorQue(unIndividuo) })
    }

    method esMejorQue(unIndividuo){
        return self.puedeVencerA(unIndividuo) && self.cantidadPeleas() > unIndividuo.cantidadPeleas()
    }
}

class Heroe inherits IndividuoComun{
    var poder

    override method potencia(){
        return super() + poder.potenciaAdicionalPara(self)
    }

    override method mejorarHabilidades(unIndividuo){
        poder.mejorar(unIndividuo.poderQuePuedeOtorgar())
    }

    override method poderQuePuedeOtorgar(){
        return poder
    }

    override method esDignoDeConfianza(){
        return super() && poder.esDignoDeConfianza(self)
    }
}

//PODERES
class SuperFuerza{
    var nivelDeFuerza

    method potenciaAdicionalPara(unHeroe){
        return nivelDeFuerza
    }

    method mejorarHabilidades(unPoder){
        nivelDeFuerza++
    }

    method esDignoDeConfianza(unHeroe){
        return self.potenciaAdicionalPara(unHeroe) < 100
    }
}

object sabiduria{
    method potenciaAdicionalPara(unHeroe){
        return unHeroe.cantidadPeleas() * 3
    }

    method mejorarHabilidades(unPoder){
        //no gana nada
    }

    method esDignoDeConfianza(unHeroe){
        return unHeroe.cantidadPeleas() > 20
    }
}

class PoderMistico{
    var poderes

    method potenciaAdicionalPara(unHeroe){
        return poderes.sum({ unPoder => unPoder.potenciaAdicionalPara(unHeroe) })
    }

    method mejorarHabilidades(unPoder){
        poderes.add(unPoder)
    }

    method esDignoDeConfianza(unHeroe){
        return false
    }
}

