clipping
subtract: brush into: aCollection
	| remaining clipResult |
	(brush containsBrush: self) ifTrue: [ ^ self ].
	
	remaining := self.
	brush faces do: [ :face |
		(self intersectsWithFaceProperly: face) ifTrue: [
			clipResult := remaining clipWithPlane: face plane material: face material.
			clipResult ifNotNil: [ 
				aCollection add: clipResult second.
				remaining := clipResult first.
			]
		]
	].

	"Check if nothing was subtracted from me"
	aCollection ifEmpty: [ aCollection add: self ].
	