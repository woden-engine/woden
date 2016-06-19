as yet unclassified
createLinearGradient: aColorRamp start: aStartPoint stop: aStopPoint
	^ WTAthensLinearGradientPaint 
		colorRamp: aColorRamp 
		start: aStartPoint 
		stop: aStopPoint
	