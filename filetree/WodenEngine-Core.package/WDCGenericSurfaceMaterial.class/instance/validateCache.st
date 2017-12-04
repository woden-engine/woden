state binding
validateCache
	(vertexShader isNil or: [fragmentShader isNil]) ifTrue: [ self fetchShaders ].
	resourceBindingsAreUpdated ifFalse: [ self bindResources ].
	resourceBindingsAreUpdated := true.