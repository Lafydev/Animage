# Animage
<h1>Description:</h1>
Let your photos inspire your daily work. <br/>
You can create a slideshow with your desktop theme or your personal photos<br/>

- Modify your timer
- upload a new directory
- Pin the widget to the desktop or keep it above all other windows

<p align="center"><img src="screenshot.png"/> </p>

<a href="https://appcenter.elementary.io/com.github.lafydev.animage"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter"></a>

<h1>Build and install</h1>

Download the last release (zip) et extract files<br/>

<h2>Dependencies</h2>
These dependencies are needed for building : <br/>
<pre color="red">sudo apt-get install exiv2 </pre/> ( added for meta informations)

<pre>sudo apt-get install gcc valac gtk+-3.0 meson </pre/>

<h2>Build with meson/Construction:</h2>

Open a Terminal in the extracted folder, build your application with meson and install it with ninja:<br/>

<pre>meson build --prefix=/usr
cd build
ninja
sudo ninja install
</pre>

<h1>Uninstall (need the extracted files)</h1>
In the previous folder ( /build) run the command :<br/>

<code>sudo ninja uninstall</code>
