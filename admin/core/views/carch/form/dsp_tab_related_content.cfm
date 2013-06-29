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
<!---<cfdump var="#rc#">
<cfabort>--->
<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.relatedcontent"))/>
<cfset tabList=listAppend(tabList,"tabRelatedcontent")>

<!---<cfset relatedContentSets = rc.contentBean.getRelatedContentSets()>--->
<!---<cfset subtype = application.classExtensionManager.getSubTypeByName(rc.content.getType(), rc.content.getSubType(), rc.content.getSiteID())>
<cfset relatedContentSets = subtype.getRelatedContentSets()>--->
<cfoutput>
<div id="tabRelatedcontent" class="tab-pane">

	<span id="extendset-container-tabrelatedcontenttop" class="extendset-container"></span>

	<!---<div class="fieldset padded">
	<!--- #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.relatedcontent')#:  --->
	<span id="selectRelatedContent"> <a class="btn" href="javascript:;" onclick="javascript: siteManager.loadRelatedContent('#HTMLEditFormat(rc.siteid)#','',1);return false;"><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.addrelatedcontent')#</a></span>
		<table id="relatedContent" class="table table-striped table-condensed table-bordered mura-table-grid"> 
			<thead>
				<tr>
				<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contenttitle')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type')#</th>
				<th class="actions">&nbsp;</th>
				</tr>
			</thead>
			<tbody id="RelatedContent">
				<cfif rc.rsRelatedContent.recordCount>
				<cfloop query="rc.rsRelatedContent">
				<cfset itemcrumbdata=application.contentManager.getCrumbList(rc.rsRelatedContent.contentid, rc.siteid)/>
				<tr id="c#rc.rsRelatedContent.contentID#">
				<td class="var-width">#$.dspZoom(itemcrumbdata)#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.rsRelatedContent.type#')#</td>
				<td class="actions">
					<input type="hidden" name="relatedcontentid" value="#rc.rsRelatedContent.contentid#" />
						<ul class="clearfix"><li class="delete"><a title="Delete" href="##" onclick="return siteManager.removeRelatedContent('c#rc.rsRelatedContent.contentid#','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removerelatedcontent'))#');"><i class="icon-remove-sign"></i></a></li>
						</ul>
				</td>
				</tr></cfloop>
				<cfelse>
				<tr>
				<td id="noFilters" colspan="4" class="noResults">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.norelatedcontent')#</td>
				</tr>
				</cfif>
			</tbody>
		</table>
		<table id="relatedContent" class="table table-striped table-condensed table-bordered mura-table-grid"> 
			<thead>
				<tr>
				<th class="var-width">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contenttitle')#</th>
				<th>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type')#</th>
				<th class="actions">&nbsp;</th>
				</tr>
			</thead>
			<tbody id="RelatedContent">
				<cfif rc.rsRelatedContent.recordCount>
				<cfloop query="rc.rsRelatedContent">
				<cfset itemcrumbdata=application.contentManager.getCrumbList(rc.rsRelatedContent.contentid, rc.siteid)/>
				<tr id="c#rc.rsRelatedContent.contentID#">
				<td class="var-width">#$.dspZoom(itemcrumbdata)#</td>
				<td>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#rc.rsRelatedContent.type#')#</td>
				<td class="actions">
					<input type="hidden" name="relatedcontentid" value="#rc.rsRelatedContent.contentid#" />
						<ul class="clearfix"><li class="delete"><a title="Delete" href="##" onclick="return siteManager.removeRelatedContent('c#rc.rsRelatedContent.contentid#','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removerelatedcontent'))#');"><i class="icon-remove-sign"></i></a></li>
						</ul>
				</td>
				</tr></cfloop>
				<cfelse>
				<tr>
				<td id="noFilters" colspan="4" class="noResults">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.norelatedcontent')#</td>
				</tr>
				</cfif>
			</tbody>
		</table>		
	</div>--->
	
	<script>
		$(document).ready(function(){
			$(".rcSortable").sortable({
				connectWith: ".rcSortable",
				revert: true,
				cursor: 'move'
			}).disableSelection();
			
			siteManager.loadRelatedContent('#HTMLEditFormat(rc.siteid)#','',1)
		});
	</script>
	
	<style>
		.mura .list-table {
		border: 1px solid ##e6e6e6;
		margin: 18px 0;
		}
	
		.mura .list-table .list-table-content-set {
		color: ##000;
		font-weight: bold;
		background: ##f0f0f0;
		padding: 8px 5px;
		}
	
		/* header of list */
		.mura .list-table .list-table-header {
		color: ##000;
		background: ##eaf4fd;
		background-image: linear-gradient(to bottom,##fffefe,##f5f5f5);
		padding: 4px 5px;
		line-height: 18px;
		font-weight: bold;
		}
	
		/* list holder - similar to tbody */
		.mura .list-table .list-table-items {
		position: relative;
		list-style: none;
		display: block;
		padding: 0;
		margin: 0;
		}
	
		/* each 'row' of the pseudo table - similar to tr */
		.mura .list-table .list-table-items li.item {
		position: relative;
		display: block;
		background: ##fcfeff;
		border-top: 1px solid ##e6e6e6;
		padding: 4px 5px;
		border-collapse: collapse;
		overflow: hidden;
		}
	
		.mura .list-table .list-table-items li.item:nth-child(even) {
		background: ##eaf4fd;
		}
	
		/* styles for the list item being sorted */
		.mura .list-table .list-table-items li.item.ui-sortable-helper {}
	
		/* the nested list within each item */
		.mura .list-table .list-table-items li.item ul {
		list-style: none;
		margin: 0;
		padding: .2em;
		}
	
		/* inline list of nested items */
		.mura .list-table .list-table-items li.item ul li {
		display: inline-block;
		}
	
		.mura .list-table .list-table-items li.item ul li strong {
		color: ##333232;
		}
	
		/* set colors & position globally to :before */
		.mura .list-table .list-table-items li.item ul li:before {
		color: ##949494;
		top: 2px;
		position: relative;
		font-family: "FontAwesome";
		font-weight: normal;
		font-style: normal;
		display: inline-block;
		text-decoration: inherit;
		font-size: 18px;
		margin-right: 5px;
		}
	
		/* sub item of 'page' */
		.mura .list-table .list-table-items li.item ul li.page:before {
		content: "\f016";
		}
	
		.mura .list-table .list-table-items li.item ul li.folder:before {
		content: "\f07b";
		}
	
		/* raquo on all but last item */
		.mura .list-table .list-table-items li.item ul li:after {
		content: "\00bb";
		position: relative;
		margin: 0 5px;
		}
	
		.mura .list-table .list-table-items li.item ul li.last:after {
		content: none;
		}
		
		.mura div[id^="rcGroup-"] .list-table-items li.item .delete:before {
		content: "\f057";
		font-family: "FontAwesome";
		font-weight: normal;
		font-style: normal;
		}
	
		.mura div[id^="rcGroup-"] .list-table-items li.item .delete {
		z-index: 1;
		position: absolute;
		text-align: center;
		top: 0;
		bottom: 0;
		right: 0;
		width: 30px;
		font-size: 14px;
		border-left: 1px solid ##e6e6e6;
		line-height: 34px;
		color: ##949494;
		}
		
		.mura div[id^="rcGroup-"] .list-table-items li.item .delete:hover {
		color: ##666;
		text-decoration: none;
		}
	</style>
	
	<div class="fieldset">
		<div class="control-group">
			<label class="control-label">Add Related Content</label>
			<div class="controls">
				<label class="radio inline">
					<input type="radio" name="contentType" value="ic" /> Internal Content
				</label>
				<label class="radio inline">
					<input type="radio" name="contentType" value="el" class="radio inline" /> External Link
				</label>
			</div>
		</div>
		<div id="selectRelatedContent">
			<!---<div class="control-group">
				<label class="control-label">Search for Content</label>
				<div id="internalContent" class="form-inline">
					<input type="text" name="k" value=""/>
					<input type="button" name="btnSearch" value="Search" class="btn" />
				</div>
				<a href="" class="pull-right">Basic Search</a>
			</div>
			<div class="control-group">
				<div id="externalLink" style="display:none;">EXTERNAL LINK FORM</div>
			</div>
			
			<div class="control-group">
				<div id="draggableContainment" class="list-table">
					<div class="list-table-header">Select New Content Parent</div>
					<ul id="rcDraggable" class="list-table-items">
						<li class="item">
							<ul>
								<li class="page last"><strong>Home</strong></li>
							</ul>
						</li>
						<li class="item">
							<ul>
								<li class="page">Home</li>
								<li class="folder">Just a Folder</li>
								<li class="page last"><strong>Just a page</strong></li>
							</ul>
						</li>
						<li class="item">
							<ul>
								<li class="page">Home</li>
								<li class="page last"><strong>My Page</strong></li>
							</ul>
						</li>
						<li class="item">
							<ul>
								<li class="page">Home</li>
								<li class="page last"><strong>Yet Another Page</strong></li>
							</ul>
						</li>
					</ul>
				</div>
			</div>--->
		</div>
		
		<div class="control-group">
			<div id="rcGroup-id1234" class="list-table">
				<div class="list-table-content-set">Related Content Bucket 1</div>
				<div class="list-table-header">Content</div>
				<ul class="list-table-items rcSortable">
					<li class="item">
						<ul>
							<li class="page last"><strong>Home</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
					<li class="item">
						<ul>
							<li class="page">Home</li>
							<li class="folder">Just a Folder</li>
							<li class="page last"><strong>Just a page</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
					<li class="item">
						<ul>
							<li class="page">Home</li>
							<li class="page last"><strong>My Page</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
					<li class="item">
						<ul>
							<li class="page">Home</li>
							<li class="page last"><strong>Yet Another Page</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
				</ul>
			</div>
		</div>
	
		<div class="control-group">
			<div id="rcGroup-id5678" class="list-table">
				<div class="list-table-content-set">Related Content Bucket 2</div>
				<div class="list-table-header">Content</div>
				<ul class="list-table-items rcSortable">
					<li class="item">
						<ul>
							<li class="page last"><strong>Home</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
					<li class="item">
						<ul>
							<li class="page">Home</li>
							<li class="folder">Just a Folder</li>
							<li class="page last"><strong>Just a page</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
					<li class="item">
						<ul>
							<li class="page">Home</li>
							<li class="page last"><strong>My Page</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
					<li class="item">
						<ul>
							<li class="page">Home</li>
							<li class="page last"><strong>Yet Another Page</strong></li>
						</ul>
						<a class="delete"></a>
					</li>
				</ul>
			</div>
		</div>		
	</div>
</div>

</cfoutput>