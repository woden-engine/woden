change reporting
invalidRect: damageRect from: aMorph
	self recordDamagedRect: (damageRect intersect: self bounds ifNone: [ ^ self ])