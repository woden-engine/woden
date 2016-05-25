pipeline state object building
setPipeline: pipeline blendState: statesDescription
	| renderTargetMask enabled sourceFactor sourceFactorAlpha destFactor destFactorAlpha operation operationAlpha |
	statesDescription do: [ :stateDescription |
		renderTargetMask := stateDescription at: 'render-target-mask'.
		enabled := stateDescription at: 'enabled'.
	
		sourceFactorAlpha := sourceFactor := BlendingFactorNameMap at: (stateDescription at: 'source-factor' ifAbsent: [ #one ]).
		destFactorAlpha := destFactor := BlendingFactorNameMap at: (stateDescription at: 'dest-factor' ifAbsent: [ #zero ]).
		operationAlpha := operation := BlendingOperationNameMap at: (stateDescription at: 'operation' ifAbsent: [ #add ]).

		(stateDescription includesKey: 'source-factor-alpha') ifTrue: [ 
			sourceFactorAlpha := BlendingFactorNameMap at: (stateDescription at: 'source-factor-alpha')
		].

		(stateDescription includesKey: 'dest-factor-alpha') ifTrue: [ 
			destFactorAlpha := BlendingFactorNameMap at: (stateDescription at: 'dest-factor-alpha')
		].

		(stateDescription includesKey: 'operation-alpha') ifTrue: [ 
			operationAlpha := BlendingOperationNameMap at: (stateDescription at: 'operation-alpha')
		].

		pipeline setBlendState: renderTargetMask enabled: enabled.
		pipeline setBlendFunction: renderTargetMask
			sourceFactor: sourceFactor destFactor: destFactor colorOperation: operation
			sourceAlphaFactor: sourceFactorAlpha destAlphaFactor: destFactorAlpha alphaOperation: operationAlpha

	]
