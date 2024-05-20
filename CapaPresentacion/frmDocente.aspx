<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="frmDocente.aspx.cs" Inherits="CapaPresentacion.frmDocente" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

       <p>Matenimiento de la tabla Docente</p>
    <p>
        CodDocente<asp:TextBox runat="server" ID ="txtCodDocente"></asp:TextBox>
          </p>
      <p>
        APaterno<asp:TextBox runat="server" ID ="txtAPaterno"></asp:TextBox>
          </p>
   
    <p>
       AMaterno<asp:TextBox runat="server" ID ="txtAMaterno"></asp:TextBox>
          </p>
    <p>
       Nombres<asp:TextBox runat="server" ID ="txtNombres"></asp:TextBox>
          </p>
    <p>
        CodUsuario<asp:TextBox runat="server" ID ="txtCodUsuario"></asp:TextBox>
          </p>
    <p>
        Contrasena<asp:TextBox runat="server" ID ="txtContrasena" TextMode="Password"></asp:TextBox>
          </p>

    <p>

        <asp:Button Text="Agregar" runat="server" ID ="btnAgregar" CssClass="btn btn-primary" OnClick="btnAgregar_Click" />
        <asp:Button Text="Eliminar" runat="server" ID ="btnEliminar" CssClass="btn btn-warning" OnClick="btnEliminar_Click" />
         <asp:Button Text="Actualizar" runat="server" ID ="btnActualizarr" CssClass="btn btn-success" OnClick="btnActualizar_Click" />
            </p>
      <p>
                    <asp:TextBox runat="server" ID="txtBuscar"></asp:TextBox>
                    <asp:Button runat="server" ID="btnBuscar" Text ="Buscar" OnClick="btnBuscar_Click" CssClass="btn btn-danger" />
                </p>
    
    <p>
        <asp:GridView runat="server" ID ="gvDocente"></asp:GridView>
            </p>
   <p>
        <asp:Label Text="Mensaje" runat="server" ID="lblMensaje"/>
    </p>
</asp:Content>
