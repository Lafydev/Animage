/*
 * Copyright (c) 2020 Lafydev. ()
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 */
using Gtk;
using GLib;


public class Animage : Window {
  private string[] listeimg;
  private Image img;
  private Layout layout;
  private int count =0;
  private int delai=10;
  private bool ratio = true;
  private bool pinned= false;
 
    void Avance () {
	if (this.count< listeimg.length-1) {
			   this.count++;}
		   else {this.count=0;}
		   }
	
	void Recule () {
		int c;
		c=this.count;
		if (c!=0) {c--;}
		 else {c=listeimg.length-1;}
		this.count=c;
		}
		   	   
	void ChangeImage (int count) {
	//affiche l'image en cours
    string fich = this.listeimg[count];
    if (this.listeimg[count]!=null) {
		
	try {	
		  //x,y = (layout) width,height
		  uint x,y;
		  this.layout.get_size(out x,out y);	
		 // layout.margin=8;
		 //print("ratio %s",(this.ratio).to_string());
		  if (this.ratio)
			 { //preserve ratio
			  Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file_at_scale (fich,(int) x,-1,true); 
			  img.set_from_pixbuf (pixbuf);
			  //recadrer
			  layout.move(this.img,10,((int)y-pixbuf.height)/2);
			} else
			{
			//rogner
			Gdk.Pixbuf pixbuf = new Gdk.Pixbuf.from_file (fich);
			int ratio_x=1;
			if (pixbuf.width>pixbuf.height) 
				{ ratio_x= (pixbuf.width/pixbuf.height) * (int)x ;}
			else
				{ ratio_x= (pixbuf.height/pixbuf.width) * (int)x ;}
			pixbuf= pixbuf.scale_simple (ratio_x, (int) y,Gdk.InterpType.BILINEAR);
			
			img.set_from_pixbuf (pixbuf);	
			layout.move(this.img,10,0);
			
		}
		  this.count=count; //a pu être modifié
		  this.layout.tooltip_text="image "+ count.to_string();
			  
		} catch (Error e) {
			stdout.printf("Error %s\n",e.message);
		} 
	}
   }
   
	void ChargeRep (string rep ) {
		//charge le tableau d'images à animer
		try {
				Dir dir = Dir.open (rep, 0);
				string? name = null;
				while ((name = dir.read_name ()) != null) {
					File fich = File.new_for_path (rep+"/"+name);
					//prendre slt les images
					if (fich.query_exists ()) {
						var file_info = fich.query_info ("*", FileQueryInfoFlags.NONE);
						//stdout.printf ("Content type: %s\n", file_info.get_content_type ());
			
						if ("image" in file_info.get_content_type ()) { 
							if (this.listeimg[0]==null) 
							{this.listeimg[0] = (rep+"/"+name) ;}
							else {
						this.listeimg+=(rep+"/"+name);
					}
					}
				}
				
				}
			} catch (Error e)
			{print("Erreur %s",e.message );}
				
			}
		
  public Animage () {
	    this.listeimg={};
		this.title = "Animages";
		this.set_keep_above(true);
		this.set_position (Gtk.WindowPosition.CENTER);
		
		this.set_default_size (350,300);
		this.move (0, 200); //a gche
		
		//this.set_decorated(false);//pas de bordure
		this.set_resizable(true); //redim
		this.destroy.connect (Gtk.main_quit);
		this.border_width = 5; //marge intérieure  
		
		
		var box = new Gtk.Box(Gtk.Orientation.VERTICAL,5);
		var toolbar = new Gtk.ActionBar();
		toolbar.get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);
	    box.pack_end(toolbar,false,true);
 		
 		//*******************************************
 		// pinned = always below + no border
 		//*******************************************
 		var ico_pin = new Gtk.Image.from_icon_name("view-pin-symbolic",IconSize.SMALL_TOOLBAR);
 		var btn_pin = new Gtk.ToggleButton();
 		btn_pin.image=ico_pin;
 		btn_pin.has_tooltip = true;
		btn_pin.tooltip_text = "Attaché";
		btn_pin.active =true;
		
 		toolbar.pack_end(btn_pin);
 		
 		var ico_ouvrir = new Gtk.Image.from_icon_name("document-open",IconSize.SMALL_TOOLBAR);
 		var btn_ouvrir = new Gtk.ToolButton(ico_ouvrir, "Ouvrir");
		btn_ouvrir.tooltip_text = "Changer de répertoire";
 		toolbar.pack_start(btn_ouvrir);
 		
		//***********************************************
 		//sous menu pour delai
 		//***********************************************
 		var box_delai = new Gtk.Box(Gtk.Orientation.HORIZONTAL,5);
 		var lbldelai= new Label("Délai en secondes");
 		box_delai.add(lbldelai);
 		var spin = new Gtk.SpinButton.with_range(5,60,1);
		spin.adjustment.value=delai;
		
