module UsersHelper

  # Show a user card with logo and minimal infos
  def user_card(user, options = {}, &block)
    content = capture(user, &block) if block_given?
    render "users/card", user: user, options: options, content: content
  end

  # Show a user logo
  def user_logo(user)
    return image_tag(user.avatar_url)
  end

end
