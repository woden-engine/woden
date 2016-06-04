as yet unclassified
initialize
	"
	self initialize.
	"
	super initialize.
	BlendVariantNames := OrderedCollection newFrom: #(
		('.blend.add' add)
		('.blend.clear' clear)
		('.blend.dest' dest)
		('.blend.dest-over' destOver)
		('.blend.multiply' multiply)
		('.blend.over' over)
		('.blend.source' source)
	).