package clases.contenido {

	public class Texto extends Contenido
	{	
		private var text:String;

		public function Texto(tipo, text)
		{
			super(tipo);
			this.text = text;
		}
		public function get_text():String
		{
			return this.text;
		}		
	}
}