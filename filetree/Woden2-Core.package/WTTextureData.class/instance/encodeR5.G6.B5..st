converting
encodeR5: r G6: g B5: b
	^ ((r bitAnd: 31) << 11) | ((g bitAnd: 63) << 11) | (b bitAnd: 31)