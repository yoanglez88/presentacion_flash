package clases.util
{
	import flash.events.Event;
	import clases.contenido.*;
	import clases.libro.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Carga
	{	
		private var lenguaje:Object;
		private var informacion:Array;
		
		public function Carga()
		{
			informacion = new Array();
			iniciarInformacion("idioma", ".", "indice_idioma.txt");
			
			lenguaje = new Object();
			lenguajeInterfaz();			
		}
		
		public function getInformacion(){
			return informacion;
		}
		
		public function getLenguaje(){
			return lenguaje;
		}
		
		private function iniciarInformacion(idIndex:String, directorio:String, file:String):void
		{
			var loader:URLLoader = new URLLoader();
			var _cargaInformacion:Function = cargaInformacion(idIndex);
			loader.addEventListener(Event.COMPLETE, _cargaInformacion);	
			loader.load(new URLRequest("informacion/"+directorio+"/"+file));
		}

		private function cargaInformacion(id:String):Function {
			return function(evt : Event):void
			{
				var result:Array = parse(evt.target.data);
				for each (var item:Object in result)
				{
					var idIndex:String = "";
					var directorio:String = "";
					var contenido:Array = new Array();
					if (id == "idioma"){
						var lenguaje:Lenguaje = new Lenguaje(item.id, item.info, contenido);
						informacion.push(lenguaje);
						idIndex = "regla_"+get_total_nombre(parseInt(item.id))+"_idioma";
						directorio = item.id;
						iniciarInformacion(idIndex, directorio, "indice_reglas.txt");
					}
					else if (id.substr(0,5) == "regla"){
						idIndex = "arbitraje_"+get_total_nombre(parseInt(item.id))+"_regla_"+id.substr(6,3)+"_idioma";
						directorio = parseInt(id.substr(6,3)).toString()+"/"+item.id;
						iniciarContenido(item, id, directorio+"/"+"contenido_regla.txt");
						iniciarInformacion(idIndex, directorio, "indice_arbitraje.txt");
					}
					else if (id.substr(0,9) == "arbitraje"){
						idIndex = "caso_"+get_total_nombre(parseInt(item.id))+"_arbitraje_"+get_total_nombre(parseInt(id.substr(10,3)))+"_regla_"+get_total_nombre(parseInt(id.substr(20,3)))+"_idioma";
						directorio = parseInt(id.substr(20,3)).toString()+"/"+parseInt(id.substr(10,3)).toString()+"/"+item.id;
						iniciarContenido(item, id, directorio+"/"+"contenido_arbitraje.txt");
						iniciarInformacion(idIndex, directorio, "indice_casos.txt");
					}
					else if (id.substr(0,4) == "caso"){
						idIndex = "decision_"+get_total_nombre(parseInt(item.id))+"_caso_"+get_total_nombre(parseInt(id.substr(5,3)))+"_arbitraje_"+get_total_nombre(parseInt(id.substr(19,3)))+"_regla_"+get_total_nombre(parseInt(id.substr(29,3)))+"_idioma";
						directorio = parseInt(id.substr(29,3)).toString()+"/"+parseInt(id.substr(19,3)).toString()+"/"+parseInt(id.substr(5,3)).toString()+"/"+item.id;
						iniciarContenido(item, id, directorio+"/"+"contenido_caso.txt");
						iniciarInformacion(idIndex, directorio, "indice_decision.txt");
					}
					else if (id.substr(0,8) == "decision"){
						directorio = parseInt(id.substr(42,3)).toString()+"/"+parseInt(id.substr(32,3)).toString()+"/"+parseInt(id.substr(18,3)).toString()+"/"+parseInt(id.substr(9,3)).toString()+"/"+item.id;
						iniciarContenido(item, id, directorio+"/"+"contenido_decision.txt");
					}
				}
			};
		}

		private function iniciarContenido(item:Object, id:String, file:String):void
		{
			var loader:URLLoader = new URLLoader();
			var _cargaContenido:Function = cargaContenido(item, id);
			loader.addEventListener(Event.COMPLETE, _cargaContenido);	
			loader.load(new URLRequest("informacion/"+file));
		}

		private function cargaContenido(item:Object, id:String):Function {
			return function(evt : Event):void
			{
				var contenido:Array = parse(evt.target.data);
				if (id.substr(0,5) == "regla"){
					var regla:Regla = new Regla(item.id, item.info, contenido);
					informacion[parseInt(id.substr(6,3))-1].set_item(regla);
				}
				else if (id.substr(0,9) == "arbitraje"){
					var arbitraje:Arbitraje = new Arbitraje(item.id, item.info, contenido);
					informacion[parseInt(id.substr(20,3))-1].get_item(parseInt(id.substr(10,3))-1).set_item(arbitraje);
				}
				else if (id.substr(0,4) == "caso"){
					var caso:Caso = new Caso(item.id, item.info, contenido);
					informacion[parseInt(id.substr(29,3))-1].get_item(parseInt(id.substr(19,3))-1).get_item(parseInt(id.substr(5,3))-1).set_item(caso);
				}
				else if (id.substr(0,8) == "decision"){
					var decision:Decision = new Decision(item.id, item.info, contenido);
					informacion[parseInt(id.substr(42,3))-1].get_item(parseInt(id.substr(32,3))-1).get_item(parseInt(id.substr(18,3))-1).get_item(parseInt(id.substr(9,3))-1).set_item(decision);
				}
			}
		}

		private function get_total_nombre(total:int):String
		{
			var total_nombre:String = "";
			if (total < 10){
				total_nombre = "00" + total;
			}
			else if (total > 9 && total < 100){
				total_nombre = '0' + total;
			}else if (total > 99){
				total_nombre = total.toString();
			}
			return total_nombre;
		}

		private function parse(cadena:String):Array
		{
			var items:Array = new Array();
			var lines:Array = cadena.split(/\n/);
			for each (var line:String in lines)
			{
				var multimedia:Multimedia = null;
				var item:Object = new Object();
				var tipo:String = '';
				var url:String = '';
				var text:String = '';
				line = line.replace(/^\s+/,'').replace(/\s+$/,'');
				if (line != '' )
				{
					if (parseInt(line.substr(0,1)))
					{
						item.id = line.substr(0,1);
						item.info = line.replace(/^[0-9]+\s+/,'');
						items.push(item);
					}
					else if (line.substr(0,5) == 'video')
					{
						tipo = 'video';
						url = line.replace(/^(video)\s+/,'');				
						multimedia = new Multimedia(tipo, url);
						items.push(multimedia);
					}
					else if (line.substr(0,6) == 'imagen')
					{
						tipo = 'imagen';
						url = line.replace(/^(imagen)\s+/,'');				
						multimedia = new Multimedia(tipo, url);
						items.push(multimedia);
					}
					else
					{
						tipo = 'texto';
						text = line.replace(/^(texto)\s+/,'');				
						var texto:Texto = new Texto(tipo, text);
						items.push(texto);
					}			
				}
			}
			return items;
		}


		private function lenguajeInterfaz(): void {
			var loader:URLLoader = new URLLoader();
			var _cargaLenguaje:Function = cargaLenguaje();
			loader.addEventListener(Event.COMPLETE, _cargaLenguaje);	
			loader.load(new URLRequest("informacion/lenguaje_interfaz.xml"));
		}

		private function cargaLenguaje():Function {
			return function (e : Event){
				var presentaciones:XML = new XML(e.target.data);
				for each(var l in presentaciones.lenguaje){
					lenguaje[l.attribute("id")]= {};
					for each(var t in l.tipo){
						lenguaje[l.attribute("id")][t.attribute("id")]= {};
						for each(var r in t.region){
							lenguaje[l.attribute("id")][t.attribute("id")][r.attribute("id")]= {};
							for each(var i in r.item){
								lenguaje[l.attribute("id")][t.attribute("id")][r.attribute("id")][i.attribute("id")]=i.text();
							}
						}
					}
				}
			};
		}		
	}
}