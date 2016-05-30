accessing
pointer: newPointer size: newSize
	pointer := newPointer.
	size := newSize.
	(data isNil and: [ data size ~= newSize ]) ifTrue: [ data := nil ].
	BufferRegistry add: self.