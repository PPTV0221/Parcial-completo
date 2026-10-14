# PawCare – Registro de mascotas

Aplicación ASP.NET WebForms (.NET Framework 4.8) con SQL Server, ADO.NET y Bootstrap 5.

## Cómo ejecutarla
1. Abre **SSMS** y ejecuta `Scripts/PawCare.sql` (crea `PawCareDB`, la tabla `Mascotas`, `spListarMascotas` y `spInsertarMascota`).
2. Abre `PawCare.sln` con **Visual Studio 2019/2022** (carga de trabajo *ASP.NET y desarrollo web*).
3. Revisa la cadena de conexión `PawCareDB` en `Web.config` (por defecto `.\SQLEXPRESS`; para LocalDB usa `(localdb)\MSSQLLocalDB`).
4. Pulsa **F5**.

## Requisitos cubiertos
| Requisito | Dónde |
|---|---|
| 1. Tabla `Mascotas` | `Scripts/PawCare.sql` |
| 2. `spListarMascotas`, `spInsertarMascota` | `Scripts/PawCare.sql` |
| 3. Formulario + GridView, Bootstrap responsivo | `Default.aspx`, `Site.Master`, `Content/Site.css` |
| 4. Validaciones (Required, RegularExpression, Range) | `Default.aspx` |
| 5. ADO.NET con `CommandType.StoredProcedure` y `SqlParameter` | `Default.aspx.cs` |

## Demo HTML
`Demo_HTML/index.html` es una versión estática (sin servidor ni base de datos) que se abre con doble clic; guarda los datos en el navegador.
