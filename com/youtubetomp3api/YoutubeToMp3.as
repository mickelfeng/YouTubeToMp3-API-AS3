package com.youtubetomp3api
{
	/*
	Copyright (c) 2013 Wenderson Pires da Silva | http://www.wpdas.com.br

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	ATTENTION: API of "youtube-mp3.org" site is being used.
	*/
	
	import com.youtubetomp3api.events.YoutubeToMp3Event;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.setInterval;
	
	public class YoutubeToMp3 extends EventDispatcher
	{
		//Constantes
		private const FIRST_REQUEST:String = "http://www.youtube-mp3.org/api/pushItem/?item=";
		private const SECOND_REQUEST:String = "http://www.youtube-mp3.org/api/itemInfo/?video_id=";
		private const THIRD_REQUEST:String = "http://www.youtube-mp3.org/get?video_id=";
		private const STATUS_SERVING:String = " serving";
		private const STATUS_LOADING:String = " loading";
		private const STATUS_CONVERTING:String = " converting";
		private const STATUS_PENDING:String = " pending";
		private const ERROR_FUNCTION:String = "pushItemYTError();";
		
		private var methodUrl:URLRequest;
		private var methodGet:URLLoader;
		private var request:String = "";
		private var video_id:String = "";
		private var pattern:RegExp = /"/gi;
		private var pattern2:RegExp = /{/gi;
		private var pattern3:RegExp = /}/gi;
		private var pattern4:RegExp = /;/gi;
		private var pattern5:RegExp = / /gi;
		private var jsonDecode:Array = new Array();
		private var json:Object;
		private var interval:uint;
		
		/**
		 * API youtube-mp3.org AS3
		 * @author Wenderson Pires da Silva
		 * @version 1.0
		 */
		public function YoutubeToMp3()
		{
			methodUrl = new URLRequest();
			methodUrl.method = URLRequestMethod.GET;
			methodGet = new URLLoader();
			methodGet.addEventListener(Event.COMPLETE, onCompleteRequest);
			methodGet.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			dispatchEvent(new YoutubeToMp3Event(YoutubeToMp3Event.ERROR));
			
			//Reset
			methodGet = new URLLoader();
			methodGet.addEventListener(Event.COMPLETE, onCompleteRequest);
			methodGet.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		private function onCompleteRequest(e:Event):void 
		{
			methodGet.removeEventListener(Event.COMPLETE, onCompleteRequest);
			methodGet.addEventListener(Event.COMPLETE, onRequestVideoIdComplete);
			
			video_id = methodGet.data;
			
			request = SECOND_REQUEST + video_id;
			methodUrl.url = request;
			methodGet.load(methodUrl);
		}
		
		private function onRequestVideoIdComplete(e:Event):void 
		{
			methodGet.removeEventListener(Event.COMPLETE, onRequestVideoIdComplete);
			
			//Verify license permitions:
			if (String(methodGet.data) == ERROR_FUNCTION)
			{
				dispatchEvent(new YoutubeToMp3Event(YoutubeToMp3Event.CONVERSION_NOT_ALLOWED));
				
			} else {
				
				jsonDecode = String(methodGet.data).replace(pattern, "").slice(7).replace(pattern2, "").replace(pattern3, "").replace(pattern4, "").split(",");
				
				json = new Object();
				
				for (var i:uint = 0; i < jsonDecode.length; i++)
				{
					json[String(String(jsonDecode[i]).split(":")[0]).replace(pattern5, "")] = String(jsonDecode[i]).split(":")[1];
				}
				
				//Init download process...
				download();
			}
		}
		
		private function download():void
		{	
			if (json.status == STATUS_SERVING)
			{
				dispatchEvent(new YoutubeToMp3Event(YoutubeToMp3Event.REQUEST_COMPLETE));
			}
			else if (json.status == STATUS_LOADING || json.status == STATUS_CONVERTING || json.status == STATUS_PENDING)
			{
				dispatchEvent(new YoutubeToMp3Event(YoutubeToMp3Event.WAITING));
				
				//5 sec to re-verify...
				interval = setInterval(download, 5000);
			}
		}
		
		/**
		 * Title of file/video. Should only be called when the request is complete!
		 */
		public function get title():String { return String(json.title); }
		
		/**
		 * File .mp3 to download. Should only be called when the request is complete!
		 */
		public function get file():URLRequest
		{
			methodUrl.url = THIRD_REQUEST + video_id + "&h=" + String(json.h).replace(pattern5, "");
			return methodUrl;
		}
		
		/**
		 * Get video on youtube to convert in .mp3 file.
		 * @param	url	Url Youtube video.
		 */
		public function getUrl(url:String):void
		{
			methodUrl.method = URLRequestMethod.GET;
			request = FIRST_REQUEST + url + "&xy=yx";
			methodUrl.url = request;
			methodGet.load(methodUrl);
		}
	}
}