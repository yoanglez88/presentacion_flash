package clases.util
{
	public class Recursos
	{		
		[Embed(source="../../recursos/fuentes/BerlinSansNormal.ttf", fontName = "BerlinSansNormal", mimeType = "application/x-font", advancedAntiAliasing="true", embedAsCFF="false")]
		var BerlinSansNormal:Class;

		[Embed(source="../../recursos/fuentes/CaslonNormal.ttf", fontName = "CaslonNormal", mimeType = "application/x-font", advancedAntiAliasing="true", embedAsCFF="false")]
		var CaslonNormal:Class;
		
		[Embed(source="../../recursos/cursor/cursor.png")]
		public static const Cursor:Class;		
	}
}