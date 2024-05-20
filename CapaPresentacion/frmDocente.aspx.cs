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

        public partial class frmDocente : System.Web.UI.Page
        {
            private void Listar()
            {
                DocenteBL docenteBL = new DocenteBL();
                gvDocente.DataSource = docenteBL.Listar();
                gvDocente.DataBind();
            }
        
        

        protected void Page_Load(object sender, EventArgs e)
            {
                if (!Page.IsPostBack)
                    Listar();
            }

            protected void btnAgregar_Click(object sender, EventArgs e)
            {
            Docente docente = new Docente();

            docente.CodDocente = txtCodDocente.Text.Trim();
            docente.APaterno = txtAPaterno.Text.Trim();
            docente.AMaterno = txtAMaterno.Text.Trim();
            docente.Nombres = txtNombres.Text.Trim();
            docente.CodUsuario = txtCodUsuario.Text.Trim();// debe el mismo correo para que actualize
            docente.Contrasena = txtContrasena.Text.Trim();

            DocenteBL docenteBL = new DocenteBL();
            if (docenteBL.Agregar(docente))
                Listar(); // Refresh the list after updating.
            lblMensaje.Text = docenteBL.Mensaje;
        }

            protected void btnEliminar_Click(object sender, EventArgs e)
            {
            string CodDocente = txtCodDocente.Text.Trim();

            // Mostrar un cuadro de diálogo de confirmación utilizando JavaScript
            string confirmScript = @"if(confirm('¿Estás seguro de que deseas eliminar este alumno?')) { __doPostBack('', ''); }";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "confirm", confirmScript, true);

            DocenteBL docenteBL = new DocenteBL();
            if (docenteBL.Eliminar(CodDocente))
            {
                Listar();
                lblMensaje.Text = docenteBL.Mensaje;
            }
        }

            protected void btnActualizar_Click(object sender, EventArgs e)
            {
            Docente docente = new Docente();

            docente.CodDocente = txtCodDocente.Text.Trim();
            docente.APaterno = txtAPaterno.Text.Trim();
            docente.AMaterno = txtAMaterno.Text.Trim();
            docente.Nombres = txtNombres.Text.Trim();
            docente.CodUsuario = txtCodUsuario.Text.Trim();// debe el mismo correo para que actualize
            docente.Contrasena = txtContrasena.Text.Trim();

            DocenteBL docenteBL = new DocenteBL();
            if (docenteBL.Actualizar(docente))
                Listar(); // Refresh the list after updating.
            lblMensaje.Text = docenteBL.Mensaje;
      
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                string CodDocente = txtBuscar.Text.Trim();
                if (!string.IsNullOrEmpty(CodDocente))
                {
                    DocenteBL docenteBL = new DocenteBL();
                    DataTable dt = docenteBL.Buscar(CodDocente);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        // Asignar los datos al GridView
                        gvDocente.DataSource = dt;
                        gvDocente.DataBind();

                        lblMensaje.Text = "Se encontró el docente con el código proporcionado.";
                        lblMensaje.Text = "Código encontrado: " + CodDocente;
                    }
                    else
                    {
                        // Limpiar el GridView y mostrar mensaje de no encontrado
                        gvDocente.DataSource = null;
                        gvDocente.DataBind();
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
