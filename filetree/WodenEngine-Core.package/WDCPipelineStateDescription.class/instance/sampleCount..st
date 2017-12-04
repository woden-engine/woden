accessing
sampleCount: newSampleCount
	newSampleCount ~= sampleCount ifTrue: [ self changed ].
	sampleCount := newSampleCount