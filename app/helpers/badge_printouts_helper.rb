module BadgePrintoutsHelper
  Role = Struct.new(:name, :classname)
  Badge = Struct.new(:first, :last, :pronouns, :role)

  module BadgeRoles
    BOARD = Role.new('Board Member', 'board')
    VOLUNTEER = Role.new('Volunteer', 'volunteer')
    SPEAKER = Role.new('Speaker', 'speaker')
  end

  MAX_BADGES = 8 # This seems the be one full page

  def available_roles
    BadgeRoles.constants.map { |sym| BadgeRoles.const_get(sym) }
  end
end
