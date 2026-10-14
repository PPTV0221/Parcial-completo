using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace PawCare
{
    public partial class _Default : System.Web.UI.Page
    {
        private readonly string cadena =
            ConfigurationManager.ConnectionStrings["PawCareDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarMascotas();
            }
        }

        // Requisito 5: el GridView se alimenta ejecutando spListarMascotas
        private void CargarMascotas()
        {
            try
            {
                using (SqlConnection cn = new SqlConnection(cadena))
                using (SqlCommand cmd = new SqlCommand("spListarMascotas", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable tabla = new DataTable();
                        da.Fill(tabla);               // abre y cierra la conexión
                        gvMascotas.DataSource = tabla;
                        gvMascotas.DataBind();
                        lblTotal.Text = tabla.Rows.Count.ToString();
                    }
                }

                // Encabezado como <thead> (mejor estilo con Bootstrap)
                if (gvMascotas.HeaderRow != null)
                {
                    gvMascotas.HeaderRow.TableSection = TableRowSection.TableHeader;
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("No se pudo cargar el listado: " + ex.Message, false);
            }
        }

        // Requisito 5: spInsertarMascota con CommandType.StoredProcedure y SqlParameter
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid) return;

            try
            {
                using (SqlConnection cn = new SqlConnection(cadena))
                using (SqlCommand cmd = new SqlCommand("spInsertarMascota", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@NombreMascota", SqlDbType.VarChar, 80).Value = txtNombreMascota.Text.Trim();
                    cmd.Parameters.Add("@NombreDueno", SqlDbType.VarChar, 100).Value = txtNombreDueno.Text.Trim();
                    cmd.Parameters.Add("@Tipo", SqlDbType.VarChar, 10).Value = ddlTipo.SelectedValue;
                    cmd.Parameters.Add("@Edad", SqlDbType.Int).Value = int.Parse(txtEdad.Text.Trim());
                    cmd.Parameters.Add("@Telefono", SqlDbType.VarChar, 9).Value = txtTelefono.Text.Trim();
                    cmd.Parameters.Add("@Observaciones", SqlDbType.VarChar, 300).Value =
                        string.IsNullOrWhiteSpace(txtObservaciones.Text)
                            ? (object)DBNull.Value
                            : txtObservaciones.Text.Trim();

                    cn.Open();
                    cmd.ExecuteNonQuery();
                }

                LimpiarFormulario();
                CargarMascotas();
                MostrarMensaje("Mascota registrada correctamente.", true);
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al registrar: " + ex.Message, false);
            }
        }

        private void MostrarMensaje(string texto, bool exito)
        {
            lblMensaje.Visible = true;
            lblMensaje.CssClass = "alert d-block " + (exito ? "alert-success" : "alert-danger");
            lblMensaje.Text = Server.HtmlEncode(texto);
        }

        private void LimpiarFormulario()
        {
            txtNombreMascota.Text = "";
            txtNombreDueno.Text = "";
            ddlTipo.SelectedIndex = 0;
            txtEdad.Text = "";
            txtTelefono.Text = "";
            txtObservaciones.Text = "";
        }
    }
}
