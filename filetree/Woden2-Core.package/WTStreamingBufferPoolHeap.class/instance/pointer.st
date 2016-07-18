accessing
pointer
	^ pointer ifNil: [ pointer := buffer validPointer getHandle ]