<cfsilent>
	<cfapplication name="imgUpload" sessionmanagement="true" sessiontimeout="#createTimeSpan(0,0,30,0)#">
	
	<!--- Session vars control the directory name, so we can keep all client files together --->
	<cfif not structKeyExists(session, "strMyId")>
		<cfset session.strMyId	=	replace(createUUID(),"-","","all")>
	</cfif>
	
	<!--- This is where the zip will be created --->
	<cfset variables.strZipDirectory		= getDirectoryFromPath(getCurrentTemplatePath()) & "files\">
	<!--- This is where we're gonna store the shrunk image, note the custom dir for keeping user files together --->
	<cfset variables.strSmallDirectory		= variables.strZipDirectory & "#session.strMyId#\">
	<cfset variables.strLstFiles			= "jpg,jpeg,gif,bmp,png">
	<cfset variables.strLstFilters			= "*.jpg|*.jpeg|*.gif|*.bmp|*.png">
	<!--- This is the size we will shrink images too. --->
	<cfset variables.intMaxBytesFileSize	= 1048576>
	<cfset request.cancelFooter				=	true>
	<cfset variables.bInvalidFileType		=	false>
	
	
	<cfif structKeyExists(form,"thefile") and len(form.thefile)>
	
		<!--- If Directory doesn't exist, create it.(It should be unique for each user) --->
		<cfif not directoryExists(variables.strSmallDirectory)>
			<cfdirectory action="create" directory="#variables.strSmallDirectory#" mode="777">
		</cfif>
	
		<!--- Upload --->
		<cffile action="upload" fileField="thefile" destination="#variables.strSmallDirectory#" nameConflict="overwrite" result="variables.stuUploadDetails">
	
		<!--- Only allow certain types of image --->
		<cfif listFindNoCase(variables.strLstFiles,variables.stuUploadDetails.serverFileExt)>
			
			<!--- Calculate percentage to shrink file --->
			<cfif variables.stuUploadDetails.fileSize GT variables.intMaxBytesFileSize>
				<!--- This is basically bs coz we're calculating the byte size reduction, and then applying that percentage to the hieght and width. Not ideal, but it'll do for now --->
				<cfset variables.intPercentDecrease	=	ceiling(((variables.stuUploadDetails.fileSize - variables.intMaxBytesFileSize) / variables.stuUploadDetails.fileSize) * 100)>
			<cfelse>
				<!--- Image doesn't need shrinking --->
				<cfset variables.intPercentDecrease	=	100>
			</cfif>
			
			<!--- Resize image and put it in new folder with name of strM.xxx where xxx is extension of file --->
			<cfimage action="resize" source="#variables.strSmallDirectory##variables.stuUploadDetails.serverFile#" width="#variables.intPercentDecrease#%" height="#variables.intPercentDecrease#%" destination="#variables.strSmallDirectory##variables.stuUploadDetails.serverFile#" overwrite="yes">
		<cfelse>
			<cfset variables.bInvalidFileType	=	true>
		</cfif>
	</cfif>
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="description" content="Noisy Photos Free Image compression software utility, allow us to compress, optimize, resize and shrink your jpeg, jpg, bmp or gif photos to email or for a more backup friendly useable, smaller file size." />
    <meta name="keywords" content="Photo, Noisy Cloud, Cloud, Noisy, Cloud Computing, compression, free, online, image, shrinker, jpeg, gif, jpg, png, bmp, photo, resize, multiple file, files, minimize, email" />
	<title>Free online photo compress, optimize and free photo shrinking. Minimize and shrink your files online. Save storage space now.</title>
	<link rel="stylesheet" type="text/css" href="noisyPix_html4.css" />
</head>

