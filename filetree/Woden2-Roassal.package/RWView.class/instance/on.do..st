interaction
on: anEvent do: aBlock
	self deprecated: 'Please use when:do: instead of on:do'.
	eventHandler when: anEvent do: aBlock.