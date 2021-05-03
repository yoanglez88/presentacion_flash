package clases.libro {
	
	public class Libro
	{
		private var id:int;
		private var titulo:String;
		private var items:Array;
		private var contenido:Array;
		
		public function Libro(id, titulo, contenido)
		{
			this.id = id;
			this.titulo = titulo;
			this.items = new Array();
			this.contenido = contenido;
		}
		public function get_id():int
		{
			return this.id;
		}			
		public function get_titulo():String
		{
			return this.titulo;
		}		
		public function set_item(item:Object):void
		{
			this.items.push(item);
		}		
		public function get_item(pos:int):Object
		{
			return this.items[pos];
		}
		public function get_contenido(pos:int):Object
		{
			return this.contenido[pos];
		}		
	}
	
}
