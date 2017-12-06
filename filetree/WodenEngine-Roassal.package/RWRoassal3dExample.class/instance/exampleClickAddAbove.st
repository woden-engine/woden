sources
exampleClickAddAbove

	| v e cube position action |
	cube := RWCube new.
	v := RWView new.
	action := nil.
	action := [ :ev |
			position := ev element position.
			position y: position y + 1.05. 
			e := cube element.
			e translateTo: position;
				when: RWMouseButtonDown do: action.
			v add: e
	].
	
	1 to: 1024 do: [ :i |
		e := cube element.
		e when: RWMouseButtonDown do: action.
		v add: e.
	].
	(RWXZGridLayout gap: 0.05) on: v elements.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WMVector3F x: 0.0 y: 3.0 z: 0.0).
^ v