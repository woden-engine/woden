as yet unclassified
compileScript: aSourceCode
	^ Smalltalk compiler
		class: WTGSBehaviorScriptClass new;
		noPattern: true;
		compile: aSourceCode