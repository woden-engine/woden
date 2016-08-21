render thread
renderThreadCycle
	| priorActiveHand |
	priorActiveHand := ActiveHand.
	ActiveHand := hand.
	[
		self doSafely: [ self runLocalStepMethods ].
		needsRendering == true ifTrue: [
			self doSafely: [ self render ].
		].
	] ensure: [ ActiveHand := priorActiveHand ].

	(Delay forMilliseconds: 10) wait.
