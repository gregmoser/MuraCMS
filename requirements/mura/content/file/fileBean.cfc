component extends="mura.bean.beanORM"{

	property nane="fileid" fieldtype="id";
	property name="content" fieldtype="one-to-one" cfc="content";
	property name="site" fieldtype="one-to-one";
	property name="filename" datatype="varchar" length=200;
	property name="contentType" datatype="varchar" length=100;
	property name="contentSubType" datatype="varchar" length=200;
	property name="fileSize" datatype="int" default=0;
	property name="fileExt" datatype="varchar" length=50;
	property name="moduleid" datatype="varchar" length=35;
	property name="created" datatype="datetime";
	property name="deleted" datatype="int" default=0;
	property name="caption" datatype="text";
	property name="credits" datatype="varchar" length=255;
	property name="alttext" datatype="varchar" length=255;

}