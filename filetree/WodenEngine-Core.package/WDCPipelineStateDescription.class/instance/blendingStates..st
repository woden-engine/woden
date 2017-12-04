accessing
blendingStates: newBlendingStates
	blendingStates ~= newBlendingStates ifTrue: [ self changed ].
	blendingStates := newBlendingStates