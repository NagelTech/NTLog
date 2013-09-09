Pod::Spec.new do |s|

  s.name         = "NTLog"
  s.version      = "0.40"
  s.summary      = "Objective C (iOS) Logging System"
  s.homepage     = "https://github.com/NagelTech/NTLog"
  s.license      = {:type => 'MIT', :file => 'license.txt'}
  s.author       = { "Ethan Nagel" => "eanagel@gmail.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/NagelTech/NTLog.git", :tag => "v0.40" }
  s.source_files  = '*.{h,m}', 'license.txt'

end
