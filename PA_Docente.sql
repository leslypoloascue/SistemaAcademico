use BDAcademico
go
--LISTAR
-- Procedimientos almacenados para TAlumno
if OBJECT_ID('spListarDocente') is not null
	drop proc spListarDocente
go
create proc spListarDocente
as
begin
	select * from TDocente
end
go

--AGREGAR
-- Procedimiento almacenado para agregar Docente
if OBJECT_ID('spAgregarDocente') is not null
	drop proc spAgregarDocente
go
create proc spAgregarDocente
@CodDocente char(5),
@APaterno varchar(50),
@AMaterno varchar(50),
@Nombres varchar(50),
@CodUsuario varchar(50),
@Contrasena varchar(50) -- Assuming Contrasena is the password
as
begin
	-- CodDocente no se duplique
	if not exists(select CodDocente from TDocente where CodDocente = @CodDocente)
	begin
		-- Usuario no existe en TUsuario
		if not exists(select CodUsuario from TUsuario where CodUsuario = @CodUsuario)
		begin
			begin try
				begin tran tranAgregar 
					insert into TUsuario values(@CodUsuario,ENCRYPTBYPASSPHRASE('miFraseDeContraseña', @Contrasena))
					insert into TDocente values(@CodDocente,@APaterno,@AMaterno,@Nombres,@CodUsuario)
				commit tran tranAgregar
				select CodError = 0, Mensaje = 'Docente insertado correctamente'
			end try
			begin catch
				rollback tran tranAgregar
				select CodError = 1, Mensaje = 'Error: No se ejecutó la transacción'
			end catch
		end
		else select CodError = 1, Mensaje = 'Error: Usuario ya asignado en TUsuario'
	end
	else select CodError = 1, Mensaje = 'Error: Código de Docente duplicado en la TDocente'
end
go

exec spAgregarDocente 'D09','Estrada','Sanchez','Americo Luis ','polo@hotmail.com','1234'
go


exec spAgregarDocente 'D010','Serrano','Lopez','Sonia Libia ','sonia@hotmail.com','1234'
go

--ELIMINAR

if OBJECT_ID('spEliminarDocente') is not null
	drop proc spEliminarDocente
go
create proc spEliminarDocente
@CodDocente char(5)
as
begin
    begin try
        begin tran tranEliminar
            delete from TDocente where CodDocente = @CodDocente
            delete from TUsuario where CodUsuario = (select CodUsuario from TDocente where CodDocente = @CodDocente)
        commit tran tranEliminar
        select CodError = 0, Mensaje = 'Docente eliminado correctamente'
    end try
    begin catch
        rollback tran tranEliminar
        select CodError = 1, Mensaje = 'Error: No se ejecutó la transacción'
    end catch
end
go

exec spEliminarDocente 'D010'
go



--Actualizar 
if OBJECT_ID('spActualizarDocente') is not null
    drop proc spActualizarDocente
go
create proc spActualizarDocente
@CodDocente char(5),
@APaterno varchar(50),
@AMaterno varchar(50),
@Nombres varchar(50),
@CodUsuario varchar(50)
as
begin
    begin try
        begin tran tranActualizar
            update TDocente set APaterno = @APaterno, AMaterno = @AMaterno, Nombres = @Nombres where CodDocente = @CodDocente
            update TUsuario set CodUsuario = @CodUsuario where CodUsuario = (select CodUsuario from TDocente where CodDocente = @CodDocente)
        commit tran tranActualizar
        select CodError = 0, Mensaje = 'Docente actualizado correctamente'
    end try
    begin catch
        rollback tran tranActualizar
        select CodError = 1, Mensaje = 'Error: No se ejecutó la transacción'
    end catch
end
go


exec spActualizarDocente 'D09', 'Estrada', 'Sanchez', 'Americo Luis ', 'nicol@hotmail.com'
go



--Buscar

if OBJECT_ID('spBuscarDocentePorCodigo') is not null
    drop proc spBuscarDocentePorCodigo
go
create proc spBuscarDocentePorCodigo
@CodDocente char(5)
as
begin
    -- Realiza la consulta y almacena el resultado en una tabla temporal
    select * into #TempDocente
    from TDocente
    where CodDocente = @CodDocente;

    -- Verifica si se encontraron filas
    if (select count(*) from #TempDocente) > 0
    begin
        -- Si se encontraron filas, retorna el docente encontrado y el mensaje de éxito
        select CodError = 0, Mensaje = 'Se encontró el código del docente'
        select * from #TempDocente
    end
    else
    begin
        -- Si no se encontraron filas, retorna el mensaje de error
        select CodError = 1, Mensaje = 'No se encontró el código del docente'
    end

    -- Limpia la tabla temporal
    drop table #TempDocente
end
go


EXEC spBuscarDocentePorCodigo 'D10'
go