adding
remove
	"Remove the element from the view it is contained in. Sending #remove to an element has the effect of making it diseapper from the screen. The Virtual Buffer are also correctly updated"
    self view removeElement: self.
    sceneNode removeFromParent.
    view signalUpdate.