<%@ Register TagPrefix="WpNs0" Namespace="MyVisualWebPart.VisualWebPart1" Assembly="MyVisualWebPart, Version=1.0.0.0, Culture=neutral, PublicKeyToken=9f357d9628fdb26a"%>
<%-- _lcid="1033" _version="14.0.7006" _dal="1" --%>
<%-- _LocalBinding --%>
<%@ Page language="C#" MasterPageFile="~masterurl/default.master"    Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage,Microsoft.SharePoint,Version=14.0.0.0,Culture=neutral,PublicKeyToken=71e9bce111e9429c" meta:webpartpageexpansion="full" meta:progid="SharePoint.WebPartPage.Document"  %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Import Namespace="Microsoft.SharePoint" %> <%@ Assembly Name="Microsoft.Web.CommandUI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> <%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<asp:Content ContentPlaceHolderId="PlaceHolderPageTitle" runat="server">
	<SharePoint:ListItemProperty Property="BaseName" maxlength="40" runat="server"/>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderPageTitleInTitleArea" runat="server">
    <WebPartPages:WebPartZone runat="server" title="loc:TitleBar" id="TitleBar" AllowLayoutChange="false" AllowPersonalization="false"><ZoneTemplate>
    <WebPartPages:TitleBarWebPart runat="server" AllowEdit="True" AllowConnect="True" ConnectionID="00000000-0000-0000-0000-000000000000" Title="Web Part Page Title Bar" IsIncluded="True" Dir="Default" IsVisible="True" AllowMinimize="False" ExportControlledProperties="True" ZoneID="TitleBar" ID="g_b41ade37_0629_4798_8eaf_310ca727d610" HeaderTitle="MyWebPart" AllowClose="False" FrameState="Normal" ExportMode="All" AllowRemove="False" AllowHide="True" SuppressWebPartChrome="False" DetailLink="" ChromeType="None" HelpLink="" MissingAssembly="Cannot import this Web Part." PartImageSmall="" HelpMode="Modeless" FrameType="None" AllowZoneChange="True" PartOrder="2" Description="" PartImageLarge="" IsIncludedFilter="" __MarkupType="vsattributemarkup" __WebPartId="{B41ADE37-0629-4798-8EAF-310CA727D610}" WebPart="true" Height="" Width=""></WebPartPages:TitleBarWebPart>

</ZoneTemplate></WebPartPages:WebPartZone>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderTitleAreaClass" runat="server">
  <style type="text/css">
	Div.ms-titleareaframe {
	height: 100%;
	}
	.ms-pagetitleareaframe table {
	background: none;
	}
  </style>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderAdditionalPageHead" runat="server">
    <meta name="GENERATOR" content="Microsoft SharePoint" />
	<meta name="ProgId" content="SharePoint.WebPartPage.Document" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="CollaborationServer" content="SharePoint Team Web Site" />
	<script type="text/javascript">
// <![CDATA[
	var navBarHelpOverrideKey = "WSSEndUser";
// ]]>
	</script>
	<SharePoint:UIVersionedContent ID="WebPartPageHideQLStyles" UIVersion="4" runat="server">
		<ContentTemplate>
<style type="text/css">
body #s4-leftpanel {
	display:none;
}
.s4-ca {
	margin-left:0px;
}
</style>
		</ContentTemplate>
	</SharePoint:UIVersionedContent>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderSearchArea" runat="server">
    <SharePoint:DelegateControl runat="server"
		ControlId="SmallSearchInputBox"/>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderLeftActions" runat="server">
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderPageDescription" runat="server">
    <SharePoint:ProjectProperty Property="Description" runat="server"/>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderBodyRightMargin" runat="server">
    <div height="100%" class="ms-pagemargin"><img src="/_layouts/images/blank.gif" width="10" height="1" alt="" /></div>
</asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderPageImage" runat="server"></asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderNavSpacer" runat="server"></asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderLeftNavBar" runat="server"></asp:Content>
<asp:Content ContentPlaceHolderId="PlaceHolderMain" runat="server">
        <table cellpadding="4" cellspacing="0" border="0" width="100%">
				<tr>
					<td id="_invisibleIfEmpty" name="_invisibleIfEmpty" valign="top" width="100%"> 
                    <WebPartPages:WebPartZone runat="server" Title="loc:FullPage" ID="FullPage" FrameType="TitleBarOnly"><ZoneTemplate>
                    <WpNs0:VisualWebPart1 runat="server" ID="g_075ad1cb_a0ee_4b34_858f_bada139a867e" Description="My Visual WebPart" Title="VisualWebPart1" __MarkupType="vsattributemarkup" __WebPartId="{075AD1CB-A0EE-4B34-858F-BADA139A867E}" WebPart="true" __designer:IsClosed="false" partorder="2"></WpNs0:VisualWebPart1>

</ZoneTemplate></WebPartPages:WebPartZone> </td>
				</tr>
				<script type="text/javascript" language="javascript">if(typeof(MSOLayout_MakeInvisibleIfEmpty) == "function") {MSOLayout_MakeInvisibleIfEmpty();}</script>
		</table>
</asp:Content>
