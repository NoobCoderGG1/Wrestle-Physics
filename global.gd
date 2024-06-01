extends Node

var callback_rewarded_ad = JavaScript.create_callback(self, "_rewarded_ad")
var callback_ad = JavaScript.create_callback(self, "_ad")

onready var win = JavaScript.get_interface("window")

func js_show_ad():
	win.showAd(callback_ad)
func js_show_rewarded_ad():
	win.showRewardVideo(callback_rewarded_ad)

func _rewarded_ad(args):
	print(args[0])
func _ad(args):
	print(args[0])
