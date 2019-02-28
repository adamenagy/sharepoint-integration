<%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %>
<%@ Assembly Name="Microsoft.Web.CommandUI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> 
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %>
<%@ Import Namespace="Microsoft.SharePoint" %> 
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VisualWebPart1UserControl.ascx.cs" Inherits="MyVisualWebPart.VisualWebPart1.VisualWebPart1UserControl" %>
<asp:TextBox ID="logBox" runat="server" TextMode="MultiLine" Width="488px"></asp:TextBox>
<div  style="float: left; display: block;" >
<asp:GridView ID="GridView1" runat="server" EnableModelValidation="True" 
        CellPadding="4" ForeColor="#333333" GridLines="None" 
        onselectedindexchanged="GridView1_SelectedIndexChanged">
        <Columns>
            <asp:TemplateField HeaderText="oneview_urn">
                <HeaderTemplate>
                    Extra
                </HeaderTemplate>
                <ItemTemplate>
                    <asp:Button ID="SendButton" OnClick="SendButton_Click" runat="server" Text="View" ToolTip='<%#DataBinder.Eval(Container.DataItem, "ID")%>' ></asp:Button>
                     <iframe runat="server" ID='ViewerPart'  style="width:500px; height: 300px; display:none"> </iframe>
                </ItemTemplate>
                <FooterTemplate>
                </FooterTemplate>
            </asp:TemplateField>
            </Columns>
    <AlternatingRowStyle BackColor="White" />
    <EditRowStyle BackColor="#7C6F57" />
    <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White" />
    <PagerStyle BackColor="#666666" ForeColor="White" HorizontalAlign="Center" />
    <RowStyle BackColor="#E3EAEB" />
    <SelectedRowStyle BackColor="#C5BBAF" BorderStyle="Solid" Font-Bold="True" 
        ForeColor="#333333" />
</asp:GridView>

   
</div>


 <iframe id="MyViewerId" style="width:500px; display: none; height: 300px;" src="" runat="server"> </iframe>

