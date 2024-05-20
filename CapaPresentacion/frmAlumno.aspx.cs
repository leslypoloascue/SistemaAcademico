using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using CapaEntidad;
using CapaNegocio;


namespace CapaPresentacion
{
    public partial class frmAlumno : System.Web.UI.Page
    {
        private void Listar()
        {
            AlumnoBL alumnoBL = new AlumnoBL();
            gvAlumno.DataSource = alumnoBL.Listar();
            gvAlumno.DataBind();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
                Listar();
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Alumno alumno = new Alumno();

            alumno.CodAlumno = txtCodAlumno.Text.Trim();
            alumno.APaterno = txtAPaterno.Text.Trim();
            alumno.AMaterno = txtAMaterno.Text.Trim();
            alumno.Nombres = txtNombres.Text.Trim();
            alumno.CodUsuario = txtCodUsuario.Text.Trim();
            alumno.Contrasena = txtContrasena.Text.Trim();
            alumno.CodEscuela = txtCodEscuela.Text.Trim();
            AlumnoBL alumnoBL = new AlumnoBL();
            if (alumnoBL.Agregar(alumno))
                Listar();
            lblMensaje.Text = alumnoBL.Mensaje;
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            string CodAlumno = txtCodAlumno.Text.Trim();

            // Mostrar un cuadro de diálogo de confirmación utilizando JavaScript
            string confirmScript = @"if(confirm('¿Estás seguro de que deseas eliminar este alumno?')) { __doPostBack('', ''); }";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "confirm", confirmScript, true);

            AlumnoBL alumnoBL = new AlumnoBL();
            if (alumnoBL.Eliminar(CodAlumno))
            {
                Listar();
                lblMensaje.Text = alumnoBL.Mensaje;
            }
        }



        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            Alumno alumno = new Alumno();

            alumno.CodAlumno = txtCodAlumno.Text.Trim();
            alumno.APaterno = txtAPaterno.Text.Trim();
            alumno.AMaterno = txtAMaterno.Text.Trim();
            alumno.Nombres = txtNombres.Text.Trim();
            alumno.CodUsuario = txtCodUsuario.Text.Trim();// debe el mismo correo para que actualize
            alumno.Contrasena = txtContrasena.Text.Trim();
            alumno.CodEscuela = txtCodEscuela.Text.Trim();

            AlumnoBL alumnoBL = new AlumnoBL();
            if (alumnoBL.Actualizar(alumno))
                Listar(); // Refresh the list after updating.
            lblMensaje.Text = alumnoBL.Mensaje;
        }
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                string CodAlumno = txtBuscar.Text.Trim();

                if (!string.IsNullOrEmpty(CodAlumno))
                {
                    AlumnoBL alumnoBL = new AlumnoBL();
                    DataTable dt = alumnoBL.Buscar(CodAlumno);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        gvAlumno.DataSource = dt;
                        gvAlumno.DataBind();
                        lblMensaje.Text = "Se encontró el alumno con el código proporcionado.";
                        lblMensaje.Text = "Código encontrado: " + CodAlumno ;



                    }
                    else
                    {
                        // Limpiar el GridView y mostrar mensaje de no encontrado
                        gvAlumno.DataSource = null;
                        gvAlumno.DataBind();
                        lblMensaje.Text = "No se encontraron alumnos con el código proporcionado.";
                    }
                }
                else
                {
                    // Mostrar mensaje de error si no se proporciona ningún código
                    lblMensaje.Text = "Por favor ingrese un código de alumno para buscar.";
                }
            }
            catch (Exception ex)
            {
                // Mostrar mensaje de error si ocurre alguna excepción
                lblMensaje.Text = "Error al buscar alumno: " + ex.Message;
            }
        }

    }
}

