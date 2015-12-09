as yet unclassified
checkErrorCode: errorCode
	errorCode < 0 ifTrue: [ 
		self error: 'Got an error from AGPU.'
	]