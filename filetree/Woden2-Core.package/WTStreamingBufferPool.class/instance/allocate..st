instance creation
allocate: numberOfElements
	^ (1 to: numberOfElements) collect: [:i | self allocate]