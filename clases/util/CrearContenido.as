package clases.util
{
	import flash.display.MovieClip;
	import fl.video.FLVPlayback;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class CrearContenido
	{
		private var presentacion:MovieClip;
		private var configBotones:ConfigBotones;
		private var lenguaje:Object;
		private var lecturaInfo:LecturaInfo;
		
		public function CrearContenido(p: MovieClip, l:Object, li:LecturaInfo)
		{
			presentacion = p;
			lenguaje = l;
			lecturaInfo = li;
			configBotones = new ConfigBotones(presentacion, lenguaje, lecturaInfo);
		}
		public function adicionarVideo(p:MovieClip, video:String, posx:int, posy:int):void {
			var reproductor:FLVPlayback = new FLVPlayback();
			reproductor.source = "galeria/videos/"+video;
			reproductor.skin = "galeria/skinPlayer.swf";
			reproductor.autoPlay = true;
			reproductor.autoRewind = true;
			reproductor.skinBackgroundAlpha = 0.5;
			reproductor.skinAutoHide = true;
			reproductor.width = 325;
			reproductor.height = 240;
			reproductor.x = posx;
			reproductor.y = posy;			
			reproductor.fullScreenTakeOver = false;
			reproductor.skinBackgroundColor = 666666;
			p.addChild(reproductor);	
		}
		
		public function puntero():void
		{
			var cursor:Bitmap = new Recursos.Cursor();
			var _mouseMove:Function = mouseMove(cursor);
			presentacion.stage.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMove);
			Mouse.hide();
			presentacion.stage.addChild(cursor);
		}
		private function mouseMove(cursor:Bitmap):Function {
			return function (e:MouseEvent){
				cursor.x = presentacion.stage.mouseX;
				cursor.y = presentacion.stage.mouseY;
				e.updateAfterEvent();
			};
		}

		public function listaIdioma(p:MovieClip, informacion:Array):void {
			var itemId:int = 1;
			for each (var item:Object in informacion){
				var mc:MovieClip = MovieClip(p.getChildByName("Boton_Check_Idioma_"+itemId));
				var mcOver:MovieClip = MovieClip(p.getChildByName("Boton_Check_Idioma_"+itemId+"_Over"));
				mc.label.text = item.get_titulo();
				mcOver.label.text = item.get_titulo();
				itemId++;
			}
			for(var i:int = itemId; i <= 3; i++){
				var check:MovieClip = MovieClip(p.getChildByName("Boton_Check_Idioma_"+i));
				p.removeChild(check);
			}
			var itemOver:MovieClip = MovieClip(p.getChildByName("Boton_Check_Idioma_"+presentacion.getVariableChecked()+"_Over"));
			configBotones.reiniciarCheck(itemOver);
		}
	}
}