		box_delai.add(spin);
        box_delai.show_all();
        
        var popover_delai = new Popover (null);
        popover_delai.add (box_delai);
        
 		var ico_delai = new Gtk.Image.from_icon_name("appointment",IconSize.SMALL_TOOLBAR);
		var btn_delai = new Gtk.MenuButton();
		btn_delai.has_tooltip = true;
		btn_delai.tooltip_text = "Délai";
		btn_delai.image=ico_delai;
		btn_delai.set_popover(popover_delai);
 		toolbar.pack_end(btn_delai);
 		
 		//***********************************************
 		//sous menu pour btn_ratio
 		//***********************************************
 		var item1 = new Gtk.RadioButton.with_label (null,"Garder ratio");
 		item1.margin = 5;
		var item2 = new Gtk.RadioButton.with_label (item1.get_group (),"Remplir");
		item2.margin = 5;
		item1.set_active(true);

        var boxmnu = new Gtk.Box(Gtk.Orientation.VERTICAL,5);
        boxmnu.add (item1);
        boxmnu.add (item2);
        boxmnu.show_all();
        
        var popover = new Popover (null);
        popover.add (boxmnu);
 		
 		var ico_ratio = new Gtk.Image.from_icon_name("zoom-best-fit",IconSize.SMALL_TOOLBAR);
		var btn_ratio = new Gtk.MenuButton();
		btn_ratio.has_tooltip = true;
        btn_ratio.image=ico_ratio;
		btn_ratio.tooltip_text = "Ratio";
		
		btn_ratio.set_popover(popover);
 		toolbar.pack_end(btn_ratio);
 		
		//var boxH = new Gtk.Box(Gtk.Orientation.HORIZONTAL,5);
		var btn_moins= new Gtk.Button.with_label("-");
		btn_moins.tooltip_text = "Image précédente";
		toolbar.pack_start(btn_moins);
		
		//fonds écran
		var paththeme= Environment.get_user_data_dir() +"/backgrounds";
		this.layout = new Layout();
		layout.set_size(300,250);
		this.img = new Gtk.Image();
		layout.put(this.img,0,0);
		
		
		var btn_plus= new Gtk.Button.with_label("+");
		btn_plus.tooltip_text = "Image suivante";
		toolbar.pack_start(btn_plus);
		
	    box.pack_start(layout,true,true);
	 
	    // charge les fonds écran
		ChargeRep(Environment.get_user_data_dir() +"/backgrounds");
	    ChangeImage(0);
	   
		//signaux 
		btn_moins.clicked.connect( ()=> {
			Recule();
		   ChangeImage(count);
			});
		btn_plus.clicked.connect( ()=> {
			Avance();
		   ChangeImage(this.count);
			});
			
		btn_ouvrir.clicked.connect( ()=> {
			var dialogue=new Gtk.FileChooserDialog("Ouvrir...",this,
			 Gtk.FileChooserAction.SELECT_FOLDER,
			"_Annuler",Gtk.ResponseType.CANCEL,
			"_Ouvrir",Gtk.ResponseType.ACCEPT);
			dialogue.set_filename (paththeme);

			if (dialogue.run()==Gtk.ResponseType.ACCEPT) 
				{
				listeimg= new string[1];
				var rep = dialogue.get_uri().substring(7); //extrait ///file
				
				ChargeRep(rep);
				ChangeImage(0);
			}	
			dialogue.destroy();	
		});	
	   
	    btn_delai.clicked.connect( ()=> {
			delai=(int)spin.adjustment.value;
			//print("nouveau délai:%lg",spin.adjustment.value);
			
		});
		
	    btn_ratio.clicked.connect( ()=> {
			this.ratio=item1.active;
			print (ratio.to_string());
			//recadrer
			ChangeImage(count);
		});
		
	    btn_pin.clicked.connect( ()=> {	
			pinned =!(pinned);
			if (pinned==true) {
				this.set_keep_below(true);
				btn_pin.tooltip_text="Toujours dessous";
				btn_pin.relief=Gtk.ReliefStyle.NONE;
			}
			else
			{this.set_keep_above(true);
			btn_pin.tooltip_text="Toujours dessus";
			btn_pin.relief=Gtk.ReliefStyle.NONE;
			}
			ChangeImage(count);
		});
    
	  	layout.size_allocate.connect ((event) => {
			layout.set_size(event.width,event.height);
			print("layout width: %u height %u\n",layout.width,layout.height);
            ChangeImage(count);
        });
	  
		 this.add(box);
         
        }
    
        public static int main (string[] args) {
			Gtk.init (ref args);
            var window = new Animage ();
            window.show_all ();
            
            Timeout.add_seconds(window.delai,()=>{
				window.Avance();
				window.ChangeImage(window.count);
				return true;
			
			});
		Gtk.main();
            return 0;
           
        }
  }

