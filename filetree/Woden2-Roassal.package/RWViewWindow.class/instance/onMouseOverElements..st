event handling
onMouseOverElements: event
	| elementBeingPointed leave enter move |
	elementBeingPointed := self elementInPosition: event position.
	mouseFocusElement ~~ elementBeingPointed ifTrue: [
		leave := RWMouseLeave new.
		leave element: mouseFocusElement;
			position: event position;
			sendToElement.

		enter := RWMouseEnter new.
		enter element: elementBeingPointed;
			position: event position;
			sendToElement.
		mouseFocusElement := elementBeingPointed.
	] ifFalse: [
		move := RWMouseMove new.
		move element: mouseFocusElement;
			position: event position;
			delta: event delta;
			sendToElement.
	].
	view signalUpdate