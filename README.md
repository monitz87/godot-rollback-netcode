This is a very quick and dirty port of the Godot Rollback Netcode addon by David Snopek to Godot 4. It's based on this fork: https://github.com/maximkulkin/godot-rollback-netcode

It was made for prototyping and testing purposes, and shouldn't be considered production ready code. Most of what I did was making sure the log inspector didn't crash and allowed loading logs and viewing replays.

Caveats:

- Only tested in OSX on a Macbook Pro M1
- When clicking the "Add Logs" button in the log inspector, the editor window will minimize. I didn't have the time or disposition to try and fix this, but you can un-minimize the editor and it will work as intended
- I modified the demo for my purposes, but had to disable monitoring on Area2D nodes because collisions were causing state mismatches when introducing uneven rollbacks on both clients. This is probably due to the Physics engine not being able to step manually on every simulated tick, but it also happens when the addon skips frames. As it is, neither bullets or players are detecting collisions and as such the "score" mechanic I introduced isn't working
