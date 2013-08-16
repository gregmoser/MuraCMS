<cfparam name="attributes.bean" default="">
<cfparam name="attributes.property" default="fileid">
<cfparam name="attributes.size" default="medium">
<cfparam name="attributes.compactDisplay" default="false">
<cfparam name="attributes.deleteKey" default="deleteFile">
<cfparam name="attributes.locked" default="false">

<cfset fileMetaData=attributes.bean.getFileMetaData(attributes.property)>
<cfif not fileMetaData.getIsNew()>
<div class="controls rule-dotted-top">
<cfoutput>
	<cfif 
		(
			(attributes.bean.getType() eq 'File' and attributes.property eq 'fileid') 
			or
			 (not fileMetaData.hasImageFileExt() and attributes.property neq 'fileid')
		)>
	     <p class="mura-file #lcase(attributes.bean.getFileExt())#"><i class="<cfif fileMetaData.hasImageFileExt()>icon-picture<cfelse>icon-file-text-alt</cfif> icon-2x"></i> #HTMLEditFormat(fileMetaData.getFilename())#<cfif attributes.property eq 'fileid' and attributes.bean.getMajorVersion()> (v#attributes.bean.getMajorVersion()#.#attributes.bean.getMinorVersion()#)</cfif>
	     </p>
	     
		<cfif attributes.property neq "fileid">
		 	<div class="btn-group">
		 		<a class="btn" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});"><i class="icon-download"></i> Download 1</a>
		 	</div>

		<cfelse>
			<div id="mura-download-locked" class="btn-group"<cfif not attributes.locked> style="display:none"</cfif>>
				<a class="btn" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});"><i class="icon-download"></i> Download 2</a>
			</div>
			<div id="mura-download-unlocked" class="btn-group"<cfif attributes.locked> style="display:none"</cfif>>
			  <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
			    <i class="icon-download"></i> Download 3 <span class="caret"></span>
			  </a>
			  <ul class="dropdown-menu">
			    <!-- dropdown menu links -->
			    <li><a href="##" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});">Download</a></li>
			    <li><a id="mura-file-offline-edit" href="##">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineediting')#</a></li>
			  </ul>
			</div>
	 	</cfif>
	</cfif>

	<cfif fileMetaData.hasImageFileExt()>	
		<div class="btn-group">
			<a class="btn" href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#attributes.bean.getContentHistID()#&siteid=#attributes.bean.getSiteID()#&fileid=#attributes.bean.getvalue(attributes.property)#&compactDisplay=#urlEncodedFormat(attributes.compactDisplay)#"><i class="icon-crop"></i>
			</a>
			<a class="btn" href="" onclick="return openFileMetaData('#fileMetaData.getContentHistID()#','#fileMetaData.getFileID()#','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="icon-info-sign"></i></a>
			<a class="btn"<cfif not attributes.locked> style="display:none"</cfif> onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});"><i class="icon-download"></i> Download 2 alt</a>
			
			<div id="mura-download-unlocked" class="btn-group"<cfif attributes.locked> style="display:none"</cfif>>
			  <a class="btn dropdown-toggle" data-toggle="dropdown" href="##">
			    <i class="icon-download"></i> Download 3 alt <span class="caret"></span>
			  </a>
			  <ul class="dropdown-menu">
			    <!-- dropdown menu links -->
			    <li><a href="##" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});"><i class="icon-download"></i> Download</a></li>
			    <li><a id="mura-file-offline-edit" href="##"><i class="icon-lock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.downloadforofflineediting')#</a></li>
			  </ul>
			</div>
			
		</div>
		<a href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#attributes.bean.getContentHistID()#&siteid=#attributes.bean.getSiteID()#&fileid=#attributes.bean.getvalue(attributes.property)#&compactDisplay=#urlEncodedFormat(attributes.compactDisplay)#">
			<img id="assocImage" src="#request.context.$.getURLForImage(fileid=attributes.bean.getvalue(attributes.property),size=attributes.size)#?cacheID=#createUUID()#" />
		</a>	
	</cfif>

	<div>
	<label class="checkbox inline" for="deleteFileBox">
		<input type="checkbox" name="#attributes.deleteKey#" value="1" class="deleteFileBox"/><a href="##" rel="tooltip" title="To remove the file, check the box and publish or save a version of the page">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')# <i class="icon-question-sign"></i></a>
	</label>
</div>

	<cfif attributes.property eq 'fileid'>
		
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
							jQuery("##mura-download-unlocked").show();
							jQuery("##mura-download-locked").hide();
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
							jQuery("##mura-download-unlocked").hide();
							jQuery("##mura-download-locked").show();
							jQuery(a).fadeOut();
							siteManager.hasFileLock=true;
							document.location="./index.cfm?muraAction=carch.lockfile&contentID=#attributes.bean.getContentID()#&siteID=#attributes.bean.getSiteID()#";
						}
					);	
				}
			);
		</script>

			
	</cfif>
</cfoutput>
</div>
</cfif>