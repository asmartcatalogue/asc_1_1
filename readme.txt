asmartcatalogue 1.1 , 7 June 2017, Copyright (C) 2017 Maurizio Ferrera

---------------------------------------------------------------
WHAT'S NEW IN VERSION 1.1 (this version)

- fixed some bugs that prevented the correct delivery of the forms to the merchant email.
- fixed a bug in newsletter.aspx that prevented the subscription to the newsletter
- added checkbox to accept/deny the treatment of personal data typed in the forms by the users
- a slightly different layout
---------------------------------------------------------------

SERVER REQUISITES
Hosting Windows supporting asp.NET 4.5 
App_Data folder with write permission (in almost all the web hosting spaces you will find by default a App_Data folder with the correct write permissions)
The server need to have Office installed (this is very frequent) since the software uses Access as database.
---------------------------------------------------------------

INSTALLATION

Connect via ftp to the root folder of your web hosting space. You will find a folder named App_Data, do not delete it since it has the right write permissions.
Unzip and transfer via ftp all the files and folders in the root folder of the hosting space.

The storefront will be visible at:
http://www.yourdomain.ext

The admin panel will be visible at:
http://www.yourdomain.ext/admin/admin.aspx . The admin password is admin.


---------------------------------------------------------------

CONFIGURATION

In web.config: 

<add key="frontlanguages" value="english,italiano"/>
the value is the list of the languages for the store-front separated by a comma.


<add key="defaultfrontlanguage" value="english"/>
the value is the language that will be used by default in the front-store. it is also the language that will be used for the generation of the metatags.


<add key="adminlanguage" value="english"/>
the value is the language used in the admin panel.


<add key="smtpserver" value="..."/>
the value is the address  of the smpt server used in order the users of the web site to send you an email through the modules present in the site.
Anyway all the modules sent by the users are registered in db and will be visible in the admin area.


<add key="youremail" value="..."/>
type in the value your email (where the forms of the web site will be sent)


<add key="useauthentication" value="true"/>
if this value is set to true, authentication will be used to send the email.


<add key="authenticationemail" value="..."/>
<add key="authenticationpass" value="..."/>
these two values are used to specify username and password for authentication if 'useathentication' is set to true.



--------------------------------------------------------------------
HOW TO MODIFY THE WORDS OF THE WEB SITE

In App_data/languages there are two .txt files, eng.txt for English language and ita.txt for Italian language.
The first line of each file contains the name of the language.
The other lines contain the sentences used in the storefront and in the admin area. 

-----------------------------------------------------------------

HOW TO ADD A NEW LANGUAGE

Make a copy for example of eng.txt and place it in the same folder. Call it how you want (it is not relevant).
In the first line place the name of the language, i.e. deutsch. 
Then modify the other lines of the files, containing the sentences used in the web site.
Finally modify in web.config the three lines:
    <add key="frontlanguages" value="english,italiano"/>
    <add key="defaultfrontlanguage" value="english"/>
    <add key="adminlanguage" value="italiano"/>
as you need.
  


----------------------------------------------------------------

HOW TO MAKE A BACKUP 

To make a backup of all the data (including products info, images, dictionary) make a local copy of all the files contained in App_Data folder.
To restore, empty the App_Data folder on the server and place inside it the files you copied locally. Restart the site from the admin panel.

----------------------------------------------------------------

For possible feedbacks write at musicosud@gmail.com
