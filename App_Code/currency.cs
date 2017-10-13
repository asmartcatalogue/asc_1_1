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




namespace asc
{


















    public class currency : System.Web.UI.Page
    {
        public int id { get; private set; }
        public double cambio { get; private set; }
        public string nome { get; private set; }
        public string decimalseparatorsymbol { get; private set; }
        public string groupseparatorsymbol { get; private set; }
        public int decimali { get; private set; }
        public currency( int _id, double _cambio, string _nome, string _decimalseparatorsymbol, int _decimali, string _groupseparatorsymbol)
        {
            this.id = _id;
            this.cambio = _cambio;
            this.nome = _nome;
            this.decimalseparatorsymbol= _decimalseparatorsymbol;
            this.decimali = _decimali;
            this.groupseparatorsymbol = _groupseparatorsymbol;
        }


    }









}
























