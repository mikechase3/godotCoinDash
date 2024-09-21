Godot 4 Game Dash. Assets/content used/derived from CHRIS BRADFIELD's [Godot Game Dev 4].
=======
Godot 4 Game Dash [project]()
https://github.com/PacktPublishing/Godot-4-Game-Development-Projects-Second-Edition/tree/main/




## Bugs and Questions

### How do I put stuff in parentheses?
1. I tried to do a markdown thing with `[text](url)`
2. I had the link on a new line so I `dd`'d it.
3. Then I tried to put it in the parentheses and it put it on a new line.
TODO: register manipulation some more? 

* Note: I use the terms slide & page interchangeably. 

### Sprite off center?
* **Prac04P34 Sprite Off Center**: handles do not correlate to inspector.
	* The Node2D transform position works as expected
	* Using the handles to scale does not affect the scale values.
* TODO: link fox01 gif.
* Testing 2024SEP20at930AM
* Solution: yeah, it's off center on the y-axis not x-axis.
  * Forgot how to replicate this.
  * Thing you are supposed to realize this when adding collision for the first time?
  * Broader issue I didn't know was an issue was that **collision shape rect has more properties**
    * Found this out when adjusting radius.
    * You don't scale your 1x1 circle but adjust radius by clicking that shape to expose more properties.

### How to signal via scripting?
* Inspector node signaling sucks. 
* ChatGPT whatever says use `$<nodeObject>.connect(signal: String, self: targetRefAddr?, functionOnTargetScript: String)
* **IDE Hints**: spews "Invalid argument for connect()" function. Arg 2 should be "Callable" but is "res://scene_main.gd"
* **Solution?** after 30m of arguing with ChatGPT's spewing bulls\*\*\* I read docs. Docs say it needs a callable? Like $<childObjOfNodeNameAsStr>.connect("signal_name", Callable(target_obj, "target method")



### Vim: HowTo Nav to End of Wrapped Line
* `g$` takes me to the end of the first line. Expected the end of a wrapped line.
* Arrows or hjkl take me to nearest bullet point. 
* Super aggrivating. Less so after realizing I can do like `20w` and use number/motions.
* Though I shouldn't use long bullets so maybe it's a feature to discourage bad documentation.


### Why the heck am I signaling when I can call children?
Maybe efficiency? Idk but to get around the signaling problem I just decided to write a child
function and try `$childNodeObj.aFunction()` and you know... it works!
So can I circumvent all this signaling stuff? Maybe calling that would modify all children if
I did more than a simple print statement. Would it do a for-each loop behind the scenes?
And signaling you can get a specific thing? I mean, couldn't you just assign IDs then?

Google says decoupling, modular design, event driven programming, scalability: multiple listeners, dynamic connections, loose coupling, easier matenance? I'll read or ask prof more about that later once I finish. 

### Can't access child's screen size property
I spent an hour trying to figure out why I can't access `screensize` from the `scene_coin`. 
Turns out the IDE won't catch a misnamed variable. It ended up being a runtime error to my surprise.

### MarginContainers Slash?
* I've never seen an access of Property/SubProperty before.
* Is this something that's done in other languages?
* I'd accept a .get() function.
* **Solution**: it's part of the tree. Trees have refs to other nodes and this is a shortcut probbaly.
it is like a file structure

