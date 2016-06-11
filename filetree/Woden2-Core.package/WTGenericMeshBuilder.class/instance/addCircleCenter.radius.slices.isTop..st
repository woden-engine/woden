adding
addCircleCenter: center radius: radius slices: slices isTop: isTop
	| normal position phi x z firstSlice secondSlice|
	self beginTriangles.
	
	isTop ifTrue: [ normal := WMVector3F x: 0.0 y: 1.0 z: 0.0 ] ifFalse: [ normal := WMVector3F x: 0.0 y: -1.0 z: 0.0 ].
	self addP: center N: normal TC: (WMVector2F x: 0.0 y: 0.0).
	
	0 to: (slices - 1) do: [ :slice |
			firstSlice := slice + 2.
			secondSlice := (slice + 1) % slices + 2.
			phi := (Float twoPi  * slice) / (slices - 1).
			x := phi cos * radius.
			z := phi sin * radius.
			position := center + (WMVector3F x: x y: 0.0 z: z).
			self addP: position N: normal TC: (WMVector2F x: x y: z).
			isTop ifTrue: [
				self addI1: firstSlice i2: 1 i3: secondSlice .
			] ifFalse: [ 
				self addI1: secondSlice i2: 1 i3: firstSlice .
			]
	].