package clases.util
{
	import flash.display.MovieClip;

	public class LecturaInfo
	{
		private var informacion:Array;
		private var presentacion:MovieClip;
		
		public function LecturaInfo(p: MovieClip, i:Array)
		{
			presentacion = p;
			informacion = i;
		}
		
		public function actualizarInformacion(p:MovieClip):void 
		{
			var indice:Array = presentacion.getVariableIndice();
			var idioma:int = presentacion.getVariableChecked() - 1;
			//presentacion.setVariableIndice(indice);
			trace(indice[3]);
			//trace(informacion[idioma].get_item(indice[0]).get_contenido(0).get_text()) //regla
			//trace(informacion[idioma].get_item(indice[0]).get_item(indice[1]).get_contenido(0).get_text()) //albitraje
			//trace(informacion[idioma].get_item(indice[0]).get_item(indice[1]).get_item(indice[2]).get_contenido(0).get_text()) //caso
			//trace(informacion[idioma].get_item(indice[0]).get_item(indice[1]).get_item(indice[2]).get_item(indice[3]).get_contenido(0).get_text()) //decision
		}		
	}
}