as yet unclassified
cubeSize: size
	| hsize |
	hsize := size * 0.5.
	^ (self faces: { 
		WTGSBrushFace nx: -1.0 ny: 0.0 nz: 0.0 d: hsize . "Left"
		WTGSBrushFace nx: 1.0 ny: 0.0 nz: 0.0 d: hsize . "Right"
		WTGSBrushFace nx: 0.0 ny: -1.0 nz: 0.0 d: hsize . "Bottom"
		WTGSBrushFace nx: 0.0 ny: 1.0 nz: 0.0 d: hsize . "Top"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: -1.0 d: hsize . "Front"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: 1.0 d: hsize . "Back"
	}) triangulate