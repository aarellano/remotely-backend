class ChatController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    puts "Session Initialized\n"
  end

  def system_msg(ev, msg)
    broadcast_message ev, {
      user_name: 'system',
      received: Time.now.to_s(:short),
      msg_body: msg
    }
  end

  def user_msg(ev, msg)
    p msg
    broadcast_message ev, {
      user_name:  connection_store[:user][:user_name],
      received:   Time.now.to_s(:short),
      msg_body:   ERB::Util.html_escape(msg)
      }
  end

  def client_connected
    p 'client connected'
    system_msg :new_message, "client #{client_id} connected"
  end

  def new_message
    user_msg :new_message, message[:msg_body].dup
  end

end
