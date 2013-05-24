component extends="mura.bean.bean"{
	
	property name='formID' required=true dataType='string';
	property name='siteID' required=true dataType='string';

	function set(data){
		if(isQuery(arguments.data)){
			arguments.data=getBean('utility').queryRowToStruct(arguments.data);
		}

		if(structKeyExists(arguments.data,'data') && isWDDX(arguments.data.data)){
			var formdata=variables.dataCollectionManager._deserializeWDDX(arguments.data.data);
			structDelete(arguments.data, data);
			structAppend(arguments.data,formdata,true);
		}

		return super.set(arguments.data);

	}

	function validate(){


	}

	function getValidations(){
		var content=getFormBean();
		var validations={properties={}};
		var i=1;
		var prop={};
		var rules=[];
		var message='';

		if(isJSON(content.getBody())){
			var formDef=deserializeJSON(content.getBody());

			for(i=1;i lte arrayLen(formDef.form.fieldOrder);i=i+1){
				prop=formDef.form.fields[formDef.form.fieldOrder[i]];
				rules=[];

				if(len(prop.validateMessage)){
					message=prop.validateMessage;
				}

				if(len(prop.validateRegex)){
					arrayAppend(rules,{'regex'=prop.validateRegex,message=message});
				}

				if(len(prop.isrequired)){
					arrayAppend(rules,{isrequired=true,message=message});
				}

				if(len(prop.validateType)){
					arrayAppend(rules,{dataType=prop.validateType,message=message});
				}

				if(arrayLen(rules)){
					validations.properties[prop.name]=rules;
				}

			}

		}

		return validations;

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