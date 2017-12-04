rendering
texturedModelFor: anEngine
	(texturedModelBuilder isNil or: [ texturedModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidTexturedModel := true.
		self createTexturedModelBuilderFor: anEngine.
	].

	invalidTexturedModel ifFalse: [ ^ texturedModel ].
	^ self createTexturedModel