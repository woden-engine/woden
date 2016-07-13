initialization
initialize
	super initialize.
	faces := #().
	positions := NativeOrderedCollection for: WMVector3D.
	boundingBox := WMBox3DD empty.