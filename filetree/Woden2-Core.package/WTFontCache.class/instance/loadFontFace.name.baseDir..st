as yet unclassified
loadFontFace: faceData name: faceName baseDir: baseDir
	faceData at: 'file' ifPresent: [ :filename |^ self loadFontFaceNamed: faceName fromFile: baseDir / filename ].
	^ nil.