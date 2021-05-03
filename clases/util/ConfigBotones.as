package clases.util
{
	import flash.display.MovieClip;
	import fl.controls.Label;
	import flash.events.MouseEvent;
	import flash.system.fscommand;
	import flash.text.TextFormat;
	import fl.transitions.Fade;
	import fl.transitions.TransitionManager;
	import fl.transitions.Transition;

	public class ConfigBotones
	{	
		private var presentacion:MovieClip;
		private var lenguaje:Object;
		private var lecturaInfo:LecturaInfo;
		
		public function ConfigBotones(p: MovieClip, l:Object, li:LecturaInfo)
		{
			presentacion = p;
			lenguaje = l;
			lecturaInfo = li;
		}

		public function aplicarEventosEstilos(p: MovieClip):void {
			for (var c:int = 0; c < p.numChildren; c++){
				eventosEstilos(p, p.getChildAt(c));
			}
		}
		
		private function eventosEstilos(p: MovieClip, item:Object):void {
			var itemOver:Object = null;
			var nombre:Array = item.name.split(/_/);
			var fuente:String = "";
			var tamano:int = 0;
			if (nombre[0] == "Texto") {
				fuente = "CaslonNormal"
				switch(nombre[1]){
					case "Indice":
						tamano = 28; break;
					case "Titulo":
						tamano = 30; break;
					case "Contenido":
						tamano = 20; break;
					case "Nota":
						tamano = 20; break;				
				}
				setStyleTexto(Label(item), fuente, tamano);
			} else if (nombre[0] == "Boton" && item.name.substr(-4,4)!="Over") {
				itemOver = p.getChildByName(item.name+"_Over");
				switch(nombre[1]){
					case "Navegacion":
						fuente = "BerlinSansNormal";
						tamano = 22;  break;
					case "Interfaz":
						switch(nombre[2]){
							case "Omitir":
								fuente = "BerlinSansNormal";
								tamano = 25; break;
							case "Iniciar":
								fuente = "BerlinSansNormal";
								tamano = 42; break;							
						}; break;
					case "Informacion":
						fuente = "BerlinSansNormal";
						tamano = 35; break;
					case "Check":
						fuente = "BerlinSansNormal";
						tamano = 30; break;
				}
				aplicar(MovieClip(item), MovieClip(itemOver), fuente, tamano);
			}
		}

		private function aplicar(item: MovieClip, itemOver: MovieClip, fuente:String, tamano:int):void {
			if(itemOver.id !="checked"){
				itemOver.visible = false;
			}			
			mouseOverOut(item, itemOver);
			setStyle(item, fuente, tamano);
			setStyle(itemOver, fuente, tamano);	
		}
		
		private function mouseOverOut(item:MovieClip, itemOver:MovieClip):void {

			var _onHover:Function = onHover(item, itemOver);
			var _onOut:Function = onOut(item, itemOver);
			item.addEventListener(MouseEvent.ROLL_OVER, _onHover);
			itemOver.addEventListener(MouseEvent.ROLL_OUT, _onOut);
				
			var nombre:Array = itemOver.name.split(/_/);
			if (nombre[0] == "Boton"){
				if (nombre[1] == "Interfaz" || nombre[1] == "Navegacion" || nombre[1] == "Informacion"){
					var _opciones_botones:Function = opciones();
					itemOver.addEventListener(MouseEvent.CLICK, _opciones_botones);
				} else if (nombre[1] == "Check"){
					var _clickChecked:Function = clickChecked();
					itemOver.addEventListener(MouseEvent.CLICK, _clickChecked);
				}
			}
		}

		private function clickChecked():Function {
			return function(e:MouseEvent){
				if(e.currentTarget.id !="checked"){
					reiniciarCheck(MovieClip(e.currentTarget));			
				}
			};	
		}
		private function numCheckButtons(p:MovieClip):int 
		{
			var count:int = 0;
			for(var i:int = 0; i < p.numChildren; i++){
				var mc:MovieClip = MovieClip(presentacion.getChildAt(i));
				var tipo:String = mc.name.split(/_/)[0].toLocaleLowerCase();
				if (tipo == "boton"){
					var region:String = mc.name.split(/_/)[1].toLocaleLowerCase();
					if (region == "check"){
						count++;
					}
				}
			}	
			return count;
		}
		
		public function reiniciarCheck(itemOver:MovieClip):void 
		{
			var nombre:Array = itemOver.name.split(/_/);
			if (nombre[0] == "Boton"){
				if (nombre[1] == "Check"){
					var pos:int = parseInt(nombre[3]);
					var item:MovieClip = MovieClip(MovieClip(presentacion.getChildAt(0)).getChildByName("Boton_Check_Idioma_"+pos));
					check_unchecked("checked", item, itemOver);
					presentacion.setVariableIdioma(item.label.text);
					var variableChecked:int = presentacion.getVariableChecked();
					if (pos != variableChecked) {
						item = MovieClip(MovieClip(presentacion.getChildAt(0)).getChildByName("Boton_Check_Idioma_"+variableChecked));
						itemOver = MovieClip(MovieClip(presentacion.getChildAt(0)).getChildByName("Boton_Check_Idioma_"+variableChecked+"_Over"));
						check_unchecked("unchecked", item, itemOver);
						presentacion.setVariableChecked(pos);
						onOut_sub(item, itemOver);
					} else {
						onHover_sub(item, itemOver);
					}
				}
			}
			cambiarLenguaje(MovieClip(presentacion.getChildAt(0)));
		}
		private function check_unchecked(value:String, item:MovieClip, itemOver:MovieClip):void 
		{
			item.id = value;
			itemOver.id = value;
		}

		private function onHover(item:MovieClip, itemOver:MovieClip):Function {
			return function(e:MouseEvent){
				if(item.id !="checked"){
					onHover_sub(item, itemOver);
				}		
			};
		}
		private function onHover_sub(item:MovieClip, itemOver:MovieClip):void {
			var posx_1:int = item.x
			var posy_1:int = item.y
			var texto:String = item.label.text;
			var posx_2:int = itemOver.x
			var posy_2:int = itemOver.y
			item.x = posx_2;
			item.y = posy_2;
			itemOver.x = posx_1;
			itemOver.y = posy_1;
			itemOver.label.text = texto;
			item.visible = false;
			itemOver.visible = true;	
		}

		private function onOut(item:MovieClip, itemOver:MovieClip):Function {
			return function(e:MouseEvent){
				if(itemOver.id !="checked"){
					onOut_sub(item, itemOver);			
				}
			};
		}
		private function onOut_sub(item:MovieClip, itemOver:MovieClip):void {
			var posx_1:int = item.x
			var posy_1:int = item.y
			var posx_2:int = itemOver.x
			var posy_2:int = itemOver.y
			item.x = posx_2;
			item.y = posy_2;
			itemOver.x = posx_1;
			itemOver.y = posy_1;
			item.visible = true;
			itemOver.visible = false;	
		}

		private function opciones():Function {
			return function(e:MouseEvent){
				var boton:MovieClip = e.currentTarget;
				if (boton.name == "Boton_Informacion_Reglas_Over"){
					presentacion.gotoAndStop(4);
				} else if (boton.name == "Boton_Informacion_Arbitraje_Over"){
					presentacion.gotoAndStop(4);
				} else if (boton.name == "Boton_Informacion_Casos_Over"){
					presentacion.gotoAndStop(4);
				} else if (boton.name == "Boton_Informacion_IniciarLectura_Over"){
					presentacion.gotoAndStop(4);	
				} else if (boton.name == "Boton_Navegacion_Inicio_Over") {
					presentacion.gotoAndStop(2);
				} else if (boton.name == "Boton_Navegacion_Menu_Over") {
					presentacion.gotoAndStop(3);
				} else if (boton.name == "Boton_Interfaz_Iniciar_Over"){
					presentacion.gotoAndStop(3);
				} else if (boton.name == "Boton_Interfaz_Omitir_Over"){
					presentacion.gotoAndStop(2);
				} else if (boton.name == "Boton_Navegacion_Anterior_Over"){
					var indiceA:Array = presentacion.getVariableIndice();
					if(indiceA[3] > 0){
						indiceA[3]-=1;
						presentacion.setVariableIndice(getIndiceVecino("a", indiceA));
						lecturaInfo.actualizarInformacion(MovieClip(presentacion.getChildAt(0)));						
					}
				} else if (boton.name == "Boton_Navegacion_Siguiente_Over"){
					var indiceS:Array = presentacion.getVariableIndice();
					var limite:int = 5;
					if(indiceS[3] < limite){
						indiceS[3]+=1;
						presentacion.setVariableIndice(getIndiceVecino("s", indiceS));
						lecturaInfo.actualizarInformacion(MovieClip(presentacion.getChildAt(0)));						
					}
				} else if(boton.name == "Boton_Navegacion_Salir_Over"){
					if(boton.parent.name == "Despedida"){
						fscommand("quit");
					} else {
						presentacion.gotoAndStop(5);
					}
				}
				//hacerTransicion();
			}
		}
		private function getIndiceVecino(direccion:String, i:Array):Array{
			var indice:Array = i;
			return indice;
		}
		private function hacerTransicion():void
		{
			TransitionManager.start(MovieClip(presentacion.getChildAt(0)), {type:Fade, direction:Transition.IN, duration:0.25});
		}
		
		private function setStyle(item:MovieClip, font:String, size:int):void {
			var nombre:Array = item.name.split(/_/);
			if (nombre[0] == "Boton"){
				item.label.setStyle("textFormat", new TextFormat(font, size));
				item.label.setStyle("mouseEnabled", false);
				item.label.setStyle("embedFonts" , true);		
			}
		}

		private function setStyleTexto(item:Label, font:String, size:int):void {
			var nombre:Array = item.name.split(/_/);
			if (nombre[0] == "Texto"){
				item.setStyle("textFormat", new TextFormat(font, size));
				item.setStyle("mouseEnabled", false);
				item.setStyle("embedFonts" , true);		
			}
		}

		public function cambiarLenguaje(p: MovieClip):void {
			var variableIdioma:String = presentacion.getVariableIdioma();
			if (lenguaje.hasOwnProperty(variableIdioma.toLocaleLowerCase()))
				for (var c:int = 0; c < p.numChildren; c++){
					var mc:Object = p.getChildAt(c);
					var tipo:String = mc.name.split(/_/)[0].toLocaleLowerCase();
					if(tipo == "boton"){
						var region:String = mc.name.split(/_/)[1].toLocaleLowerCase();
						if(region != "check"){
							var label:String = mc.name.split(/_/)[2].toLocaleLowerCase();
							mc.label.text = lenguaje[variableIdioma.toLocaleLowerCase()][tipo][region][label];
						}
					}
				}
		}		
	}
}