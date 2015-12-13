state loading
loadNamed: stateName pipelineState: stateDesc scope: scope baseDir: baseDir
	| state |
	state := WTPipelineState new
		name: stateName;
		scope: scope;
		description: stateDesc;
		isAbstract: (stateDesc at: 'abstract' ifAbsent: false).
		
	pipelineStateObjects at: stateName put: state