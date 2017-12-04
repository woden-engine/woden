initialization
initialize
	super initialize.
	faces := #().
	positions := SLVMNativeOrderedCollection for: WMVector3D.
	color := self generateColor.
	boundingBox := WMBox3DD empty.