tracing
trace: formatString format: formatArgument 
	self class tracingEnabled ifFalse: [ ^ self ].
	self trace: (formatString format: formatArgument)