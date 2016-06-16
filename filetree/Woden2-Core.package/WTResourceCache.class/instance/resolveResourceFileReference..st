private
resolveResourceFileReference: aFileName
	| fileReference solvedReference |
	fileReference := aFileName asFileReference.
	fileReference exists ifTrue: [ ^ fileReference asAbsolute ].
	engine assetSearchPaths do: [ :searchPath |
		solvedReference := searchPath resolve: fileReference.
		solvedReference exists ifTrue: [ ^ solvedReference asAbsolute ]
	].

	self error: 'Failed to solve resource path ', aFileName printString
