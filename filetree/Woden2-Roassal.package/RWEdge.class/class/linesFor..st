constructions
linesFor: aCollectionOfAssociations
	^ aCollectionOfAssociations collect: [ :assoc | RWLine black elementFrom: assoc key to: assoc value ]