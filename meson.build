project('com.github.lafydev.animage', 'vala', 'c', version: '0.1.0')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
]

sources = files('src/animage.vala')

executable(meson.project_name(), sources, dependencies: dependencies, install: true)

install_data(
        join_paths('data/icons', meson.project_name() +'.png'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor','48x48','apps')
    )
       
#installation du .desktop vers le menu applications
install_data( 
	join_paths('data',meson.project_name()+'.desktop'),
	install_dir: join_paths(get_option('datadir'),'applications')
)
#installation du xml 
install_data(
	join_paths('data',meson.project_name()+'.appdata.xml'),
	install_dir: join_paths(get_option('datadir'),'metainfo')
)
meson.add_install_script('meson/post_install.py')
