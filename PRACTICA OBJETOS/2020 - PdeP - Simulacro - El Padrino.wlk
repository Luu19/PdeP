/* SIMULACRO 2020: EL PADRINO */
/*
Las familias se componen de miembros con muchos rangos y armas (los miembros tienen rangos y armas)
Los miembros defienden intereses a traves de practicas, asesinatos y traiciones

Armas disponibles:
    ->revolver: todos salen con el, es confiable, mata de un disparo si tiene balas, cada disparo gasta una bala,
    se puede recargar
    ->escopeta: hiere a la victima, si la victima ya esta herida, la mata
    ->cuerda de piano: si es de buena calidad, mata instaneamente

Rangos:
    ->Don: cabeza de la familia, da ordenes a sus subordinados (estos son subjefes o soldados)
        ->caso especial: Don Vito, jefe de Corleone, al ordenar atacar a un subordinado, este ataca dos veces
    ->Subjefe: cada vez que tiene que usar un arma, usa una distinta. Tambien tiene subordinados
    ->Soldado: Cada uno empieza con una escopeta de regalo, puede obtener mas armas. No tiene subordinados
    Siempre usa el arma mas a mano

Todas las familias tienen un solo Don
*/
/* ARMAS */
class Revolver{
    var cantidadBalas
    var balasGastadas = cantidadBalas

    method esSutil(){
        return cantidadBalas.equals(1)
    }

    method usarContra(unaPersona){
        if(self.tieneBalas()){
            unaPersona.morir()
            self.gastarBala()
        }
    }

    method recargar(){
        balasGastadas = cantidadBalas 
    }

    method gastarBala(){
        balasGastadas -= 1
    }

    method tieneBalas(){
        return balasGastadas =/ 0
    }

}

class CuerdaDePiano{
    var buenaCalidad

    method esSutil(){
        return true
    }

    method usarContra(unaPersona){
        unaPersona.morir()
    }
}

class Escopeta{

    method usarContra(unaPersona){
        if(unaPersona.estaHerida()){
            unaPersona.morir()
        }else{
            unaPersona.herir()
        }
    }

}

/* FAMILIA */
class Familia{
    var integrantes = #{}
    var don
    var traiciones = #{}

    method alguienDuermeConLosPeces(){
        return integrantes.any({ unIntegrante => unIntegrante.duermeConLosPeces() })
    }

    method elMasPeligroso(){
        return integrantes.max({ unIntegrante => unIntegrante.cantidadArmas() })
        //self.integrantesVivos().max({ unIntegrante => unIntegrante.cantidadArmas() })
        // modificado por cuestion del enunciado
    }

    method integrantesVivos(){
        return integrantes.filter({ unIntegrante => unIntegrante.estaVivo() })
    }

    method distribuirArmas(){
        integrantes.forEach({ unIntegrante => unIntegrante.agregarArma(new Revolver(cantidadBalas = 6)) })
    }

    method atacarFamilia(unaFamilia){
        self.integrantesVivos().forEach({ unIntegrante => unIntegrante.tomarVictima(unaFamilia) })
    }

    method reorganizarse(){
        self.nombrarSubjefesNuevos()
        self.nuevoDon()
        self.aumentarLealtadDeFamilia()
    }

    method soldadosVivos(){
        return self.integrantesVivos().filter({ unIntegrante => unIntegrante.esSoldado() })
    }

