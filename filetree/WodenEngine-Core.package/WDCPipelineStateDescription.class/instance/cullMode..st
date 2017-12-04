accessing
cullMode: newCullMode
	cullMode ~= newCullMode ifTrue: [ self changed ].
	cullMode := newCullMode