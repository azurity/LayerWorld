static func load_mods(root):
	var dir = Directory.new()
	if dir.open('./mods') != OK:
		print(TranslationServer.translate('can_not_open_folder'))
		OS.alert(tr('can_not_open_folder') % 'mods')
		get_tree().quit()
	dir.list_dir_begin()
	var mod_list = []
	var file_name = dir.get_next()
	while file_name != '':
		if !dir.current_is_dir() and file_name.substr(file_name.length()-4,4) == '.pck':
			var mod_name = file_name.substr(0,file_name.length()-4)
			ProjectSettings.load_resource_pack('res://mods/%s.pck' % mod_name)
			var mod_script = null
			if dir.file_exists('res://mods/%s/boot.gdc' % mod_name):
				mod_script = load('res://mods/%s/boot.gdc' % mod_name).new()
			else:
				print('warning: %s has no boot script' % mod_name)
			mod_list.append({'name':mod_name,
					'script':mod_script,
					'before_loaded':false,
					'loaded':false,
					'after_loaded':false})
			print(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	print(mod_list)
	load_pass(root,mod_list,'before_')
	load_pass(root,mod_list,'')
	load_pass(root,mod_list,'after_')
	pass
	
static func load_pass(root,mod_list,stage):
	for mod in mod_list:
		if !mod[stage+'loaded']:
			print('%sloading: %s' % [stage,mod['name']])
			if mod['script'].has_method(stage+'boot'):
				mod['script'].call(stage+'boot',root,mod_list)
			mod[stage+'loaded'] = true
	pass