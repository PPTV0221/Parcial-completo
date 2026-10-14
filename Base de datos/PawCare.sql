IF DB_ID('PawCareDB') IS NULL
    CREATE DATABASE PawCareDB;
GO
USE PawCareDB;
GO

IF OBJECT_ID('dbo.Mascotas', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mascotas (
        Id             INT IDENTITY(1,1) PRIMARY KEY,           
        NombreMascota  VARCHAR(80)  NOT NULL,
        NombreDueno    VARCHAR(100) NOT NULL,
        Tipo           VARCHAR(10)  NOT NULL
                       CONSTRAINT CK_Mascotas_Tipo CHECK (Tipo IN ('Perro','Gato','Otro')),
        Edad           INT          NOT NULL
                       CONSTRAINT CK_Mascotas_Edad CHECK (Edad BETWEEN 0 AND 30),
        Telefono       VARCHAR(9)   NOT NULL,                   
        Observaciones  VARCHAR(300) NULL                        
    );
END
GO

-- lista--
CREATE OR ALTER PROCEDURE dbo.spListarMascotas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, NombreMascota, NombreDueno, Tipo, Edad, Telefono, Observaciones
    FROM dbo.Mascotas
    ORDER BY Id DESC;
END
GO

-- Mascota--
CREATE OR ALTER PROCEDURE dbo.spInsertarMascota
    @NombreMascota VARCHAR(80),
    @NombreDueno   VARCHAR(100),
    @Tipo          VARCHAR(10),
    @Edad          INT,
    @Telefono      VARCHAR(9),
    @Observaciones VARCHAR(300) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Mascotas (NombreMascota, NombreDueno, Tipo, Edad, Telefono, Observaciones)
    VALUES (@NombreMascota, @NombreDueno, @Tipo, @Edad, @Telefono, @Observaciones);
END
GO

-- info test--
IF NOT EXISTS (SELECT 1 FROM dbo.Mascotas)
    EXEC dbo.spInsertarMascota 'Firulais', 'Juan Pérez', 'Perro', 3, '987654321', 'Vacuna al día';
GO

EXEC dbo.spListarMascotas;
GO
