comparing
hash
	^ self class hash bitXor:
	( x hash bitXor:
	( y hash bitXor:
	( z hash bitXor:
	  w hash)))