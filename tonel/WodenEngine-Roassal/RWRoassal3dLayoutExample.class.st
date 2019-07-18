"
RWRoassal3dLayoutExample new installTitle: 'Circle' 
		code:
		'
	| v  |
	v := RWView new.
	1 to: 10 do: [ :i |
		v add: RWCube element.
	].

	RWCircleLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	
^ v'
	
"
Class {
	#name : #RWRoassal3dLayoutExample,
	#superclass : #RWAbstractExample,
	#category : 'WodenEngine-Roassal-Examples'
}

{ #category : #sources }
RWRoassal3dLayoutExample >> exampleCircle [

	| v  |
	v := RWView new.
	1 to: 10 do: [ :i |
		v add: RWCube element.
	].

	RWCircleLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	
^ v
]

{ #category : #icons }
RWRoassal3dLayoutExample >> exampleCircleIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAAwCAYAAADn/d+1AAABWklEQVR4XuXcwbGCMBCAYfqg
EAphqCMH2kglKYw2oqsXh0myyQYc4HfmP72Rh/t5MdEM70fMta5r3LZNzTmXrHTtOzdNU/L1
hhCq5qVcP//HZVk+/0SLD/LNe181LzOINI5jnOc5O/RSNBAteV7F9etuwgLDB2mCaAOxwNBB
GiFsIC03RQWRN6y8cY3XHyK/S8UfAh+EHx+ED8KPD8IH4ccH4YPw44PwQfjxQfjxQe6RbNOW
Mi4h88tsXcgubGneg3W/XKA6lpgfncwmt2ek7bubQTo2YB5faWZ8ED4IPz4IH4QPwgfhg/BB
Lgsig9/HH7z+IXA/M/lsooLwh8dfy+LHB+GD8OOD8EH48UH4IPz4IHwQ/hD4IPz4IHwQfn8H
Sa0CE1aEUyu5v3V+G8d2Q/yfRTv1l7ing7QeHsA/OMC0iXfOKQ58EDPMOeec8EHMMPzjmY4C
OeJ4phdPoJZCghvuoAAAAABJRU5ErkJggg=='
]

{ #category : #sources }
RWRoassal3dLayoutExample >> exampleCube [

| v  |
	v := RWView new.
	1 to: 1000 do: [ :i |
		v add: RWCube element.
	].

	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	RWCubeLayout on: v elements.

	v addInteraction: RWMouseKeyControl.
	
^ v
]

{ #category : #icons }
RWRoassal3dLayoutExample >> exampleCubeIcon [
	^ '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
AAAASUVORK5CYII='
]

{ #category : #sources }
RWRoassal3dLayoutExample >> exampleForceBasedLayout [
	<script: 'self new exampleForceBasedLayout'>
	| v boxes |
	v := RWView new.
	boxes := RWCube new
		size: 10;
		elementsOn: (1 to: 20).
	RWEdgeBuilder new
		view: v;
		elements: boxes;
		connectFrom: [ :value | value // 2 ] to: #yourself.
	v addAll: boxes.
	RWForceBasedLayout2D on: boxes.
	v addInteraction: RWOrbitController.
	v open.
]

{ #category : #accessing }
RWRoassal3dLayoutExample >> label [
	^ 'Roassal 3d layouts'
]
