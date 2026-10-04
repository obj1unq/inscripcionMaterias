class Materia {

}
class Carrera {
  const property materias

  method pertenece(materia) {
    return materias.contains(materia)
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
        return nota.between(1, 10) and not self.aprobada(materia) and self.perteneceASusCarreras(materia)
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
}