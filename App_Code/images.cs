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

using System.Web;
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
namespace asc
{

    public class images
    {
        public static void delete(string imgname)
        {

            string relativedir = "~/app_data";
            string absolutedir = HttpContext.Current.Server.MapPath(relativedir);
            string absoluteimgpath = absolutedir + "/" + imgname;
            if (File.Exists(absoluteimgpath)) File.Delete(absoluteimgpath);

        }


        public static void deleteandsave (System.Web.HttpPostedFile postedfile, string imglogicalpath)
        {

            string absoluteimgpath = HttpContext.Current.Server.MapPath(imglogicalpath);
            if (File.Exists(absoluteimgpath)) File.Delete(absoluteimgpath);

            Bitmap OriginalBM = new Bitmap(postedfile.InputStream);
            double originalw = Convert.ToDouble(OriginalBM.Width);
            double originalh = Convert.ToDouble(OriginalBM.Height);
            double ratio = originalw / originalh;
            double newwidth = 100;
            double newheight = newwidth / ratio;
            Size newSize = new Size(Convert.ToInt32(newwidth), Convert.ToInt32(newheight));

            Bitmap ResizedBM = new Bitmap(OriginalBM, newSize);
            System.IO.Stream outstream = new System.IO.MemoryStream();
            ResizedBM.Save(outstream, ImageFormat.Png);
            outstream.Position = 0;
            System.IO.BinaryReader br = new System.IO.BinaryReader(outstream);
            Byte[] bytes = br.ReadBytes((Int32)outstream.Length);
            File.WriteAllBytes(absoluteimgpath, bytes);
            
        }
        public static void savesecondaryimage(System.Web.HttpPostedFile postedfile, string absoluteimgpath, out int w, out int h)
        {


            Bitmap OriginalBM = new Bitmap(postedfile.InputStream);
            double originalw = Convert.ToDouble(OriginalBM.Width);
            w = Convert.ToInt32(originalw);
            double originalh = Convert.ToDouble(OriginalBM.Height);
            h = Convert.ToInt32(originalh);
            Size newSize = new Size(OriginalBM.Width, OriginalBM.Height);
            Bitmap ResizedBM = new Bitmap(OriginalBM, newSize);
            System.IO.Stream outstream = new System.IO.MemoryStream();
            ResizedBM.Save(outstream, ImageFormat.Png);
            outstream.Position = 0;
            System.IO.BinaryReader br = new System.IO.BinaryReader(outstream);
            Byte[] bytes = br.ReadBytes((Int32)outstream.Length);
            File.WriteAllBytes(absoluteimgpath, bytes);


        }


    }


}