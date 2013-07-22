<cfset request.layout=false>
<cfset fileMetaData=$.getBean('fileMetaData').loadBy(fileid=rc.fileid,contenthistid=rc.contenthistid,siteid=rc.siteid)>
<cfoutput>
 <div class="fieldset">
 	<cfif fileMetaData.hasImageFileExt()>
	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.image')#
		</label>
		<div class="controls">
			<img src="#fileMetaData.getUrlForImage('medium')#"/>
		</div>
	</div>
	</cfif>
	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.caption')#
		</label>
		<div class="controls">
			<textarea id="file-caption" data-property="caption" class="filemeta span4 htmlEditor">#fileMetaData.getCaption()#</textarea>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.alttext')#
		</label>
		<div class="controls">
			<input type="text" data-property="alttext" value="#HTMLEditFormat(fileMetaData.getAltText())#"  maxlength="255" class="filemeta span4">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.credits')#
		</label>
		<div class="controls">
			<input type="text" data-property="credits" value="#HTMLEditFormat(fileMetaData.getCredits())#"  maxlength="255" class="filemeta span4">
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			#application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.updatedefaults')#
		</label>
		<div class="controls checkbox">
			<input type="checkbox" id="filemeta-setasdefault"> #application.rbFactory.getKeyValue(session.rb,'sitemanager.filemetadata.setasdefault')#
		</div>
	</div>
	<input type="hidden" data-property="property" value="#HTMLEditFormat(rc.property)#" class="filemeta">
</div>	
</cfoutput>