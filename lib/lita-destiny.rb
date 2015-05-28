require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "destiny/base_api"
require "lita/handlers/destiny"

Lita::Handlers::Destiny.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
