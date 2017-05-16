Pod::Spec.new do |s|
  	s.name             = "DarkLightning"
  	s.version          = "2.0.0-alpha1"
  	s.summary          = "Simply the fastest way to transmit data between iOS/tvOS and OSX"
  	s.description      = <<-DESC
  	DarkLightning is a lightweight Swift library to allow data transmission between iOS/tvOS devices (Lightning port, Dock connector, USB-C) and OSX (USB) at 480MBit. 
                       DESC

  	s.homepage         = "https://github.com/jensmeder/DarkLightning"
  	s.license          = 'MIT'
  	s.author           = { "Jens Meder" => "me@jensmeder.de" }
  	s.source           = { :git => "https://github.com/jensmeder/DarkLightning.git", :tag => s.version.to_s }

  	s.requires_arc = true
  	s.ios.deployment_target = '8.0'
  	s.osx.deployment_target = '10.10'
  	s.tvos.deployment_target = '9.0'

	s.subspec "OSX" do |sp|

		sp.source_files = 'Sources/Daemon/**/*{swift}', 'Sources/Utils/**/*{swift}', 'Sources/Port/**/*{swift}'
		sp.platform     = :osx, '10.10'

	end

	s.subspec "iOS" do |sp|

		sp.source_files = 'Sources/Port/**/*{swift}', 'Sources/Utils/**/*{swift}'
		sp.platform     = :ios, '8.0'

	end
	
	s.subspec "tvOS" do |sp|

		sp.source_files = 'Sources/Port/**/*{swift}', 'Sources/Utils/**/*{swift}'
		sp.platform     = :tvos, '9.0'

	end

end
