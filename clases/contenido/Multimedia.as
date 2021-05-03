package clases.contenido {
	
	public class Multimedia extends Contenido
	{
		private var url:String;
		
		public function Multimedia(tipo, url)
		{
			super(tipo);
			this.url = url;
		}
		public function get_url():String
		{
			return this.url;
		}		
	}
}
