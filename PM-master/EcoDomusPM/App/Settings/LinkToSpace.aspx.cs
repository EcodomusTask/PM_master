﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Data;
using BIMModel;
using EcoDomus.Session;
using System.Globalization;
using System.Threading;

public partial class App_Settings_LinkToSpace : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            

            GridSortExpression sortExpr = new GridSortExpression();
            sortExpr.FieldName = "name";
            sortExpr.SortOrder = GridSortOrder.Ascending;
            //Add sort expression, which will sort against first column
            rg_space.MasterTableView.SortExpressions.AddSortExpression(sortExpr);
           BindSpaces();

        }
    }

    protected override void InitializeCulture()
    {
        try
        {
            string culture = Session["Culture"].ToString();
            if (culture == null)
            {
                culture = "en-US";
            }
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(culture);
            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(culture);
        }
        catch (Exception ex)
        {

            redirect_page("~\\app\\Login.aspx?Error=Session");
        }

    }


    public void redirect_page(string url)
    {

        Response.Redirect(url, false);

    }

    private void BindSpaces()
    {

        DataSet ds = new DataSet();
        BIMModelClient BIMModelClient = new BIMModel.BIMModelClient();
        BIMModels BIMModels = new BIMModel.BIMModels();

   //   BIMModels.Fk_facility_id = new Guid(SessionController.Users_.ProjectId);

        BIMModels.Search_text = txtClass.Text.Trim().ToString();
        BIMModels.File_id = new Guid(Request.QueryString["file_id"].ToString());
        ds = BIMModelClient.proc_get_facility_spaces_for_bim_linktospace_pm(BIMModels, SessionController.ConnectionString);
        rg_space.DataSource = ds;
        rg_space.DataBind();
        ViewState["comp_Dataset"] = ds;
    }


    protected void rg_space_PageSizeChanged(object source, Telerik.Web.UI.GridPageSizeChangedEventArgs e)
    {
        try
        {
            BindSpaces();
        }
        catch (Exception ex)
        {
            Response.Write("rg_space_PageSizeChanged :" + ex.Message.ToString());
        }
    }

    protected void rg_space_SortCommand(object source, GridSortCommandEventArgs e)
    {
        try
        {
            BindSpaces();
        }
        catch (Exception ex)
        {
            Response.Write("rg_space_PageSizeChanged :" + ex.Message.ToString());
        }
    }

    protected void rg_space_PageIndexChanged(object source, GridPageChangedEventArgs e)
    {
        try
        {
            BindSpaces();
        }
        catch (Exception ex)
        {
            Response.Write("rg_space_PageSizeChanged :" + ex.Message.ToString());
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindSpaces();
    }

    protected void radcombo_space_status_SelectedIndexChanged(object o, RadComboBoxSelectedIndexChangedEventArgs e)
    {

    }

    protected void btnSelect_Click(object sender, EventArgs e)
    {
        string id = "";

        try
        {
            if (rg_space.SelectedItems.Count > 0)  // check weather user check any text box or not 
            {

                id = Convert.ToString(rg_space.SelectedValue);

                DataSet ds = new DataSet();
                BIMModelClient objbim_Client = new BIMModelClient();
                BIMModels objbim_Model = new BIMModels();

                objbim_Model.Pk_space_id= new Guid(id);
                objbim_Model.External_space_id = Convert.ToString(Request.QueryString["element_numeric_id"]);
                objbim_Model.File_id = new Guid(Convert.ToString(Request.QueryString["file_id"]));
                objbim_Model.User_id = new Guid(SessionController.Users_.UserId);
                switch (radcombo_space_status.SelectedValue)
                {

                    case "Overwrite":
                        objbim_Client.proc_assign_space_for_bim(objbim_Model, SessionController.ConnectionString);
                        ClientScript.RegisterStartupScript(this.GetType(), "script", "<script language='javascript'>closeWindow()</script>");
                        break;

                    case "Existing":
                       if (Request.QueryString["properties"] != "no property")
                      {

                          objbim_Client.proc_replace_space_for_model(objbim_Model, SessionController.ConnectionString);
                          ClientScript.RegisterStartupScript(this.GetType(), "script", "<script language='javascript'>closeWindow()</script>");
                      }
                       else
                        {
                           ScriptManager.RegisterStartupScript(this, this.GetType(), "merge", "mergeattributealert1();", true);
                        }
                        break;


                    case "Merge":
                        if (Request.QueryString["properties"] != "no property")
                        {
                            
                            objbim_Client.proc_merge_space_attribute(objbim_Model, SessionController.ConnectionString);
                            ClientScript.RegisterStartupScript(this.GetType(), "script", "<script language='javascript'>closeWindow()</script>");
                        }
                        else
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "merge", "mergeattributealert();", true);
                        }
                        break;

                }

                ClientScript.RegisterStartupScript(this.GetType(), "script", "<script language='javascript'>closeWindow()</script>");
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}