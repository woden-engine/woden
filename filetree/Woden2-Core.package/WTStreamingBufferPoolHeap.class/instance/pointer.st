accessing
pointer
	^ pointer ifNil: [ pointer := self buffer validPointer getHandle ]