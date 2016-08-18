accessing
extent: newExtent
	| oldExtent |
	oldExtent := self extent.
	super extent: newExtent.
	
	(oldExtent ~= newExtent and: [ osWindowRenderer isNotNil ]) ifTrue: [ 
		osWindow extent  ~= newExtent ifTrue: [ osWindow extent: newExtent ].
		screenForm := Form extent: self extent depth: 32.
		osWindowRenderer form: screenForm.
	].