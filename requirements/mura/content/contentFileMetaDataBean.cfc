component extends="mura.bean.beanORMVersioned" 
	table="tcontentfilemetadata" 
	entityName="fileMetaData" 
	bundleable=true 
	versioned=true {
	
	property name="metaID" fieldType="id";
	property name="fileID" fieldType="index" dataType="char" length="35";
	property name="altText" dataType="varchar" length="255";
	property name="filename" type="string" default="" persistent=false;
	property name="filesize" type="integer" default="0" persistent=false;
	property name="contentType" type="string" default="" persistent=false;
	property name="contentSubType" type="string" default="" persistent=false;
	property name="fileExt" type="string" default="" persistent=false;
	property name="created" type="datetime" persistent=false;
	property name="directImages" type="boolean" default=true persistent=false;

	function loadBy(returnFormat="self"){
		var result=super.loadBy(argumentCollection=arguments);

		switch(arguments.returnFormat){
			case 'self': 
				if(variables.instance.isnew && len(variables.instance.fileid)){
					set(getBean('fileManager').readMeta(variables.instance.fileid));
				}

				return this;
				break;
			case 'query':
			case 'iterator':
				return result;
		}

	}

	private function getLoadSQL(){
		return "select tcontentfilemetadata.*, tfiles.filename, tfiles.fileSize, tfiles.contentType, tfiles.contentSubType, tfiles.fileExt, tfiles.created
			 from tcontentfilemetadata
			 inner join tfiles on (tcontentfilemetadata.fileid=tfiles.fileid)
			 ";
	}

	function persistToVersion(version1,version2){
		var properties=arguments.version2.getAllValues();

		for(var prop in properties){
			if(properties[prop] == getValue('fileid')){
				return true;
			}
		}

		return false;
	}

	function setSiteID(siteid){
		if(len(arguments.siteid)){
			variables.instance.siteid=arguments.siteid;
			variables.instance.directImages=getBean('settingsManager').getSite(variables.instance.siteid).getContentRenderer().directImages;
		}
	}

	function getURLForFile(method='inline'){
		if ( not getValue('isNew') ) {
			return '';
		} else {
			return '#application.configBean.getContext()#/tasks/render/file/?method=#arguments.method#&amp;fileID=#getValue('fileid')#';
		}
	}

	function getURLForImage(
		size='large',
		direct=false,
		complete=false,
		height='AUTO',
		width='AUTO',
		siteid=variables.instance.siteid,
		fileid= variables.instance.fileid
	)
	{
	
		var imageURL = getBean('fileManager').createHREFForImage(argumentCollection=arguments);
		if ( IsSimpleValue(imageURL) ) {
			return imageURL;
		} else {
			return '';
		};
	}


}