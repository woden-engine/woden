rendering process stages
updateForDeltaMicroseconds: microsecondsDelta
	super updateForDeltaMicroseconds: microsecondsDelta.
	deltaTimeBlock ifNotNil: [ deltaTimeBlock value: microsecondsDelta * 1e-6 ]