event handling
onClickEvent: anEvent
	| np |
	np := self normalizedPosition: (self globalPointToLocal: anEvent position).
	Transcript show: np; cr.