adding
addGridWithWidth: width height: height subdivisions: subdivisions
	| dx dy sx sy x y s t rs rd|
	self beginTriangles.
	
	"Add vertices"
	dx := width / (subdivisions - 1).
	dy := height / (subdivisions - 1).
	sx := width * -0.5.
	sy := height * -0.5.
	y := sy.
	1 to: subdivisions do: [:j |
		x := sx.
		t := (j - 1) / (subdivisions - 1) asFloat.
		1 to: subdivisions do: [:i |
			s := (i - 1) / (subdivisions - 1) asFloat.
			self addP: (WMVector3F x: x y: 0.0 z: y) N: (WMVector3F x: 0.0 y: 1.0 z: 0.0) TC: (WMVector2F x: s y: t).
			x := x + dx.
		].
	
		y := y + dy.
	] .

	"Add quads"
	1 to: (subdivisions - 1) do: [:j |
		rs := j * subdivisions - subdivisions.
		rd := (j + 1) * subdivisions - subdivisions.
		
		1 to: (subdivisions - 1) do: [:i |
			self addI1: rd + i + 1 i2: rs + i + 1 i3: rs + i;
				addI1: rs + i i2: rd + i i3: rd + i + 1
		].
	].
