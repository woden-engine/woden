as yet unclassified
intersectsWithBrushProperly: brush
	elements do: [:element |
		(element intersectsWithBrushProperly: brush) ifTrue: [ ^ true ]
	].
	^ false