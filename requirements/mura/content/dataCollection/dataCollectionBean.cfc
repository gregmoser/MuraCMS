component extends="mura.bean.bean"{
	
	property name='formID' required=true dataType='string';
	property name='siteID' required=true dataType='string';

	function validate(){


	}

	function getValidations(){
		var content=getFormBean();

		if(isJSON(content.getBody())){

		} else {
			return {properties={}};
		}

	}

	function getFormBean(){
		return getBean('content').loadBy(contentID=getValue('formID'),siteID=getValue('siteID'));
	}

	function setContentID(contentID){
		variables.instance.formid=arguments.contentID;
	}

	function setDataCollectionManager(dataCollectionManager){
		variables.dataCollectionManager=arguments.dataCollectionManager;
	}

	function loadBy(responseID){
		set(variables.dataCollectionManager.read(responseID));
		return this;
	}

	function delete(){
		variables.dataCollectionManager.delete(getValue('responseID'));
		return this;
	}

	function save(){
		//need to make sure responseID,siteid and formID are in data
		variables.dataCollectionManager.update(getAllValues());
		return this;
	}

}