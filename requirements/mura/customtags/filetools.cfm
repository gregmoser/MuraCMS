<cfparam name="attributes.bean" default="">
<cfparam name="attributes.property" default="fileid">
<cfparam name="attributes.size" default="medium">
<cfparam name="attributes.compactDisplay" default="false">
<cfparam name="attributes.deleteKey" default="deleteFile">
<cfparam name="attributes.locked" default="false">

<cfset fileMetaData=attributes.bean.getFileMetaData(attributes.property)>
<cfif not fileMetaData.getIsNew()>
<cfoutput>
	<cfif 
		(
			(attributes.bean.getType() eq 'File' and attributes.property eq 'fileid') 
			or
			 (not fileMetaData.hasImageFileExt() and attributes.property neq 'fileid')
		)>
	     <p class="mura-file #lcase(attributes.bean.getFileExt())#">#HTMLEditFormat(fileMetaData.getFilename())#<cfif attributes.property eq 'fileid' and attributes.bean.getMajorVersion()> (v#attributes.bean.getMajorVersion()#.#attributes.bean.getMinorVersion()#)</cfif>
	     </p>
	     
			<cfif attributes.locked or attributes.property neq "fileid">
		 	<a class="btn" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});"><i class="icon-download"></i> Download</a><br>
		<cfelse>
			<div class="btn-group">
			  <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
			    <i class="icon-download"></i> Download
			    <span class="caret"></span>
			  </a>
			  <ul class="dropdown-menu">
			    <!-- dropdown menu links -->
			    <li><a href="##" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});">Download</a></li>
			    <li><a id="mura-file-offline-edit" href="##">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineediting')#</a></li>
			  </ul>
			</div>
			
			<script>
						jQuery("##mura-file-unlock").click(
							function(event){
								event.preventDefault();
								confirmDialog(
									"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#",
									function(){
										jQuery("##msg-file-locked").fadeOut();
										jQuery("##mura-file-unlock").hide();
										jQuery("##mura-file-offline-edit").fadeIn();
										siteManager.hasFileLock=false;
										jQuery.post("./index.cfm",{muraAction:"carch.unlockfile",contentid:"#attributes.bean.getContentID()#",siteid:"#attributes.bean.getSiteID()#"})
									}
								);	
								
							}
						);
						jQuery("##mura-file-offline-edit").click(
							function(event){
								event.preventDefault();
								var a=this;
								confirmDialog(
									"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineeditingconfirm'))#",
									function(){
										jQuery("##msg-file-locked").fadeIn();
										jQuery("##mura-file-unlock").fadeIn();
										jQuery(a).fadeOut();
										siteManager.hasFileLock=true;
										document.location="./index.cfm?muraAction=carch.lockfile&contentID=#attributes.bean.getContentID()#&siteID=#attributes.bean.getSiteID()#";
									}
								);	
							}
						);
					</script>

			
	 	</cfif>
	</cfif>

	<cfif fileMetaData.hasImageFileExt()>	
	<div class="btn-group">
			<a class="btn" href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#attributes.bean.getContentHistID()#&siteid=#attributes.bean.getSiteID()#&fileid=#attributes.bean.getvalue(attributes.property)#&compactDisplay=#urlEncodedFormat(attributes.compactDisplay)#"><i class="icon-crop"></i>
			</a>
			<a class="btn" href="" onclick="return openFileMetaData('#fileMetaData.getContentHistID()#','#fileMetaData.getFileID()#','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="icon-info-sign"></i></a>
			 <a class="btn" href="##" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});"><i class="icon-download"></i></a>
			<!---
			<a class="btn" href="javascript:##;" onclick="javascript: siteManager.loadAssocImages('#htmlEditFormat(attributes.bean.getSiteID())#','#htmlEditFormat(attributes.bean.getvalue(attributes.property))#','#htmlEditFormat(attributes.bean.getContentID())#','',1);return false;"><i class="icon-picture" data-toggle="tooltip" title="" data-original-title="Select an Existing Image"></i>
			</a>--->
		</div>
		<a href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#attributes.bean.getContentHistID()#&siteid=#attributes.bean.getSiteID()#&fileid=#attributes.bean.getvalue(attributes.property)#&compactDisplay=#urlEncodedFormat(attributes.compactDisplay)#">
			<img id="assocImage" src="#request.context.$.getURLForImage(fileid=attributes.bean.getvalue(attributes.property),size=attributes.size)#?cacheID=#createUUID()#" />
		</a>	
	</cfif>

	<label class="checkbox inline" for="deleteFileBox">
		<input type="checkbox" name="#attributes.deleteKey#" value="1" class="deleteFileBox"/> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')#
	</label>
</cfoutput>
</cfif>