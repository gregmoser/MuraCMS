<cfscript>
request.layout=false;
bean1=$.getBean('content').loadBy(contenthistid=rc.contenthistid1);
bean2=$.getBean('content').loadBy(contenthistid=rc.contenthistid2);	
diff=bean2.compare(bean1);

if(!structIsEmpty(diff)){
	for(i in diff){
		writeOutput("<h3>#i#</h3>");
		writeOutput(diff[i].html);
	}
} else { 
	writeOutput(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.codediffnodifference'));
}
</cfscript>