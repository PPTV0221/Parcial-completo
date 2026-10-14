<%@ Page Title="PawCare" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PawCare._Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row g-4">

        <!-- ===== Formulario (en móvil ocupa todo el ancho y va arriba) ===== -->
        <div class="col-12 col-lg-4">
            <div class="card pc-card">
                <div class="card-header pc-card-header">
                    <i class="bi bi-plus-circle me-2"></i>Nueva mascota
                </div>
                <div class="card-body">

                    <asp:Label ID="lblMensaje" runat="server" Visible="false" role="alert"></asp:Label>

                    <div class="mb-3">
                        <asp:Label ID="lblNombreMascota" runat="server" AssociatedControlID="txtNombreMascota"
                            CssClass="form-label" Text="Nombre de la mascota *"></asp:Label>
                        <asp:TextBox ID="txtNombreMascota" runat="server" CssClass="form-control"
                            MaxLength="80" placeholder="Ej: Firulais" autocomplete="off"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvMascota" runat="server"
                            ControlToValidate="txtNombreMascota" Display="Dynamic" CssClass="text-danger pc-error"
                            ErrorMessage="El nombre de la mascota es obligatorio."></asp:RequiredFieldValidator>
                    </div>

                    <div class="mb-3">
                        <asp:Label ID="lblNombreDueno" runat="server" AssociatedControlID="txtNombreDueno"
                            CssClass="form-label" Text="Nombre del dueño *"></asp:Label>
                        <asp:TextBox ID="txtNombreDueno" runat="server" CssClass="form-control"
                            MaxLength="100" placeholder="Ej: Juan Pérez" autocomplete="off"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDueno" runat="server"
                            ControlToValidate="txtNombreDueno" Display="Dynamic" CssClass="text-danger pc-error"
                            ErrorMessage="El nombre del dueño es obligatorio."></asp:RequiredFieldValidator>
                    </div>

                    <div class="row g-3 mb-3">
                        <div class="col-6">
                            <asp:Label ID="lblTipo" runat="server" AssociatedControlID="ddlTipo"
                                CssClass="form-label" Text="Tipo"></asp:Label>
                            <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Perro" Value="Perro"></asp:ListItem>
                                <asp:ListItem Text="Gato" Value="Gato"></asp:ListItem>
                                <asp:ListItem Text="Otro" Value="Otro"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-6">
                            <asp:Label ID="lblEdad" runat="server" AssociatedControlID="txtEdad"
                                CssClass="form-label" Text="Edad (años) *"></asp:Label>
                            <asp:TextBox ID="txtEdad" runat="server" CssClass="form-control"
                                TextMode="Number" min="0" max="30" step="1" placeholder="0 - 30"></asp:TextBox>
                        </div>
                        <div class="col-12 mt-0">
                            <asp:RequiredFieldValidator ID="rfvEdad" runat="server"
                                ControlToValidate="txtEdad" Display="Dynamic" CssClass="text-danger pc-error"
                                ErrorMessage="La edad es obligatoria."></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rvEdad" runat="server"
                                ControlToValidate="txtEdad" Type="Integer" MinimumValue="0" MaximumValue="30"
                                Display="Dynamic" CssClass="text-danger pc-error"
                                ErrorMessage="La edad debe estar entre 0 y 30 años."></asp:RangeValidator>
                        </div>
                    </div>

                    <div class="mb-3">
                        <asp:Label ID="lblTelefono" runat="server" AssociatedControlID="txtTelefono"
                            CssClass="form-label" Text="Teléfono *"></asp:Label>
                        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control"
                            MaxLength="9" placeholder="9 dígitos, ej: 987654321" autocomplete="off"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTelefono" runat="server"
                            ControlToValidate="txtTelefono" Display="Dynamic" CssClass="text-danger pc-error"
                            ErrorMessage="El teléfono es obligatorio."></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revTelefono" runat="server"
                            ControlToValidate="txtTelefono" ValidationExpression="^\d{9}$"
                            Display="Dynamic" CssClass="text-danger pc-error"
                            ErrorMessage="El teléfono debe tener 9 dígitos numéricos."></asp:RegularExpressionValidator>
                    </div>

                    <div class="mb-3">
                        <asp:Label ID="lblObservaciones" runat="server" AssociatedControlID="txtObservaciones"
                            CssClass="form-label" Text="Observaciones (opcional)"></asp:Label>
                        <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" MaxLength="300"
                            placeholder="Vacunas, alergias, notas..."></asp:TextBox>
                    </div>

                    <asp:Button ID="btnGuardar" runat="server" Text="Registrar mascota"
                        CssClass="btn pc-btn w-100" OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>

        <!-- ===== GridView (en móvil queda debajo del formulario) ===== -->
        <div class="col-12 col-lg-8">
            <div class="card pc-card">
                <div class="card-header pc-card-header">
                    <i class="bi bi-list-ul me-2"></i>Mascotas registradas
                    <asp:Label ID="lblTotal" runat="server" CssClass="badge rounded-pill bg-secondary ms-1" Text="0"></asp:Label>
                </div>
                <div class="table-responsive">
                    <asp:GridView ID="gvMascotas" runat="server" AutoGenerateColumns="False"
                        UseAccessibleHeader="true" GridLines="None"
                        CssClass="table table-striped table-hover pc-grid"
                        EmptyDataText="No hay mascotas registradas."
                        EmptyDataRowStyle-CssClass="pc-empty">
                        <Columns>
                            <asp:BoundField DataField="Id" HeaderText="Id" />
                            <asp:BoundField DataField="NombreMascota" HeaderText="Mascota" />
                            <asp:BoundField DataField="NombreDueno" HeaderText="Dueño" />
                            <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
                            <asp:BoundField DataField="Edad" HeaderText="Edad" />
                            <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                            <asp:BoundField DataField="Observaciones" HeaderText="Observaciones" NullDisplayText="—" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

    </div>

</asp:Content>
