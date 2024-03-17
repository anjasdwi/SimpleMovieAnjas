# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def common_pods
  use_frameworks!
  pod 'Alamofire'
  pod 'SnapKit'
  pod 'SDWebImage'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod "RxGesture"
  pod 'RxDataSources'
  pod 'SkeletonView'
  pod 'ReachabilitySwift'
end

target 'SimpleMovieAnjas' do
  # Comment the next line if you don't want to use dynamic frameworks
  common_pods

  # Pods for anjas_coding_challenge

  target 'SimpleMovieAnjasTests' do
    inherit! :search_paths
    # Pods for testing
    common_pods
    pod 'RxBlocking'
    pod 'RxTest'
  end

  target 'SimpleMovieAnjasUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
