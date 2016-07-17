as yet unclassified
snapTranslation: translation
	^ WMVector3D
		x: (self roundToGrid: translation x)
		y: (self roundToGrid: translation y)
		z: (self roundToGrid: translation z)