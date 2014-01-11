<cfapplication name="imgUpload" sessionmanagement="true" sessiontimeout="#createTimeSpan(0,0,5,0)#" />
<!--- This file lists all zip files stored on server and permits you to delete them --->


<cfif structKeyExists(url,"password") AND len(url.password) AND url.password eq "yoda123">
	<cfset variables.strDumpDirectory		= getDirectoryFromPath(getCurrentTemplatePath()) & "files\" />

	<cfif not directoryExists(variables.strDumpDirectory)>
		No directory.<cfabort />
	</cfif>
	
	<!--- Delete Submitted Files --->
	<cfif structKeyExists(form,"submit") AND structKeyExists(form,"chk_delete") AND listLen(form.chk_delete)>
		<cfloop from="1" to="#listLen(form.chk_delete)#" index="variables.intLcv">
			<cfoutput><font color="red">#variables.strDumpDirectory##listGetAt(form.chk_delete,variables.intLcv)# - Deleted</font><br /></cfoutput>
			<cfif directoryExists(variables.strDumpDirectory & listGetAt(form.chk_delete,variables.intLcv))>
				<!--- Deleteing directory --->
				<cfdirectory action="delete" directory="#variables.strDumpDirectory##listGetAt(form.chk_delete,variables.intLcv)#" recurse="true" />
			<cfelse>
				<!--- Deleting zip file --->
				<cffile action="delete" file="#variables.strDumpDirectory##listGetAt(form.chk_delete,variables.intLcv)#" />
			</cfif>
		</cfloop>
	</cfif>
	
	<!--- LIST FILES --->
	<div id="listFiles">
		<cfdirectory action="list" directory="#variables.strDumpDirectory#" name="variables.rstFiles" />
		
		<cfif variables.rstFiles.recordcount>
			<cfoutput><strong>Current Time:</strong> #now()#<br /><br /></cfoutput>
			
			<table border="1">
				<tr>
					<th>&nbsp;</th>
					<th><strong>Name</strong></th>
					<th><strong>Date</strong></th>
				</tr>
				<form action="<cfoutput>listZips.cfm?password=#url.password#</cfoutput>" method="POST">
					<cfoutput query="variables.rstFiles">
						<tr>
							<td>
								<input type="checkbox" name="chk_delete" value="#variables.rstFiles.name#" />
							</td>
							<td>#variables.rstFiles.name#</td>
							<td>#variables.rstFiles.dateLastModified#</td>
						</tr>
					</cfoutput>
					<tr>
						<td colspan="3">
							<input type="submit" name="submit" value="DELETE CHECKED" />
						</td>
					</tr>
				</form>
			</table>
		<cfelse>
			No files.
		</cfif>
	</div><!-- /listFiles -->
</cfif>