rendering
wireModelFor: anEngine
	(wireModelBuilder isNil or: [ wireModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidWireModel := true.
		self createWireModelBuilderFor: anEngine.
	].

	invalidWireModel ifFalse: [ ^ wireModel ].
	^ self createWireModel