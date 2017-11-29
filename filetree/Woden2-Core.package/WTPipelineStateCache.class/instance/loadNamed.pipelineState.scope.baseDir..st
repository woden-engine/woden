state loading
loadNamed: stateName pipelineState: stateDesc scope: scope baseDir: baseDir
	| state variantDesc |
	state := WTPipelineState new
		name: stateName;
		scope: scope;
		description: stateDesc;
		isAbstract: (stateDesc at: 'abstract' ifAbsent: false).
		
	pipelineStateObjects at: stateName put: state.
	
	stateDesc at: 'mixin-variants' ifPresent: [ :mixinVariants |
		mixinVariants do: [ :variant |
			variantDesc := Dictionary newFromPairs: {
				'inherit-from' . { stateName . variant }
			}.
			
			self loadNamed: (stateName , '.' , variant) asSymbol pipelineState: variantDesc scope: scope baseDir: baseDir
		]
	].