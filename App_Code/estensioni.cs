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

namespace estensioni
{
    /// <summary>
    /// Descrizione di riepilogo per extensionmethods
    /// </summary>
    public static class mieEstensioni
    {
        public static String Substring(this String instr, int startIndex, bool handleIndexException)
        {
            if (handleIndexException == false)
            {
                return instr.Substring(startIndex);
            }
            int instrlength = instr.Length;
            return instr.Substring(startIndex < 0 ? 0 :
               startIndex > (instrlength - 1) ? instrlength : startIndex);
        }
        public static String Substring(this String instr, int startIndex, int length, bool handleIndexException)
        {
            if (handleIndexException == false)
            {
                return instr.Substring(startIndex, length);
            }
            int newfrom, newlth, instrlength = instr.Length;
            if (length < 0) //length is negative
            {
                newfrom = startIndex + length;
                newlth = -1 * length;
            }
            else //length is positive
            {
                newfrom = startIndex;
                newlth = length;
            }
            if (newfrom + newlth < 0 || newfrom > instrlength - 1)
            {
                return string.Empty;
            }
            if (newfrom < 0)
            {
                newlth = newfrom + newlth;
                newfrom = 0;
            }
            return instr.Substring(newfrom,
                Math.Min(newlth, instrlength - newfrom));
        }
        public static string ShowNull(this String instr)
        {
            return string.IsNullOrEmpty(instr) ? "<<null>>" : instr;
        }


    
    }


}