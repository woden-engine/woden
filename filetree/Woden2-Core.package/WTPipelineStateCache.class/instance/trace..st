tracing
trace: aString
	self class tracingEnabled ifFalse: [ ^ self ].
	Transcript show: aString; cr.
	FileStream stdout nextPutAll: aString; lf