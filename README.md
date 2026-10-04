# Inscripción a materias

En una Universidad de un país latinoamericano se necesita un sistema que permita realizar la inscripción a materias. En esta universidad se tiene un único curso de cada materia y sólo se maneja información de un cuatrimestre (no se consideran inscripciones anteriores). En cambio, sí se debe conocer el historial de materias aprobadas de una persona estudiante, junto con la nota que obtuvo.

## Parte 1 Historia académica

Cada materia pertenece a una única carrera y puede tener otras materias como prerrequisitos. Además, un estudiante puede estar cursando distintas carreras. 

### Requerimientos

Construir un modelo que permita resolver los siguientes requerimientos: 

1. Registrar una materia aprobada por una persona indicando la nota obtenida. Si esta persona ya tiene registrada la aprobación de la materia, se debe lanzar un error. 

    > **Tip**: La nota con la que la persona aprobó una materia, no puede ser un atributo de la persona (porque la persona tiene muchas notas) ni de la materia (porque una materia es cursada por muchas personas). 

2. Conocer para una persona: si tiene o no aprobada una materia (su nota alcanza la calificación 6), 

3. Conocer para una persona la cantidad de materias aprobadas y el promedio **en una determinada carrera**

3. Saber para una persona: la colección de materias de **todas** las carreras a las que está inscripta.

### Casos de prueba

En los ejemplos incluiremos tres carreras: _Programación_, _Tecnicatura en Economía Social y solidaria(TUESS)_ y _TO_.

* Programación incluye estas materias: Elementos de Programación, Matemática 1, Objetos 1, Objetos 2, Objetos 3, Trabajo Final, Bases de Datos(BD), Programación Concurrente (PConc)
* TUESS incluye Matemáticas para economía y administración (MEyA), Trabajo y sociedad (TyS), Economía, Desarrollo local.
* TO incluye Lectura y escritura académica (LEA), Ciencias de la Salud, Psicología, Antropología, Sociología.
* Los requisitos de Obj2 son Obj1 y Mate1.
* Los requisitos de Obj3 son Obj2 y BD.
* Los requisitos de PConc son Obj1 y BD.
* Economía tiene como único requisito a TyS.

Escenario
1. Hacer que la estudiante _Alex_ se anote en las carreras de Programación y TUESS. 
2. Registrar la aprobación de Matemática 1 (con un 8) y Objetos 1 (con un 10)
3. Verificar que su promedio en Programación sea 9. 
4. Verificar que todas las materias para Alex sean todas las de programación y también todas las de TUESS.  


## Parte 2 Condiciones para inscribirse

Requerimientos

1. Determinar si una persona _e_ puede inscribirse a una materia _m_. Para esto se deben cumplir cuatro condiciones: 

    - _m_ debe corresponder a alguna de las carreras en la que está inscripta _e_, 
    - _e_ no puede haber aprobado _m_ previamente, 
    - _e_ no debe estar estar ya inscripta en _m_,
    - _e_ debe tener aprobadas todas las materias que se declaran como _pre-requisitos_ de _m_.  
    

2. Inscribir una persona _e_ a una materia _m_, verificando las condiciones de inscripción de la materia. Si no se cumplen las condiciones, lanzar un error. 


3. Materias habilitadas en una carrera: dada una carrera, conocer todas las materias de esa carrera a las que se puede inscribir. Sólo vale si está cursando esa carrera.  



### Casos de prueba

Verificar que Alex puede inscribirse a Objetos 2, pues tiene aprobadas Objetos 1 y Matemática 1.


## Parte 3: Listas de espera

Extender el modelo para considerar que cada materia tiene un “cupo”, es decir, una cantidad máxima de estudiantes que se pueden inscribir. Para manejar el exceso en los cupos, las materias tienen una lista de espera, de estudiantes que quisieran cursar pero no tienen lugar. Entonces, como resultado de la inscripción, la persona puede quedar confirmada, o en lista de espera (ambas situaciones, si cumple con las condiciones del punto 4 de la parte 2). No se requiere que el sistema conteste nada con respecto al resultado de la inscripción. 

### Requerimientos:

1. Poder de baja un estudiante de una materia. En caso de haber estudiantes en lista de espera, el primer estudiante de la lista debe obtener su lugar en la materia.

2. Brindar resultados de inscripción, específicamente:

    * Las personas estudiantes inscriptos a una materia dada.
    * Las personas estudiantes en lista de espera para una materia dada.

3. Brindar información útil para una persona estudiante, específicamente: las materias en las que está inscripta, las materias en las que quedó en lista de espera. _TIP_ para esto, usar la lista de todas las materias de las carreras que cursa, resuelto anteriormente.


### Casos de prueba 
Suponiendo que

* Alex tiene aprobadas EPyL, Mate1, Obj1, BD, MEyA, TyS.
* Luisa, Romina y Alicia que aprobaron EPyL, Obj1, y Mate1; 
* Ana que aprobó solamente EPyL. 
* Luisa, Romina, Alicia y Ana están cursando Programación.
* Obj2 tiene cupo para 3 estudiantes.

Realizar estos tests:
* Alex puede inscribirse en Obj2, pero no en Obj3 (porque le falta Obj2) ni en Obj1 (porque ya la tiene aprobada).

* Alex puede inscribirse en las materias Obj2 y PConc de la carrera de Programacion; y en Economía de la TUESS.
* Si se inscriben, en este orden, Luisa, Romina, Alicia y Alex en Obj2, entonces las tres primeras quedan confirmadas, y Alex queda en lista de espera.
* Si después se da de baja Romina en Obj2, entonces Alex pasa a tener la inscripción confirmada en esa materia.


## Parte 4: Distintos tipos de requisitos

Agregar al modelo la capacidad de expresar otros tipos de requisitos (no sólo un conjunto de materias previamente aprobadas) a la hora de verificar la inscripción a una materia. Otras opciones son:

   * Requerir una cantidad de créditos. Esto implica que cada materia conozca la cantidad de _créditos_ que otorga. Por ejemplo, para inscribirse en Trabajo Final se necesita haber acumulado 250 créditos.

   * Requerir todas las materias del año anterior. Para esto es necesario poder indicar a qué año pertenece cada materia. Por ejemplo, para cursar Obj3, que es una materia de tercer año, es necesario haber aprobado todas las materias del segundo año. 

   * No requerir nada. Es decir no tener requerimientos. Por ejemplo EPyL es una de las primeras materias y por lo tanto no tiene ninguna condición especial, cualquiera puede cursarla.

Cada materia tiene sólo uno de estos tipos de requisitos: correlativas, cŕeditos, por año o nada. 

## Parte 5: Gestión de la lista de espera

Incorpora al modelo la capacidad de configurar diferentes _estrategias para gestionar la lista de espera_ en cada materia, a saber:

- Por orden de llegada: si te querés inscribir y no hay lugar vas a la lista de espera por llegar último
- Elitista: entran los que tengan mejor promedio.
- Por grado de avance: Inscribimos al estudiante con más materias aprobadas en la carrera.


### Casos de prueba 