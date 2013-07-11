<cfparam name="attributes.name" default="newfile">
<cfparam name="attributes.id" default="">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.label" default="">
<cfparam name="attributes.required" default="#attributes.name#">
<cfparam name="attributes.validation" default="">
<cfparam name="attributes.regex" default="">
<cfparam name="attributes.message" default="">

<cfoutput>
	<div data-name="#attributes.name#" class="mura-file-selector mura-resource-select #attributes.class#">
		<div class="btn-group" data-toggle="buttons-radio">
			<button type="button" style="display:none">HORRIBLE HACK</button>
			<button type="button" class="btn" value="Upload"><i class="icon-upload-alt"></i> Via Upload</button>
			<button type="button" class="btn" value="URL"><i class="icon-download-alt"></i> Via URL </button>
		</div>

		<div class="well">
	
			<div id="mura-file-upload-#attributes.name#" class="mura-file-option mura-file-upload fileTypeOption#attributes.name#">
			
				<div class="control-group">
					<label class="control-label">Select File to Upload</label>
					<div class="controls">
						<input name="#attributes.name#" type="file" class="mura-file-selector-#attributes.name#"
							data-label="#HTMLEditFormat(attributes.label)#" data-label="#HTMLEditFormat(attributes.required)#" data-validation="#HTMLEditFormat(attributes.validation)#" data-regex="#HTMLEditFormat(attributes.regex)#" data-message="#HTMLEditFormat(attributes.message)#">
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
		</div>
	</div>
</cfoutput>