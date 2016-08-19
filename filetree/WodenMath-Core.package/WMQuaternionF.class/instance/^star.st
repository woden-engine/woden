arithmetic
* other
	other isNumber ifTrue: [ ^ self scale: other ] ifFalse: [ ^ self multWithQuaternion: other ]