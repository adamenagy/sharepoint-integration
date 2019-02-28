<%@ Page language="C#" %>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882">

<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<head>
<meta name="WebPartPageExpansion" content="full" />
<title></title>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
<link rel="stylesheet" href="https://developer.api.autodesk.com/viewingservice/v1/viewers/style.css" type="text/css" />
<script src="https://developer.api.autodesk.com/viewingservice/v1/viewers/viewer3D.min.js"></script>
<!-- <link href="Styles/generic.css" rel="stylesheet" /> -->
<script>
  $(function () {
    console.log("MyViewerPage Version : 1.0.0");
    MGC.initializeViewer();
  });
    
  var MGC = {
    initializeViewer : function() {         
      // Set from the server side on first time invocation
      var urn = Autodesk.Viewing.Private.getParameterByName("urn");
      var accessToken = Autodesk.Viewing.Private.getParameterByName("accessToken");		        
      console.log("urn : " + urn);
      console.log("accessToken : " + accessToken);

	    var options = {};
			 
      // Environment controls service end points viewer uses
      options.env = "AutodeskProduction";
      // Access token required for authentication and authorization
      // In practice you need to obtain a valid access token and pass it to viewer, instead of using this token 
      // Note it is valid for two hours so you will need to recreate from time to time.
      options.accessToken = accessToken;

      // The document to load in the viewer ...
      options.document =  "urn:" + urn;   
      
      // Use 3D viewer
      var viewerElement = document.getElementById('viewer3d');
      var viewer = new Autodesk.Viewing.Private.GuiViewer3D(viewerElement, {});
      //var viewer = new Autodesk.Viewing.Viewer3D(viewerElement, {});

		  Autodesk.Viewing.Initializer(options, function () {	
        viewer.initialize();

        // Load model
        MGC.loadDocument(viewer, Autodesk.Viewing.Private.getAuthObject(), options.document);
      });
    }, // initializeViewer 
    loadDocument : function(viewer, auth, documentId, initialItemId) {
      Autodesk.Viewing.Document.load(documentId, auth,
        function (document) {
			    var geometryItems = [];

	        if (initialItemId) {
	          geometryItems = Autodesk.Viewing.Document.getSubItemsWithProperties(document.getRootItem(), {'guid':initialItemId}, true);
	        }
	
	        if (geometryItems.length == 0) {
	          geometryItems = Autodesk.Viewing.Document.getSubItemsWithProperties(document.getRootItem(), {'type':'geometry', 'role':'3d'}, true);
	        }
	
	        if (geometryItems.length > 0) {
	          viewer.load(document.getViewablePath(geometryItems[0]));
	        }         
	      }, MGC.onErrorLoadModel
      );
    }, // loadDocument 
    onErrorLoadModel : function(msg) {
      var container = document.getElementById('viewer3d');
      if (container) {
        Autodesk.Viewing.Private.AlertBox.displayError(container, "LOAD Error: " + msg);
      }
    } // onErrorLoadModel 
  }; // MGC
</script>
<!--[if gte mso 9]>
  <SharePoint:CTFieldRefs runat="server" Prefix="mso:" FieldList="FileLeafRef,WikiField,_dlc_DocId,_dlc_DocIdUrl,_dlc_DocIdPersistId">
    <xml>		
    <mso:CustomDocumentProperties>
    <mso:_dlc_DocId msdt:dt="string">2C46KHKTKV4W-3-6</mso:_dlc_DocId>
    <mso:_dlc_DocIdItemGuid msdt:dt="string">4e0c012d-951e-4d8c-b2bc-c54a671336f1</mso:_dlc_DocIdItemGuid>
    <mso:_dlc_DocIdUrl msdt:dt="string">http://adamnagya9d4/_layouts/DocIdRedir.aspx?ID=2C46KHKTKV4W-3-6, 2C46KHKTKV4W-3-6</mso:_dlc_DocIdUrl>
    </mso:CustomDocumentProperties>
    </xml>
  </SharePoint:CTFieldRefs>
<![endif]-->
</head>

<body style="margin:0px; padding:0px; width: 100%; height: 100%;">

<div id="viewer3d" style="position: absolute; width: 100%; height: 100%; overflow: hidden;">
</div>

</body>

</html>