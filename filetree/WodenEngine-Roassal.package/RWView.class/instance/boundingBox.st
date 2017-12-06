accessing
boundingBox
	"Return the bounding box of the view"
	| aBox |
	elements ifEmpty: [ ^ WMBox3DF new ].
	
	aBox := WMBox3DF new.
	elements do: [ :e | aBox insertBox: e boundingBox ].
	^ aBox