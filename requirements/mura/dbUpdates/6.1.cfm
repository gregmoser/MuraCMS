<cfscript>
	getBean('approvalChain').checkSchema();
	getBean('approvalChainMembership').checkSchema();
	getBean('approvalRequest').checkSchema();
	getBean('approvalAction').checkSchema();
	getBean('approvalChainAssignment').checkSchema();
	getBean('changesetRollBack').checkSchema();
	getBean('contentSourceMap').checkSchema();
	getBean('relatedContentSet').checkSchema();
	getBean('fileMetaData').checkSchema();
	getBean('file').checkSchema();


	dbUtility.setTable("tclassextend")
	.addColumn(column="iconclass",dataType="varchar",length="50");

	dbUtility.setTable("tsettings")
	.addColumn(column="contentApprovalScript",dataType="longtext")
	.addColumn(column="contentRejectionScript",dataType="longtext");

	dbUtility.setTable('temails')
	.addColumn(column='template',dataType='varchar');

	dbUtility.setTable("tchangesets")
	.addColumn(column="closeDate",dataType="datetime");

	dbUtility.setTable("tcontent")
	.addIndex('filename')
	.addIndex('title')
	.addIndex('subtype')
	.addIndex('isnav');
	
	// drop primary key before adding relatedContentID
	if (!dbUtility.setTable("tcontentrelated").columnExists("relatedContentID")) {
		dbUtility.setTable("tcontentrelated").dropPrimaryKey();
	}
	
	dbUtility.setTable("tcontentrelated")
	.addColumn(column="relatedContentSetID",dataType="varchar",length="35")
	.addColumn(column="orderNo",dataType="int")
	.addColumn(column="externalTitle",dataType="varchar",length="500")
	.addColumn(column="externalURL",dataType="varchar",length="2000")
	.addColumn(column="relatedContentID",autoincrement=true);

	dbUtility.setTable("tcontentcategories")
	.addColumn(column="isfeatureable",dataType="int");

</cfscript>