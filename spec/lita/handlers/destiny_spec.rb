require "spec_helper"

describe Lita::Handlers::Destiny, lita_handler: true do
  let(:api_key) { 'd319ebf361e9f4f28e65fa05ce1cf8d6' }
  let(:config) { Lita::Handlers::Destiny.configuration_builder.build }
  
  before do
    config.api_key = api_key
  end
  
  it { is_expected.to route_command("!nightfall").to(:nightfall)}
  
end
