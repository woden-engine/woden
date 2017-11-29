as yet unclassified
compileScript: aSourceCode
	^ Smalltalk compiler
		class: WTGSBehavior;
		compile: aSourceCode