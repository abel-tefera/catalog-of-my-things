require_relative 'app'
require_relative 'home'

def main
  app = App.new
  app.fetch_json_files

  home(app)
end

main
