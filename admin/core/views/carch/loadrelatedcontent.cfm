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
<cfparam name="rc.isNew" default="1">
<cfparam name="rc.keywords" default="">
<cfparam name="rc.searchTypeSelector" default="">
<cfparam name="rc.rcStartDate" default="">
<cfparam name="rc.rcEndDate" default="">
<cfparam name="rc.rcCategoryID" default="">
<cfset request.layout=false>
<cfset baseTypeList = "Page,Folder,Calendar,Gallery,File,Link"/>
<cfset rsSubTypes = application.classExtensionManager.getSubTypes(siteID=rc.siteID, activeOnly=true) />

<cfoutput>
	<div class="control-group">
		<label class="control-label">Add Related Content</label>
		<div id="internalContent" class="form-inline">
			<input type="text" name="keywords" value="#rc.keywords#" id="rcSearch" placeholder="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchforcontent')#"/>
			<input type="button" name="btnSearch" value="Search" id="rcBtnSearch" class="btn" />
		</div>
		<a href="##" class="pull-right" id="aAdvancedSearch">Advanced Search</a>
	</div>
	
	<div id="rcAdvancedSearch" style="display:none;">
		<div class="control-group">
			<div class="span6">
				<label class="control-label">Content Type</label>
				<div class="controls">
					<select name="searchTypeSelector" id="searchTypeSelector">
						<option value="">All</option>
						<cfloop list="#baseTypeList#" index="t">
							<cfsilent>
								<cfquery name="rsst" dbtype="query">select * from rsSubTypes where type = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#t#"> and subtype not in ('Default','default')</cfquery>
							</cfsilent>
							<option value="#t#^Default"<cfif rc.searchTypeSelector eq "#t#^Default"> selected="selected"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#</option>
							<cfif rsst.recordcount>
								<cfloop query="rsst">
									<option value="#t#^#rsst.subtype#"<cfif rc.searchTypeSelector eq "#t#^#rsst.subtype#"> selected="selected"</cfif>>#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.type.#lcase(t)#")#  / #rsst.subtype#</option>
								</cfloop>
							</cfif>
						</cfloop>
					</select>
				</div>
			</div>	
			<div class="span6">
				<label class="control-label">Release Date Range</label>
				<div class="controls">
					<input type="text" name="rcStartDate" id="rcStartDate" class="datepicker span4 mura-relatedContent-datepicker" value="#rc.rcStartDate#" />
					<input type="text" name="rcEndDate" id="rcEndDate" class="datepicker span4 mura-relatedContent-datepicker" value="#rc.rcEndDate#" />
				</div>
			</div>			
		</div>
		<div class="control-group">
			<div class="controls">
				<label class="control-label">Available Categories</label>
		
				<div id="mura-list-tree" class="controls">
					<cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" categoryID="#rc.rcCategoryID#" nestLevel="0" useID="0" elementName="rcCategoryID">
				</div>
			</div>
		</div>
	</div>
</cfoutput>


<cfif not rc.isNew>
	<cfscript>
		$=application.serviceFactory.getBean("MuraScope");
	
		feed=$.getBean("feed");
		feed.setMaxItems(100);
		feed.setNextN(100);
		feed.setLiveOnly(0);
		feed.setShowNavOnly(0);
		feed.setSortBy("lastupdate");
		feed.setSortBy("desc");
		
		if (len($.event("searchTypeSelector"))) {
			feed.addParam(field="tcontent.type",criteria=listFirst($.event("searchTypeSelector"), "/"),condition="in");	
			if (listLen($.event("searchTypeSelector"), "/") == 2) {
				feed.addParam(field="tcontent.subtype",criteria=listFirst($.event("searchTypeSelector"), "/"));	
			} else {
				feed.addParam(field="tcontent.subtype",criteria='Default');	
			}
		}
		
		if (len($.event("rcStartDate"))) {
			feed.addParam(field="tcontent.releaseDate",datatype="date",condition="gte",criteria=$.event("rcStartDate"));	
		}
		
		if (len($.event("rcEndDate"))) {
			feed.addParam(field="tcontent.releaseDate",datatype="date",condition="lte",criteria=$.event("rcEndDate"));	
		}
		
		if (len($.event("rcCategoryID"))) {
			feed.setCategoryID($.event("rcCategoryID"));	
		}
		
		if (len($.event("keywords"))) {	
			subList=$.getBean("contentManager").getPrivateSearch($.event("siteID"),$.event("keywords"));
			feed.addParam(field="tcontent.contentID",datatype="varchar",condition="in",criteria=valuelist(subList.contentID));
		}
		
		rc.rslist=feed.getQuery();
	</cfscript>
	<div class="control-group">
		<cfif rc.rslist.recordcount>
			<div id="draggableContainment" class="list-table">
				<div class="list-table-header">Matching Results</div>
				<cfoutput query="rc.rslist" startrow="1" maxrows="100">	
					<cfset crumbdata=application.contentManager.getCrumbList(rc.rslist.contentid, rc.siteid)/>
					<cfif arrayLen(crumbdata) and structKeyExists(crumbdata[1],"parentArray") and not listFind(arraytolist(crumbdata[1].parentArray),rc.contentid)>
						<ul id="rcDraggable" class="list-table-items">
							<li class="item" data-content-type="#rc.rslist.type#/#rc.rslist.subtype#" data-contentid="#rc.rslist.contentID#">
								#$.dspZoomNoLinks(crumbdata)#
							</li>
						</ul>
					</cfif>
				</cfoutput>
			</div>
		<cfelse>
			<cfoutput>  
				<p>#application.rbFactory.getKeyValue(session.rb,'sitemanager.noresults')#</p>
			</cfoutput>
		</cfif>
	</div>
</cfif>	

