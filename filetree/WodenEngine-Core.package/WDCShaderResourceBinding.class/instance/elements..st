accessing
elements: numberOfElements
	self flag: 'Pass an actual descriptor of the elements'.
	slots := Array new: numberOfElements.
	slotActions := Array new: numberOfElements.