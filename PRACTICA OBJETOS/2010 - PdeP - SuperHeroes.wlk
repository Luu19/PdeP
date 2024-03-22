/* 2010 PARCIAL : SUPERHEROES */
/*
Los HEROES se agrupan en SALONES DE LA JUSTICIA

De los VILLANOS se conoce
    ->nivel de crueldad, cantidad de misiones que tiene encargadas * coeficiente de maldad del villano (propio)
    ->las misiones que tiene que realizar

Las MISIONES se dividen en
    ->coercitivas, tiene como objetivo un ciudadano, trata de chantejaer a ese ciudadano,
    tiene éxito si el objetivo es extosionable o si su inclinación al soborno > nivel minimo de soborno de la mision
    ->destructiva, tiene como objetivo una metropolis, hace danio a la metropolis y
    provoca malestar en los ciudadanos de la misma, siempre son exitosas

Todas las misiones tienen un danio asociado, depende del objetivo
    ->ciudadano, danio 4
    ->heroe, danio 8
    ->villano, danio 1
    ->ciudad, danio = sumatoria del danio que se hace a todos los ciudadanos

Cada CIUDADANO puede ser o no extorsionable
    ->nivel de inclinacióna al soborno se calcula como inclinación propia + base factores socioeconomicos

HEROES son ciudadanos, nunca son extorsionables
    ->inclinacion 0
Para que un heroe acuda en auxilio de una metropoli
    ->no debe estar ocupado, un heroe esta ocupado si tiene una mision asignada
    ->si su ciudad de origen da señal de auxilio, acude en su ayuda
    ->si la ciudad que lanza señal de auxilio tiene entre sus criminales a su archienemigo, 
    sin importar nada el heroe acude en su auxilio

VILLANOS son ciudadanos
    ->nivel de inclinacion al soborno es * 4 al del ciudadano comun

Las METROPOLIS conocen
    ->ciudadanos
    ->salon de la justicia, si necesita auxilio se lo pide al salon
    ->senial de auxilio
    ->ataques anteriores
*/

//PERSONAJES
class Ciudadano{
    var esExtorsionable

    method danioAsociado(){
        return 4
    }

    method esPosibleComprarlo(cantidadSoborno){
        return esExtorsionable || self.nivelDeInclinacionAlSoborno() > cantidadSoborno
    }

    method esArchiEnemigoDe(unHeroe){
        return false
    }

    method nivelDeInclinacionAlSoborno()
}

//Clase Intermedia
class CiudadanoComun inherits Ciudadano{
    var indiceDeInclinacionAlSoborno
    var baseFactoresSocioEconomicos

    override method nivelDeInclinacionAlSoborno(){
        return indiceDeInclinacionAlSoborno + baseFactoresSocioEconomicos
    }
}

class Heroe inherits Ciudadano(esExtorsionable = false){
    var property lugarDondeNacio

    override method danioAsociado(){
        return 8
    }

    override method nivelDeInclinacionAlSoborno(){
        return 0
    }

    method esLugarDondeNacio(unLugar){
        return lugarDondeNacio.equals(unLugar)
    }

    method puedeAcudirA(unaMetropoli){
        return not estaOcupado || self.esLugarDondeNacio(unaMetropoli) || unaMetropoli.esHogarDeArchienemigoDe(self)
    }
}

class Villano inherits CiudadanoComun{
    var coeficienteDeMaldad
    var misiones

    method nivelDeCrueldad(){
        return self.cantidadMisiones() * coeficienteDeMaldad
    }

    method cantidadMisiones(){
        return misiones.size()
    }

    method danioAsociado(){
        return 1
    }

    override method nivelDeInclinacionAlSoborno(){
        return super() * 4
    }

    method coleccionDeObjetivosOrdenados(){
        return self.objetivosDeMisionesSinRepetir()
        .sortBy({ unOb1, unOb2 => 
        self.cantidadVecesQueApareceEnObjetivos(unOb1) > self.cantidadVecesQueApareceEnObjetivos(unOb1) })
    }

    override method esArchiEnemigoDe(unHeroe){
        return unHeroe.esLugarDondeNacio(self.lugarQueMasVecesAtaca())
    }

    method lugarQueMasVecesAtaca(){
        return self.coleccionDeObjetivosOrdenados().first()
    }

    method cantidadVecesQueApareceEnObjetivos(unObjetivo){
        return self.objetivosDeMisiones().occurrencesOf(unObjetivo)
    }

    method objetivosDeMisiones(){
        return misiones.map({ unaMision => unaMision.objetivo() })
    }

    method objetivosDeMisionesSinRepetir(){
        return self.objetivosDeMisiones().asSet()
    }
}

class Metropoli{
    var habitantes = #{}
    var registroDeAtaquesALaCiudad = #{}
    const salonDeLaJusticia

    method danioAsociado(){
        return habitantes.sum({ unHabitante => unHabitante.danioAsociado() })
    }

    method peorEnemigoDeUnaCiudad(){
        return self.villanosQueAtacaronALaCiudad().max({ unVillano => self.cantidadVecesQueApareceEnRegistroDeAtaque(unVillano) })
    }

    method villanosQueAtacaronALaCiudadSinRepetidos(){
        return self.villanosQueAtacaronALaCiudad().asSet()
    }

    method villanosQueAtacaronALaCiudad(){
        return registroDeAtaquesALaCiudad.map({ unRegistro => unRegistro.responsableDeAtaque() })
    }

    method cantidadVecesQueApareceEnRegistroDeAtaque(unVillano){
        return self.villanosQueAtacaronALaCiudad().occurrencesOf(unVillano)
    }

    method esHogarDeArchienemigoDe(unHeroe){
        return habitantes.any({ unHabitante => unHabitante.esArchiEnemigoDe(unHeroe) })
    }

    method heroesDelSalonQuePuedenAcudirEnAuxilio(){
        return salonDeLaJusticia.heroesIntegrantes().filter({ unHeroe => unHeroe.puedeAcudirA(self) })
    }

}

//SALON DE LA JUSTICIA
class SalonDeLaJusticia{
    var integrantes = #{}

    method heroesIntegrantes(){
        return integrantes
    }
}

//REGISTROS
class RegistroDeAtaque{
    const property responsableDeAtaque
    const property ataqueRealizado
}

//MISIONES
class Mision{
    var objetivo

    method danioAsociado(){
        return objetivo.danioAsociado()
    }

    method seraExitosa()
}

class MisionCoercitiva{
    var nivelDeSobornoMision

    override method seraExitosa(){
        return objetivo.esPosibleComprarlo(nivelDeSobornoMision)
    }
}

class MisionDestructiva{

    override method seraExitosa(){
        return true
    }
}