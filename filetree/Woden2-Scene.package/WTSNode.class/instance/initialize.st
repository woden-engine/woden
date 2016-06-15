initialization
initialize
	super initialize.
	transform := WMReversibleAffineTransformF identity.
	children := OrderedCollection new.
	visible := true.