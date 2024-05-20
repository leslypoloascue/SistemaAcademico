using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CapaEntidad;  //  llamar al mapeado 
using System.Data;  // llamar buffer de la memoria : tablas con registros


namespace CapaNegocio.Interface
{
    interface IAlumno
    {
        //declara los metodos de la Clase Alumno 
        DataTable Listar();
        bool Agregar(Alumno alumno);
        bool Eliminar(string CodAlumno);
        bool Actualizar(Alumno alumno);
        DataTable Buscar(string CodAlumno);
    }
}
