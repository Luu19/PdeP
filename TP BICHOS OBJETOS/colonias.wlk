class Colonia{
    const hormigueros = #{}

    method reclamarAlimentoDeHormigueros(){
        hormigueros.forEach({unHormiguero => unHormiguero.reclamarAlimento()})
    }

    method poblacionTotal(){
        return hormigueros.sum({unHormiguero => unHormiguero.cantidadDeHormigas()})
    }

    method defenderColonia(unIntruso){
        hormigueros.forEach({unHormiguero => unHormiguero.defenderseDe(unIntruso)})
    }
}

class superColonia{
    const colonias = #{}

    method reclamarAlimentoDeColonias(){
        colonias.forEach({unaColonia => unaColonia.reclamarAlimentoDeHormigueros()})
    }

    method poblacionTotalDeSuperColonia(){
        return colonias.sum({unaColonia => unaColonia.poblacionTotal()})
    }

    method defenderSuperColonia(unIntruso){
        colonias.forEach({unaColonia => unaColonia.defenderColonia(unIntruso)})
    }
}