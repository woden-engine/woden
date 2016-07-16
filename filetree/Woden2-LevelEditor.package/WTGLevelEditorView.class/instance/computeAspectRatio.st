as yet unclassified
computeAspectRatio
	(self height asFloat closeTo: 0.0) ifTrue: [ ^ 1.0 ].
	^ self width asFloat / self height asFloat