using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CapaEntidad;  //  llamar al mapeado 
using System.Data;  // llamar buffer de la memoria : tablas con registros


namespace CapaNegocio.Interface
{
    interface IDocente
    {
        //declara los metodos de la Clase Docente
        DataTable Listar();
        bool Agregar(Docente docente);
        bool Eliminar(string CodDocente);
        bool Actualizar(Docente docente);
        DataTable Buscar(string CodDocente);

    }
}
