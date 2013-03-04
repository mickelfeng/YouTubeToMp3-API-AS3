package com.youtubetomp3api.events
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
	
	import flash.events.Event;
	
	public class YoutubeToMp3Event extends Event
	{
		/**
		 * Communication error or permission.
		 */
		public static const ERROR:String = "_errorRequest";
		
		/**
		 * Request complete. File ready to be downloaded.
		 */
		public static const REQUEST_COMPLETE:String = "_requestComplete";
		
		/**
		 * Awaiting return.
		 */
		public static const WAITING:String = "_requestWaiting";
		
		/**
		 * Conversion not allowed.
		 */
		public static const CONVERSION_NOT_ALLOWED:String = "_conversionNotAllowed.";
		
		/**
		 * API youtube-mp3.org AS3 | Events
		 * @author Wenderson Pires da Silva
		 * @version 1.0
		 */
		public function YoutubeToMp3Event(type:String) 
		{
			super(type);
		}
	}
}