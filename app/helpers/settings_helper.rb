module SettingsHelper
  def meetup_profile_link(uid)
    link_to uid, "https://www.meetup.com/sfhumanists/members/#{uid}/"
  end
end
