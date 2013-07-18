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
<cfset request.layout=false>
<cfparam name="rc.keywords" default="">
<cfparam name="rc.isNew" default="1">
<cfset counter=0 />
<cfoutput>
<div class="control-group control-group-nested">
	<label class="control-label"><a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'tooltip.searchforassocfile'))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforassoc#rc.filetype#')# <i class="icon-question-sign"></i></a></label>
	<div class="controls">
		<div class="input-append">
			<input class="filesearch" value="#HTMLEditFormat(rc.keywords)#" type="text" maxlength="50"/><input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.search')#" />
		</div>
	</div>
</div>


</cfoutput>
<cfif len(rc.keywords)>
<div style="overflow: auto;" id="selectAssocImageResults">
<cfset rc.rsList=application.contentManager.getPrivateSearch(rc.siteid,rc.keywords,'','',rc.type)/>
<!---<cfoutput>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#</cfoutput>--->
<table>
<tr>
	<cfset filtered=structNew()>
    <cfif rc.rslist.recordcount>
     <cfoutput query="rc.rslist" startrow="1" maxrows="100">
		<cfif not structKeyExists(filtered,'#rc.rslist.fileid#')>
			<cfsilent>
				<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid)/>
	       		<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
			</cfsilent>
			<cfif verdict neq 'none'>
				<cfset filtered['#rc.rslist.fileid#']=true>
				<cfset counter=counter+1/> 
		        <td><img src="#application.configBean.getContext()#/tasks/render/small/?fileID=#rc.rslist.fileid#"><input type="radio" name="#HTMLEditFormat(rc.property)#" value="#rc.rslist.fileid#"></td>
		 	</cfif>
	 	</cfif>
      </cfoutput>
	 </cfif>
	 <cfif not counter>
		<cfoutput>
		<td>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</td>
		</cfoutput>
	</cfif>
</td>
</table>
</div>
</cfif>