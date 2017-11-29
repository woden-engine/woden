as yet unclassified
createRadialGradient: colorRamp center: aCenter radius: aRadius focalPoint: focalPoint
	^ WTAthensRadialGradientPaint 
		colorRamp: colorRamp 
		center: aCenter 
		focalPoint: focalPoint
		radius: aRadius
	