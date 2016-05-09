Pod::Spec.new do |s|
  s.name         = "MXBorder"
  s.version      = "0.1.0"
  s.summary      = "UIView Border Creator"
  s.description  = "UIView Border Creator"
  s.homepage     = "https://github.com/longminxiang/MXBorder"
  s.license      = "MIT"
  s.author       = { "Eric Lung" => "longminxiang@gmail.com" }
  s.source       = { :git => "https://github.com/longminxiang/MXBorder.git", :tag => "v" + s.version.to_s }
  s.requires_arc = true
  s.platform     = :ios, '8.0'
  s.source_files = "MXBorder/*.{h,m}"
end