<body>
	<div id="wrapper">
        <div id="header">
            <h1>Noisy Pix - Free Online Photo Compress, Optimize And Shrink</h1>
        </div>
		
		<div id="content">
		
			<div id="socialMedia">
				<!-- Place this tag where you want the +1 button to render -->
				<g:plusone annotation="inline"></g:plusone>
			</div>
		
			<!--- 1) Upload photo --->
			<div id="step1_form" class="contentBox">
				<!--- File upload form --->
				<img src="http://noisyimages.s3.amazonaws.com/images.png" alt="Select images to compress and optimize" class="boxedImg" />
				<div class="formContent">
					<h2>Photo Shrink:</h2>
					Please select a photo to upload and compress:<br />
					<form action="index.cfm" method="post" enctype="multipart/form-data">
						<fieldset>
							<input type="file" name="thefile" id="thefile" />
							<input type="submit" name="submit" value="Submit" />
						</fieldset>
					</form>
				</div>
			</div>
			
			<cfif structKeyExists(form,"thefile") and len(form.thefile) and (not variables.bInvalidFileType)>
				<!--- 2 a) Show all files selected so far --->
				<div id="step2_disp" class="contentBox">
					<img src="http://noisyimages.s3.amazonaws.com/upload.png" alt="List of uploaded photos ready for compression" class="boxedImg" />
					<!--- Get all files in user dir --->
					<cfdirectory action="list" directory="#variables.strSmallDirectory#" name="variables.rstImages" filter="#variables.strLstFilters#">
				
					<div class="formContent">
						<!--- Loop through and output. If just uploaded add a note to say successfully uploaded --->
						<strong>You have uploaded the following files:</strong><br />
						<cfloop query="variables.rstImages">
							<cfoutput>
								&nbsp;&nbsp;#variables.rstImages.name#
								<cfif variables.rstImages.name eq variables.stuUploadDetails.serverFile><font color="green">....Successfully uploaded.</font></cfif>
								<br />
							</cfoutput>
						</cfloop>
					</div>
				</div>
			<cfelse>
				<!--- 2 b) Show welcome message --->
				<cfif variables.bInvalidFileType>
					<div id="step2_help" class="contentBox">
						<div class="formContent">
							<font color="red">Invalid File Type</font>
						</div>
					</div>				
				<cfelse>
					<div id="step2_help" class="contentBox">
						<img src="http://noisyimages.s3.amazonaws.com/help.png" alt="Information and welcome to Noisy Pix photo the free online compression tool." class="boxedImg" />
						<div class="formContentSmaller">
							<h2>Noisy Pix Free Photo Compression Software.</h2>
							<br />
							<p>
								Noisy Pix is a <strong>freeware</strong> utility that allows you to <strong>compress</strong> and optimize large images or photos that take up your storage space, into small manageable files. You can upload and <strong>compress</strong> as many gifs, jpegs, jpgs or photos as you want 
								and the <strong>free</strong> image shrinker will compress, shrink, resize and return them to you in one convenient zip file. To get started simply select your photo using the above file selector and press submit. Noisy Pix Shrinker 
								works great for saving space, <strong>emails</strong> and <strong>backups</strong> of your family photos.
							</p>
						</div>
					</div>
				</cfif>
			</cfif>
			
			<!--- 3) Download Zip --->
			<cfif structKeyExists(form,"thefile") and len(form.thefile) and (not variables.bInvalidFileType)>
				<div id="step3_zip" class="contentBox">
					<img src="http://noisyimages.s3.amazonaws.com/download.png" alt="Download your compresses photos" class="boxedImg" />
					<!--- Zip up the files --->
					<cfzip file="#variables.strZipDirectory##session.strMyId#.zip" action="zip" source="#variables.strSmallDirectory#" filter="#variables.strLstFilters#" />
					<div class="formContent">
						<!--- Output Link to download --->
						<cfoutput><a href="files/#session.strMyId#.zip">Download Zipped Images</a></cfoutput>
					</div>
				</div>
			</cfif>
			
			<!--- 4) Terms And Conditions --->
			<div id="step4_terms" class="contentBox">
				<img src="http://noisyimages.s3.amazonaws.com/info.png" alt="Terms and conditions for Noisy Cloud" class="boxedImg" />
				<div class="formContent">
					<h2>Free Online Tool T&C</h2>
					<br />
					<p>
						Noisy Pix is a product of <a href="http://www.noisycloud.co.uk" onclick="return ! window.open(this.href);">Noisy Cloud</a>. 
						By using this free service you agree NOT to use this service for any activities in any way illegal in 
						the country of use, the USA or UK. You will not	use this tool for any material which you are 
						not the copyright holder. Noisy Cloud are not responsable for the your content which is hosted <strong>unsecure</strong>
						and temporarily.
					</p>
				</div>
			</div>
		</div><!-- /content -->
        <div id="footer">
            <a href="http://www.noisycloud.co.uk">&copy; Noisy Cloud Solutions <cfoutput>#year(now())#</cfoutput></a>
        </div>
	</div><!-- /wrapper -->
</body>
</html>