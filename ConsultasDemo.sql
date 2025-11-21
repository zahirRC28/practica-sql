-- ===============================================
-- CONSULTAS DEMO
-- ===============================================

-- BUSCAR TODOS LOS ALUMNOS
SELECT 
    a.id_alumno,
    a.Nombre_alumno,
    a.Email,
    COUNT(m.edicion_id) AS "Número de Ediciones"
FROM Alumnos a
INNER JOIN matriculas AS m ON a.id_alumno = m.alumno_id
GROUP BY a.id_alumno, a.Nombre_alumno, a.Email
ORDER BY a.Nombre_alumno;

-- BUSCAR ALUMNO POR NOMBRE
SELECT *
FROM Alumnos
WHERE Nombre_alumno LIKE '%Teresa%'
ORDER BY Nombre_alumno;

-- BUSCAR ALUMNO POR EMAIL
SELECT *
FROM Alumnos
WHERE Email = 'Teresa_Laguna@gmail.com';

-- LISTAR TODOS LOS PROFESORES (CLAUSTROS)
SELECT 
    id_claustro,
    Nombre_claustro
FROM Claustros
ORDER BY Nombre_claustro;

-- CONTAR EDICIONES POR MATERIA
SELECT 
    m.nombre_materia AS "Materia",
    COUNT(e.id_edicion) AS "Total Ediciones"
FROM Materias m
INNER JOIN Ediciones e ON m.id_materia = e.Materia_id
GROUP BY m.nombre_materia;

-- LISTAR TODOS LOS ESTUDIANTES ALFABÉTICAMENTE
SELECT 
    id_alumno,
    Nombre_alumno,
    Email
FROM Alumnos
ORDER BY Nombre_alumno ASC;

-- ESTUDIANTES DE DATA SCIENCE
SELECT 
    a.id_alumno,
    a.Nombre_alumno,
    a.Email,
    m.nombre_materia AS "Materia",
    e.Fecha AS "Fecha Inicio",
    c.Localizacion AS "Campus",
    mod.horario AS "Horario",
    mod.tipo AS "Tipo"
FROM Alumnos a
INNER JOIN Matriculas mat ON a.id_alumno = mat.alumno_id
INNER JOIN Ediciones e ON mat.edicion_id = e.id_edicion
INNER JOIN Materias m ON e.Materia_id = m.id_materia
INNER JOIN Campus c ON e.Campus_id = c.id_campus
INNER JOIN modalidades mod ON e.Modalidad_id = mod.id_modalidad
WHERE m.nombre_materia = 'DataScience'
ORDER BY a.Nombre_alumno;

-- NOTAS DE UN ALUMNO ESPECÍFICO
SELECT 
    a.Nombre_alumno,
    a.Email,
    p.nombre_proyecto AS "Proyecto",
    m.nombre_materia AS "Materia",
    CASE 
        WHEN p.nota = TRUE THEN 'APTO'
        WHEN p.nota = FALSE THEN 'NO APTO'
        ELSE 'SIN DEFINIR'
    END AS "Nota",
    e.Fecha AS "Edición"
FROM Proyectos p
INNER JOIN Alumnos a ON p.alumno_id = a.id_alumno
INNER JOIN Materias m ON p.materia_id = m.id_materia
INNER JOIN Ediciones e ON p.edicion_id = e.id_edicion
WHERE a.id_alumno = 1
ORDER BY m.nombre_materia, p.nombre_proyecto;

-- PROYECTO CON MÁS "NO APTO"
SELECT
    p.nombre_proyecto AS "Proyecto",
    m.nombre_materia AS "Materia",
    SUM(CASE WHEN p.nota = FALSE THEN 1 ELSE 0 END) AS "Total No Aptos",
    COUNT(*) AS "Total Evaluaciones"
FROM Proyectos p
INNER JOIN Materias m ON p.materia_id = m.id_materia
GROUP BY p.nombre_proyecto, m.nombre_materia
ORDER BY SUM(CASE WHEN p.nota = FALSE THEN 1 ELSE 0 END) DESC
LIMIT 1;

