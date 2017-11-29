as yet unclassified
ensureCapacityForAtLeast: count keepOldData: keepOldData
	| newCapacity oldCapacity oldBuffer |
	count <= capacity ifTrue: [ ^ self ].
	newCapacity := count asLargerPowerOfTwo.
	oldCapacity := capacity.
	
	"Just set the buffer to nil"
	capacity := newCapacity.
	oldBuffer := buffer.
	buffer := nil.
	
	(keepOldData and: [ oldBuffer isNotNil ]) ifTrue: [ 
		LibC memCopy: oldBuffer validPointer to: self validPointer size: oldCapacity * elementSize
	].
	
	reallocatedAction ifNotNil: [ reallocatedAction value: self ].