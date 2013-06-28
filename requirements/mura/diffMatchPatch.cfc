component {
	
	function init(){
		variables.diff_match_patch = application.serviceFactory.getBean('javaLoader').create("name.fraser.neil.plaintext.diff_match_patch");
		return this;
	}

	function compute(String text1, String text2, type ="diff_main") {
		var diffOb = evaluate('variables.diff_match_patch.#type#(arguments.text1,arguments.text2)');
		
		variables.diff_match_patch.diff_cleanupSemantic(diffOb);
		
		var returnStruct = {
			diff = diffOb,
			html = variables.diff_match_patch.diff_prettyHtml(diffOb),
			text1 = variables.diff_match_patch.diff_text1(diffOb),
			text2 = variables.diff_match_patch.diff_text2(diffOb)
		};
			
		return returnStruct;
	}

}