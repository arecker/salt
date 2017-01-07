require 'serverspec'

set :backend, :exec

PUBKEY = <<-eos
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD/J98LsMpGwuNA/U3jpqOB0YcD8TNO5CSYZmFm7liDWT2Ndw6uOt3wEQx7LcYh1aDeI6XsHkqNSUoMbgVmFQ10KzEWTd/F+JIE/2aQ5uowJ5/DynobXEgAt/c7FqlnCWWK4u4MbAc5oFLn2sc/eeg1FbQP8EnYJ+8Qi0T/ny9gSLHun8oSAI2Ae74iKnPYyEqozZZf46LToR30W3C/6w0kN6k7H9M3IgrZxWuvRZTsQIvl8meo0YxItTR7HDiqSMav5ZXah6mT7OHhCTN0LIReOPsQu2j4Dc96cfWaIfoSTwQtsx/Teoc/BjhNfawj+YwjRk6li36QUw8xjtGauCLivqrDiB2omFrqY3X15JgMQQkSxiRO4TMFjJSKX52vh9YR5P62uuYyZMqzBvn7QfWG4qQWkPkivX3f3TpIGwmF68Adyaz1+bkFnFRcgytGM960w7RVUp2s98ndoqeRK2av6UJvutqXvPyCbKJvHKUIjQ3UivwwienSTuTXDUYT3hjruz1umwMAcRqqadHaNOBViPT7dvg5t+ruCeJedjtdhXRvsiKiFucq8fxzev46jMD/zCq4hlQUV5Uk8cYYT8dius3TojUddgaEV3by29B5h4/6sVjC/MVCIHu4r+qup2a4X9PL+lrVDQyjD0tdHfBI86FBwUV/EuiFxzrvaCGJQw== alex@lappy-486
eos

describe user('alex') do
  it { should have_authorized_key(PUBKEY) }
  it { should belong_to_group('sudo') }
  it { should have_home_directory('/home/alex') }
  it { should have_login_shell('/bin/bash') }
end
