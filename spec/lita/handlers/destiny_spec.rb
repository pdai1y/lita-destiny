require "spec_helper"

describe Lita::Handlers::DestinyHandler, lita_handler: true do
  let(:api_key) { 'd319ebf361e9f4f28e65fa05ce1cf8d6' }
  let(:config) { Lita::Handlers::DestinyHandler.configuration_builder.build }

  before do
    config.api_key = api_key
  end

  it { is_expected.to route_command("!nightfall").to(:nightfall)}

  it { is_expected.to route_command("!weekly").to(:weekly)}

  it { is_expected.to route_command("!xur").to(:xur)}

  it { is_expected.to route_command("!poe32").to(:poe_32)}

  it { is_expected.to route_command("!poe34").to(:poe_34)}

  it { is_expected.to route_command("!poe35").to(:poe_35)}
end
