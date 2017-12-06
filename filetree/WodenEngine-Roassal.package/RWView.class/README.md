Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, "I represent a paragraph of text".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	baseShapes:		<Object>
	camera:		<RWCamera>  Camera from which the scene is visible
	cameraLight:		<Object>
	dynamicsWorld:		<Object>
	elements:		<Object>
	eventHandler:		<Announcer> take care of the event sent to the view
	fullscreen:		<Object>
	isStereo:		<Object>
	lightCamera:		<Object>
	scene:		<WDScene>	Contains all the elements that are displayed
	sceneRenderer:		<WDSceneRendered> Indicates how the scene can be rendered
	selectionRenderer:		<WDSelectionSceneRenderer> used to identify which object is pointed by the mouse
	signalUpdateCallback:		<Object>


    Implementation Points