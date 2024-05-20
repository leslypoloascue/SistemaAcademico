use BDAcademico
go
--listar
-- Procedimientos almacenados para TAlumno
if OBJECT_ID('spListarAlumno') is not null
	drop proc spListarAlumno
go
create proc spListarAlumno
as
begin
	select * from TAlumno
end
go

exec spListarAlumno
go
--AGREGAR
-- Procediimiento almacenado para agregar Alumno
if OBJECT_ID('spAgregarAlumno') is not null
	drop proc spAgregarAlumno
go
create proc spAgregarAlumno
@CodAlumno char(5),
@APaterno varchar(50),
@AMaterno varchar(50),
@Nombres varchar(50),
@CodUsuario varchar(50),
@Contrasena varchar(50),
@CodEscuela char(3)
as
begin
	-- CodAlumno no se duplique
	if not exists(select CodAlumno from TAlumno where CodAlumno = @CodAlumno)
		-- Usuario no existe en TUsuario
		if not exists(select CodUsuario from TUsuario where CodUsuario=@CodUsuario)
			-- CodCarrera debe existir en la tabla TCarrera
			if exists(select CodEscuela from TEscuela where CodEscuela = @CodEscuela)
				begin
					begin tran tranAgregar 
					begin try
						insert into TUsuario values(@CodUsuario,ENCRYPTBYPASSPHRASE('miFraseDeContraseña', @Contrasena))
						insert into TAlumno values(@CodAlumno,@APaterno,@AMaterno,@Nombres,@CodUsuario,@CodEscuela)
						commit tran tranAgregar
						select CodError = 0, Mensaje = 'Alumno insertado correctamente'
					end try
					begin catch
						rollback tran tranAgregar
						select CodError = 1, Mensaje = 'Error: No se ejecuto la transaccion'
					end catch
				end
			else select CodError = 1, Mensaje = 'Error: CodEscuela no existe en TEscuela'
		else select CodError = 1, Mensaje = 'Error: Usuario ya asignado en TUsuario'
	else select CodError = 1, Mensaje = 'Error: Codigo de Alumno duplicado en la TAlumno'
end
go

exec spAgregarAlumno 'A0031','Juarez','Maquera','Rosa','juarezm@gmail.com','1234','C01'
go
--Eliminar
-- Procedimiento almacenado para eliminar un alumno
if OBJECT_ID('spEliminarAlumno') is not null
	drop proc spEliminarAlumno
go
create proc spEliminarAlumno
@CodAlumno char(5)
as
begin
	-- Verificar que el CodAlumno existe en la tabla Alumno
	if exists (select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
	begin
	    declare @CodUsuario varchar(50)
		set @CodUsuario = (select CodUsuario from TAlumno where CodAlumno = @CodAlumno)
		if exists (select CodUsuario from TUsuario where CodUsuario = @CodUsuario)
		begin
			begin tran tranEliminar
				begin try
					delete from TAlumno where CodAlumno = @CodAlumno
					delete from TUsuario where CodUsuario = @CodUsuario
					commit tran tranEliminar
					select CodError = 0, Mensaje = 'Alumno eliminado correctamente'
				end try
				begin catch
					rollback tran tranEliminar
					select CodError = 1, Mensaje = 'Error: No se ejecuto la transaccion'
				end catch
			end			
		else select CodError = 1, Mensaje = 'Error: No existe CodUsuario en la TUsuario'		
	end
	else select CodError = 1, Mensaje = 'Error: CodAlumo no existe en la TAlumno'
end
go

exec spEliminarAlumno 'A0031'
go

-- Login de usuario
if OBJECT_ID('spLogin') is not null
	drop proc spLogin
go
create proc spLogin
@CodUsuario varchar(50),@Contrasena varchar(50)
as
begin
	if exists (select CodUsuario from TUsuario where CodUsuario = @CodUsuario and CONVERT(varchar(50),DECRYPTBYPASSPHRASE('miFraseDeContraseña', Contrasena))=@Contrasena)
	begin
		if exists (select CodUsuario from TDocente where CodUsuario = @CodUsuario)
			select CodError = 0, Mensaje = 'Docente'
		else if exists (select CodUsuario from TAlumno where CodUsuario = @CodUsuario)
			select CodError = 0, Mensaje = 'Alumno'
		else 
			select CodError = 1, Mensaje = 'Error: Usuario no tiene privilegio de docente ni alumno, consulte al administrador'
	end
	else 
		select CodError = 1, Mensaje = 'Error: Usuario y / o contraseñas incorrectas'
end
go

exec spLogin 'cuellar@hotmail.com','1234'
go



--Actualizar 
if OBJECT_ID('spActualizarAlumno') is not null
    drop proc spActualizarAlumno
go

create proc spActualizarAlumno
    @CodAlumno char(5),
    @APaterno varchar(50),
    @AMaterno varchar(50),
    @Nombres varchar(50),
    @CodUsuario varchar(50),
    @CodEscuela char(3)
as
begin
    -- Check if the student exists in TAlumno
    if exists (select CodAlumno from TAlumno where CodAlumno = @CodAlumno)
    begin
        -- Check if the provided username exists in TUsuario
        if exists (select CodUsuario from TUsuario where CodUsuario = @CodUsuario)
        begin
            -- Check if the provided school code exists in TEscuela
            if exists (select CodEscuela from TEscuela where CodEscuela = @CodEscuela)
            begin
                begin tran tranActualizar
                    begin try
                        -- Update student information in TAlumno
                        update TAlumno
                        set APaterno = @APaterno,
                            AMaterno = @AMaterno,
                            Nombres = @Nombres,
                            CodUsuario = @CodUsuario,
                            CodEscuela = @CodEscuela
                        where CodAlumno = @CodAlumno

                        -- Commit the transaction
                        commit tran tranActualizar

                        select CodError = 0, Mensaje = 'Alumno actualizado correctamente'
                    end try
                    begin catch
                        -- Rollback the transaction if an error occurs
                        rollback tran tranActualizar
                        select CodError = 1, Mensaje = 'Error: No se pudo actualizar el alumno'
               	end catch
				end
            else select CodError = 1, Mensaje = 'Error: CodEscuela no existe en TEscuela'
				end
        else select CodError = 1, Mensaje = 'Error: Usuario no existe en TUsuario'
			end
    else select CodError = 1, Mensaje = 'Error: Codigo de Alumno no existe en TAlumno'
end
go

EXEC spActualizarAlumno 'A0031', 'Lopez', 'Escobedo', 'Nicol', 'juarezm@gmail.com', 'C01'
go

--Buscar

if OBJECT_ID('spBuscarAlumnoPorCodigo') is not null
    drop proc spBuscarAlumnoPorCodigo
go
create proc spBuscarAlumnoPorCodigo
@CodAlumno char(5)
as
begin
    -- Realiza la consulta y almacena el resultado en una tabla temporal
    select * into #TempAlumno
    from TAlumno
    where CodAlumno = @CodAlumno;

    -- Verifica si se encontraron filas
    if (select count(*) from #TempAlumno) > 0
    begin
        -- Si se encontraron filas, retorna el docente encontrado y el mensaje de éxito
        select CodError = 0, Mensaje = 'Se encontró el código del docente'
        select * from #TempAlumno
    end
    else
    begin
        -- Si no se encontraron filas, retorna el mensaje de error
        select CodError = 1, Mensaje = 'No se encontró el código del docente'
    end

    -- Limpia la tabla temporal
    drop table #TempAlumno
end
go


EXEC spBuscarAlumnoPorCodigo 'A0001'
go


