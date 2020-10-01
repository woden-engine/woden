Extension { #name : #SysmelStructureType }

{ #category : #'*WodenEngine-Core' }
SysmelStructureType class >> wodenPoolBufferHeapSize [
	^ (1<<16) // self instanceSize
]
