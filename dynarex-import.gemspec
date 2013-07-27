Gem::Specification.new do |s|
  s.name = 'dynarex-import'
  s.version = '0.2.2'
  s.summary = 'dynarex-import'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('rexslt') 
  s.signing_key = '../privatekeys/dynarex-import.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dynarex-import'
end
