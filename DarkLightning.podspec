Pod::Spec.new do |s|
  	s.name             = "DarkLightning"
  	s.version          = "0.1.2"
  	s.summary          = "Simply the fastest way to transmit data between iOS and OSX"
  	s.description      = <<-DESC
  	DarkLightning is a lightweight Objective-C library to allow data transmission between iOS devices (Lightning port or Dock connector) and OSX (USB) at 480MBit. 
                       DESC

  	s.homepage         = "https://github.com/jensmeder/DarkLightning"
  	s.license          = 'MIT'
  	s.author           = { "Jens Meder" => "me@jensmeder.de" }
  	s.source           = { :git => "https://github.com/jensmeder/DarkLightning.git", :tag => s.version.to_s }

  	s.requires_arc = true
  	s.platform     = :osx, '10.10'
  	s.platform     = :ios, '8.0'

	s.subspec "OSX" do |sp|

		sp.source_files = 'Pod/OSX/**/*'
		sp.platform     = :osx, '10.9'
		sp.private_header_files = "Pod/OSX/Internal/**/*.h"

	end

	s.subspec "iOS" do |sp|

		sp.source_files = 'Pod/iOS/**/*'
		sp.platform     = :ios, '8.0'

	end

end
