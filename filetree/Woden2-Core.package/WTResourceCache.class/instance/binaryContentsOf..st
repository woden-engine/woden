resource loading
binaryContentsOf: aFileReference
	^ aFileReference readStreamDo: [ :in |
		^ in binary; upToEnd
	]