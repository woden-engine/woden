class initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	OpaqueTransparencyMode := WDRenderer blendingReplace.
	AdditiveTransparencyMode := WDRenderer blendingAdditive.
	AdditiveAlphaTransparencyMode := WDRenderer blendingAdditiveAlpha.
	AlphaOverTransparencyMode := WDRenderer blendingOver.