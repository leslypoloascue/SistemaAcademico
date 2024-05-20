﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CapaDato;
using CapaEntidad;

namespace CapaNegocio
{
     public class AlumnoBL : Interface.IAlumno

    {
        // llmar a la capadato

        private Datos datos = new DatosSQL();

        // mensaje del procedimiento almacenado
        public string Mensaje{get; set;}

        public DataTable Listar ()
        {
            return datos.TraerDataTable("spListarAlumno");
        }
        public bool Agregar(Alumno alumno)
        {
            DataRow fila = datos.TraerDataRow("spAgregarAlumno", alumno.CodAlumno, alumno.APaterno, alumno.AMaterno,
                alumno.Nombres, alumno.CodUsuario, alumno.Contrasena, alumno.CodEscuela);
            //traer el mensaje del PA para llaverlo a formulario
            Mensaje = fila["Mensaje"].ToString();
            byte codError = Convert.ToByte(fila["CodError"]);
            if (codError == 0) return true;
            else return false;
         }

        public bool Eliminar(string CodAlumno)
        {
            DataRow fila = datos.TraerDataRow("spEliminarAlumno", CodAlumno);
            //traer el mensaje del PA para llaverlo a formulario
            Mensaje = fila["Mensaje"].ToString();
            byte codError = Convert.ToByte(fila["CodError"]);
            if (codError == 0) return true;
            else return false;
        }

        public bool Actualizar(Alumno alumno)
        {
            DataRow fila = datos.TraerDataRow("spActualizarAlumno", alumno.CodAlumno, alumno.APaterno, alumno.AMaterno,
        alumno.Nombres, alumno.CodUsuario, alumno.CodEscuela);
            //traer el mensaje del PA para llevarlo al formulario
            Mensaje = fila["Mensaje"].ToString();
            byte codError = Convert.ToByte(fila["CodError"]);
            if (codError == 0) return true;
            else return false;
        }
      
        public DataTable Buscar(string CodAlumno)
        {
            DataTable dt = datos.TraerDataTable("spBuscarAlumnoPorCodigo", CodAlumno);

            // Verificar si el DataTable tiene filas
            if (dt.Rows.Count > 0)
            {
                // Extraer el mensaje y el código de error de la primera fila
                int codError = Convert.ToInt32(dt.Rows[0]["CodError"]);
                string mensaje = dt.Rows[0]["Mensaje"].ToString();

                // Determinar el resultado basado en el código de error y retornar el mensaje
                if (codError == 0)
                {
                    // Si se encontró el docente, retornar la tabla con los datos del docente
                    return dt;
                }
                else
                {
                    // Si no se encontró el docente, lanzar una excepción con el mensaje de error
                    throw new Exception(mensaje);
                }
            }
            else
            {
                // Si no hay filas en el DataTable, lanzar una excepción con un mensaje de error genérico
                throw new Exception("Error desconocido al buscar el docente.");
            }
        }

    }
}
