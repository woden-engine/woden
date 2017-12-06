public normalize color
distinctColorUsing: aBlockOrSymbol
	"Give a color to each element according to the result of execution the block and symbol on each element.

	For example, the following example paints all the class according to the package the class is in:
	| b |
	b := RTMondrian new.
	b shape circle.
	b nodes: Collection withAllSubclasses.
	b edges connectFrom: #superclass.
	b layout tree.
	b normalizer
		normalizeSize: #numberOfMethods;
		distinctColorUsing: #package.
	b	
	"
	| normalizer allObjects |
	allObjects := elements collect: [ :e | aBlockOrSymbol rtValue: e model ].
	allObjects removeDuplicates.
	
	normalizer := RTMultiLinearColorForIdentity new 
						objects: allObjects; 
						command: aBlockOrSymbol.

	elements do: [ :el | el trachelShape color: (normalizer rtValue: el model) ]