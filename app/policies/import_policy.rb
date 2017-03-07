class ImportPolicy < Struct.new(:user, :import)
  def url?
    user.admin?
  end

  def create_from_url?
    user.admin?
  end
end
