comparing
hash
	^ self class hash bitXor:
		(firstIndex hash bitXor:
		(indexCount hash bitXor:
		(material hash bitXor:
		 primitiveType hash)))