private
resolveResourceFileReference: aFileName ifFailed: aBlock
	| fileReference solvedReference |
	(aFileName isString and: [ aFileName isEmpty ]) ifTrue: [ ^ aBlock value ].

	fileReference := aFileName asFileReference.
	fileReference exists ifTrue: [ ^ fileReference asAbsolute ].
	engine assetSearchPaths do: [ :searchPath |
		solvedReference := searchPath resolve: fileReference.
		solvedReference exists ifTrue: [ ^ solvedReference asAbsolute ]
	].

	aBlock value.