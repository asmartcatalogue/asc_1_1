<%@ Page Language="C#" %>

<%--  
    Copyright (C) 2017 Maurizio Ferrera
 
    This file is part of asmartcatalogue

    asmartcatalogue is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    asmartcatalogue is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with asmartcatalogue.  If not, see <http://www.gnu.org/licenses/>.
--%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>asmartcatalogue Error Page</title>

    <style>
        body {
            font-family: Arial;
            color: #999;
        }

        div {
            font-family: Arial;
            color: #999;
        }

        a:link, a:visited {
            color: #999;
        }
    </style>

</head>
<body>
    <div>
        <h3>asmartcatalogue Error page</h3>
        <p>opsss...An error has occurred.</p>
        <p>Maybe you typed in a field one or more not allowed characters, like <b>&gt;</b> or <b>&lt;</b> or other special characters. In this case Go back with back button of your browser</p>
        <p>The details of the error are visible setting in web.config the <b>customErrors mode</b> to <b>Off</b>.</p>

    </div>
</body>
</html>
