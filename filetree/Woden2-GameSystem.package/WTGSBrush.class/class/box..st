construction
box: box
	^ (self faces: { 
		WTGSBrushFace nx: -1.0 ny: 0.0 nz: 0.0 d: box min x negated. "Left"
		WTGSBrushFace nx: 1.0 ny: 0.0 nz: 0.0 d: box max x . "Right"
		WTGSBrushFace nx: 0.0 ny: -1.0 nz: 0.0 d: box min y negated. "Bottom"
		WTGSBrushFace nx: 0.0 ny: 1.0 nz: 0.0 d: box max y . "Top"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: -1.0 d: box min z negated. "Front"
		WTGSBrushFace nx: 0.0 ny: 0.0 nz: 1.0 d: box max z . "Back"
	}) triangulate