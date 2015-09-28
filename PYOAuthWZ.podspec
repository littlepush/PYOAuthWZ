#
#  Be sure to run `pod spec lint PYCore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "PYOAuthWZ"
  s.version      = "0.2"
  s.summary      = "OAuth Pod for @Zieglar NodeJs Framework"

  s.description  = <<-DESC
  				   This is the OAuth Pod for @Zieglar's Nodejs framework.
				   If you do not know how to use it, then leave it alone.
                   DESC

  s.homepage     = "https://github.com/littlepush/PYOAuthWZ"
  s.license      = { :type => "LGPLv3", :file => "LICENSE" }

  s.author             = { "Push Chen" => "littlepush@gmail.com" }
  s.social_media_url   = "https://twitter.com/littlepush"

  s.platform     = :ios, "7.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/littlepush/PYOAuthWZ.git", :tag => "0.2" }
  s.dependency "PYCore"
  s.dependency "PYData"
  s.dependency "PYNetwork"

  s.source_files  = "PYOAuthWZ/*.{h,m}", "PYOAuthWZ/**/*.{h,m}"
end
