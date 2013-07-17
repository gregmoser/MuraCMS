<cfparam name="attributes.bean" default="">
<cfparam name="attributes.property" default="fileid">
<cfparam name="attributes.size" default="medium">
<cfparam name="attributes.compactDisplay" default="false">
<cfparam name="attributes.deleteKey" default="deleteFile">

<cfset fileMetaData=attributes.bean.getFileMetaData(attributes.property)>

<cfoutput>
<cfif not fileMetaData.getIsNew() and attributes.bean.getType() eq 'File' and attributes.property eq 'fileid'>
	
	<p style="display:none;" id="mura-revision-type">
		<label class="radio inline">
			<input type="radio" name="versionType" value="major">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.major')#
		</label>
		<label class="radio inline">
				<input type="radio" name="versionType" value="minor" checked />#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.version.minor')#
		</label>
	</p>
	<script>
		jQuery(".mura-file-selector-newfile").change(function(){
			jQuery("##mura-revision-type").fadeIn();
			});	
	</script>
	

     <p>
     <a class="mura-file #lcase(attributes.bean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getFileID()#&method=attachment" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',this.href);">#HTMLEditFormat(attributes.bean.getAssocFilename())#<cfif attributes.bean.getMajorVersion()> (v#attributes.bean.getMajorVersion()#.#attributes.bean.getMinorVersion()#)</cfif></a>
     </p>
</cfif>

<cfif fileMetaData.hasImageFileExt()>
	<a href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#attributes.bean.getContentHistID()#&siteid=#attributes.bean.getSiteID()#&fileid=#attributes.bean.getvalue(attributes.property)#&compactDisplay=#urlEncodedFormat(attributes.compactDisplay)#">
		<img id="assocImage" src="#request.context.$.getURLForImage(fileid=attributes.bean.getvalue(attributes.property),size=attributes.size)#?cacheID=#createUUID()#" />
	</a>
						
	<div class="btn-group">
		<a class="btn" href="./index.cfm?muraAction=cArch.imagedetails&contenthistid=#attributes.bean.getContentHistID()#&siteid=#attributes.bean.getSiteID()#&fileid=#attributes.bean.getvalue(attributes.property)#&compactDisplay=#urlEncodedFormat(attributes.compactDisplay)#"><i class="icon-crop"></i>
		</a>
		<a class="btn" href="" onclick="return openFileMetaData('#fileMetaData.getContentHistID()#','#fileMetaData.getFileID()#','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="icon-info-sign"></i></a>
		
		<!---
		<a class="btn" href="javascript:##;" onclick="javascript: siteManager.loadAssocImages('#htmlEditFormat(attributes.bean.getSiteID())#','#htmlEditFormat(attributes.bean.getvalue(attributes.property))#','#htmlEditFormat(attributes.bean.getContentID())#','',1);return false;"><i class="icon-picture" data-toggle="tooltip" title="" data-original-title="Select an Existing Image"></i>
		</a>--->
	</div>
</cfif>

<cfif not fileMetaData.getIsNew()>
	<label class="checkbox inline" for="deleteFileBox">
		<input type="checkbox" name="#attributes.deleteKey#" value="1" class="deleteFileBox"/> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')#
	</label>
</cfif>
</cfoutput>