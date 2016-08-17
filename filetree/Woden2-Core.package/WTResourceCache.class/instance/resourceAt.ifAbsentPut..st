resource loading
resourceAt: name ifAbsentPut: aBlock
	| result |
	"Weak GC can also return nil."
	result := resources at: name ifAbsent: [ nil ].
	result ifNotNil: [ ^ result ].

	result := aBlock value.
	resources at: name put: result.
	^ result