accessing
attributes
	^ super attributes ==> [ :tokens | { tokens first } , (tokens second collect: #second) ]