<cfscript>
	getBean('approvalChain').checkSchema();
	getBean('approvalChainMembership').checkSchema();
	getBean('approvalRequest').checkSchema();
	getBean('approvalAction').checkSchema();
	getBean('approvalChainAssignment').checkSchema();
	getBean('changesetRollBack').checkSchema();
	getBean('contentSourceMap').checkSchema();

	dbUtility.setTable("tclassextend")
	.addColumn(column="iconclass",dataType="varchar",length="50");

	dbUtility.setTable("tsettings")
	.addColumn(column="contentApprovalScript",dataType="longtext")
	.addColumn(column="contentRejectionScript",dataType="longtext");

	dbUtility.setTable('temails')
	.addColumn(column='template',dataType='varchar');
</cfscript>