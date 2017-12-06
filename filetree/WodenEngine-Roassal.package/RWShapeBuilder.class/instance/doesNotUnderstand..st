reflective operations
doesNotUnderstand: aMessage
	"we simply forward the messages we do not understand
	to the actual shape implementation"
	self shape 
		perform: aMessage selector 
		withArguments: aMessage arguments