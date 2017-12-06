initialization
initialize
	Replace := self sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ZERO.
	AlphaOver := self sourceFactor: AGPU_BLENDING_SRC_ALPHA destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA.
	Add := self sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ONE.
	AddAlpha := self sourceFactor: AGPU_BLENDING_SRC_ALPHA destFactor: AGPU_BLENDING_ONE.