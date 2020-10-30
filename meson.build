project('com.github.lafydev.animage', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
	dependency('gio-2.0'),
]

sources = files('src/animage.vala')

#install exe in usr/bin
executable(meson.project_name(), sources, dependencies: dependencies, install: true)

#install icon png
install_data(
        join_paths('data/icons', meson.project_name() +'.png'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor','48x48','apps')
    )
       
#translate and install .desktop 
i18n.merge_file(
	input:	join_paths('data',meson.project_name()+'.desktop.in'),
	output: meson.project_name() +'.desktop',
	po_dir: join_paths(meson.source_root(),'po'),
	type: 'desktop',
	install: true,
	install_dir: join_paths(get_option('datadir'),'applications')
)
#translate and install appdata.xml 
i18n.merge_file(
	input:
	join_paths('data',meson.project_name()+'.appdata.xml.in'),
	output: meson.project_name()+ '.appdata.xml',
	po_dir: join_paths(meson.source_root(),'po'),
	install:true,
	install_dir: join_paths(get_option('datadir'),'metainfo')
)
#meson in po
subdir('po')

meson.add_install_script('meson/post_install.py')
