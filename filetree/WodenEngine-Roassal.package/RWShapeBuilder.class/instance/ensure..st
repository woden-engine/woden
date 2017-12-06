exceptions
ensure: aClassShape
	"Make sure the current shape is instance of aClassShapeName. If no, then set it"
	(shape isKindOf: aClassShape)
		ifFalse: [ self shape: aClassShape new ]