as yet unclassified
initialize
	"
	self initialize.
	"
	super initialize.
	BlendVariantNames := OrderedCollection newFrom: #(
		('.blend.replace' replace)
		('.blend.alpha-over' alphaOver)
	).