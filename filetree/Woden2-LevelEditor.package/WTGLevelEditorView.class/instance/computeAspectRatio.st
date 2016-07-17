as yet unclassified
computeAspectRatio
	| myExtent |
	myExtent := self innerBounds extent.
	(myExtent y asFloat closeTo: 0.0) ifTrue: [ ^ 1.0 ].
	^ myExtent x asFloat / myExtent y asFloat