-- CUÁNTOS ESTUDIANTES HAY EN CADA MATERIA
SELECT 
    m.nombre_materia AS "Materia",
    COUNT(DISTINCT a.id_alumno) AS "Total Estudiantes"
FROM Materias m
INNER JOIN Ediciones e ON m.id_materia = e.Materia_id
INNER JOIN Matriculas mat ON e.id_edicion = mat.edicion_id
INNER JOIN Alumnos a ON mat.alumno_id = a.id_alumno
GROUP BY m.id_materia, m.nombre_materia;

-- MOSTRAR TODAS LAS EDICIONES QUE SE IMPARTIERON EN MADRID
SELECT 
    e.id_edicion,
    m.nombre_materia AS "Materia",
    e.Fecha AS "Fecha Inicio",
    mod.horario AS "Horario",
    mod.tipo AS "Tipo",
    cl1.Nombre_claustro AS "Profesor",
    cl2.Nombre_claustro AS "Ayudante",
    COUNT(DISTINCT mat.alumno_id) AS "Total Alumnos"
FROM Ediciones e
INNER JOIN Materias m ON e.Materia_id = m.id_materia
INNER JOIN Campus c ON e.Campus_id = c.id_campus
INNER JOIN modalidades mod ON e.Modalidad_id = mod.id_modalidad
LEFT JOIN Claustros cl1 ON e.Profesor_id = cl1.id_claustro
INNER JOIN Claustros cl2 ON e.Ayudante_id = cl2.id_claustro
INNER JOIN Matriculas mat ON e.id_edicion = mat.edicion_id
WHERE c.Localizacion = 'Madrid'
GROUP BY e.id_edicion, m.nombre_materia, e.Fecha, mod.horario, mod.tipo, cl1.Nombre_claustro, cl2.Nombre_claustro
ORDER BY e.Fecha DESC;

-- LISTAR LOS PROFESORES DE FULLSTACK
SELECT 
    cl.id_claustro,
    cl.Nombre_claustro AS "Profesor",
    COUNT(e.id_edicion) AS "Total Ediciones de FullStack"
FROM Claustros cl
INNER JOIN Ediciones e ON cl.id_claustro = e.Profesor_id
INNER JOIN Materias m ON e.Materia_id = m.id_materia
WHERE m.nombre_materia = 'FullStack'
GROUP BY cl.id_claustro, cl.Nombre_claustro
HAVING COUNT(e.id_edicion) > 0
ORDER BY cl.Nombre_claustro;

-- LISTAR LOS ALUMNOS CON SU MATERIA Y LOCALIZACIÓN
SELECT 
    a.id_alumno,
    a.Nombre_alumno,
    a.Email,
    m.nombre_materia AS "Materia",
    c.Localizacion AS "Campus",
    e.Fecha AS "Fecha Inicio",
    mod.tipo AS "Tipo (Presencial/Online)"
FROM Alumnos a
INNER JOIN Matriculas mat ON a.id_alumno = mat.alumno_id
INNER JOIN Ediciones e ON mat.edicion_id = e.id_edicion
INNER JOIN Materias m ON e.Materia_id = m.id_materia
INNER JOIN Campus c ON e.Campus_id = c.id_campus
INNER JOIN modalidades mod ON e.Modalidad_id = mod.id_modalidad
ORDER BY a.Nombre_alumno, m.nombre_materia;

-- INFORMACIÓN COMPLETA DE UNA EDICIÓN
SELECT 
    e.id_edicion,
    m.nombre_materia AS "Materia",
    e.Fecha AS "Fecha de Inicio",
    c.Localizacion AS "Campus",
    mod.horario AS "Horario",
    mod.tipo AS "Tipo",
    cl1.Nombre_claustro AS "Profesor",
    cl2.Nombre_claustro AS "Ayudante"
FROM Ediciones e
JOIN Materias m ON e.Materia_id = m.id_materia
JOIN Campus c ON e.Campus_id = c.id_campus
JOIN modalidades mod ON e.Modalidad_id = mod.id_modalidad
INNER JOIN Claustros cl1 ON e.Profesor_id = cl1.id_claustro
INNER JOIN Claustros cl2 ON e.Ayudante_id = cl2.id_claustro
WHERE e.id_edicion = 1;


