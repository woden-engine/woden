"
RWRoassal3dExample new installTitle: 'MatrixHandling' 
		code:
		'
| v es |
v := RWView new.
es := RWCube elementsOn: (1 to: 10).
v addAll: es.
RWCubeLayout on: es.

es when: RWMouseButtonDown do: [ :evt |
        | node |
        node := evt element sceneNode.
          node shapeMatrix: (WDMatrix4 scale: 1.1) * (node shapeMatrix )
         ].

^	 v'
	
"
Class {
	#name : #RWRoassal3dExample,
	#superclass : #RWAbstractExample,
	#category : 'WodenEngine-Roassal-Examples'
}

{ #category : #sources }
RWRoassal3dExample >> exampleClickAddAbove [

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
]

{ #category : #icons }
RWRoassal3dExample >> exampleClickAddAboveIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAAwCAYAAADn/d+1AAABH0lEQVR4XuXVDWqDMACA0d3D
g3gQEY/hRfQi/h4xmx3ptmDLLFKavsJHsRrRPpJ8fH2C30vl/wk+iJ8P4oP4+SA+iJ8P4oP4
+SA+iJ8P4ueD+CB+PogP4ueD+CB+PogP4ueD+PkgPoifD+KD+PkgPoifD+KD+Pkgfv8CKYoi
lGWZVTk+8y5IPNm2bdbl/g5VVX0j5Q7xLiAxH8QH8UHuggzDEGJd14Xfx3vtXfPouLRxHEPf
95fv2HY8TdO1eZ4vLctybV3X0DTNn9/idVtxbHrveP8znn3vukfG+TPEX7J8EB/EB/FBTtnU
j3Zv0zrrXLoBp5tyrK7rm+fScc9+hyP5M8RfsnwQH8QH+WlbT98F5Bnv4s8Qf8nyQXyQjPoE
zysBs/a3nVMAAAAASUVORK5CYII='
]

{ #category : #sources }
RWRoassal3dExample >> exampleClickLeds [

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
]

{ #category : #icons }
RWRoassal3dExample >> exampleClickLedsIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAA5CAYAAADA8o59AAABLklEQVR4XuXY242CQBiAUcuh
Ch6ogCqgCe6Xusf9SdZHdV0khGPyPRiGQTgZMNx+PsnvVPkXwQfx80F8ED8fxAfx80F8ED8f
xAfx80H8fBAfxM8H8UH8fBAfxM8H8UH8fBA/H8QH8fNBfBA/H8QH8fNBfBA/H8TPB/FB/HwQ
H8TPB/FB/A6pLMt0hbIsu8R53KqqSk3TvN2z8XvM1bbtVmzrum6r7/s0DEMaxzFN07Q1z3Na
lmVrXddUFMXjexTbY1zsE/vGHFHMV9f14zjRf87j1di/zuWvkLOtEB/EB/FBfBAfxAe5Ekj8
2/g2yCfH8FeIv0J8EB/EB/FBfJADHvKvQM76EPdBfBD/luWDCK/f9x631+vt3/I8P/z3fePa
+SvEv2X5ID6ID+KDfNodCPc7X/SS3+EAAAAASUVORK5CYII='
]

{ #category : #sources }
RWRoassal3dExample >> exampleClickToGetGreen [

	| v e |
	v := RWView new.

	1 to: 100 do: [ :i |
		e := RWCube element.
		e when: RWMouseButtonDown do: [ :ev |
			ev element shape color: Color green.
			ev element changed.
		].
		v add: e.
	].
	RWXZGridLayout on: v elements.
	v addInteraction: RWMouseKeyControl.
	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0).

^ v
]

{ #category : #icons }
RWRoassal3dExample >> exampleClickToGetGreenIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAA5CAYAAADA8o59AAAB00lEQVR4XuXby6mDQBhAYfuw
EJcWEXBjERJUXFqIHYh7O9KYJrz8wgQ14/PqaDjC2QjxMR8ZMwQtx3Fay7L43SWHD8IH4ccH
4YPw44PwQfjxQfgg/PggfBD+QPBB+E31fD7bMAxXF0XRIcVxPOjqgfA87+uajrjPLWMrWXme
t1VVddV1vdjr9VqsaZrF3u/3oMfjcRmGnLsoiq9rWnMfS2OxZkzV+Eu3AQmC4BIUOaecmw+i
ATGNojD4IDMgplD6GHyQBZCzUcYYfJAVIGeh6DD4ICtBpKPXSVPn4YPwQX4TJEmSNk3Trr0I
rut+jsEH+SdIWZat2vY8U2zbHhyDD3IgyNYHvUx3umPwQQ4EkdZMX77vd9MdH8QAiGwy2HMY
8jmJD2IIRPbrpi/ZpzD4IIZBdD+L1Wf4IHwQPggf5IYgss7gg9wEZIzRXwjyQQyD6DD68UEM
gvBX6jcCWfpmjKcvtS7hg5wAsgWjX5ZlfBD+/yF8ED6ICZC90xQf5ASQozHUg54PsgPkDIw5
FD7IDMiZGFMofJAJEBMYOhQ+iAbEJMYYhQ8yuvkrMPootwHhv0HFf6WNHx+ED8KPD8IH4ccH
4YPw44PwQfiDwAfhxwf5kf4A4CSqdI6AQ/MAAAAASUVORK5CYII='
]

{ #category : #sources }
RWRoassal3dExample >> exampleCone [

	| v |
	v := RWView new.
	v add: RWCone element.
	v camera position: (WMVector3F x: 0.0 y: 0.0 z: 3.0). 
	v  @ RWMouseKeyControl.

	^ v
]

{ #category : #icons }
RWRoassal3dExample >> exampleConeIcon [
	^ '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'
]

{ #category : #sources }
RWRoassal3dExample >> exampleCylinder [

	| v |
	v := RWView new.
	v add: RWCylinder element.
	v  @ RWMouseKeyControl.
	

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleCylinderIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAA8CAYAAACQPx/OAAABGklEQVR4XuXXO2qGUBRG0czH
+VhY2liICHZWjsohWNvZWNg4Al+lJw9IGQgp4g/rgz2Bu+DCeftY+L1U/iP4IH4+iA/i54P4
IH4+iA/i54P4IH4+iJ8P4oP4+SA+iJ8P4oP4+SA+iJ8P4ueD+CB+PogP8khFUURVVdE0TXRd
91XbtlHXdZRlGXme+yD/Vd/3MY5jzPMc67rGfd/xuW3bYlmWmKYphmGINE19kCdAvrfvuw/y
SiDnefogPogP8iPIdV0+iA/ig/hflg/ig/wJ5DgOH+SVQPzD8KGyLPvVpZ4kiQ/i54P4IH4+
iA/i54P4+SA+iJ8P4oP4+SA+iJ8P4oP4+SB+PogP4ueD+CB+PogP4ueD+CB+PgjeO9tdjfSs
DmwOAAAAAElFTkSuQmCC'
]

{ #category : #sources }
RWRoassal3dExample >> exampleHighlighting [
	| v es |
	v := RWView new.
	es := ((RWCube new size: 1)) elementsOn: (1 to: 16).

	es @ (RWHighlightable highlight: [ :vv | | arr |
		
		arr := OrderedCollection new.
		arr add: vv - 1.
		arr add: vv.
		arr add: vv + 1.
		arr add: vv - 4.
		arr add: vv + 4.
		arr]).

	RWXYGridLayout on: es.
	v addAll: es.
^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleHighlightingIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAAwCAYAAADn/d+1AAADv0lEQVR4XuWcb07yQBCHvYcH
MXoN4jn4gN7CGIy38IMQFbyR/0AFBRQQ+r5PkyWltt3Z7tYA0+T3jZ3dzsNud2em3ft/Rb5q
NBrRw8ODVfV6fU1ZtiR2rq6uooODg8IxYV9ii7Gn22I7OU76k9gK4cu9EEb29/d/OVuiLFu1
Wk3UVgJEIsZuAyIR494YIK7OLAIidWYIIHk2XIFkQd0IIK6zJc+GxCEhgPj0H3hWVAfEZbb4
tPcFUvSvlgAJPCuqB2JmCzeXJ5+2NocUtfXtu0qf7VVsXL/0A9EPRL/0A9EPpFCHh4fxidcm
yc4k+fuTk5NMHR0dicZ1enr6S2lbjN1m5/j4WHR/GwPEJXRi26U8Pj7Genp6WtPz83Osl5eX
6Pr62jom+nl7e4teX1/X1O/3V8JWkSP5A7H93rrQSZlYVh6YNAwDwsDAye122zrbcOTHx0es
4XC40mAwiIUd7DFL8kBsbSwrZHDRBgMH39zciA6Gk8lkpfF4vNLn52f0/v4e9Xq9TCBbH1ys
AkgeDJx7d3cnAjKbzWJNp9OVvr6+otFopB+IC5A8GDgTB3e7XRGQ5XK50mKxiObzefT9/R0D
YdnSD0QAJA2DfzJLDDBwKM69v78XAUlfPz8/a0B4sOsHIgRiZgYwWKaYGcDg8gXCc0Q/EAcg
LCUGRnJmmKssEJYtniMAYce1s0A4XDFomyRAms1mfM5ga8tuigc4zwwgGF1eXoqAJNsg7GAP
u9inn6xDZhrI2dmZ9d7Oz883O3RiC3/bHGpr6xt+L2pvC79L+tcfy9Ify9Iv/UD0A9Ev/UD0
S78T9APRr+qBpPfpZQvVzBmg6kI58h0+lYumfQXnks0KnRA2yQooJq8yoRNsYAub+vMhDkDy
Irw+QLJg0A9xM/1ABECSyahklLcMENpiAxjYNKlbE1XWD6QEEKK0ZYAYGNjJgqEfiDD8juMI
j+NIwuUsN4h8Bup0OuIUbhEMspP6gQiAUK4DEPIWLDWIxJLR7e2tuMihCIZ+IA5AyOjxADYi
7WokrTqxwUA7+UqbK5AiZ+IkMnk4ErEjMjI1Va1WS1woVwSDGrC8QrlkbdbOApG8cYSTTE7d
iPOCEbAuLi5E76bYYBQBSdrZOiD6pT+WpR+IfukHoh+Ifu0wkHRJv+tr0bYQuG/4vcq+Nw6I
Tz5E+vGBEPkQn/HTvqLarL+dFRIgEhshvuSQ51CXT2tUMFv+dlZIMoZ/9a2TvFniei+BZ4u/
EV6KDFXbK7FDra0EiMQWYw9R24tC+PIffiW9awfhMogAAAAASUVORK5CYII='
]

{ #category : #sources }
RWRoassal3dExample >> exampleIncreasingCubeSize [

| e v |
v := RWView new.

e := RWCube element.

v add: e.

e when: RWMouseButtonDown do: [ :evt | 
	evt element shape width: 2.
	evt element shape height: 2.
	evt element shape color: Color green.
	
	e changed.
].
^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleIncreasingCubeSizeIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAAwCAYAAADn/d+1AAAAn0lEQVR4XuXYwQ0AIAgEQTuj
NEpHrUBfRjIk28DNj7Gu/L7KH8EH8fNBfBA/H8QH8fNBfBA/H8QH8fNB/HwQH8TPB/FB/HwQ
H8TPB/FBOhURlZnHfJBH7bFvzgfxQXwQH8QH8UF8EB/EB/FBfBAfxAfxXyc+iJ8P4oP4+SA+
iJ8P4ueD+CB+PogP4ueD+CB+PogP4ueD+PkgPoifD9KoCV4Yu/JDSb9fAAAAAElFTkSuQmCC'
]

{ #category : #sources }
RWRoassal3dExample >> exampleLine [

| es v |

v := RWView new.
es := RWCube elementsOn: (1 to: 20).
v addAll: es.
RWCircleLayout on: es.
es @ RWPopup.

2 to: 20 do: [ :i |  
	v add: (RWLine edgeFrom: (v elementFromModel: i) to: (v elementFromModel: 1))
].

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleLineIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAABCCAYAAAChF3N/AAABZElEQVR4XuXcbQoCMQyEYU+0
N9r7H8MvUBZdENZ2O80jDAr+qOYl6TQ2Xu6Pq6plWZ4K+1wukFA4Pow9ONtnH4gNxw96GBw/
0C0g+UCqgtmmYaAFFB3b/hvruu6+9tUdzvEFfFBdSlu7xV6A/PL3F5hzF/ez6qedzqivflaF
217YVMzrWoqCqvNlipgKy9FMkFX+oc3/PWSi8jcgq/zgh5kKP8g9sqp5c9HXMFPhByylbTK8
deLLzxAfiC8fiA/Elw/EB+LLB+ID8eUD8fWpR2/FV478DPFLli8fiA/Elw/EB+LLB+ID8eUD
8eUHIey+lx+MsBuRfpBOut7jl6xJ7//6gQ2bO/EDHjaZ5V+I9m2vP91bE0jRSV1/U/WBmOPO
mUAm2FRHHyb9TTVpwurib6rjWiqHS5b/t0vdIXwD8TfVrmXIP6lPCMIH0trA+K2TOhB8IGEQ
fCBhEHwgDeypD6QwhLdu/MdxuqagsiIAAAAASUVORK5CYII='
]

{ #category : #sources }
RWRoassal3dExample >> exampleManyCubes [

| v cubes |
v := RWView new.
cubes := RWCube elementsOn: (1 to: 100).

v addAll: cubes.
RWCubeLayout on: cubes.
^ v
]

{ #category : #icons }
RWRoassal3dExample >> exampleManyCubesIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAAwCAYAAADn/d+1AAADnUlEQVR4XuWc7Y3CMAyGuweD
IOZAzIEQYgsEzAEMAgxSEEv05ErmTLDzTZriH++PgzY1fpLYSZ1r2rbtWouWy6VVk8mka5qm
13w+t7YV0/7xeOyvw+fc7/cgrdfr/r7dbhf0PF/B9aYPUtpvUh0Gmk6nL4O+BQSfEQsE28kN
BNsH+fhqdEBs18UCAfskR8Dn+oHoB6IfiCogq9WqNwyUCgSCLxi93W4/vksBwjkGBLanADmf
z6/fngUIGiYp9CGXy6VztWlrX+q5CGS/33en08lbs9mMBSI9BzpCiP2hndfVfuPTSCh1gML1
cB9hG+BMhEDFOdcm6X4cQfic1N/sC8TD3qbPo0N/qM8wjIEC91FH0fgUMle77k0BAh0udnrn
BGsXYuu7wTFwfAOmj0xHcU51Lb64RWtOICnxVoDwLwxInCDAolM4QUAEp0s9xjY/c3MpOOfx
ePS63W59wDwcDt1ms3kTfAbfuWTeB8Lv8DnX6/Ut5nC2+QLB6yV/AQRo2+Zz7yyLI+rKqmwp
pTmqsMc+n8+iAig0K+Ns8wXyypQsM85X0l6EkwsIdcgvALFN+0XWITGxRoovpYHA9OWKE9/y
QTEgOIJQOLfSWEOBYI8ClQYC8YjaygGhi0ju2uqB0LQTnO2azuicWxoIBHpujSNtk2BwHtUI
4RZnth5VIxBzxKeu1aoD4qshgbj0M0BseTdOa7WMkMViIdpqbkSOFohtN9aMOUMEdRoTYHEo
2Rq77zVaIDWkvfqB6AeiH4h+IPqB6AeiH4h+IPqB6AeiH4h+IPqBDACEvo0cYuuEbhyqAKJ/
c7FSINLL/1qA0BdlVLj5+RNAYDrC8lAqWrNV4/sQrqoQdoJH/QrXVoA91jeGqYWFoyhyoNvf
Q2ZZ1I5RFjlgoZwks5TUBILFcVSlgUBBHlcoZ/OBqwDb9s49OxAa5HLUZZmp5ZB1WVIRX2yh
HFcQkQWI+Zo1Z+ViLUBMu3NVLppwnEBsObdvuUvpYmvfgMr9rhqKraUO/lH9HltzVBpIzuMI
MTbmTIA+4KQWfklAoEoxZZsFgZg9Cf4OSb+lowy0jjfURjPo58rG+g6UO5VLOT0ljRC6oo85
QUVX4AgkZRRLHTHLrkaOdUjoQUmfgCmdMcx16DPXKdzcvqruWDS3zYJOSwEiHbZMPYWr/5y6
/nPq+oGoBmJOKXimBDOmGCAQ1NERIds7owSCpfqYzWj7b0AQ80IWrK72/wBF0tT+B/f41gAA
AABJRU5ErkJggg=='
]

{ #category : #sources }
RWRoassal3dExample >> exampleMatrixHandling [

| v es |
v := RWView new.
es := RWCube elementsOn: (1 to: 10).
v addAll: es.
RWCubeLayout on: es.

es when: RWMouseButtonDown do: [ :evt |
        | node |
        node := evt element sceneNode.
          node shapeMatrix: (WMMatrix4F scale: 1.1) * (node shapeMatrix )
         ].

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleMatrixHandlingIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAABCCAYAAAChF3N/AAACLklEQVR4XuXcQa6CMBSFYffB
QggjF2FgGw50zgbQhYjrEliF790BSWPQHrAC5Sc501r7IdJLy+7/ePKzqvAHgQ/CDx+ED8IP
H4QPwk98II/HQ8rpdNpcm1GD3G63Z5IkUptN00hRB+9wOPBBhkBsYOYGsZPgeDzyQYZAbGDS
NJ0VxD6TD/IBxOJrs21bKefz+WM7hs8H4YPwQfggPwbpuk4KH4QPsh2Quq4XBenvzDYPYme+
L4ZxuVxkkPv9LqUoChnE+mDx9TXP8/hrWe4XV6LMrJV2fDP/Mf2yz1QrCdEUF9WBDAUcqp2Z
IPjVXn75nR8+CB+EHz4IH4QfPggfhJ/tLnJwn+K55XG37mSlDnU2rB5lWcqTQ7cvr2X8Kc/p
NwGizrBDgbgzdT4IH4QPwgfhg/BB+CB8ED4IH4QPwgVR1veGAunX9aJA7Au4sZUgQ/EtSHBj
A61kv99L7RnMu35Z3P5nWcavZfFrWfzwQfjhg/BB+OGD8EH4iQjE7vdtduxLbO1ECaKu613j
2t6Z1/euB0IdSLUd39k9dlX+TDDLb9ixGtEaNuzwd1CtCIS/pY2/x/B3IFOuxa+DwN8WHQDE
/uCm/GnzQX4A8g0EHyQgyNTLkwqiPDEM9fIZ94lhdCDfXp5UkLlfz9SfYFGBXK9Xab/5u1RV
JYGoZYrQLzCLDkTtrHJL+w7E0Jd6HZ/9+vkg4uWJX+3lg/BB+OGD8EH4IHwQPsgYkAUejUaR
P/+gR248slO4AAAAAElFTkSuQmCC'
]

{ #category : #sources }
RWRoassal3dExample >> exampleMenu [

| classes v n shape es |

classes := RTObject withAllSubclasses.
v := RWView new.
n := RTMultiLinearColorForIdentity new objects: classes.
shape := RWUVSphere new size: [ :c | (c numberOfMethods / 100) + 1 ] ; color: [ :cls | (n rtValue: cls) ].
es := shape elementsOn: classes.
es @ (RWMenuActivable new action: #inspect; item: 'browse class' action: [ :e | e model browse ]).
v addAll: es.
RWCubeLayout on: es.

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleMenuIcon [
	^ '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'
]

{ #category : #sources }
RWRoassal3dExample >> examplePopup [

| v es shape |
v := RWView new.

shape := RWCube new color: [ :m | Color random ].
es := shape elementsOn: (1 to: 100).
RWCubeLayout on: es.
v addAll: es.

es do: [ :e | e addInteraction: RWPopup ].

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> examplePopupIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAAwCAYAAADn/d+1AAAHGElEQVR4XuXb609TZxzA8b6b
mxEE5DpA14EEkEbAailUKi23UrCUlkKvSAWFcqnITVRURIeiwlyim05FnS82nZjNLFvGtsS9
HduLZXu3uGTZ3/Fbn8ed4zntOafn9NRSOC++MSE56TnPJ32ep+ccZbdeLMAtjgwuPWf5CjnI
ZDKcrl4Np15OCErtU5OpPAdAqbHR6vLOwJXLTyFpayr+jM+m/xSUudqHjxuqNsBXvZMw6DXQ
8nTpQdlZRmaeawH/t/2885yxQkrSVvwZW9K3QkHtblA6tayZr3aD/6cLrIkGCUYRA4JiA5G/
VyQK5LyxkxGk1b1fFIjKqSSvnQti3YKgwWdKX2OJGKQoM4cECe64xyp9EGEgyzjpg8QFyLL0
QSIBaa1rh47dfTixICbTSTjUtRj4dwwjUEMX/SgwyEIiQKxlajKLUgtnHaO42mZxi3qjtwvk
Ce24qICMLPQBV3xATrvn4VnX77jJB9PgeNTBu2CQ6TO/4Fzum6CtdoSA9LbMwgnXXd4VbleG
gJi1FnhyYRnnH/bTQHR+LUbh20HdbdBnP8HxAdGNtmIUtmR8BlwICOp69xOwHe0KGWw+vQJZ
xSAaTTc5HRAV5JZDi6aXd8HHF+4o4gThW5V6mIQQAhIuGTrJ5PQkvA5EC4TI3emLAGSVBpKb
WxoyqHwxEF7wsQgDg1xcxgkF2V2jBm3x1RAMMSDot0uWYgdxjvQTjgSHDWSm/lOwKHpA69BH
FURdYuQFkpKYGVWQnWkGkMvMjBhCQYIQXterbQa2Ttjc0N5cj4GYQos5wrjhWeYEQTVr7NDo
cIOxfwindXaCc+x8SJbZFZx+9D7s8V6EPMsQpNZaaRVahqHKOxe24ONQ+3vO4HxzX+KGTl7D
KNQsTgfY+ybIinfVYAgiNpCqqnEcGmimyvUKOHK8GY64NazJVs/dBq68GgPOULIPSnPzaZpo
V8UEwQSC6jSeB0//A1xdyyS5gBPfClTx5ccxDaEQ3xZiXRn1zMLZqRUyKgYXCBF1jDLSEqC0
JAe8djXuk3k7/LYyxRpvEGoEjr/6VBRAVjccCAKgIlB7IyDUPBUmcChttIFnKxikdE8bVKhd
eK0gijUImr6IdQVVH7h/plHbOUGYKkszQk1JHSNCTEGCQzhF6WW0EATK6bhOA1GUteASEzPw
4o2KNUiRtR9vhVG5OSUYIxikVfMBrjS3A5JkhWSFafvArNOGRVhTEGpoWstITCYRqFFBqHNu
rEHQQk98NhsIkVbjxlORQVcsCCFuQIjQxaZnFoA8X00iUItHEGro74kJaazrwroE4dtagoRr
w4DYj/UGOsJY8d5SSH03Iy5A8rJLYF9xLTRVuhizGZo2Bsjzf1YD/cqYbdBLhnBiDVLQNgB7
i3TQoLLjhm2X4eb494ydPjolLRCMEmOQikMzJIb0QaQPIn0Q6YNIH0T6INIHkT6I9EGkDyJ9
EOmDSB9kjUAOtBrwr/S1unWSHLhxiG6bSAZE+jcX4xRky+YUyEovCCleQBLf2ga5CYUhbSgQ
9PxdV9UDrQ2TtHSVXlAqWnBx8zwkMPiabDPOrZgOSbWzYn2CoCeF1DdUBrsfhoRQ4hnkrPZx
oC9oaXdYaW+SRPLkMGYgtmonzlgzxJrTPBcCoq6yQoXRBMZeHy7WICq/F+ps2biyMjkF5DWE
ymJkrcZaD802HXR07F97kGMmP0wdXoLRns8Z62qb5wQZXrgLY3cewTilWIM0zQ2A76KCVmtN
MyeI7dw4awOzg7EFIV5cwO/Y6kfgzqV/WUMoXCD3/vgbt0Qp1iDupTH48BstbvH/evsaOUHG
ny5xRt0EBE9rUQGhItBeeo4SyL04AFl8AyDBW2aEExaEbc+dl6SAvZm10CB3hW3Eep8T5GCd
B9pNOrBblWEjYND0hdaUneXKkHMrSlKCVe4LG9N1EesF8a3oGbOCWtkftgq9IyyIosDOq/SU
Etj8dhrb753IEPiCtDW18oIQAsIHA4XgogWCUaq6QWVsEw3CiRMpQjiQK6e+EwTBBpKSmUUb
0NRNWbxBqjNNISB7DqSSIIsCQYga2yaiBhKMIxMDwQSCIPq7D0WEgSLWFLT7MjmsoMh5h0zI
dEWdtpKS0kH+vgJXrlJikEURIEQdxy5EFQQl+7juBXAlFOSHZ35BcYF01BaCS72NDA3uc8NL
QdnzhzGEvs5FVmvexQrSYXoIE76/eDd+5UdBIA2V89BtWmEtKiBo2iOmBLEgk8btsGjPC0ks
SHvnOPQNLISkre4RBVKpHCKvfUOC/HySObEgaPCvffQipMOHb0gfRPog6whkpr+O1oMRDQap
LU6MGAQt6gTIdNt1Wk799MYDSd6U/up/8G5JFg1SY7fRQigIhNhlfR0YZCF1BkDQcQTI0LZu
Wpa8XlEgDU2XSBB5jk40yH/OtqRMIq9jnAAAAABJRU5ErkJggg=='
]

{ #category : #sources }
RWRoassal3dExample >> exampleRedLight [

	| v |
	v := RWView new.
	v add: (RWCube element).
	v add: (RWPointLight new color: Color red).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	v addInteraction: RWMouseKeyControl.

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleRedLightIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAA8CAYAAACQPx/OAAAA60lEQVR4XuXYMQqEMBBAUe+R
g9gs5EgWaexy2/SewFWLRVDQBZHoG/h9mEeaaaYZ/arKX4IP4ueD+CB+PogP4ueD+CB+PogP
4ueD+PkgPoifD+KD+PkgPoifD+KD+Pkgfj6ID+Lng/ggtxZjHHPOp6vhzX3bLqWUDnscyLzk
f+bOt31C+C1/6LpNpZTDfJCLf8IehA/ig/ggPogP4oP4ID6ID+KD+CA+iA+CgOydS9ZIrwTx
j4t+PogP4ueD+PkgPoifD+KD+PkgPoifD+KD+Pkgfj6ID+Lng/ggfj6ID+Lng/ggfj6Inw9S
eV8Nv4mK+h1sGQAAAABJRU5ErkJggg=='
]

{ #category : #sources }
RWRoassal3dExample >> exampleSimpleCube [

| v c |
v := RWView new.
c := RWCube new.
v add: c element.
^ v
]

{ #category : #icons }
RWRoassal3dExample >> exampleSimpleCubeIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAAwCAYAAADn/d+1AAAAn0lEQVR4XuXYwQ0AIAgEQTuj
NEpHrUBfRjIk28DNj7Gu/L7KH8EH8fNBfBA/H8QH8fNBfBA/H8QH8fNB/HwQH8TPB/FB/HwQ
H8TPB/FBOhURlZnHfJBH7bFvzgfxQXwQH8QH8UF8EB/EB/FBfBAfxAfxXyc+iJ8P4oP4+SA+
iJ8P4ueD+CB+PogP4ueD+CB+PogP4ueD+PkgPoifD9KoCV4Yu/JDSb9fAAAAAElFTkSuQmCC'
]

{ #category : #sources }
RWRoassal3dExample >> exampleSpheres [

	| view shape |
	view := RWView new.
	shape := RWUVSphere new .
	shape width: [ :v | (v log + 1) ];
		height: [ :v | (v log + 2)];
		depth: [ :v | (v log + 3) ].

	view addAll: ( shape elementsOn: (1 to: 1000)).

	RWCubeLayout on: view elements.
	view @ RWMouseKeyControl .

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleSpheresIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAA8CAYAAACQPx/OAAAXgElEQVR4XuXcVa80VdoG4Pof
aJCg4RR3d5khBIIFSYDg7jY4gw4wuLu7u7u7uwwOAwQOqMlV+e6dtdfu6u79vidfwkGlu6ur
1iP3Y0ubCy+8sL3gggva888/vz3vvPPac889d+I655xz2rPPPrs966yz2jPPPLP997//3V1n
nHFGe/rpp7ennXZae+qpp7annHJKe/LJJ7cnnXRSe+KJJ7b//Oc/2+OOO6495phj2qOOOqo9
4ogj2sMOO6w95JBD2oMOOqg94IAD2v3226/dZ5992r322qvdc8892913373dZZddJi503n77
7fbbb79t//zzz/a1115rn3322fbhhx9ub7/99vbyyy/v+Ft22WXbpmkmrsMPP7yT56abbmrv
v//+9umnn27feOON9ueff25/++237l5Jx7XHHnt0fOy7777t/vvv3x544IHtwQcf3B566KFd
e/gnx9FHH90ee+yx7fHHH9/JSFYyk50O6IJO6IaOyEBv9EeP0Ss90zc+6T/XRRdd1DaDwCDo
KDD+9a9/DQTjhBNO6BjGOAGOPPLI9h//+EcnHCEJS2iA7L333p0igLHrrrtOUhLB7rnnnvbD
Dz9sP//88/all15qn3jiiU6hN998c3vJJZd0ilpuueUmAeIeGa6//vru/ccee6x9/vnn2w8+
+KB98cUX27vvvnsKIOjjg4Hgi8H0gcLIGBsZyVqCQh/0gvcAUoJCp6NAaQaBUQJRg4HYMDBq
7wDGKO/YbbfdpiiJQu+77772xhtvbB9//PHO0h966KH2rrvuaq+99tpOGEpbe+21JwGCFwZz
1VVXtbfddlv7wAMPdEB61z3vk6mkhT4+GAi+GExAwTf+ycG4SlDI2gdK6SWueMkgUEpgmj4w
XINCVAkGJgaBEe9gVayr9g6hgfAJVbV3uCjxwQcf7MITRd55552ddd9yyy3tZZddNsHTGmus
MQkQtPHCg4AKAO0AVlsBqC9s4SuhCyiMqAYloSugBBDXOKGrBKX2lmY6+SJglF6RnMGFSzDG
8Q5KGOQdLh7xyCOPdGFHPsCwUHX11Vd330NvpZVWmgQI60WXLPKMdwHqU1va1DYeB3lJQleZ
T6YDSvJJQhfd1aEroNTe4mpmBox4RZRDGckbM+MdLOW5557rLJlFx0skPW6NJwpCZ/HFF58E
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
EDkm9n/fnHqnAjVgugAAAABJRU5ErkJggg=='
]

{ #category : #sources }
RWRoassal3dExample >> exampleThreeCubesAndLightWithShadows [

	
	| v floor light|
	v := RWView new.
	v add: (RWCube element).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	
	floor := RWCube new width: 10.0; depth: 5.0; height: 0.1; element.
	floor translateByY: -0.6.
	v add: floor.
	
	light := RWSpotLight new.
	light lookDown;
		translateByX: 2.0 y: 3.0 z: 0.0;
		influenceRadius: 10.0;
		castShadows: true.
	v add: light.
	v addInteraction: RWMouseKeyControl.
	v withShadows.

^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleThreeCubesAndLightWithShadowsIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAAA8CAYAAACQPx/OAAAE/UlEQVR4XuWaBW5jSxBFvY+s
ICvIOgL7CDMzMzMzMzMzc/ZSf25L1+rpeGbsaH6S/yvSUZyXvOp+daqqbSmeH1+in2+F/iTo
F6If/UL0C9GPfiH6hehHvxD9QvSjX4h+IfrRL0Q/+oXoF6If/UL0C9GPfiH6hehHvxD9QvSj
X4h+9AvRL0Q/+oXoF/KpBAUFSUhIiN8EEjuQuAB78SdueHi4wc/9/reEYNORkZF+449gJCuQ
mMQVHhwcbGJFRETI0NCQl8HBQRkYGPB3v7qFBBrvd0IgA8kHtgz9Qr6BEBvI0C/ki4Qg8b6E
9Pf36xfy2ULCwsK83WB3BmToF/JFQpB4irCF9PX16RfyFUKQeHYEwTX9Qr5QyK/QL+SThYSG
hkpvb69PGbj+14S4n47/9EEqKipKoqOjJSYmRuLi4iQhIUGSk5MlLS1NMjMzJTc3VwoLC6Wk
pEQqKiqkurpa6uvrpbGxUVpaWqStrU06Ojqkq6tLenp6zANhFuN9fVlZWUBJ29vbk/39fTk8
PJSjoyM5Pj6Wk5MTOT09NbS3t39YCPa8vLwsi4uLMj8/L6OjoybxrhRe80uI+9H9TzfYyY6N
jZX4+HhJSkqSlJQUSU9Pl6ysLMnLy3uX8NraWmloaJDm5mZpbW01iWDSAa5VVVWZ+/Lz86Wg
oMC8Li4uNnFKS0uNjIyMjICSdnd3Jw8PD/L09CQvLy/y+vpqvkPGwsKCjI+PmyLAOoEKQbKf
n5/l8fFR7u/v5ebmRi4vL4302dlZExuFhKICfgnxt8qR+MTExJ8qPTs7+6fkI2FIak1Njbfi
IYBVDwmdnZ1eCfi5rq7O3J+Tk2Pi4TtAFyE25RQVFb2TA9lYD2tBKKpwbGzMVOzOzo6cnZ2Z
JNlSkEBIeXt7M68pBt1nV7V7MLsHNF6jI9Ah6MCrqytvbAjHWljz9vZWzs/P5eDgQDY3N2Vp
aUmmpqbMeixE7B/PUV5eLh5fFY8Rw6pH8lGVqHwkCgmyBVRWVno7gBKampqMBCxmiwDd3d2m
WpA8vkXEe/bh4WEZGRkxCUVlTUxMmI3PzMyYasNIQOLwQEjCysqKrK2tycbGhnnQ7e1tIwEj
Cg+PEWWPJyTl4uLCVPD19bURhWRBFqobyUOlI5EUB9hVBCIJr+FvCO7B/YiFmIiNNbAW1sTa
2AP2gj2haLBH7BV79tgCWP0YPewAVColoEIhASZtERhFFMGRBBGUYY8mCLFnLIWgYnxJmZyc
/EnM3NyckYMusOWsrq7K+vq6V9DW1paRtLu76z1HKMo9S5AUYEsDqHqAJBIklSDJNrxu/z1j
MKYtgjIoBPvypKamvpOATsC44KhgN2BEUATGEsaNK8PuDFsIO4RS2CVsf1sM5WAkAAiCHHYN
mJ6eficJHeSKYicBCnOlobMA5NkCCUUSJO6jMAZiEqyBNYGH44jd4IrAvEZH+JLBEWWfFb8S
Qil2p9hSXDFu11CMr+5xBdmSXFGUZXcWoDBXGoE8CnShUFcscX9vY8dBfA/GFQ5rjCyOLYDz
A91jdxCAQIBuApBJoYQHMw9nF0gnGIc2KAaCMWmDIuHhboPCISggG3S2DYqLoMhcUHQuOHB/
B4r0b+H56Htw/fw76Bfy3YTo/6cC/f/koB/9QvQL0Y9+IfqF6Ee/EP1C9KNfiH4h+pOgX4h+
9AvRL0Q/+oXoF6If/UL+5/wD/BtZ+VF9284AAAAASUVORK5CYII='
]

{ #category : #sources }
RWRoassal3dExample >> exampleTransparencAlphay [

| v els shape |
"Alpha over transparency"

v := RWView new.
shape := RWCube new alphaOverTranslucent color: (Color red a: 0.8).
els := shape elementsOn: (1 to: 20).
v addAll: els.
RWCubeLayout on: els.
v addInteraction: RWMouseKeyControl.
^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleTransparencAlphayIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAABBCAYAAAAngwHRAAAE5ElEQVR4XuWcu07cQBSGt0Gh
AhFKBxEFksATWNtHCAWSEIbNPVEgFwIEbeEy5bYRNc+wVVoq6rR5iGloXLuZnN+XlbOKxzPr
y9p7Iv1StFo83vk85zZn3KF/ir8apXIu1CV5lupOME4Tx/CaCAQ3JS01nGAc2zFsJ8udYAw5
S0DchgHpcweCCXAaAkTwBxJNgGgAECe+F/5ALFdJVUAEfyD/AnGnDKTPHwh/IPyB8AfCH0jj
gfikINZv0mWs69R3HAMgQY58AyAXqetdppS+Dn8g8VNaNRA3XqH8gRgCcSsG0p91IMlT18/R
YOzHZwHp59j6yxwNNGDdHCBp5f0eYVlpqBVIkvGKCoG4lkA6FQJxm1x+NwVTFIhjAURUBMRt
w36Izoyl9SOe/HH9MQSSXPN6YUGrH7duZZqS/wG5ztD4/Ttt2aAq0/nnAQmd+8qKkqurmfII
SscCSA3OuqVA5ubMgKytKbm+Hunhw0j3748+85aW8oHQWOyBjJe6dTLNrG3tvGsYPXW4AMny
L+PKg1rV3zqz0OTAX/yB8AfCX/yB8AdSZ6Ncb5Kw+d495VHI61GI61Go621sKG9zMxL+j88e
PFAeQl/6blcT/mY5fNaNcrYFOrm1peTOjpJPnyr5/LmSQijZ60U6OFByf1/JvT0lnzxRcns7
hGJbGGW1QXUTl8ahq7jmBKHUgewaCZ0ubJWPH4cT7r98qfw3b5T/7p3yP3yI9P698t++Vf7r
1+oGoAgKVkrWSujNzytvcTEcd5C6Fz8lvvshNCnyzh0l6YnWJYbhyqDJDghAcHiogs+fVfD1
a6QvX1Tw6ZMKPn4MoQAczFdmpk7ww1ILjct/g+p/QFCfygMCM0XmaQTj+FgFJyeRvn2LwBAU
rBSAg1/RArl7lz+QTCB4WsnEaIHAR5C5CldCAuPsLNLpaQSFVgrMF8BpgSwvhw8AfyBFgMA3
vHoVrQ5MPiCcn0f6/j0CRKsEPiUEQtEXfyB1AwEICKuEP5CSgVCOketDXrxQwdFR5C8SKIlg
xggWoi+EwVqTdfs2fyCFoyzkGDTRiKRCP5JAgQADkRY5fITE8DdIFPlHWSUAyWwD2t0NJzqg
FRBCwUqB+YIACNEXchJy/PLZszCjz9rv5w+kjFZSyr5HWToyczJf8CmhAAEZe5KtU0aPMgv/
VlLLI21WJ6gePYqgYKXQChiVT6AEBIAho6cyi2npJDFlYlaA8Bd/IPyB8Bd/IPyB8BdTIG7B
viyR87dOgbHFdFuB6h2wG59cGmbJsHMRZQ/UorKEzac8ID9prKHmXjz+raQWvb3Yx0AdCkpa
StFeGn+GnUD+vb11AkGZRSP+zdaGPbxFz4d0LM6HuBWcDxFtBKI7RTUrJ6jctgARFZ8xFJZA
nIrPGDpNbpQbGugqLrtDvzRAskxDcp3fObqKv9fTmNIsIOnrmPymCw7Hop2Kj0UL/ufUzYGI
Gl4c4PAHktO5aNgnmwar043BqzXS/chsOxf5v3yGP5DZAuIaHtAc5IShRYGYvlLD5hUbrQJi
elK2DiBuCUD6bQYiLGGUAcQ02SwCxGnb+RB3AhBlALExJ0WAmI4zdSBFQBQFIix9WBEgfcNi
6FSBiBJgFAHiWNbGigIxGW+qQPpTBHJhGY6WAcTkLQ8zAaTI/njRkLuOe6lLfwGjCR0aVm3Q
DgAAAABJRU5ErkJggg=='
]

{ #category : #sources }
RWRoassal3dExample >> exampleTransparency [

| v els shape |
"Additive blending"
v := RWView new.
shape := RWCube new color: (Color gray).
els := shape elementsOn: (1 to: 10).
v addAll: els.

shape := RWCube new translucent color: (Color red a: 0.5).
els := shape elementsOn: (11 to: 20).
v addAll: els.

RWCubeLayout on: els.
v addInteraction: RWMouseKeyControl.
^	 v
]

{ #category : #icons }
RWRoassal3dExample >> exampleTransparencyIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAABBCAYAAAAngwHRAAADGElEQVR4XuXcO07rQBQGYDc0
NFR4FRZStmCxCRdu8lgAugVroGU5KSiQ8n4n7d3L3PktH64xxJ4TzCTOj/SLYEVONB925hx7
Etgfw5+LCv8g8IPwhx+EH4Q//CD8IPxpH0hqM3TIi2KfQ8ekjvuLFPukAonOBJLwg3wPkpwB
JOIHqQaJPYKE+Wvyg1SAJB5BIn4QfhB+EH4QfhA+kJsbM7y9/Z+7OzO8v/+8zYYfxBcIBt8h
qUXhBynlIR/sujwpQF7sQLvk0R5JriAu7/HPtfSywry+SBwTKE41PvaTKLoIrWouusK4tjt+
OoDRZUHwd3v52+/84QfhB+EPPwg/CH/4QSTdbtf0ej3T7/ezDAaDL8F2PAfpdDr8IOVKPa2L
rajrqmrJeDw20+nUzGYzM5/PzWKxMMvlMgseI9iO50wmkwzFpT5K895XXTh6WbbvhFaHS2GI
QQaGQKxWK7Ner7PgMYLtglIF8qmXJc1J/uaiDkQwBGKz2WTZbrfZb4ERFJy++EE0IBgEBQgG
GYMtGIDY7XYfwd+CAjh8pjiDIPwgehA5OgRjv99/BH/LkQI4fpBfBpHTFQZdMA6HQxYBkaOE
H8TjEVIEERR+kDN/hpRPWYIBLP7PkFNBcH38B7MsAAhMeaalnmXh2jz/tFc37UVtIUdJsQYR
iOIMC3j8095TQOx/JkAihyt0UhgWq3QpCKX+KFbrVYVhmL9eLCA4Wq8dpOmMRqMMpdg+KQfb
8Ry0WdD74u9l8YcfhB+EP/wg/CD84Qfhj+cXlLl/VVxXzlYl9PheWgmiub83UKwNPJa4wXt7
o2sD0dxonTS4v7DBm60Tx6OOf30I//qQCwCRFVN1IIr1IfwgTa4xlCVu/GsM62c9zzbvR/LG
v+izeZC62dMrroMfyTs/SLMgLrMUfhAPIJrpIj/IL4KEJ9QUWpAw8PttQHFbQbQQp4DEgf+v
ZwrbCJIq3nA5f22MI0gYnOcLzGImkEWO8vpNngu3+T8qaxuXPChOxa77bD2I5ELWgF9H+50f
hB+EH4QfhB+EH+TSQPgH/2v+AWhLHmTeBgakAAAAAElFTkSuQmCC'
]

{ #category : #accessing }
RWRoassal3dExample >> label [
	^ 'Roassal 3d'
]
