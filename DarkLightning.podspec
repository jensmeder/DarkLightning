Pod::Spec.new do |s|
  	s.name             = "DarkLightning"
  	s.version          = "1.0.1"
  	s.summary          = "Simply the fastest way to transmit data between iOS/tvOS and OSX"
  	s.description      = <<-DESC
  	DarkLightning is a lightweight Objective-C library to allow data transmission between iOS/tvOS devices (Lightning port, Dock connector, USB-C) and OSX (USB) at 480MBit. 
                       DESC

  	s.homepage         = "https://github.com/jensmeder/DarkLightning"
  	s.license          = 'MIT'
  	s.author           = { "Jens Meder" => "me@jensmeder.de" }
  	s.source           = { :git => "https://github.com/jensmeder/DarkLightning.git", :tag => s.version.to_s }

  	s.requires_arc = true
  	s.ios.deployment_target = '8.0'
  	s.osx.deployment_target = '10.9'
  	s.tvos.deployment_target = '9.0'

	s.subspec "OSX" do |sp|

		sp.source_files = 'Source/OSX/**/*{h,m,c}','Source/USB/**/*{h,m,c}', 'Source/Sockets/**/*{h,m,c}'
		sp.platform     = :osx, '10.9'
		
		sp.dependency 'DarkLightning/PacketProtocol'

	end

	s.subspec "iOS" do |sp|

		sp.source_files = 'Source/iOS/**/*{h,m,c}', 'Source/MobileDevicePort/**/*{h,m,c}', 'Source/Sockets/**/*{h,m,c}'
		sp.platform     = :ios, '8.0'
		
		sp.dependency 'DarkLightning/PacketProtocol'

	end
	
	s.subspec "tvOS" do |sp|

		sp.source_files = 'Source/tvOS/**/*{h,m,c}','Source/MobileDevicePort/**/*{h,m,c}', 'Source/Sockets/**/*{h,m,c}'
		sp.platform     = :tvos, '9.0'
		
		sp.dependency 'DarkLightning/PacketProtocol'

	end
	
	s.subspec "PacketProtocol" do |sp|

		sp.source_files = 'Source/PacketProtocol/**/*{h,m,c}'
		sp.ios.deployment_target = '8.0'
  		sp.osx.deployment_target = '10.9'
		sp.tvos.deployment_target = '9.0'

	end

end
