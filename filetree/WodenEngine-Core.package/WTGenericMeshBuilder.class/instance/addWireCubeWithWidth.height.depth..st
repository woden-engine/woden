adding
addWireCubeWithWidth: width height: height depth: depth
	| px py pz nx ny nz |
	self beginLines.
	
	px := width * 0.5.
	py := height * 0.5.
	pz := depth * 0.5.
	nx := width * -0.5.
	ny := height * -0.5.
	nz := depth * -0.5.
	
	self
		addP: (WMVector3F x: nx y: ny z: nz);
		addP: (WMVector3F x: px y: ny z: nz);
		addP: (WMVector3F x: nx y: py z: nz);
		addP: (WMVector3F x: px y: py z: nz);
		
		addP: (WMVector3F x: nx y: ny z: pz);
		addP: (WMVector3F x: px y: ny z: pz);
		addP: (WMVector3F x: nx y: py z: pz);
		addP: (WMVector3F x: px y: py z: pz).
		
	self
		addI1: 1 i2: 2;
		addI1: 3 i2: 4;
		addI1: 5 i2: 6;
		addI1: 7 i2: 8;
		
		addI1: 1 i2: 3;
		addI1: 2 i2: 4;
		addI1: 5 i2: 7;
		addI1: 6 i2: 8;
	
		addI1: 1 i2: 5;
		addI1: 2 i2: 6;
		addI1: 3 i2: 7;
		addI1: 4 i2: 8.
