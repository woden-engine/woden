state loading
loadPipelineStatesFromFile: aFileName prefix: aStateNamePrefix
	| statesJson baseDir |
	baseDir := aFileName asFileReference parent.
	statesJson := self readJsonFromFile: aFileName.
	statesJson at: 'states' ifPresent: [ :statesDesc |
		statesDesc keysAndValuesDo: [ :name :stateDesc |
			self loadNamed: (aStateNamePrefix , name) asSymbol pipelineState: stateDesc scope: aStateNamePrefix baseDir: baseDir
		]
	].

	statesJson at: 'groups' ifPresent: [ :groups |
		groups keysAndValuesDo: [ :newPrefix :fileName |
			self loadPipelineStatesFromFile: (baseDir / fileName) fullName prefix: aStateNamePrefix , newPrefix , '.'
		]
	]