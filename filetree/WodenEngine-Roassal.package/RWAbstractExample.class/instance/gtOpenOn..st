instance creation
gtOpenOn: v
	|  icon64Mime form element  |

	self gtExamples do: [ :anExample |
		icon64Mime := self perform: (anExample method selector, #Icon) asSymbol.
		form := TRPlatform current formClass fromBinaryStream: 
							(TRPlatform current mimeDecodeToBytes: icon64Mime readStream).
		element := (RTBitmap new form: form) elementOn: anExample.
		element @ (RTPopup new text: anExample method selector asString).
		element @ (RTEventForwarder new eventClass: TRMouseDragging). 
		v add: element ].

	RTGridLayout new on: v elements.
	