as yet unclassified
loadFontsFromFile: fontFileName
	| baseDir fontsJson |
	baseDir := fontFileName asFileReference parent.
	fontsJson := self readJsonFromFile: fontFileName.
	
	fontsJson at: 'include' ifPresent: [ :include |
		include keysAndValuesDo: [ :key :value |
			self loadFontsFromFile: (baseDir / value) fullName.
		]
	].

	fontsJson at: 'fonts' ifPresent: [ :fontsData |
		fontsData keysAndValuesDo: [ :fontName :fontData |
			self loadFont: fontData name: fontName baseDir: baseDir
		]
	].

	fontsJson at: 'default-font' ifPresent: [ :fontName | default := fonts at: fontName ].
	fontsJson at: 'default-mono-font' ifPresent: [ :fontName | defaultMono := fonts at: fontName ].
	fontsJson at: 'default-sans-font' ifPresent: [ :fontName | defaultSans := fonts at: fontName ].
	fontsJson at: 'default-serif-font' ifPresent: [ :fontName | defaultSerif := fonts at: fontName ].
