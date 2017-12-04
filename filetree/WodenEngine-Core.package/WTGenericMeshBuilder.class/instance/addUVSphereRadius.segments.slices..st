adding
addUVSphereRadius: radius segments: segments slices: slices
	| normal position texcoord phi theta x y z firstRow secondRow firstSlice secondSlice |
	self beginTriangles.

	"Add the vertices"
	(0 to: segments - 1) do: [ :segment |
		phi := (Float pi * segment) / (segments - 1).
		
		(0 to: slices - 1) do: [ :slice |
			theta := (Float twoPi  * slice) / (slices - 1).
			x := (theta cos) * (phi sin ).
			y := (theta sin) * (phi sin ).
			z := phi cos.
			normal := WMVector3F x: x y: y z: z.
			position := WMVector3F x: (x * radius) y: (y * radius) z: (z * radius).			
			texcoord := WMVector2F x: theta / Float twoPi y: phi / Float pi.
			self addP: position N: normal  TC: texcoord.
		].		
	].

	"Add the quads"
	(0 to: segments - 2) do: [ :segment |
		firstRow := segment*slices.
		secondRow := (segment+1)*slices.
		(0 to: slices - 1) do: [ :slice |
			firstSlice := slice + 1.
			secondSlice := (slice + 1) % slices + 1.
			self addQuadI1: firstRow + secondSlice i2: firstRow+firstSlice i3: secondRow+firstSlice i4: secondRow+secondSlice
		]
	].
