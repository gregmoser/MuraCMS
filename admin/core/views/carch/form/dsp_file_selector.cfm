<cfset stats=rc.contentBean.getStats()>
<cfset lockedByYou=stats.getLockID() eq session.mura.userID>
<cfset lockedBySomeElse=len(stats.getLockID()) and stats.getLockID() neq session.mura.userID>
<cfoutput>
<div class="control-group">
   <label class="control-label">
	<cfif rc.ptype eq 'Gallery' or rc.type neq 'File'>
		<a href="##" rel="tooltip" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'tooltip.selectimage'))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectimage')# <i class="icon-question-sign"></i></a>
	<cfelse>
		#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfile')#
	</cfif>	
	</label>
     <div class="controls">
		<cfif not lockedBySomeElse>
			<cfif  rc.type eq 'File'
				and (rc.type eq 'File' and not rc.contentBean.getIsNew())>
				<p id="msg-file-locked" class="alert"<cfif not lockedByYou> style="display:none;"</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.youvelockedfile')# <a id="mura-file-unlock" href=""<cfif not lockedByYou> style="display:none;"</cfif>><i class="icon-unlock"></i> #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a>
			</cfif>

			<cf_fileselector name="newfile" property="fileid" bean="#rc.contentBean#" deleteKey="deleteFile" compactDisplay="#rc.compactDisplay#" locked="#len(stats.getLockID())#" >

			<cfif rc.type eq 'File'>										
				<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getFileID())#" />
			</cfif>
	<cfelse>
		<!--- Locked by someone else --->
		
			<cfset select=$.getBean("user").loadBy(stats.getLockID())>
			<p id="msg-file-locked" class="alert alert-error help-block">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.filelockedby"),"#HTMLEditFormat(lockedBy.getFName())# #HTMLEditFormat(lockedBy.getLName())#")#  <a href="mailto:#HTMLEditFormat(lockedBy.getEmail())#?subject=#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.fileunlockrequest'))#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.requestfilerelease')#</a></p>
			<a class="mura-file #lcase(rc.contentBean.getFileExt())#" href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileid=#rc.contentBean.getFileID()#&method=attachment" onclick="return confirmDialog('#application.rbFactory.getKeyValue(session.rb,'sitemanager.downloadconfirm')#',this.href);">#HTMLEditFormat(rc.contentBean.getAssocFilename())#<cfif rc.contentBean.getMajorVersion()> (v#rc.contentBean.getMajorVersion()#.#rc.contentBean.getMinorVersion()#)</cfif></a>
			<cfif rc.contentBean.getcontentType() eq 'image'>
				<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#rc.contentBean.getFileID()#" />
				</cfif>
			 <cfif listFindNoCase(session.mura.memberships,"s2")><a id="mura-file-unlock" href="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfile')#</a></cfif>
			<input type="hidden" name="fileid" value="#htmlEditFormat(rc.contentBean.getFileID())#" />
		<cfif listFindNoCase(session.mura.memberships,"s2")>
		<script>
			jQuery("##mura-file-unlock").click(
						function(event){
							event.preventDefault();
							confirmDialog(
								"#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#",
								function(){
									jQuery.post(
										"./index.cfm",{muraAction:"carch.unlockfile",contentid:"#rc.contentBean.getContentID()#",siteid:"#rc.contentBean.getSiteID()#"},
										function(){location.reload();}
									);
								}
							);	
							
						}
					);
		</script>
		</cfif>
	</cfif>
	<script>
		hasFileLock=<cfif stats.getLockID() eq session.mura.userID>true<cfelse>false</cfif>;
		unlockfileconfirm="#JSStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.unlockfileconfirm'))#";
	</script>
	<input type="hidden" id="unlockwithnew" name="unlockwithnew" value="false" />
	</div>
	</div>
</cfoutput>