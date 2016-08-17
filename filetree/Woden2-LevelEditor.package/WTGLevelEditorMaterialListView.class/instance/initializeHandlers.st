initialize-release
initializeHandlers
	self
		addEventHandler: (BlEventHandler on: BlMouseEnterEvent do: [ :evt | 
			evt consumed: true.
			self requestFocus.
		]);
		addEventHandler: (BlEventHandler on: BlMouseLeaveEvent do: [ :evt | 
			evt consumed: true.
			highlightedCell := nil.
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
		addEventHandler: (BlEventHandler on: BlScrollEvent do: [ :evt | 
			evt consumed: true.
			self onScrollEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlKeyDownEvent do: [ :evt | 
			evt consumed: true.
			self onKeyDownEvent: evt.
		])