    method nombrarSubjefesNuevos(){
        const posiblesSubjefes = self.soldadosVivos().filter({ unIntegrante => unIntegrante.cantidadArmas() > 5 })
        posiblesSubjefes.forEach({ unIntegrante => unIntegrante.cambiarRango(new Subjefe(subordinados = #{})) })
    }

    method nuevoDon(){
        const posibleNuevoDon = don.subordinadoMasLeal()
        if(posibleNuevoDon.sabeDespacharElegantemente()){
            posibleNuevoDon.ascenderADon(self)
            /*
            posibleNuevoDon.cambiarRango(new Don(subordinados = posibleDon.subordinados()))
            don = posibleNuevoDon
            */
        }
    }

    method aumentarLealtadDeFamilia(){
        integrantes.forEach({ unIntegrante => unIntegrante.aumentarLealtadEnPorcentaje(10) })
    }

    method don(unaPersona){
        don = unaPersona
    }

    method ajusticiar(unTraidor){
        /* No especifica qué hace */
    }

    method agregarTraicionDeRecuerdo(unaTraicion){
        traiciones.add(unaTraicion)
    }

    method lealtadPromedio(){
        return integrantes.sum({ unIntegrante => unIntegrante.lealtad() }) / integrantes.size()
    }

    method incorporarMiembro(unMiembro){
        integrantes.add(unMiembro)
    }
}


/* PERSONA */
class Integrante{
    var property estaVivo = true
    var armas = [new Escopeta()]
    var rol
    var estaHerida = false
    var lealtad

    method duermeConLosPeces(){
        return not estaVivo
    }

    method cantidadArmas(){
        return armas.size()
    }

    method agregarArma(unArma){
        armas.add(unArma)
    }

    method sabeDespecharElegantemente(){
        rol.sabeDespacharElegantemente(self)
    }

    method tieneArmaSutil(){
        armas.any({ unArma => unArma.esSutil() })
    }

    method tomarVictima(unaFamilia){
        const masPeligroso = unaFamilia.elMasPeligroso()
        if(masPeligroso.estaVivo()){
           rango.atacar(elMasPeligroso, self) 
        }
    }

    method armaCualquiera(){
        return armas.anyOne()
    }

    method armaMasAMano(){
        return armas.head()
    }

    method morir(){
        estaVivo = false
    }

    method estaHerida(){
        return estaHerida
    }

    method herir(){
        estaHerida = true
    }

    method esSoldado(){
        rango.esSoldado()
    }

    method cambiarRango(unRango){
        rango = unRango
    }

    method ascenderADon(unaFamilia){
        rango = new Don(subordinados = rango.subordinados())
        unaFamilia.don(self)
    }

    method aumentarLealtadEnPorcentaje(unaPorcentaje){
        lealtad += lealtad * unaPorcentaje / 100
    }

    method atacar(unaPersona){
        rango.atacar(unaPersona, self)
    }

    method irseAOtraFamilia(otraFamilia){
        unaFamilia.incorporarMiembro(self)
    }
}

class Don{
    var subordinados = #{}

    method sabeDespacharElegantemente(unaPersona){
        return true
    }

    method atacar(victima, atacante){
        const unSubordinado = subordinados.anyOne()
        unSubordinado.atacar(victima, unSubordinado)
    }

    method esSoldado(){
        return false
    }

    method subordinadoMasLeal(){
        return subordinados.max({ unSubordinado => unSubordinado.lealtad() })
    }

}

class Subjefe{
    var subordinados = #{}

    method sabeDespacharElegantemente(unaPersona){
        return subordinados.any({ unSubordinado => unSubordinado.tieneArmaSutil() })
    }

    method atacar(victima, atacante){
        atacante.armaCualquiera().usarContra(victima)
    }

    method esSoldado(){
        return false
    }

}

object Soldado{

    method sabeDespacharElegantemente(unaPersona){
        return unaPersona.tieneArmaSutil()
    }

    method atacar(victima, atacante){
        return atacante.armaMasAMano().usarContra(victima)
    }

    method esSoldado(){
        return true
    }

    method subordinados(){
        return #{}
    }
}

/* TRAICIONES */
class Traicion{
    var victimas
    var traidor
    var fechaTentativa
    var familiaALaQueQuiereIrse

    method adelantarFecha(nuevaFecha, nuevaVictima){
        victimas.add(nuevaVictima)
        fechaTentativa = nuevaFecha
    }

    method realizarsePor(unaFamilia){
        if(!self.puedeRealizarseSinProblemas(unaFamilia)){
            unaFamilia.ajusticiar(traidor)
            unaFamilia.agregarTraicionDeRecuerdo(self)
        }else{
            victimas.forEach({ unaVictima =>  traidor.atacar(unaVictima) }) //esto se puede extraer a un metodo del traidor
            traidor.irseAOtraFamilia(familiaALaQueQuiereIrse)
            unaFamilia.agregarTraicionDeRecuerdo(self)
        }
    }

    method puedeRealizarseSinProblemas(unaFamilia){
        return unaFamilia.lealtadPromedio() < traidor.lealtad() * 2 
    }

}