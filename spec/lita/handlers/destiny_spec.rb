require "spec_helper"

describe Lita::Handlers::Destiny, lita_handler: true do
  let(:api_key) { 'abcd-1234567890-hWYd21AmMH2UHAkx29vb5c1Y' }
  let(:config) { Lita::Handlers::Destiny.configuration_builder.build }
  
  before do
    config.api_key = api_key
  end
  
  it { is_expected.to route_command("!nightfall").to(:nightfall)}
  
  
end
