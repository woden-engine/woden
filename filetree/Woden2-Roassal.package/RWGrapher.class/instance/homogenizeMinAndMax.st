as yet unclassified
homogenizeMinAndMax
	
	minX := self minX.
	maxX := self maxX.
	minY := self minY.
	maxY := self maxY.
	minZ := self minZ.
	maxZ := self maxZ.
	datasets do: [ :ds |
		ds minX: minX.
		ds minY: minY.
		ds maxX: maxX.
		ds maxY: maxY.
		ds maxX: maxZ.
		ds maxY: maxZ. ]