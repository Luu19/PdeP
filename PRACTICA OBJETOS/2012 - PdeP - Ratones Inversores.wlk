/* 2012 PARCIAL : RATONES INVERSORES */
/*
De MICKEY (de los ratones en general) se conoce:
    ->cantidad de dinero que tiene para invertir
    ->inversiones hechas
    ->inversiones pendientes
Los ratones solo puede hacer inversiones para las cuales les alcanza el dinero
Las INVERSIONES pueden ser
    ->comprar una compañía
        *Las COMPAÑÍAS conocen las películas que realizaron y cada PELÍCULA tiene su recaudación
        *Cada compañía cuesta un % de la recaudación total de sus películas y ese porcentaje es 
        propio de cada compañía
    ->construir un parque de diversiones
        *Tiene un costo igual al de las atracciones que tenga (se sabe el total) + costo en m2 de superficie 
        que ocupe el parque. El m2 tiene un valor por igual para todos los parques que luego puede ir cambiando
    ->producir una pelicula
        *Costo de producción + sueldo de cada personaje
        *En las peliculas independientes solo se les paga a los 4 personajes de mayor sueldo + costo producción

El FLAUTISTA HAMELIN conoce a todos los ratones
*/

//RATON
class Raton{
    var inversionesPendientes
    var inversionesRealizadas
    var dineroDisponible
    

    method costoInversionesPendientes(){
        return inversionesPendientes.sum({ unaInversion => unaInversion.costo() })
    }

    method costoInversionesRealizadas(){
        return inversionesRealizadas.sum({ unaInversion => unaInversion.costo() })
    }

    method realizarInversion(unaInversion){
        self.validarInversionPosible(unaInversion)
        self.liquidarCostoInversion(unaInversion)
        inversionesRealizadas.add(unaInversion)
    }

    method validarInversionPosible(unaInversion){
        if(not unaInversion.puedeSerRealizadaPor(self)){
            throw new Exception(message = "No hay dinero disponible para realizar esta inversion")
        }
    }

    method realizarTodasLasInversionesPendientes(){
        self.inversionesQuePuedeRealizar()..forEach({ unaInversion => self.realizarInversion(unaInversion) })
    }

    method inversionesQuePuedeRealizar(){
        return inversionesPendientes.filter({ unaInversion => unaInversion.puedeSerRealizadaPor(self) })
    }

    method esMasRatonQue(unRaton){
        return self.costoInversionesRealizadas() < unRaton.costoInversionesRealizadas()
    }

    method liquidarCostoInversion(unaInversion){
        dineroDisponible -= unaInversion.costo()
    }

    method capitalDisponible(){
        return dineroDisponible
    }

    method esAmbicioso(){
        return self.costoInversionesPendientes() > dineroDisponible * 2
    }

    method sufrirEfectoDelFlautista(){
        self.realizarTodasLasInversionesPendientes()
        self.aumentarSueldoAlPersonajePeorPago()
    }

    method aumentarSueldoAlPersonajePeorPago(){
        self.personajePeorPago().duplicarSueldo()
    }

    method personajesPeoresPagosInversiones(){
        return inversionesRealizadas.map({ unaInversion => unaInversion.personajeMalPago() }).asSet()
    }

    method personajePeorPago(){
        return self.personajesPeoresPagosInversiones().min({ unPersonaje => unPersonaje.sueldo() })
    }
}

//FLAUTISTA
object flautistaHamelin{
    var ratonesQueConoce = #{}

    method tocarFlauta(){
        self.ratonesAmbiciososQueConoce().forEach({ unRaton => unRaton.sufrirEfectoDelFlautista() })
    }

    method ratonesAmbiciososQueConoce(){
        return ratonesQueConoce.filter({ unRaton => unRaton.esAmbicioso() })
    }
}

//INVERSIONES
class Inversion{

    method puedeSerRealizadaPor(unRaton){
        return self.costo() < unRaton.capitalDisponible()
    }

    method costo()

    method personajeMalPago(){
        //override para comprar compañia y producir pelicula
    }
}

class ComprarCompania inherits Inversion{
    const porcentajeDeRecaudacion
    var peliculasQueRealizaron = #{}

    override method costo(){
        return self.recaudacionTotalDePeliculas() * porcentajeDeRecaudacion / 100
    }

    method recaudacionTotalDePeliculas(){
        return peliculasQueRealizaron.sum({ unaPelicula => unaPelicula.recaudacion() })
    }

    method personajesInvolucrados(){
        return peliculasQueRealizaron.map({ unaPelicula => unaPelicula.personajes() }).flatten().asSet()
    }

    override method personajeMalPago(){
        return self.personajesInvolucrados().min({ unPersonaje => unPersonaje.sueldo() })
    }
}

class ConstruirParqueDeDiversiones inherits Inversion{
    const costoAtracciones
    const metrosCuadradosDelParque
    var valorMetroCuadrado

    override method costo(){
        return costoAtracciones + metrosCuadradosDelParque * valorMetroCuadrado
    }

    method actualizarValorMetroCuadrado(unValor){
        valorMetroCuadrado = unValor
    }

    method personajesInvolucrados(){
        //no hay
    }
}

class ProducirPelicula inherits Inversion{
    const costoProduccion
    var personajes

    override method costo(){
        return costoProduccion + self.totalSueldoPersonajes()
    }

    method totalSueldoPersonajes(){
        return personajes.sum({ unPersonaje => unPersonaje.sueldo() })
    }

    method personajesInvolucrados(){
        return personajes
    }

    override method personajeMalPago(){
        return personajes.min({ unPersonaje => unPersonaje.sueldo() })
    }
}

class ProducirPeliculaIndependiente inherits ProducirPelicula{

    override method totalSueldoPersonajes(){
        return self.personajesConMejorSueldo().sum({ unPersonaje => unPersonaje.sueldo() })
    }

    method personajesConMejorSueldo(){
        return personajes.sortBy({ unP1, unP2 => unP1.sueldo() > unP2.sueldo() }).take(4)
    }
}

// CLASES ADICIONALES
class Pelicula{
    const property personajes
    const property recaudacion
}

class Personaje{
    var nombre
    var property sueldo

    method duplicarSueldo(){
        sueldo *= 2
    }
}
