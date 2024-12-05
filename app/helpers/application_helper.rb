module ApplicationHelper
  def user_avatar(user, options = {})
    if user.profile_picture.attached?
      image_tag user.profile_picture, options
    else
      image_tag 'default_avatar.png', options
    end
  end
end
