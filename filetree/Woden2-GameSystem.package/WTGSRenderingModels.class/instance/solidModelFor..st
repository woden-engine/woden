rendering
solidModelFor: anEngine
	(solidModelBuilder isNil or: [ solidModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidSolidModel := true.
		self createSolidModelBuilderFor: anEngine.
	].

	invalidSolidModel ifFalse: [ ^ solidModel ].
	^ self createSolidModel