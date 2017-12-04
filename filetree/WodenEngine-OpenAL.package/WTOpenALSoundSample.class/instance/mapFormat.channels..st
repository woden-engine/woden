as yet unclassified
mapFormat: format channels: channels
	channels = 1 ifTrue: [ 
		format == #byte ifTrue: [ ^ AL_FORMAT_MONO8 ].
		format == #short ifTrue: [ ^ AL_FORMAT_MONO16 ].
	].
	channels = 2 ifTrue: [ 
		format == #byte ifTrue: [ ^ AL_FORMAT_STEREO8 ].
		format == #short ifTrue: [ ^ AL_FORMAT_STEREO16 ].
	].
	self error: 'Unsupported sound format.'.
