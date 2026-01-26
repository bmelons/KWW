extends HitscanWeapon


@export var altHand:Texture2D

var a = false
var blow = {
	true:Main.player.bulletpoint2,
	false:Main.player.bulletpoint
}

func _ready():
	hitscan_exceptions()
	Camera = Main.player.cam
	Main.player.rh.texture = hand
	Main.player.lh.texture = altHand
	Main.player.icon.frame = iconFrame

func _add_fire():
	a = not a
	beamorigin = blow[a]
