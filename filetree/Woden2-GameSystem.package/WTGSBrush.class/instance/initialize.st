initialization
initialize
	super initialize.
	faces := #().
	positions := NativeOrderedCollection for: WMVector3D.
	color := self generateColor.
	boundingBox := WMBox3DD empty.