object sinRequisito {

  method cumple(estudiante, materia) {
    return true
  }

}

class Correlativas {
  const materias

  method cumple(estudiante, materia) {
    return materias.all({_materia => estudiante.aprobada(_materia)})
  }
}

class Creditos {
  
  const creditosNecesarios

  method cumple(estudiante, materia) {
    return estudiante.creditos(materia.carrera()) >= creditosNecesarios
  }

}

object añoCompleto {
  method cumple(estudiante, materia) {
    return estudiante.añoCompleto(materia.carrera(), materia.añoPrevio()) //me canse de refactorizar, es muy tarde 
  }

}

object ordenDeLlegada {
  method siguiente(carrera, espera) {
    return espera.first()
  }
}
object elitista {
  method siguiente(carrera, espera) {
    return espera.max({estudiante => estudiante.promedio(carrera)})
  }
}

object avance {
  method siguiente(carrera, espera) {
    return espera.max({estudiante => estudiante.creditos(carrera)})
  }
}

class Materia {
  var requisito = sinRequisito
  const property año = 1
  const property creditos = 0
  const cupo = 30
  const property espera = []
  var property criterioDeBaja = ordenDeLlegada

  //Uso referencia cruzada acá, evitarlo llevaría a necesitar un objeto universidad en la cual estén todas las carreras 
  //para ir a buscar la carrera donde está una materia. Eso obliga alguna manganeta en la generación de la relación
  //-initialize, o setter- usé ambos para ver como quedaba.
  var property carrera = null 

  const property inscriptos = #{}

  method añoPrevio() {
    return año -1 
  }

  method requisito(_requisito) {
    requisito = _requisito
  }

  method inscripto(estudiante) {
    return inscriptos.contains(estudiante) or espera.contains(estudiante)
  } 

  method cumpleRequisitos(estudiante) {
    return requisito.cumple(estudiante, self)
  }

  method aceptaInscribir(estudiante) {
    return not self.inscripto(estudiante) and self.cumpleRequisitos(estudiante)
  }
  method inscribir(estudiante) {
    if (self.hayCupo()) {
      inscriptos.add(estudiante)
    }
    else {
      espera.add(estudiante)
    }
  }

  method hayCupo() {
    return inscriptos.size() < cupo
  }
  method bajar(estudiante) {
    self.validarBajar(estudiante)
    if (espera.contains(estudiante)) {
      espera.remove(estudiante)
    }
    else {
      inscriptos.remove(estudiante)
      if (not espera.isEmpty()) {
        const movible = criterioDeBaja.siguiente(carrera, espera)
        espera.remove(movible)
        inscriptos.add(movible)
      }
    }

  }
  method validarBajar(estudiante) {
    if (not self.inscripto(estudiante)) {
      self.error("No se puede dar de baja un estudiante que no está inscript")
    }
  }
}
class Carrera {
  var materias = null

  method initialize() {
    self._asignarCarrera()
  }

  method materias() {
    return materias
  }

  method _asignarCarrera() {
    materias.forEach({materia => materia.carrera(self)})
  }

  method materias(_materias) {
    materias = _materias
    self._asignarCarrera()
  }
  method pertenece(materia) {
    return materias.contains(materia)
  }

  method materiasInscribibles(estudiante){
    return materias.filter({materia => estudiante.puedeInscribirMateria(materia)})
  }
  method añoCompleto(estudiante, año) {
    return materias.filter({materia => materia.año() == año}).all({materia => estudiante.aprobada(materia)})
  }
}

class Cursada {
  const property materia
  const property nota

  method aprueba(_materia) {
    return self.cursa(_materia) and self.aprobada()
  }

  method apruebaEnLaCarrera(carrera) {
    return carrera.materias().any({_materia=> self.aprueba(_materia)})
  }
  method cursa(_materia) {
     return materia == _materia
  }

  method aprobada() {
    return nota.between(6, 10)
  }
  method creditos() {
    return materia.creditos()
  }
}

class Estudiante {
    const property carreras = #{}
    const cursadas = []

    method inscribir(carrera) {
      self.validarInscribir(carrera)
      carreras.add(carrera)
    }

    method validarInscribir(carrera) {
      if (self.inscripto(carrera)) {
        self.error("No se puede inscribir a una " + carrera + " porque  ya está inscripta")
      }
    }
    method inscripto(carrera) {
      return carreras.contains(carrera)
    }

    method cursada(materia, nota) {
      self.validarCursada(materia, nota)
      cursadas.add(new Cursada(materia=materia, nota=nota))
    }
    method validarCursada(materia, nota) {
      if ( not self.puedeRegistrarCursada(materia, nota) ) {
        self.error("No se puede resgistrar la cursada")
      }
    }
    method puedeRegistrarCursada(materia, nota) {
        return nota.between(1, 10) and self.debeMateria(materia)
    }
    method aprobada(materia) {
      return cursadas.any({cursada => cursada.aprueba(materia)})
    } 
    method perteneceASusCarreras(materia) {
      return carreras.any({carrera => carrera.pertenece(materia)})
    }
    method promedio(carrera) {
      return self.cursadasAprobadas(carrera).average({cursada => cursada.nota()}) //tambien se puede usar un map y average o contar cantidad
     }

    method cursadasAprobadas(carrera) {
      return cursadas.filter({cursada=> cursada.apruebaEnLaCarrera(carrera)})
    }
    method promedio() {
      return cursadas.filter({cursada => cursada.aprobada()}).average({cursada => cursada.nota()})
    }
    method cantidadAprobadas(carrera) {
      return self.cursadasAprobadas(carrera).size()
    }
    method cursadas(materia) {
      return cursadas.filter({cursada => cursada.cursa(materia)})
    } 

    method debeMateria(materia) {
      return not self.aprobada(materia) and self.perteneceASusCarreras(materia)
    }
    method puedeInscribirMateria(materia) {
      return self.debeMateria(materia) and materia.aceptaInscribir(self)
    }
    method inscribirMateria(materia) {
      self.validarInscribirMateria(materia)
      materia.inscribir(self)
    }
    method validarInscribirMateria(materia) {
      if (not self.puedeInscribirMateria(materia)) {
        self.error("No se puede inscribir a " + materia)
      }
    }

    //TODO, quizas no necesito este pasamanos
    method añoCompleto(carrera, año) {
      return carrera.añoCompleto(self, año)
    }

    method creditos(carrera) {
      return self.cursadasAprobadas(carrera).sum({cursada => cursada.creditos()})
    }

}