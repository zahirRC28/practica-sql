CREATE TABLE Alumnos (
    id_alumno SERIAL PRIMARY KEY ,
    Nombre_alumno VARCHAR(50),
    Email VARCHAR(50)
);

CREATE TABLE Claustros (
    id_claustro SERIAL PRIMARY KEY,
    Nombre_claustro VARCHAR(50)
);

CREATE TABLE Campus (
    id_campus SERIAL PRIMARY KEY,
    Localizacion VARCHAR(50)
);

CREATE TABLE modalidades (
    id_modalidad SERIAL PRIMARY KEY,
    horario VARCHAR(50),
    tipo VARCHAR(50)
);



CREATE TABLE Materias(
    id_materia SERIAL PRIMARY KEY,
    nombre_materia VARCHAR(50)

);

CREATE TABLE Ediciones (
    id_edicion SERIAL PRIMARY KEY,
    Fecha DATE,
    Campus_id INT,
    Modalidad_id INT,
    Materia_id INT,
    Profesor_id INT,
    Ayudante_id INT,
    FOREIGN KEY (Campus_id) REFERENCES Campus(id_campus),
    FOREIGN KEY (Modalidad_id) REFERENCES Modalidades(id_modalidad),
    FOREIGN KEY (Materia_id) REFERENCES Materias(id_materia),
    FOREIGN KEY (Profesor_id) REFERENCES Claustros(id_claustro),
	FOREIGN KEY (Ayudante_id) REFERENCES Claustros(id_claustro) 
);

CREATE TABLE Matriculas (
    alumno_id INT,
    edicion_id INT,
    PRIMARY KEY (alumno_id, edicion_id),
    FOREIGN KEY (alumno_id) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (edicion_id) REFERENCES Ediciones(id_edicion)
);

CREATE TABLE Proyectos (
    id_proyecto SERIAL PRIMARY KEY,
    nombre_proyecto VARCHAR,
    alumno_id INT,
    materia_id INT,
    edicion_id INT,
    nota BOOLEAN,
    FOREIGN KEY (alumno_id) REFERENCES Alumnos(id_alumno),
    FOREIGN KEY (materia_id) REFERENCES Materias(id_materia),
    FOREIGN KEY (edicion_id) REFERENCES Ediciones(id_edicion)
);





