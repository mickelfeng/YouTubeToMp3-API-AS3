package
{
	import com.youtubetomp3api.events.YoutubeToMp3Event;
	import com.youtubetomp3api.YoutubeToMp3;
	import flash.display.Sprite;
	import flash.media.Sound;
	
	public class Example extends Sprite
	{
		private var youtube:YoutubeToMp3;
		
		/**
		 * Example of use YoutubeToMp3 API
		 * @author Wenderson Pires da Silva - http://www.wpdas.com.br
		 */
		public function Example()
		{
			youtube = new YoutubeToMp3();
			
			//Error in request
			youtube.addEventListener(YoutubeToMp3Event.ERROR, errorFile);
			
			//Request complete
			youtube.addEventListener(YoutubeToMp3Event.REQUEST_COMPLETE, complete);
			
			//Waiting for request of file
			youtube.addEventListener(YoutubeToMp3Event.WAITING, onWaiting);
			
			//Conversion not allowed
			youtube.addEventListener(YoutubeToMp3Event.CONVERSION_NOT_ALLOWED, noAllowed);
			
			//Getting vídeo youtube to convert in mp3 file.
			youtube.getUrl("http://www.youtube.com/watch?v=hqPm-dVRKyw");
		}
		
		private function noAllowed(e:YoutubeToMp3Event):void 
		{
			trace("Conversion not allowed!");
		}
		
		private function onWaiting(e:YoutubeToMp3Event):void 
		{
			trace("Waiting file...");
		}
		
		private function complete(e:YoutubeToMp3Event):void 
		{
			trace("Title: " + youtube.title);
			
			var s:Sound = new Sound(youtube.file);
			s.play();
			
			//...etc
		}
		
		private function errorFile(e:YoutubeToMp3Event):void 
		{
			trace("Error");
		}
	}
}