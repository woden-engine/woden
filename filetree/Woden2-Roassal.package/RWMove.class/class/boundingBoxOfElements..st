as yet unclassified
boundingBoxOfElements: aCollection
	| bbox |
	bbox := WMBox3DF new.
	aCollection do: [ :each | bbox insertBox: each boundingBox ].
	^ bbox