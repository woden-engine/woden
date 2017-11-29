private
resolveResourceFileReference: aFileName
	^ self resolveResourceFileReference: aFileName ifFailed: [
		self error: 'Failed to solve resource path ', aFileName printString
	]