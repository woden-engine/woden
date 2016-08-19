comparing
hash
	^ self class hash bitXor:
		( m11 hash bitXor:
		( m12 hash bitXor:
		( m21 hash bitXor:
		( m22 hash ))))