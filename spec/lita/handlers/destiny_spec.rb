require "spec_helper"

describe Lita::Handlers::Destiny, lita_handler: true do
  let(:api_token) { 'abcd-1234567890-hWYd21AmMH2UHAkx29vb5c1Y' }
  let(:config) { Lita::Adapters::Destiny.configuration_builder.build }
  
  before do
    config.api_token = api_token
  end
  
  it { is_expected.to route_command("!nightfall").to(:nightfall)}
  
  
end
