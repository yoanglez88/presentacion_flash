package clases.contenido {
	
	public class Contenido
	{
		private var tipo:String;//nota, texto, imagen, video
		
		public function Contenido(tipo) {
			this.tipo = tipo;
		}
		public function get_tipo():String
		{
			return this.tipo;
		}
	}
}
