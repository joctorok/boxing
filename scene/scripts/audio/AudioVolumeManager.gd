extends Node

var CurrentVolume = 1.0

#var for the master AudioBus
var masterBus = AudioServer.get_bus_index("Master")

#Checks if current event is  "-" or "+"
func _input(event):
	if event.is_action_pressed("Volume_Down"):
		TurnVolumeDown()
	elif event.is_action_pressed("Volume_Up"):
		TurnVolumeUp()

#test fucntion to see if the volume goes up
func TurnVolumeUp():
	CurrentVolume + 10
	AudioServer.set_bus_volume_db(masterBus, CurrentVolume)
	pass
	
#test fucntion to see if the volume goes up
func TurnVolumeDown():
	CurrentVolume - 10
	AudioServer.set_bus_volume_db(masterBus, CurrentVolume)
	pass




