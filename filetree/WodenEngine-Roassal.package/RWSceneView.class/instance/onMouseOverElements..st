visiting
onMouseOverElements: event
	| elementBeingPointed leave enter move |
	elementBeingPointed := self elementInPosition: event position.
	self mouseFocusElement ~~ elementBeingPointed ifTrue: [
		leave := RWMouseLeave new.
		leave element: self mouseFocusElement;
			position: event position;
			sendToElement.

		enter := RWMouseEnter new.
		enter element: elementBeingPointed;
			position: event position;
			sendToElement.
		mouseFocusElement := elementBeingPointed.
	] ifFalse: [
		move := RWMouseMove new.
		move element: self mouseFocusElement;
			position: event position;
			delta: event delta;
			sendToElement.
	].
	model signalUpdate