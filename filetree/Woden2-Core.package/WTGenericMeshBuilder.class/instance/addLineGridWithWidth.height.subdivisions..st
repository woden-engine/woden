adding
addLineGridWithWidth: width height: height subdivisions: subdivisions
	| dx dy x y px py nx ny tc  |
	
	"Add vertices"
	dx := width / (subdivisions - 1).
	dy := height / (subdivisions - 1).
	px := width * 0.5.
	py := height * 0.5.
	nx := px negated.
	ny := py negated.
	tc := WMVector2F new.
	x := nx.
	
	"Vertical lines"
	self beginLines.
	1 to: subdivisions do: [:i |
		self addP: (WMVector3F x: x y: ny z: 0.0) TC: tc.
		self addP: (WMVector3F x: x y: py z: 0.0) TC: tc.
		self addI1: i*2 - 1 i2: i*2.
		x := x + dx.
	].

	"Horizontal lines"
	self beginLines.
	y := ny.
	1 to: subdivisions do: [:i |
		self addP: (WMVector3F x: nx y: y z: 0.0) TC: tc.
		self addP: (WMVector3F x: px y: y z: 0.0) TC: tc.
		self addI1: i*2 - 1 i2: i*2.
		y := y + dy.
	].
