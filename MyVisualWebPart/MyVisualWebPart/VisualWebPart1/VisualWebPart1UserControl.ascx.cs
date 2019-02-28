using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using Microsoft.SharePoint;
using System.Data;
using RestSharp;

namespace MyVisualWebPart.VisualWebPart1
{
  using System;
  using System.Collections.Generic;
  using System.Linq;
  using System.Web;
  using System.Net;
  using System.Net.Security;
  using System.Security.Cryptography.X509Certificates;
  using System.Web.SessionState;
  using System.IO;
  using System.Text;
  using System.Web.UI.HtmlControls;

  public static class Constants
  {
    public const string kConsumerKey = @"your app's consumer key";
    public const string kSecretKey = @"your app's secret key";
    public const string kBaseUrl = @"https://developer.api.autodesk.com";
  }

  // Used to receive the data through the REST requests
  namespace Models
  {
    public class AuthResult
    {
      public string token_type { get; set; }
      public int expires_in { get; set; }
      public string access_token { get; set; }
    }

    public class BucketCreationData
    {
      public string bucketKey { get; set; }
      public List<ServicesAllowed> servicesAllowed { get; set; }
      public string policy { get; set; }
    }

    public class ServicesAllowed
    {
      public string serviceId { get; set; }
      public string access { get; set; }
    }

    public class BucketCreationResult
    {
      public string key { get; set; }
      public string owner { get; set; }
      public DateTime createdDate { get; set; }
      public List<ServicesAllowed> permissions { get; set; }
      public string policy { get; set; }
    }
  }

  public partial class VisualWebPart1UserControl : UserControl
  {
    private static string _accessToken = "";
    // You could name the bucket anything, but naming has some requirements, 
    // e.g. it should be all small case
    private static string _bucketKey = "mytestbucket";
    private static string _base64URN = "";
    private static SPListItem _item = null;
    private static RestClient _client;

    private void logMessage(string message)
    {
      logBox.Text += message; 
    }

    private void logIn()
    {
      _client = new RestClient(Constants.kBaseUrl);

      RestRequest req = new RestRequest();
      req.Resource = "authentication/v1/authenticate";
      req.Method = Method.POST;
      req.AddHeader("Content-Type", "application/x-www-form-urlencoded");
      req.AddParameter("client_id", Constants.kConsumerKey);
      req.AddParameter("client_secret", Constants.kSecretKey);
      req.AddParameter("grant_type", "client_credentials");

      IRestResponse<Models.AuthResult> resp = _client.Execute<Models.AuthResult>(req);
      if (resp.StatusCode == System.Net.HttpStatusCode.OK)
      {
        Models.AuthResult ar = resp.Data;
        if (ar != null)
        {
          _accessToken = ar.access_token; 
          CreateBucket();

          logMessage("\nAuthenticate success, access token is: "
              + _accessToken + ", and bucket key is " + _bucketKey);
        }
      }
    }

    // The settoken call will validate the token and set the token as 
    // secure cookie in your browser. This would mean that the subsequent 
    // calls from the browser need not send the token in the authorization 
    // header as the token would be sent in the cookie as part of the requests.
    // We do not have to use it in this case though
    private bool SetToken(string accessToken)
    {
      RestRequest req = new RestRequest();
      req.Resource = "utility/v1/settoken";
      req.Method = Method.POST;
      req.AddHeader("Content-Type", "application/x-www-form-urlencoded");
      req.AddParameter("access-token", accessToken);

      IRestResponse resp = _client.Execute(req);
      if (resp.StatusCode == System.Net.HttpStatusCode.OK)
      {
        string r = resp.Content;
        return true;
      }
      return false;
    }

    // You need to upload a file into a given bucket
    // Here we make sure that our bucket exists
    public void CreateBucket()
    {
      RestRequest req = new RestRequest();
      req.Resource = "oss/v1/buckets";
      req.Method = Method.POST;
      req.AddParameter("Authorization", "Bearer " + _accessToken, ParameterType.HttpHeader);
      req.AddParameter("Content-Type", "application/json", ParameterType.HttpHeader);

      string body = "{\"bucketKey\":\"" + _bucketKey + "\",\"servicesAllowed\":{},\"policy\":\"transient\"}";

      req.AddParameter("application/json", body, ParameterType.RequestBody);
   
      IRestResponse respBC = _client
          .Execute(req);

      if (respBC.StatusCode == System.Net.HttpStatusCode.OK
          || respBC.StatusCode == System.Net.HttpStatusCode.Conflict) // already existed
      {
        logMessage("\nGetBucketKey: OK or already existed");
      }
      else
      {
        logMessage("\nGetBucketKey: error");
      }
    }

