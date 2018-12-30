func before_boot(root,mod_list):
	#do nothing
	pass

func boot(root,mod_list):
	print('boot example mod')
	root.add_child(load('res://mods/exampleMod/root.tscn').instance())

func after_boot(root,mod_list):
	#do nothing
	pass
