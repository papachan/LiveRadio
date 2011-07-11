package net.androidda.examples.liveradio.api
{
	public class Service
	{
		public var isInitialized:Boolean = false;
		
		public function Service(enforcer:SingletonEnforcer )
		{
			init();
		}
		private static var _instance:Service;
		
		public static function getInstance():Service
		{
			if ( _instance == null )
			{
				_instance = new Service( new SingletonEnforcer());
			}
			return _instance;
			
		}
		protected function init() : void{
			
		}		
		
	}
}
internal  class SingletonEnforcer {}