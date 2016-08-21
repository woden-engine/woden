snapping
snapBox: box
	^ WMBox3DD min: (self snapTranslation: box min) max: (self snapTranslation: box max)