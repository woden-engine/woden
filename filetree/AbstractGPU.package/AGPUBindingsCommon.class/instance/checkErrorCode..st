as yet unclassified
checkErrorCode: errorCode
	errorCode < 0 ifTrue: [ 
		Transcript show: 'Got an error from AGPU: ' , errorCode printString; cr.
		self error: 'Got an error from AGPU.'
	]