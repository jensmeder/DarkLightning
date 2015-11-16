Pod::Spec.new do |s|
  	s.name             = "DarkLightning"
  	s.version          = "0.2.2"
  	s.summary          = "Simply the fastest way to transmit data between iOS and OSX"
  	s.description      = <<-DESC
  	DarkLightning is a lightweight Objective-C library to allow data transmission between iOS devices (Lightning port or Dock connector) and OSX (USB) at 480MBit. 
                       DESC

  	s.homepage         = "https://github.com/jensmeder/DarkLightning"
  	s.license          = 'MIT'
  	s.author           = { "Jens Meder" => "me@jensmeder.de" }
  	s.source           = { :git => "https://github.com/jensmeder/DarkLightning.git", :tag => s.version.to_s }

  	s.requires_arc = true
  	s.ios.deployment_target = '8.0'
  	s.osx.deployment_target = '10.9'

	s.subspec "OSX" do |sp|

		sp.source_files = 'Source/OSX/**/*{h,m,c}'
		sp.platform     = :osx, '10.9'
		sp.private_header_files = "Source/OSX/Internal/**/*.h"
		
		sp.dependency 'DarkLightning/PacketProtocol'

	end

	s.subspec "iOS" do |sp|

		sp.source_files = 'Source/iOS/**/*{h,m,c}'
		sp.platform     = :ios, '8.0'
		
		sp.dependency 'DarkLightning/PacketProtocol'

	end
	
	s.subspec "PacketProtocol" do |sp|

		sp.source_files = 'Source/PacketProtocol/**/*{h,m,c}'
		sp.ios.deployment_target = '8.0'
  		sp.osx.deployment_target = '10.9'

	end

end
