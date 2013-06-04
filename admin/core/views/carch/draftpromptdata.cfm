 <!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->

<cfset draftprompdata=application.contentManager.getDraftPromptData(rc.contentid,rc.siteid)>
<cfif draftprompdata.showdialog>
	<cfset draftprompdata.showdialog='true'>
	<cfsavecontent variable="draftprompdata.message">
	<cfoutput>
		<div id="draft-prompt">
		<p class="alert alert-info">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.dialog')#</p>
			<table>
				<thead>
					<tr>
						<th colspan="4">Published Version</th>
					</tr>
				</thead>
				<tbody>
					<td>Lorem Ipsum Dolor Site Amet</td>
					<td>6/5/13 9:18 AM</td>
					<td>R. Thompson</td>
					<td><i class="icon-pencil"></i></td>
				</tbody>
			</table>
			<table>
				<thead>
					<tr>
						<th colspan="4">Latest Draft</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Lorem Ipsum Dolor Site Amet</td>
						<td>6/5/13 9:18 AM</td>
						<td>R. Thompson</td>
						<td><i class="icon-pencil"></i></td>
					</tr>
				</tbody>
			</table>
			<table>	
				<thead>
					<tr>
						<th colspan="4">Change Sets</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Lorem Ipsum Dolor Site Amet</td>
						<td>6/5/13 9:18 AM</td>
						<td>R. Thompson</td>
						<td><i class="icon-pencil"></i></td>
					</tr>
				</tbody>
			</table>
			<table>	
				<thead>
					<tr>
						<th colspan="4">Awaiting Approval</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>Lorem Ipsum Dolor Site Amet</td>
						<td>6/5/13 9:18 AM</td>
						<td>R. Thompson</td>
						<td><i class="icon-pencil"></i></td>
					</tr>
				</tbody>
			</table>
					
						
		
		
		
		
		
		
			<p class="alert alert-info">#application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.dialog')#</p>
				<a href="##" class="btn btn-large btn-block draft-prompt-option" data-contenthistid="#draftprompdata.publishedHistoryID#"><!--- <i class="icon-pencil"></i>  --->#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.published'))#</a>
			<cfif draftprompdata.hasdraft>
			<a href="##" class="btn btn-large btn-block draft-prompt-option" data-contenthistid="#draftprompdata.historyid#"><!--- <i class="icon-pencil"></i>  --->
				#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.draftprompt.latest'))#
				<cfif draftprompdata.hasdraftpending >
					(#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.pending')#)
				</cfif>
			</a>
			</cfif>
			
			<cfif draftprompdata.pendingchangesets.recordcount>
			

<div class="btn-group btn-block">
			  <a class="btn btn-large btn-block dropdown-toggle" data-toggle="dropdown" style="font-size: 14px !important;" href="##">
			    Edit a Version in a Change Set
			    <span class="caret"></span>
			 </a>
			  <ul class="dropdown-menu">
				<cfloop query="draftprompdata.pendingchangesets">
				<li>
					<a href="##" class="draft-prompt-option" data-contenthistid="#draftprompdata.pendingchangesets.contenthistid#">#HTMLEditFormat(draftprompdata.pendingchangesets.changesetName)#</a>
				</li>
				</cfloop>
			 </ul>
			</div>
			
			<h1><!--- <i class="icon-arrow-right"></i>  --->#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.editversioninchangeset')#</h1>
				<cfloop query="draftprompdata.pendingchangesets">
					<a href="##" class="draft-prompt-option btn btn-large btn-block" data-contenthistid="#draftprompdata.pendingchangesets.contenthistid#">#HTMLEditFormat(draftprompdata.pendingchangesets.changesetName)#
						<cfif listFindNoCase('Pending,Rejected',draftprompdata.pendingchangesets.approvalStatus)>
							(#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.#draftprompdata.pendingchangesets.approvalStatus#')#)
						</cfif>
					</a>
				</cfloop>	
			</cfif>
			<cfif draftprompdata.yourapprovals.recordcount>
			<cfset content=$.getBean('content').loadBy(contentid=rc.contentid)>
			<!---
<div class="btn-group btn-block">
			  <a class="btn btn-large btn-block dropdown-toggle" data-toggle="dropdown" style="font-size: 14px !important;" href="##">
			    Edit a Version in a Change Set
			    <span class="caret"></span>
			 </a>
			  <ul class="dropdown-menu">
				<cfloop query="draftprompdata.pendingchangesets">
				<li>
					<a href="##" class="draft-prompt-option" data-contenthistid="#draftprompdata.pendingchangesets.contenthistid#">#HTMLEditFormat(draftprompdata.pendingchangesets.changesetName)#</a>
				</li>
				</cfloop>
			 </ul>
			</div>
--->
			<!---<h1><!--- <i class="icon-arrow-right"></i>  --->#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.theseversionsapproval')#</h1>
				<cfloop query="draftprompdata.yourapprovals">
					<a href="#content.getURL(querystring="previewid=#draftprompdata.yourapprovals.contenthistid#")#" class="draft-prompt-approval btn btn-large btn-block">#LSDateFormat(draftprompdata.yourapprovals.lastupdate)# #LSTimeFormat(draftprompdata.yourapprovals.lastupdate,"medium")#
					</a>
				</cfloop>--->	
			</cfif>
		</div>
	</cfoutput>
	</cfsavecontent>
<cfelse>
	<cfset draftprompdata.showdialog='false'>
	<cfset draftprompdata.message="">	
</cfif>
<cfset structDelete(draftprompdata,'yourapprovals')>
<cfset structDelete(draftprompdata,'pendingchangesets')>
<cfcontent type="application/json">
<cfoutput>#createObject("component","mura.json").encode(draftprompdata)#</cfoutput>
<cfabort>