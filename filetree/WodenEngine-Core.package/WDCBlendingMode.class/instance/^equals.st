comparing
= other
	^ self class == other class and:
	[ enabled = other enabled and:
	[ sourceFactor = other sourceFactor and:
	[ destFactor = other destFactor and:
	[ operation = other operation and:
	[ sourceAlphaFactor = other sourceAlphaFactor and:
	[ destAlphaFactor = other destAlphaFactor and:
	[ alphaOperation = other alphaOperation]]]]]]]