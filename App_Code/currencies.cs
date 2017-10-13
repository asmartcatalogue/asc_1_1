/*
 
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
 
*/

using System;
using System.Data;
using System.Globalization;
using System.Threading;
using System.Web;

    namespace asc
    {
        public class currencies
        {


            public static NumberFormatInfo usernumberformatinfo(asc.currency curr)
            {
                CultureInfo modified = new CultureInfo(Thread.CurrentThread.CurrentCulture.Name);
                Thread.CurrentThread.CurrentCulture = modified;
                NumberFormatInfo worknumberformatinfo = modified.NumberFormat;
                worknumberformatinfo.CurrencySymbol = curr.nome + " ";
                worknumberformatinfo.CurrencyDecimalDigits = curr.decimali;
                worknumberformatinfo.CurrencyDecimalSeparator = curr.decimalseparatorsymbol;
                worknumberformatinfo.CurrencyGroupSeparator = curr.groupseparatorsymbol;

                worknumberformatinfo.NumberDecimalSeparator = worknumberformatinfo.CurrencyDecimalSeparator;
                worknumberformatinfo.NumberGroupSeparator = worknumberformatinfo.CurrencyGroupSeparator;


                return worknumberformatinfo;
            }











            public static double rounded(double _numero, int _decimaldigits)
            {
                return Math.Round(_numero, _decimaldigits);
            }


            public static double todefinedcurrencyfrommaster(double _numero, double _cambio)
            {
                return (_numero * _cambio);


            }

            public static DataRow rowcurrencybyidcurrency(int id)
            {

                DataTable dtcurrencies = (DataTable)HttpContext.Current.Application["dtcurrenciesavailable"];
                DataRow rowcurrentcurrency = dtcurrencies.Rows.Find(id);
                return rowcurrentcurrency;

            }


            public static double tomastercurrencyfromdefinedcurrency(double numero, int idcurrency)
            {
                DataTable dtcurrencies = (DataTable)HttpContext.Current.Application["dtcurrenciesavailable"];
                DataRow rowcurrentcurrency = dtcurrencies.Rows.Find(idcurrency);
                return (numero / (double)rowcurrentcurrency["cambio"]);
            }

        }



    }




    