extends Node
"""
This singleton’s only purpose is to list signals that can be emitted 
and connected to. A “deeply” nested node like $Game/Party/Godette/Walk 
could then emit the appropriate signal directly using the global Events 
node: 
	EventBus.emit_signal('party_walk_started', {destination = destination}) 

Other nested nodes could connect to these signals: 
	EventBus.connect('party_walk_started', self, '_on_Party_walk_started')
"""
# warning-ignore-all:unused_signal
signal start_turn(unit)
signal end_turn(unit)

signal game_init
signal unit_turns_loaded
signal exit_level
signal ability_gained(ability)

signal play_button_pressed
signal update_player_log(new_line)
