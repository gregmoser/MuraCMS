<cfset request.layout=false>
<cfset fileMetaData=$.getBean('fileMetaData').loadBy(fileid=rc.fileid,contenthistid=rc.contenthistid,siteid=rc.siteid)>
<cfoutput>

 <div class="fieldset">
 	<div class="control-group">
		<label class="control-label">
			Image
		</label>
		<div class="controls">
			<img src="#fileMetaData.getUrlForImage('medium')#"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Caption
		</label>
		<div class="controls">
			<textarea id="file-caption" class="span4 htmlEditor">#fileMetaData.getCaption()#</textarea>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Alt Text
		</label>
		<div class="controls">
			<input type="text" id="file-alttext" value="#HTMLEditFormat(fileMetaData.getAltText())#"  maxlength="255" class="span4">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Credits
		</label>
		<div class="controls">
			<input type="text" id="file-credits" value="#HTMLEditFormat(fileMetaData.getCredits())#"  maxlength="255" class="span4">
		</div>
	</div>
</div>	
</cfoutput>