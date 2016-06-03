instance creation
newCanvas
	"Answer a preinitialized instance of AthensCanvas.
	Private to receiver and its subclasses, override seldom"
	^ WTAthensCanvas on: self
