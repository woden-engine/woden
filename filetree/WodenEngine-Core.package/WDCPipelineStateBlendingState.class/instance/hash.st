comparing
hash
	^ enabled hash bitXor:
	( targetMask hash bitXor:
	( sourceFactor hash bitXor:
	( destFactor hash bitXor:
	( operation hash bitXor:
	( sourceAlphaFactor hash bitXor:
	( destAlphaFactor hash bitXor:
	( alphaOperation hash)))))))