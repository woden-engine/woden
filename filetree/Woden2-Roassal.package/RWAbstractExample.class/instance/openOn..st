instance creation
openOn: v

	| exampleSymbols icon64Mime form element  helpBar |

	exampleSymbols := self class selectors 
								select: [ :symbol | (symbol beginsWith: 'example') 
															and: [ (symbol endsWith: 'Icon') not ] ].
	exampleSymbols do: [ :k |
		icon64Mime := self perform: (k, #Icon) asSymbol.
		form := TRPlatform current formClass fromBinaryStream: 
							(TRPlatform current mimeDecodeToBytes: icon64Mime readStream).
		element := (RTBitmap new form: form) element.
		element @ (RTPopup new text: k asString).
		element when: TRMouseLeftClick do: [ :evt | self class new perform: k ].
		element when: TRMouseRightClick do: [ :evt | (self class >> k) browse ].
		element @ (RTEventForwarder new eventClass: TRMouseDragging). 
		v add: element.
	].

	RTGridLayout new on: v elements.
	
	v canvas addMenu: 'back' callback: [ self pressedBackButtonOn: v ].
	helpBar := TRLabelShape new text: ' Left to run / Right for code'.
	v canvas addFixedShape: helpBar.
	TRConstraint stickAtTheBottomOfTheWindow: helpBar.
	