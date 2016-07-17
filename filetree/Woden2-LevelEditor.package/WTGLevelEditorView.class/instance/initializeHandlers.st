event handling
initializeHandlers
	self
		addEventHandler: (BlEventHandler on: BlMouseEnterEvent do: [ :evt | 
			evt consumed: true.
			self requestFocus.
		]);
		addEventHandler: (BlEventHandler on: BlClickEvent do: [ :evt | 
			evt consumed: true.
			self onClickEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDblClickEvent do: [ :evt | 
			evt consumed: true.
			self onDoubleClickEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlMouseMoveEvent do: [ :evt | 
			self onMouseMoveEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDragStartEvent do: [ :evt | 
			evt consumed: true.
			self onDragStartEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDragEvent do: [ :evt | 
			evt consumed: true.
			self onDragEvent: evt.
		]);	
		addEventHandler: (BlEventHandler on: BlDragEndEvent do: [ :evt | 
			evt consumed: true.
			self onDragEndEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlTextInputEvent do: [ :evt | 
			evt consumed: true.
			self onTextInput: evt.
		]);
		addEventHandler: (BlEventHandler on: BlKeyDownEvent do: [ :evt | 
			evt consumed: true.
			self onKeyDownEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlKeyUpEvent do: [ :evt | 
			evt consumed: true.
			self onKeyUpEvent: evt.
		])
