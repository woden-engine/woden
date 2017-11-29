hooks
initializeFirstTimeElement: element
	element when: RWMouseRightButtonDown do: [ :event |
		TRUtil instance widgetFactory menuForAssociations: actions on: element
	]