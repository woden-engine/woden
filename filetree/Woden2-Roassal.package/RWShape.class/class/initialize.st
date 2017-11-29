class initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	OpaqueTransparencyMode := #blendingReplace.
	AdditiveTransparencyMode := #blendingAdditive.
	AdditiveAlphaTransparencyMode := #blendingAdditiveAlpha.
	AlphaOverTransparencyMode := #blendingOver.