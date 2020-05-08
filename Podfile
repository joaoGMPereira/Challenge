use_frameworks!

target 'Challenge_Example' do
  pod 'JewFeatures', :git => 'https://github.com/joaoGMPereira/JEW-FEATURE.git', :branch => 'versionToTest'
  
  target 'Challenge_Tests' do
    inherit! :search_paths

    
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
