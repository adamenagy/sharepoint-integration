#Autodesk View and Data API sample demos integration with sharepoint

##Description

*This sample is part of the [Developer-Autodesk/Autodesk-View-and-Data-API-Samples](https://github.com/Developer-Autodesk/autodesk-view-and-data-api-samples) repository.*

You can find a blog post about this here http://adndevblog.typepad.com/cloud_and_mobile/2014/06/integrate-viewer-with-sharepoint.html

This repo contains files that show how you can upload files and view them inside SharePoint using the Autodesk viewer.

There are three main parts to this:
* MyViewerPage.aspx: this html page uses the Autodesk Viewer to show the file whose urn is  passed to it in the URL as the urn parameter. It also requires the accessToken that you get when authenticating with the viewing service to be also passed in the URL
* MyVisualWebPart project: a C# Visual Web Part project which has a user control that can be used inside a SharePoint Web Part page. This will list all the files found in the Documents library of a SharePoint site and uses MyViewerPage.aspx inside an iframe to show the file in the viewer
* MyWebPart.aspx: this is the SharePoint page which embeds the above Visual Web part project's control that lists the SharePoint documents 


##Dependencies

* SharePoint: it was built using SharePoint 2010 server, but might work with later versions as well.
* RestSharpSigned: you can get it through the NuGet Visual Studio AddIn  

##Setup/Usage Instructions

* Get your consumer key and secret key from http://developer.autodesk.com
* Replace kConsumerKey and kSecretKey of the Constants class inside "MyVisualWebPart / MyVisualWebPart / VisualWebPart1 / VisualWebPart1UserControl.ascx.cs" with the ones you got.

Please refer to http://adndevblog.typepad.com/cloud_and_mobile/2014/06/integrate-viewer-with-sharepoint.html for more detailed instructions.

## License

This sample is licensed under the terms of the [MIT License](http://opensource.org/licenses/MIT). Please see the [LICENSE](LICENSE) file for full details.

##Written by 

Adam Nagy





    
