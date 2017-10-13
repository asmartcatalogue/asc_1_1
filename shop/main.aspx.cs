//Copyright (C) 2017 Maurizio Ferrera

//This file is part of asmartcatalogue

//asmartcatalogue is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.

//asmartcatalogue is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with asmartcatalogue.  If not, see <http://www.gnu.org/licenses/>.

namespace asc
{
    using System.Web.UI;
    using System.Web.UI.WebControls;



    public partial class behindMainAspx : Page
    {






        void Page_Init()
        {

            Label lblbreadcrumbsMaster = (Label)(Master.FindControl("lblbreadcrumbs"));
            lblbreadcrumbsMaster.Text = "<span class='breadcrumbs'>" + asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.you.are.here.home") + "</span>";

            string worktitle =
                 asc.language.getforfrontfromdictionaryindefaultlanguage("inallthepages.you.are.here.home") +
                 " | " + Application["config_nomesito"].ToString();
            Page.Title = asc.filtertext.getonlyallowedcharsfortitleandmetatag(worktitle);


        }




    }

}