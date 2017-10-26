require_relative '../config/environment'
require_relative '../lib/api_communicator'
require_relative '../lib/cli'
require 'asciiart'
require 'tty-prompt'


puts "
8888888b.                    d8b                   888    888                                 888
888   Y88b                   Y8P                   888    888                                 888
888    888                                         888    888                                 888
888   d88P  .d88b.   .d8888b 888 88888b.   .d88b.  8888888888  .d88b.  888  888 88888b.   .d88888
8888888P   d8P  Y8b d88P     888 888  88b d8P  Y8b 888    888 d88  88b 888  888 888  88b d88  888
888 T88b   88888888 888      888 888  888 88888888 888    888 888  888 888  888 888  888 888  888
888  T88b  Y8b.     Y88b.    888 888 d88P Y8b.     888    888 Y88..88P Y88b 888 888  888 Y88b 888
888   T88b  Y88888   Y8888P  888 88888P    Y88888  888    888  Y8888P   Y888888 888  888  Y888888
                                 888
                                 888
                                 888


"



welcome_image
welcome_message
user = create_new_account_or_login_prompt
100.times do
  prompt_menu(user)
end
