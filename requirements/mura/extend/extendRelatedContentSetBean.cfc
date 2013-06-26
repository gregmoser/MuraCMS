component extends="mura.bean.beanORM" table="tclassextendrelatedcontentsets" entityname="relatedContentSet" bundleable=true {

	property name="relatedContentSetID" fieldtype="id";
    property name="name" ormtype="varchar" length="50" default="";
    property name="availableSubTypes" ormtype="text";
    property name="orderNo" ormtype="int";
	property name="siteID" ormtype="varchar" length="25" default="";
	property name="subTypeID" ormtype="varchar" length="35" default="";
	
}