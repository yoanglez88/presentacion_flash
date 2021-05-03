package clases {
		import clases.libro.*;
		import clases.contenido.*;
		import clases.util.*;
		import flash.display.MovieClip;
		import flash.display.StageScaleMode;
		import flash.display.StageDisplayState;
	
	public class Principal extends MovieClip
	{
		private var lenguaje:Object;
		private var informacion:Array;
		
		private var variableIdioma:String;
		private var variableChecked:int;
		private var variableIndice:Array;
		
		private var crearContenido:CrearContenido;
		private var configBotones:ConfigBotones;
		private var lecturaInfo:LecturaInfo;
		

		public function Principal()
		{
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			
			variableChecked = 1;
			variableIdioma = "Español";
			variableIndice = new Array(0, 0, 0, 0);

			var carga = new Carga();
			informacion = carga.getInformacion();
			lenguaje = carga.getLenguaje();
			
			lecturaInfo = new LecturaInfo(this, informacion);
			
			crearContenido = new CrearContenido(this, lenguaje, lecturaInfo);
			crearContenido.puntero();
			
			configBotones = new ConfigBotones(this, lenguaje, lecturaInfo);
			
			gotoAndStop(1);
		}
		public function getVariableChecked():int{
			return variableChecked;
		}
		public function setVariableChecked(checked:int):void{
			variableChecked = checked;
		}
		public function getVariableIdioma():String{
			return variableIdioma;
		}
		public function setVariableIdioma(idioma:String):void{
			variableIdioma = idioma;
		}
		public function getVariableIndice():Array{
			return variableIndice;
		}
		public function setVariableIndice(indice:Array):void{
			variableIndice = indice;
		}		
	}
}