# coding: utf-8
Pod::Spec.new do |spec|
  spec.name = 'ManagedObject'
  spec.version = '0.1.0'
  spec.summary = 'Core Data extensions'
  spec.description = <<-DESCRIPTION.gsub(/\s+/, ' ').chomp
  iOS framework containing useful Core Data extensions in Swift.
  DESCRIPTION
  spec.homepage = 'https://github.com/royratcliffe/ManagedObject'
  spec.license = { type: 'MIT', file: 'MIT-LICENSE.txt' }
  spec.authors = { 'Roy Ratcliffe' => 'roy@pioneeringsoftware.co.uk' }
  spec.source = { git: 'https://github.com/royratcliffe/ManagedObject.git',
                  tag: spec.version.to_s }
  spec.source_files = 'ManagedObject/**/*.{swift,h}'
  spec.platform = :ios, '9.0'
  spec.requires_arc = true
end
