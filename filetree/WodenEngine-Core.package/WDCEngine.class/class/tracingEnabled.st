accessing
tracingEnabled
	^ TracingEnabled ifNil: [ TracingEnabled := false ]