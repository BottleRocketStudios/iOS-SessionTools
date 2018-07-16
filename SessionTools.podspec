#
# Be sure to run `pod lib lint SessionTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SessionTools'
    s.version          = '1.0.1'
    s.summary          = 'Provides a simple way to make "session" objects for storing, deleting, and refreshing data.'
    
    s.description      = <<-DESC
    Provides a simple way to create "session" objects for use in your own session manager setup. It can store, delete, and refresh any info you want. You can also broadcast notifications when your info changes.
    DESC
    
    s.homepage         = 'https://github.com/BottleRocketStudios/iOS-SessionTools'
    s.license          = { :type => 'Apache', :file => 'LICENSE' }
    s.author           = { 'Bottle Rocket Studios' => 'earl.gaspard@bottlerocketstudios.com' }
    s.source           = { :git => 'https://github.com/bottlerocketstudios/iOS-SessionTools.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    s.frameworks = 'Foundation'
    
    s.subspec 'Base' do |base|
        # subspec for users who don't want to use Keychain for storage
        base.source_files = 'SessionTools/Classes/Base/*'
    end
    
    s.subspec 'KeychainStorage' do |keychain|
        keychain.dependency 'KeychainAccess'
        s.source_files = 'SessionTools/Classes/Base/*', 'SessionTools/Classes/KeychainStorage/*'
    end
end
