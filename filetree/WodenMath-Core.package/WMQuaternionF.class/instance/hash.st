comparing
hash
	^ self class hash bitXor:
	( r hash bitXor:
	( i hash bitXor:
	( j hash bitXor:
	( k hash ))))