    // The "View" button's handler. When this is clicked then we either show the model
    // or if it's already visible then hide it 
    protected void SendButton_Click(object sender, EventArgs e)
    {
      Button btn = (Button)sender;
      HtmlControl viewer = (HtmlControl)btn.Parent.FindControl("ViewerPart");

      var web = SPContext.Current.Web;
      SPListCollection coll = web.GetListsOfType(SPBaseType.DocumentLibrary);
      SPList list = coll["Documents"];
      _item = list.GetItemById(int.Parse(btn.ToolTip));

      // The urn value stored in the "urn" column of the document.
      // We created this column ourselves previously in the 
      _base64URN = (string)_item.Properties["urn"];

      // If it has no value yet
      if (string.IsNullOrEmpty(_base64URN))
      {
        string fileName = _item.File.Name;

        // Now upload
        byte[] data = _item.File.OpenBinary();

        RestRequest req = new RestRequest();

        string objectKey = HttpUtility.UrlEncode(fileName);
        req.Resource = "oss/v1/buckets/" + _bucketKey + "/objects/" + objectKey;
        req.Method = Method.PUT;
        req.AddParameter("Authorization", "Bearer " + _accessToken, ParameterType.HttpHeader);
        req.AddParameter("Content-Type", "application/stream");
        req.AddParameter("Content-Length", data.Length);
        req.AddParameter("requestBody", data, ParameterType.RequestBody);

        IRestResponse resp = _client.Execute(req);
        if (resp.StatusCode == System.Net.HttpStatusCode.OK)
        {
          string content = resp.Content;

          logMessage("\nFile(s) uploaded successfully!");

          var id = GetIdValueInJson(content);
          _base64URN = Base64Encode(id);
          bool success = StartTranslation(viewer, _base64URN, _accessToken);
          if (success)
          {
            logMessage("Translation OK: urn = " + _base64URN);
            _item.File.CheckOut();
            _item.Properties["urn"] = _base64URN;
            _item.Update();
            _item.File.CheckIn("set urn");
            // Update the table on the page
            BindData();
          }
        }
        else
        {
          logMessage("\nerror when uploading files. msg = " + resp.Content);
        }
      }
      else
      {
        ShowInViewer(viewer);
      }
    }

    private void ShowInViewer(HtmlControl viewer)
    {
      string encToken = HttpUtility.UrlEncode(_accessToken);
      string encUrn = HttpUtility.UrlEncode(_base64URN);

      // Show in iframe.
      // If it's already showing something, then make it disappear,
      // otherwise make it appear and show the file
      if (viewer.Style["display"] == "block")
      {
        viewer.Style["display"] = "none";
        viewer.Attributes["src"] = "";
      }
      else
      {
        viewer.Style["display"] = "block";
        viewer.Attributes["src"] = "MyViewerPage.aspx?accessToken=" + encToken + "&urn=" + encUrn;
      }
    }

    private bool StartTranslation(HtmlControl viewer, string base64URN, string accessToken)
    {
      RestRequest req = new RestRequest();
 
      // Start translation
      req.Resource = "/viewingservice/v1/register"; 
      req.Method = Method.POST;
      req.AddParameter("Authorization", "Bearer " + accessToken, ParameterType.HttpHeader);
      req.AddParameter("Content-Type", "application/json;charset=utf-8", ParameterType.HttpHeader);
      string body = "{\"urn\":\"" + base64URN + "\"}";
      req.AddParameter("application/json", body, ParameterType.RequestBody);

      IRestResponse resp = _client.Execute(req);
      string content = "";
      if (resp.StatusCode == System.Net.HttpStatusCode.OK)
      {
        content = resp.Content;
        logMessage("\nTranslation starting...");

        // Show it in the viewer
        ShowInViewer(viewer);

        return true;
      }
      else if (resp.StatusCode == System.Net.HttpStatusCode.Created)
      {
        content = resp.Content;
        logMessage("\nTranslation has been posted before, it is ready for viewing");

        // Show it in the viewer
        ShowInViewer(viewer);

        return true;
      }
      else
      {
        logMessage("\nError when trying to tranlate. msg =" + resp.Content);

        return false;
      }
    }

    public bool IsReusable
    {
      get
      {
        return false;
      }
    }

    private static string GetIdValueInJson(string content)
    {
      string idSrcFlag = "\"id\" : \"";
      int index = content.IndexOf(idSrcFlag) + idSrcFlag.Length;
      int idLen = content.IndexOf("\"", index + 1) - index;
      var urn = content.Substring(index, idLen);
      return urn;
    }

    public static string Base64Decode(string base64EncodedData)
    {
      byte[] bytes = Convert.FromBase64String(base64EncodedData);
      return Encoding.UTF8.GetString(bytes);
    }

    public static string Base64Encode(string plainText)
    {
      byte[] bytes = Encoding.UTF8.GetBytes(plainText);
      return Convert.ToBase64String(bytes);
    }

    protected void BindData()
    {
      var web = SPContext.Current.Web;
      SPListCollection coll = web.GetListsOfType(SPBaseType.DocumentLibrary);
      DataTable dt = coll["Documents"].Items.GetDataTable();
      GridView1.DataSource = dt;
      GridView1.DataBind();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
      ServicePointManager.ServerCertificateValidationCallback =
          new RemoteCertificateValidationCallback(ValidateServerCertificate);

      if (!IsPostBack)
      {
        logMessage("\nBefore logIn");
        try
        {
          logIn();
        }
        catch
        {
          logMessage("\nLogin error");
        }

        BindData();
      }
    }

    public static bool ValidateServerCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
    {
      return true;
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    { 
      logMessage("\nGridView1_SelectedIndexChanged = " + GridView1.SelectedIndex.ToString());
    }
  }
}
