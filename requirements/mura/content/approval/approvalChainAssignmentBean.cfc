component extends="mura.bean.beanORM" table="tapprovalassignments" bundlealbe=true {

	property name="assignmentID" fieldtype="id";
    property name="approvalChain" fieldtype="many-to-one" cfc="approvalChain" fkcolumn="chainID";
    property name="content" fieldtype="many-to-one" cfc="content" fkcolumn="contentID"; 
    property name="site" fieldtype="many-to-one" cfc="site" fkcolumn="siteID";

}