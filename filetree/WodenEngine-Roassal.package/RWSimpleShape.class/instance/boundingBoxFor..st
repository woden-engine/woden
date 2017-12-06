computing
boundingBoxFor: element
	| hw hh hd |
	hw := (self widthFor: element) * 0.5.
	hh := (self heightFor: element) * 0.5.
	hd := (self depthFor: element) * 0.5.
	^ WMBox3DF
		nx: hw negated ny: hh negated nz: hd negated
		px: hw py: hh pz: hd