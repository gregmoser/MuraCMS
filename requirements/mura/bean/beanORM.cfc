component extends="mura.bean.bean" {

	function init(){
		super.init();
		variables.table="";
		variables.primaryKey="";
		variables.properties={};
		variables.dbUtility="";
		variables.beanClass="";
		variables.addObjects=[];
		variables.removeObjects=[];
		variables.synthedFunctions={};
		getProperties();

		for(var prop in variables.properties){
			prop=variables.properties[prop];

			if(structKeyExists(prop,"type") and listFindNoCase("struct,array",prop.type)){
				if(prop.type eq "struct"){
					variables.instance[prop.name]={};
				} else if(prop.type eq "array"){
					variables.instance[prop.name]=[];
				}
			} else if(prop.persistent){

				if(structKeyExists(prop,"fieldType") and prop.fieldType eq "id"){
					variables.instance[prop.column]=createUUID();
				}else if (listFindNoCase("date,datetime,timestamp",prop.datatype)){
					variables.instance[prop.column]=now();
				} else if(structKeyExists(prop,"default")){
					if(prop.default neq 'null'){
						variables.instance[prop.column]=prop.default;
					} else {
						variables.instance[prop.column]='';
					}
				} 

				if (prop.name eq 'lastupdateby'){
					if(isDefined("session.mura") and session.mura.isLoggedIn){
						variables.instance.LastUpdateBy = left(session.mura.fname & " " & session.mura.lname,50);
					} else {
						variables.instance.LastUpdateBy='';
					}
				} else if (prop.name eq 'lastupdatebyid'){
					if(isDefined("session.mura") and session.mura.isLoggedIn){
						variables.instance.LastUpdateById = session.mura.userID;
					} else {
						variables.instance.LastUpdateById='';
					}
				}

			}
		}

		//writeDump(var=variables.instance);
		//writeDump(var=variables.properties,abort=true);

	}

	function OnMissingMethod(MissingMethodName,MissingMethodArguments){
		var prefix=left(arguments.MissingMethodName,3);

		if(len(arguments.MissingMethodName)){

			if(structKeyExists(variables.synthedFunctions,arguments.MissingMethodName)){
				try{

					if(not structKeyExists(arguments,'MissingMethodArguments')){
						arguments.MissingMethodArguments={};
					}

					if(structKeyExists(variables.synthedFunctions[arguments.MissingMethodName],'args')){
						
						if(structKeyExists(variables.synthedFunctions[arguments.MissingMethodName].args,'cfc')){
							var bean=getBean(variables.synthedFunctions[arguments.MissingMethodName].args.cfc);
							
							if(variables.synthedFunctions[arguments.MissingMethodName].args.functionType eq 'getEntity'){
								variables.synthedFunctions[arguments.MissingMethodName].args.loadKey=bean.getPrimaryKey();
							} else {
								variables.synthedFunctions[arguments.MissingMethodName].args.loadKey=variables.synthedFunctions[arguments.MissingMethodName].args.fkcolumn;
							}

							structAppend(arguments.MissingMethodArguments,synthArgs(variables.synthedFunctions[arguments.MissingMethodName].args),true);
						}
					}

					return evaluate(variables.synthedFunctions[arguments.MissingMethodName].exp);

				} catch(any err){
					if(request.muratransaction){
						transactionRollback();
					}				
					writeDump(var=variables.synthedFunctions[arguments.MissingMethodName]);
					writeDump(var=err,abort=true);
				}
			} 

			if(listFindNoCase("set,get",prefix) and len(arguments.MissingMethodName) gt 3){
				var prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3);	
				
				if(prefix eq "get"){
					return getValue(prop);
				} 

				if(not structIsEmpty(arguments.MissingMethodArguments)){
					return setValue(prop,arguments.MissingMethodArguments[1]);
				} else {
					throw(message="The method '#arguments.MissingMethodName#' requires a propery value");
				}
					
			} else {
				throw(message="The method '#arguments.MissingMethodName#' is not defined");
			}
		} else {
			return "";
		}
	}

	private function synthArgs(args){
		var returnArgs={
				"#translatePropKey(args.loadkey)#"=getValue(translatePropKey(args.fkcolumn)),
				returnFormat=args.returnFormat
			};

		if(structKeyExists(args,'prop') and structKeyExists(variables.properties[args.prop],'orderby')){
			returnArgs.orderby=variables.properties[args.prop].orderby;
		}

		return returnArgs;
	}

	function set(data){
		if(isdefined('preLoad')){
			evaluate('preLoad()');
		}

		super.set(argumentCollection=arguments);

		if(isdefined('postLoad')){
			evaluate('postLoad()');
		}

		return this;
	}


	function getDbUtility(){
		if(not isObject(variables.dbUtility)){
			variables.dbUtility=getBean('dbUtility');
			variables.dbUtility.setTable(getTable());	
		}
		return variables.dbUtility;
	}

	function setDbUtility(dbUtility){
		variables.dbUtility=arguments.dbUtility;
	}

	function getTable(){
		if(not len(variables.table)){
			variables.table=getMetaData(this).table;
		}
		return variables.table;
	}

	function getPrimaryKey(){
		return variables.primaryKey;
	}

	function getColumns(){
		if(!getDbUtility().tableExists()){
			checkSchema();
		}
		return getDbUtility().columns();
	}

	function getSite(){
		return getBean('settingsManager').getSite(getValue('siteID'));
	}

	function checkSchema(){
		var props=getProperties();

		for(var prop in props){
			table=props[prop].table;
			if(props[prop].persistent){
				getDbUtility().addColumn(argumentCollection=props[prop]);

				if(structKeyExists(props[prop],"fieldtype")){
					if(props[prop].fieldtype eq "id"){
						getDbUtility().addPrimaryKey(argumentCollection=props[prop]);
					} else if ( listFindNoCase('one-to-many,many-to-one',props[prop].fieldtype) ){
						getDbUtility().addIndex(argumentCollection=props[prop]);
					}
				}
			}
		}
		
		return this;
	}

	private function translatePropKey(property){
		if(arguments.property eq 'primaryKey'){
			return getPrimaryKey();
		}
		return arguments.property;
	}


	function getProperties(){
		
		if(structIsEmpty(variables.properties)){
			var md={};
			var pname='';
			var i='';
			var prop={};
			var md=getMetaData(this);
			
			variables.table=md.table;
			variables.beanClass=listLast(md.name,'.');

			if(right(variables.beanClass,4) eq "bean"){
				variables.beanClass=left(variables.beanClass,len(variables.beanClass)-4);
			}
			
			//writeDump(var=md,abort=true);

			for (md; 
			    structKeyExists(md, "extends"); 
			    md = md.extends) 
			  { 

			    if (structKeyExists(md, "properties")) 
			    { 
			      for (i = 1; 
			           i <= arrayLen(md.properties); 
			           i++) 
			      { 
			        pName = md.properties[i].name; 

			        if(!structkeyExists(properties,pName)){
			       	 	variables.properties[pName]=md.properties[i];
			       	 	prop=variables.properties[pName];
			       	 	prop.table=variables.table;

			       	 	if(!structKeyExists(prop,"fieldtype")){
			       	 		prop.fieldType="";
			       	 	} 

			       	 	if(prop.fieldtype eq 'id'){
			       	 		variables.primaryKey=prop.name;
			       	 		setPropAsIDColumn(prop);
			       	 	}

			       	 	if(!structKeyExists(prop,"dataType")){
			       	 		if(structKeyExists(prop,"ormtype")){
			       	 			prop.dataType=prop.ormtype;
			       	 		} else if(structKeyExists(prop,"type")){
			       	 			prop.dataType=prop.type;
			       	 		} else {
			       	 			prop.type="string";
			       	 			prop.dataType="varchar";
			       	 		}
			       	 	}

			       	 	if(structKeyExists(prop,'cfc')){
			       	 		prop.persistent=true;

			       	 		if(prop.fieldtype eq 'one-to-many'){
			       	 			prop.persistent=false;
			       	 		} else {
			       	 			prop.persistent=true;
			       	 			setPropAsIDColumn(prop);
			       	 			//writeDump(var=prop,abort=true);
			       	 		}

			       	 		if(!structKeyExists(prop,'fkcolumn')){
			       	 			prop.fkcolumn="primaryKey";
			       	 		}

			       	 		prop.column=prop.fkcolumn;

			       	 		if(prop.fieldtype eq 'one-to-many'){
			       	 			//getBean("#prop.cfc#").loadBy(argumentCollection=structAppend(arguments.MissingMethodArguments,synthArgs(variables.synthedFunctions["has#prop.name#"].args),false)).recordcount
				       	 		variables.synthedFunctions['get#prop.name#Iterator']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=prop.name,fkcolumn="primaryKey",cfc="#prop.cfc#",returnFormat="iterator",functionType='getEntityIterator'}};
				       	 		variables.synthedFunctions['get#prop.name#Query']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=prop.name,fkcolumn="primaryKey",cfc="#prop.cfc#",returnFormat="query",functionType='getEntityQuery'}};
				       	 		variables.synthedFunctions['has#prop.name#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments).recordcount',args={prop=prop.name,fkcolumn="primaryKey",cfc="#prop.cfc#",returnFormat="query",functionType='hasEntity'}};
				       	 		variables.synthedFunctions['add#prop.name#']={exp='addObject(arguments.MissingMethodArguments[1])',args={prop=prop.name,functionType='addEntity'}};
				       	 		variables.synthedFunctions['remove#prop.name#']={exp='removeObject(arguments.MissingMethodArguments[1])',args={prop=prop.name,functionType='removeEntity'}};

					       	 	if(structKeyExists(prop,"singularname")){
					       	 		variables.synthedFunctions['get#prop.singularname#Iterator']=variables.synthedFunctions['get#prop.name#Iterator'];
					       	 		variables.synthedFunctions['get#prop.singularname#Query']=variables.synthedFunctions['get#prop.name#Query'];
					       	 		variables.synthedFunctions['add#prop.singularname#']=variables.synthedFunctions['add#prop.name#'];
					       	 		variables.synthedFunctions['has#prop.singularname#']=variables.synthedFunctions['has#prop.name#'];
					       	 		variables.synthedFunctions['remove#prop.singularname#']=variables.synthedFunctions['remove#prop.name#'];
					       	 	}
			       	 		} else if (prop.fieldtype eq 'many-to-one' or prop.fieldtype eq 'one-to-one'){
			       	 			if(prop.fkcolumn eq 'siteid'){
			       	 				variables.synthedFunctions['get#prop.name#']={exp='getBean("settingsManager").getSite(getValue("siteID"))',args={prop=prop.name,functionType='getEntity'}};
			       	 				variables.synthedFunctions['set#prop.name#']={exp='setValue("siteID",arguments.MissingMethodArguments[1].getSiteID()))',args={prop=prop.name,functionType='setEntity'}};
			       	 			} else {
			       	 				variables.synthedFunctions['get#prop.name#']={exp='bean.loadBy(argumentCollection=arguments.MissingMethodArguments)',args={prop=prop.name,fkcolumn="#prop.fkcolumn#",cfc="#prop.cfc#",returnFormat="this",functionType='getEntity'}};
			       	 				variables.synthedFunctions['set#prop.name#']={exp='setValue("#prop.fkcolumn#",arguments.MissingMethodArguments[1].getValue(arguments.MissingMethodArguments[1].getPrimaryKey())',args={prop=prop.name,functionType='setEntity'}};
			       	 			}
			       	 		}

			       	 		if(not structKeyExists(prop,'cascade')){
			       	 			prop.cascade='none';
			       	 		}

			       	 	} else if(!structKeyExists(prop,"persistent") ){
			       	 		prop.persistent=true;
			       	 	} 

			       	 	if(!structKeyExists(prop,'column')){
			       	 		prop.column=prop.name;
			       	 	}

			       	 	structAppend(prop,getDbUtility().getDefaultColumnMetatData(),false);

			      	} 
			      }
			    } 
			} 

		}

		//writeDump(var=variables.properties,abort=true);
		
		return variables.properties;
	}

	private function setPropAsIDColumn(prop){
		arguments.prop.type="string";
		arguments.prop.nullable=false;
		arguments.prop.default="";

		if(arguments.prop.name eq 'site'){
			arguments.prop.ormtype="varchar";
			arguments.prop.datatype="varchar";
			arguments.prop.length=25;
		} else {
			arguments.prop.ormtype="char";
			arguments.prop.datatype="char";
			arguments.prop.length=35;
		}
	}

	private function addObject(obj){
		//writeDump(var='arguments.obj.set#getPrimaryKey()#(getValue("#getPrimaryKey()#"))',abort=true);
		evaluate('arguments.obj.set#getPrimaryKey()#(getValue("#getPrimaryKey()#"))');
		arrayAppend(variables.addObjects,arguments.obj);
		return this;
	}

	private function removeObject(obj){
		//writeDump(var='arguments.obj.set#getPrimaryKey()#(getValue("#getPrimaryKey()#"))',abort=true);
		arrayAppend(variables.removeObjects,arguments.obj);
		return this;
	}

	private function addQueryParam(qs,prop,value){
		var paramArgs={};
		var columns=getColumns();

		if(arguments.prop.persistent){
			
			paramArgs={name=arguments.prop.column,cfsqltype="cf_sql_" & columns[arguments.prop.column].datatype};
						
			if(structKeyExists(arguments,'value')){
				paramArgs.null=arguments.prop.nullable and (not len(arguments.value) or arguments.value eq "null");
			}	else {
				arguments.value='null';
				paramArgs.null=arguments.prop.nullable and (not len(variables.instance[arguments.prop.column]) or variables.instance[arguments.prop.column] eq "null");			
			} 

			paramArgs.value=arguments.value;

			if(columns[arguments.prop.column].datatype eq 'datetime'){
				paramArgs.cfsqltype='cf_sql_timestamp';
			}

			if(listFindNoCase('text,longtext',columns[arguments.prop.column].datatype)){
				paramArgs.cfsqltype='cf_sql_longvarchar';
			}

			arguments.qs.addParam(argumentCollection=paramArgs);
		}

	}

	function save(){
		var pluginManager=getBean('pluginManager');
		var event=new mura.event({siteID=variables.instance.siteid,bean=this});
		pluginManager.announceEvent('onBefore#variables.beanClass#Save',event);
		
		if(!hasErrors()){
			var props=getProperties();
			var columns=getColumns();
			var prop={};
			var started=false;
			var sql='';
			var qs=new query();

			for (prop in props){
				if(props[prop].persistent){
					addQueryParam(qs,props[prop],variables.instance[props[prop].column]);
				}
			}

			qs.addParam(name='primarykey',value=variables.instance[getPrimaryKey()],cfsqltype='cf_sql_varchar');

			if(qs.execute(sql='select #getPrimaryKey()# from #getTable()# where #getPrimaryKey()# = :primarykey').getResult().recordcount){
				
				if(isdefined('preUpdate')){
					evaluate('preUpdate()');
				}

				pluginManager.announceEvent('onBefore#variables.beanClass#Update',event);

				if(!hasErrors()){

					savecontent variable="sql" {
						writeOutput('update #getTable()# set ');
						for(prop in props){
							if(props[prop].column neq getPrimaryKey() and structKeyExists(columns, props[prop].column)){
								if(started){
									writeOutput(",");
								}
								writeOutput("#props[prop].column#= :#props[prop].column#");
								started=true;
							}
						}

						writeOutput(" where #getPrimaryKey()# = :primarykey");
					}

					if(arrayLen(variables.removeObjects)){
						for(var obj in variables.removeObjects){	
							obj.delete();
						}
					}

					if(arrayLen(variables.addObjects)){
						for(var obj in variables.addObjects){	
							//writeDump(var=obj.getAllValues(),abort=true);
							obj.save();
						}
					}
						
					qs.execute(sql=sql);

					if(isdefined('postUpdate')){
						evaluate('postUpdate()');
					}

					pluginManager.announceEvent('onAfter#variables.beanClass#Update',event);
				}
				
			} else{

				if(isdefined('preCreate')){
					evaluate('preCreate()');
				}

				if(isdefined('preInsert')){
					evaluate('preInsert()');
				}

				pluginManager.announceEvent('onBefore#variables.beanClass#Create',event);

				if(!hasErrors()){

					savecontent variable="sql" {
						writeOutput('insert into #getTable()# (');
						for(prop in props){
							if(structKeyExists(columns, props[prop].column)){
								if(started){
									writeOutput(",");
								}
								writeOutput("#props[prop].column#");
								started=true;
							}
						}

						writeOutput(") values (");

						started=false;
						for(prop in props){
							if(structKeyExists(columns, props[prop].column)){
								if(started){
									writeOutput(",");
								}
								writeOutput(" :#props[prop].column#");
								started=true;
							}
						}

						writeOutput(")");
						
					}

					//writeDump(var=variables.instance,abort=true);
					//writeDump(var=sql,abort=true);
				
					if(arrayLen(variables.addObjects)){
						for(var obj in variables.addObjects){	
							obj.save();
						}
					}


					qs.execute(sql=sql);

					if(isdefined('postCreate')){
						evaluate('postCreate()');
					}


					if(isdefined('postInsert')){
						evaluate('postInsert()');
					}

					pluginManager.announceEvent('onAfter#variables.beanClass#Create',event);
				}
			}

			pluginManager.announceEvent('onAfter#variables.beanClass#Save',event);
			pluginManager.announceEvent('on#variables.beanClass#Save',event);
		
		} else {
			request.muratransaction=false;
		}

		return this;
	}

	/*
	function save(){
		if(request.muraORMtransaction){
			_save();
		} else {
			request.muraORMtransaction=true;
			transaction {
				try{
					_save();
					if(request.muraORMtransaction){
						transactionCommit();
					} else {
						transactionRollback();
					}
				} catch(any err){
					transactionRollback();
				}
			}
			request.muraORMtransaction=false;
		}
	}
		
	function delete(){
		if(request.muraORMtransaction){
			_delete();
		} else {
			request.muraORMtransaction=true;
			transaction {
				try{
					_delete();
					if(request.muraORMtransaction){
						transactionCommit();
					} else {
						transactionRollback();
					}
				} 
				catch(any err){
					transactionRollback();
				}
			}
			request.muraORMtransaction=false;
		}
	}*/
	
	function delete(){
		var props=getProperties();
		var pluginManager=getBean('pluginManager');
		var event=new mura.event({siteID=variables.instance.siteid,bean=this});

		if(isdefined('preDelete')){
			evaluate('preDelete()');
		}

		pluginManager.announceEvent('onBefore#variables.beanClass#Delete',event);

		for(var prop in props){
			if(structKeyExists(props[prop],'cfc') and props[prop].fieldtype eq 'one-to-many' and  props[prop].cascade eq 'delete'){
				var loadArgs[props[prop].fkcolumn]=getValue(translatePropKey(props[prop].fkcolumn));
				var subItems=evaluate('getBean(variables.beanClass).loadBy(argumentCollection=loadArgs).get#prop#Iterator()');
				while(subItems.hasNext()){
					subItems.next().delete();
				}
			}
		}

		var qs=new Query();
		qs.addParam(name='primarykey',value=variables.instance[getPrimaryKey()],cfsqltype='cf_sql_varchar');
		qs.execute(sql='delete from #getTable()# where #getPrimaryKey()# = :primarykey');

		if(isdefined('postDelete')){
			evaluate('postDelete()');
		}

		pluginManager.announceEvent('onAfter#variables.beanClass#Delete',event);

		return this;
	}

	function loadBy(returnFormat="self"){
		var qs=new Query();
		var sql="";
		var props=getProperties();
		var prop="";
		var columns=getColumns();
		var started=false;
		var rs="";
		var hasArg=false;

		savecontent variable="sql"{
			writeOutput("select * from #getTable()# ");
			for(var arg in arguments){
				hasArg=false;
				prop=arg;

				if(structKeyExists(props,arg) or arg eq 'primarykey'){
					hasArg=true;
				} else if (structKeyExists(columns,arg)) {
					for(prop in props){
						if(props[prop].column eq arg){
							hasArg=true;
							break;
						}
					}
				}

				if(hasArg){
					if(arg eq 'primarykey'){
						arg=getPrimaryKey();
						prop=arg;
					}

					addQueryParam(qs,props[prop],arguments[arg]);

					if(not started){
						writeOutput("where ");
						started=true;
					} else {
						writeOutput("and ");
					}

					writeOutput(" #arg#= :#arg# ");
				}	
			}

			if(structKeyExists(arguments,'orderby')){
				writeOutput("order by #arguments.orderby# ");	
			}
		}
		
		rs=qs.execute(sql=sql).getResult();
	
		if(rs.recordcount){
			set(rs);
		} else {
			set(arguments);
		}

		if(arguments.returnFormat eq 'query'){
			return rs;
		} else if( arguments.returnFormat eq 'iterator'){	
			return getBean('beanIterator').setBeanClass(variables.beanClass).setQuery(rs);
		} else {
			return this;
		}
	}

	function clone(){
		return getBean(variables.beanClass).setAllValues(structCopy(getAllValues()));
	}

	function hasProperty(property){
		var props=getProperties();

		for(var prop in props){
			if(props[prop].column eq arguments.property){
				return true;
			}
		}

		return false;
	}

	function getFeed(){		
		var feed=getBean('beanFeed').setBeanClass(variables.beanClass).setTable(getTable());
	
		if(hasProperty('siteid')){
			feed.setSiteID(getValue('siteID'));
		}

		return feed;
		
	}

	function getIterator(){		
		return getBean('beanIterator').setBeanClass(variables.beanClass);
	}

}