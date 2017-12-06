sources
exampleClickLeds

	| v e colors cube |
	colors := {  Color gray . Color red . Color green . Color blue . Color yellow . Color white}.
	cube := RWCube new.
	cube color: [ :val | colors at: val ].
	
	v := RWView new.
	
	1 to: 1024 do: [ :i |
		e := cube elementOn: 1.
		e when: RWMouseButtonDown do: [ :ev |
			ev element model: ev element model + 1.
			ev element model > colors size ifTrue: [ ev element model: 1 ].
			ev element changed.
		].
		e when: RWMouseButtonUp do: [ :ev |
			ev element model: ev element model + 1.
			ev element model > colors size ifTrue: [ ev element model: 1 ].
			ev element changed.
		].

		v add: e.
	].
	(RWXZGridLayout gap: 0.05) on: v elements.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WMVector3F x: 0.0 y: 3.0 z: 0.0).

^ v