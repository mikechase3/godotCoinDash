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

### Debugging Signals from Timer to Main and Back

I’ve been wrestling with some signal issues, and it’s time to document my confusion. My rubber duck debugging didn’t work, so I turned to the docs, and now I’m gearing up for some professional help in office hours.

1. **Scene Structure**: 
   * `scene_hud: bp_scene` has a child node called `GameTimer:bp_timer`.
2. **Signal Emission in `scene_hud.gd`**: 
   * The script only emits the `start_game` signal, and this happens when a button is pressed.
   * When the button is clicked, I hide the message, hide the button, and then emit the signal with `emit_signal("start_game")`.
   * `StartButton` automatically triggers `_on_StartButton_pressed()`.
3. **How I'm Signaling `start_game`**: 
   * This is where things get fuzzy. I’m signaling using `emit_signal("start_game")`, but I’m not sure if I’m handling it right.
   * I thought I had to pass a `Callable` with the `connect` method? ChatGPT says I don't?
   * I tried creating `temp_callable = Callable(self, "start_game")` and used `$scene_hud.start_game.connect("function name", temp_callable)`, but then I was told I don’t need that, so now I’m kind of lost on when and why to use `Callable`.

**Status**: No syntax errors anymore, but I’m getting a runtime error now.

---

Here's your documentation updated with all the key points, including the journey through your challenges and learning:

### Start Button Still Doesn’t Work
I had really crappy notes & had an AI re-write them more concisely. I spent about 3hrs on this bug, maybe 6hrs of less focused work:

The button doesn’t seem to do anything. It should hide itself, hide the message, and start the game, but it’s not cooperating. I’ve checked the signal connections, but something’s still off. I'll look at the solution, but might have to sort it out during office hours.

1. **Initial Check:**
   ```python
   # Connect the Hub
   print("Is scene_hub valid?: If null, that's bad.")
   print($scene_hud)
   $scene_hud.start_game.connect(Callable(self, "_on_hud_start_game"))
   ```
   This gets called. It's not null, but a reference to a CanvasLayer as expected.

2. **UI Connection Issue:**
   Interestingly, when I do it through the UI like the book says to, it generates this:
   ```python
   func _on_scene_hud_start_game() -> void:
       pass # Replace with function body.
   ```
   The signal for the `scene_hud` shows a green `..:: _on_scene_hud_start_game()` function in `scene_main`. 

3. **Identifying the Problem:**
   Could the word `scene` matching with my file tree really be the big deal? I was confused about whether I needed to make a connection for the button's `pressed()` signal or if it would work automatically.

4. **Solution Found:**
   After much back and forth, I discovered that I needed to manually connect the button's `pressed()` signal to my handler method. The correct implementation in `_ready()` is:
   ```python
   func _ready() -> void:
       var callablePressed = Callable(self, "_on_start_button_pressed")
       $StartButton.connect("pressed", callablePressed)
   ```

### Key Takeaways:
- Always remember to connect button signals manually; they don’t do this automatically.
- Use `Callable` when connecting signals to avoid errors with the expected argument types.
- The confusion with the word "scene" in the function name did not affect the functionality; it was just a naming convention that caused concern.

### Minor: Remember IDE won't check filenames.
So I tried referencing `$HUD` because that's what the book calls it.
* I named it `scene_hud` and tried calling that

```python
func _on_game_timer_timeout():
    time_left -= 1
    if $HUD:
        $HUD.update_timer(time_left)
    else:
        print("HUD is null!")
    if time_left < 0:
        game_over()  # end if the game's time is up.
```

It gave me some error about null references for $HUD. Changing it to `$scene_hud.update_timer(time_left)` worked though. 