public
elementsOn: objects
	^ (objects collect: [ :o | self elementOn: o ]) asRWGroup