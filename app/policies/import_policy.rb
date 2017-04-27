class ImportPolicy < Struct.new(:user, :import)
  def url?
    user.admin? || user.confirmed_client?
  end

  def create_from_url?
    user.admin? || user.confirmed_client?
  end
end
