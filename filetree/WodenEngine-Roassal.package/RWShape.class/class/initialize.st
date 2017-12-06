class initialization
initialize
	"
	self initialize
	"
	super initialize.
	
	OpaqueTransparencyMode := WDCBlendingMode replace.
	AdditiveTransparencyMode := WDCBlendingMode add.
	AdditiveAlphaTransparencyMode := WDCBlendingMode addAlpha.
	AlphaOverTransparencyMode := WDCBlendingMode alphaOver.