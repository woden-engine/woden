accessing
pointEntity: anObject
	pointEntity := anObject.
	pointEntity ifTrue: [ self createPointEntityNode ] ifFalse: [ self deletePointEntityNode ]