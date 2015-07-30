Pod::Spec.new do |s|
  s.name             = "DynamicInvoker"
  s.version          = "0.2.0"
  s.summary          = "Method overloading for Obj-C."
  s.homepage         = "https://github.com/MediaHound/DynamicInvoker"
  s.license          = 'Apache'
  s.author           = { "Dustin Bachrach" => "dustin@mediahound.com" }
  s.source           = { :git => "https://github.com/MediaHound/DynamicInvoker.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
