<cfparam name="attributes.name" default="newfile">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.label" default="">
<cfparam name="attributes.required" default="#attributes.name#">
<cfparam name="attributes.validation" default="">
<cfparam name="attributes.regex" default="">
<cfparam name="attributes.message" default="">
<cfparam name="attributes.deleteKey" default="">
<cfparam name="attributes.compactDisplay" default="false">
<cfparam name="attributes.property" default="#attributes.name#">
<cfparam name="attributes.size" default="medium">

<cfif attributes.bean.getTypes() neq 'File' and attributes.property eq 'fileid'>
	<cfset filetype='Image'>
<cfelse>
	<cfset filetype='File'>
</cfif>

<cfoutput>
	<div data-name="#attributes.name#" data-property="#attributes.property#" data-fileid="#attributes.bean.getValue(attributes.property)#" data-filetype="#filetype#" data-contentid="#attributes.bean.getcontentid()#" data-siteid="#attributes.bean.getSiteID()#"class="mura-file-selector mura-resource-select #attributes.class#">
		<div class="btn-group" data-toggle="buttons-radio">
			<button type="button" style="display:none">HORRIBLE HACK</button>
			<button type="button" class="btn active" value="Upload"><i class="icon-upload-alt"></i> Via Upload</button>
			<button type="button" class="btn" value="URL"><i class="icon-download-alt"></i> Via URL </button>
			<button type="button" class="btn" value="Existing"><i class="icon-picture"></i> Select Existing</button>
		</div>

		<div class="well">

			<div id="mura-file-upload-#attributes.name#" class="mura-file-option mura-file-upload fileTypeOption#attributes.name#">
			
				<div class="control-group">
					<label class="control-label">Select File to Upload</label>
					<div class="controls">
						<input name="#attributes.name#" type="file" class="mura-file-selector-#attributes.name#"
							data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validation="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
						<a style="display:none;" class="btn" href="" onclick="return openFileMetaData('#attributes.bean.getContentHistID()#','','#attributes.bean.getSiteID()#','#attributes.property#');"><i class="icon-info-sign"></i></a>
					</div>
				</div>
				
			</div>
			<div id="mura-file-url-#attributes.name#" class="mura-file-option mura-file-url fileTypeOption#attributes.name#">
				
				<div class="control-group">
					<label class="control-label">Enter URL</label>
					<div class="controls">		
						<input type="text" name="#attributes.name#" class="mura-file-selector-#attributes.name# input-xxlarge" type="url" placeholder="http://www.domain.com/yourfile.zip"	value=""
						data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validate="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
					</div>
				</div>
		
			</div>

			<div id="mura-file-existing-#attributes.name#" class="mura-file-option mura-file-existing fileTypeOption#attributes.name#">
				
		
			</div>
		</div>

		<cfif isObject(attributes.bean)>
			<cf_filetools bean="#attributes.bean#" property="#attributes.property#" deleteKey="#attributes.deleteKey#" compactDisplay="#attributes.compactDisplay#" size="#attributes.size#" filetype="#filetype#">
		</cfif>
	</div>


</cfoutput>