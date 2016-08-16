accessing
boundingBox
	"Return the bounding box of the view"
	| aBox |
	elements isEmpty ifTrue: [ ^ WDAABox zero ].
	
	aBox := WDAABox new.
	elements do: [ :e | aBox addBox: e boundingBox ].
	^ aBox