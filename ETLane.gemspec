#
# Be sure to run `pod lib lint ETLane.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Gem::Specification.new do |s|
  s.name             = 'ETLane'
  s.version          = '0.1.63'
  s.summary          = 'A short description of ETLane.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Xcode helper for upload builds and metadata
                       DESC

  s.homepage         = 'https://github.com/teanet/ETLane'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.licenses          = ['MIT']
  s.authors     = ["teanet"]
  s.files = Dir['Scripts/*'] + Dir['Scripts/Sources/**/*'] + Dir['Lanes/**/*']
end