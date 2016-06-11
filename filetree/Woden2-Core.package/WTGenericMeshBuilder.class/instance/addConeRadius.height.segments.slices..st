adding
addConeRadius: baseRadius height: height segments: segments slices: slices
	| normal position texcoord radius phi x y z firstRow secondRow firstSlice secondSlice |
	self beginTriangles.
	"Add the vertices"
	(0 to: segments - 1) do: [ :segment |
		y := (height*(segment/(segments - 1))) - (height*0.5).
		radius := baseRadius*(segments - 1 - segment)/(segments - 1).
				
		(0 to: slices - 1) do: [ :slice |
			phi := (Float twoPi  * slice) / (slices - 1).
			x := phi cos.
			z := phi sin.
			position := (WMVector3F x: x * radius y: y z: z * radius).
			normal := WMVector3F x: x y: 0.0 z: z.
			texcoord := WMVector2F x: phi / Float twoPi y: (segment/(segments - 1)) asFloat.
			self addP: position N: normal TC: texcoord.
		].		
	].

	"Add the quads"
	(0 to: segments - 2) do: [ :segment |
		firstRow := segment*slices.
		secondRow := (segment+1)*slices.
		(0 to: slices - 1) do: [ :slice |
			firstSlice := slice + 1.
			secondSlice := (slice + 1) % slices + 1.
			self addQuadI1: firstRow + secondSlice i2: firstRow+firstSlice i3: secondRow+firstSlice i4: secondRow+secondSlice.
		]
	].

	"Add the caps"
	self addCircleCenter: (WMVector3F x: 0.0 y: height * -0.5 z: 0.0) radius: radius slices: slices isTop: false.
