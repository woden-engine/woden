initialization
initialize
	super initialize.
	elements := OrderedCollection new.
	maxBindings := self class defaultMaxBindings.
	totalBindingPointCount := 0.