<cfparam name="attributes.bean" default="">
<cfparam name="attributes.property" default="fileid">
<cfparam name="attributes.size" default="medium">
<cfparam name="attributes.compactDisplay" default="false">
<cfparam name="attributes.deleteKey" default="deleteFile">

<cfset fileMetaData=attributes.bean.getFileMetaData(attributes.property)>

<cfoutput>
<cfif not fileMetaData.getIsNew() and
	(
		(attributes.bean.getType() eq 'File' and attributes.property eq 'fileid') 
		or
		 (not fileMetaData.hasImageFileExt() and attributes.property neq 'fileid')
	)>
     <p>
     <a class="mura-file #lcase(attributes.bean.getFileExt())#" href="##" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});">#HTMLEditFormat(fileMetaData.getFilename())#<cfif attributes.property eq 'fileid' and attributes.bean.getMajorVersion()> (v#attributes.bean.getMajorVersion()#.#attributes.bean.getMinorVersion()#)</cfif></a>
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
		 <a class="btn" href="##" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',function(){location.href='#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#attributes.bean.getvalue(attributes.property)#&method=attachment';});"><i class="icon-download"></i></a>
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